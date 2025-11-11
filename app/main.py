"""FastAPI application for GlanceWatch."""

import logging
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI, Request, status
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

from . import __version__
from .config import Config, ConfigLoader
from .monitor import GlancesMonitor
from .models import (
    MetricResponse,
    DiskMetricResponse,
    StatusResponse,
    ConfigResponse,
    ErrorResponse
)
from .api.health import router as health_router

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

# Global config
app_config: Config = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan handler - runs startup and shutdown tasks."""
    global app_config
    
    # Startup - Load configuration
    app_config = ConfigLoader.load()
    logger.info(f"Configuration loaded: Glances={app_config.glances_base_url}")
    
    # Mount UI
    ui_dir = Path(__file__).parent.parent / "ui"
    if ui_dir.exists():
        app.mount("/configure", StaticFiles(directory=str(ui_dir), html=True), name="configure")
        logger.info(f"UI mounted at /configure (serving from {ui_dir})")
    else:
        logger.warning(f"UI directory not found: {ui_dir}")
    
    yield
    
    # Shutdown
    logger.info("Application shutting down")


# Create FastAPI app
app = FastAPI(
    title="GlanceWatch",
    description="Lightweight monitoring adapter for Glances + Uptime Kuma",
    version=__version__,
    lifespan=lifespan
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(health_router)


def get_error_response(message: str, detail: str = None) -> dict:
    """Create standardized error response."""
    return ErrorResponse(
        ok=False,
        error=message,
        detail=detail
    ).model_dump()


async def handle_metric_error(request: Request, metric_name: str, error: Exception):
    """Handle metric check errors with configurable HTTP status codes."""
    error_msg = f"Error checking {metric_name}"
    detail = str(error)
    
    logger.error(f"{error_msg}: {detail}")
    
    # Determine HTTP status code
    http_status = app_config.return_http_on_failure or status.HTTP_200_OK
    
    return JSONResponse(
        status_code=http_status,
        content=get_error_response(error_msg, detail)
    )


@app.get("/", tags=["Info"])
async def root():
    """Root endpoint with service information."""
    return {
        "service": "GlanceWatch",
        "version": __version__,
        "description": "Lightweight monitoring adapter for Glances + Uptime Kuma",
        "endpoints": {
            "ui": "/configure",
            "health": "/health",
            "status": "/status",
            "ram": "/ram",
            "cpu": "/cpu",
            "disk": "/disk",
            "config": "/config"
        }
    }


@app.get("/status", response_model=StatusResponse, tags=["Monitoring"])
async def get_status(request: Request):
    """
    Get overall system status for all metrics.
    
    Returns combined RAM, CPU, and disk status with overall ok/not-ok status.
    Returns HTTP 503 when any threshold is exceeded (for Uptime Kuma alerting).
    """
    try:
        async with GlancesMonitor(app_config) as monitor:
            result = await monitor.check_status()
            
            # Return HTTP 503 when thresholds are exceeded
            if not result.ok:
                return JSONResponse(
                    status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                    content=result.model_dump()
                )
            
            return result
    
    except Exception as e:
        return await handle_metric_error(request, "status", e)


@app.get("/ram", response_model=MetricResponse, tags=["Monitoring"])
async def get_ram_status(request: Request):
    """
    Check RAM usage against configured threshold.
    
    Returns:
        MetricResponse with ok=true if RAM usage is below threshold
    """
    try:
        async with GlancesMonitor(app_config) as monitor:
            result = await monitor.check_ram()
            
            if not result.ok and app_config.return_http_on_failure:
                return JSONResponse(
                    status_code=app_config.return_http_on_failure,
                    content=result.model_dump()
                )
            
            return result
    
    except Exception as e:
        return await handle_metric_error(request, "RAM", e)


@app.get("/cpu", response_model=MetricResponse, tags=["Monitoring"])
async def get_cpu_status(request: Request):
    """
    Check CPU usage against configured threshold.
    
    Returns:
        MetricResponse with ok=true if CPU usage is below threshold
    """
    try:
        async with GlancesMonitor(app_config) as monitor:
            result = await monitor.check_cpu()
            
            if not result.ok and app_config.return_http_on_failure:
                return JSONResponse(
                    status_code=app_config.return_http_on_failure,
                    content=result.model_dump()
                )
            
            return result
    
    except Exception as e:
        return await handle_metric_error(request, "CPU", e)


@app.get("/disk", response_model=DiskMetricResponse, tags=["Monitoring"])
async def get_disk_status(request: Request):
    """
    Check disk usage against configured threshold for monitored mount points.
    
    Returns:
        DiskMetricResponse with ok=true if all disks are below threshold
    """
    try:
        async with GlancesMonitor(app_config) as monitor:
            result = await monitor.check_disk()
            
            if not result.ok and app_config.return_http_on_failure:
                return JSONResponse(
                    status_code=app_config.return_http_on_failure,
                    content=result.model_dump()
                )
            
            return result
    
    except Exception as e:
        return await handle_metric_error(request, "disk", e)


@app.get("/config", response_model=ConfigResponse, tags=["Configuration"])
async def get_config():
    """
    Get current configuration (read-only).
    
    Returns current thresholds and monitoring settings without exposing sensitive data.
    """
    return ConfigResponse(
        glances_base_url=app_config.glances_base_url,
        thresholds={
            "ram_percent": app_config.thresholds.ram_percent,
            "cpu_percent": app_config.thresholds.cpu_percent,
            "disk_percent": app_config.thresholds.disk_percent
        },
        disk_mounts=app_config.disk.mounts
    )


class ThresholdUpdate(BaseModel):
    """Request model for updating thresholds."""
    thresholds: dict


@app.put("/config", tags=["Configuration"])
async def update_config(update: ThresholdUpdate):
    """
    Update monitoring thresholds.
    
    Updates are applied in-memory immediately and persisted to config.yaml.
    """
    global app_config
    
    try:
        # Update thresholds
        new_thresholds = update.thresholds
        
        if "ram_percent" in new_thresholds:
            app_config.thresholds.ram_percent = float(new_thresholds["ram_percent"])
        if "cpu_percent" in new_thresholds:
            app_config.thresholds.cpu_percent = float(new_thresholds["cpu_percent"])
        if "disk_percent" in new_thresholds:
            app_config.thresholds.disk_percent = float(new_thresholds["disk_percent"])
        
        # Persist to config.yaml
        config_path = ConfigLoader.get_config_path()
        import yaml
        
        config_data = {
            "thresholds": {
                "ram_percent": app_config.thresholds.ram_percent,
                "cpu_percent": app_config.thresholds.cpu_percent,
                "disk_percent": app_config.thresholds.disk_percent
            }
        }
        
        with open(config_path, "w") as f:
            yaml.dump(config_data, f, default_flow_style=False)
        
        logger.info(f"Configuration updated: {new_thresholds}")
        
        return {
            "ok": True,
            "message": "Configuration updated successfully",
            "thresholds": {
                "ram_percent": app_config.thresholds.ram_percent,
                "cpu_percent": app_config.thresholds.cpu_percent,
                "disk_percent": app_config.thresholds.disk_percent
            }
        }
    
    except Exception as e:
        logger.error(f"Failed to update configuration: {e}")
        return JSONResponse(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            content={"ok": False, "error": f"Failed to update configuration: {str(e)}"}
        )


if __name__ == "__main__":
    import uvicorn
    from pathlib import Path
    
    # Mount static files for UI if available
    ui_dir = Path(__file__).parent.parent / "ui"
    if ui_dir.exists():
        app.mount("/configure", StaticFiles(directory=str(ui_dir), html=True), name="configure")
        logger.info(f"UI available at /configure")
    
    config = ConfigLoader.load()
    uvicorn.run(
        "app.main:app",
        host=config.host,
        port=config.port,
        log_level=config.log_level.lower()
    )


def cli():
    """CLI entry point for glancewatch command."""
    import uvicorn
    
    config = ConfigLoader.load()
    logger.info(f"Starting GlanceWatch v{__version__}")
    logger.info(f"Glances URL: {config.glances_base_url}")
    logger.info(f"Server: http://{config.host}:{config.port}")
    logger.info(f"Web UI: http://{'localhost' if config.host == '0.0.0.0' else config.host}:{config.port}/configure/")
    
    uvicorn.run(
        "app.main:app",
        host=config.host,
        port=config.port,
        log_level=config.log_level.lower()
    )
