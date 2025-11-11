"""Health check API endpoints."""

import time
from datetime import datetime

from fastapi import APIRouter, Depends

from .. import __version__
from ..config import Config
from ..monitor import GlancesMonitor
from ..models import HealthResponse

router = APIRouter()

# Track service start time
_start_time = time.time()


def get_config() -> Config:
    """Dependency to get current configuration."""
    from ..main import app_config
    return app_config


@router.get("/health", response_model=HealthResponse, tags=["Health"])
async def health_check(config: Config = Depends(get_config)):
    """
    Check service health and Glances connectivity.
    
    Returns:
        HealthResponse with service status, version, and Glances connection status
    """
    glances_connected = False
    
    try:
        async with GlancesMonitor(config) as monitor:
            glances_connected = await monitor.test_connection()
    except Exception:
        glances_connected = False
    
    uptime = time.time() - _start_time
    status = "healthy" if glances_connected else "degraded"
    
    return HealthResponse(
        status=status,
        version=__version__,
        glances_connected=glances_connected,
        glances_url=config.glances_base_url,
        uptime_seconds=round(uptime, 2),
        timestamp=datetime.utcnow()
    )
