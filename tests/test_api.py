"""Tests for FastAPI endpoints."""

import pytest
from unittest.mock import patch, AsyncMock
from fastapi.testclient import TestClient

from app.main import app
from app.config import Config, ThresholdConfig, DiskConfig
from app.models import MetricResponse, DiskMetricResponse


@pytest.fixture
def test_config():
    """Create test configuration."""
    return Config(
        glances_base_url="http://localhost:61208",
        thresholds=ThresholdConfig(
            ram_percent=80.0,
            cpu_percent=80.0,
            disk_percent=85.0
        ),
        disk=DiskConfig(mounts=["/"]),
        return_http_on_failure=None
    )


@pytest.fixture
def client():
    """Create test client."""
    return TestClient(app)


def test_root_endpoint(client):
    """Test root endpoint returns service info."""
    response = client.get("/")
    
    assert response.status_code == 200
    data = response.json()
    assert data["service"] == "GlanceWatch"
    assert "version" in data
    assert "endpoints" in data


def test_health_endpoint(client, test_config):
    """Test health check endpoint."""
    with patch('app.api.health.get_config', return_value=test_config):
        with patch('app.monitor.GlancesMonitor.test_connection', return_value=True):
            response = client.get("/health")
            
            assert response.status_code == 200
            data = response.json()
            assert "status" in data
            assert "version" in data
            assert "glances_connected" in data
            assert data["glances_url"] == "http://localhost:61208"


def test_ram_endpoint_ok(client, test_config):
    """Test RAM endpoint when usage is below threshold."""
    mock_result = MetricResponse(
        ok=True,
        value=50.0,
        threshold=80.0,
        unit="%"
    )
    
    with patch('app.main.app_config', test_config):
        with patch('app.monitor.GlancesMonitor.check_ram', return_value=mock_result):
            response = client.get("/ram")
            
            assert response.status_code == 200
            data = response.json()
            assert data["ok"] is True
            assert data["value"] == 50.0
            assert data["threshold"] == 80.0


def test_ram_endpoint_threshold_exceeded(client):
    """Test RAM endpoint when usage exceeds threshold."""
    test_config_with_failure = Config(
        glances_base_url="http://localhost:61208",
        thresholds=ThresholdConfig(ram_percent=80.0),
        return_http_on_failure=503
    )
    
    mock_result = MetricResponse(
        ok=False,
        value=90.0,
        threshold=80.0,
        unit="%"
    )
    
    with patch('app.main.app_config', test_config_with_failure):
        with patch('app.monitor.GlancesMonitor.check_ram', return_value=mock_result):
            response = client.get("/ram")
            
            assert response.status_code == 503
            data = response.json()
            assert data["ok"] is False
            assert data["value"] == 90.0


def test_cpu_endpoint(client, test_config):
    """Test CPU endpoint."""
    mock_result = MetricResponse(
        ok=True,
        value=45.5,
        threshold=80.0,
        unit="%"
    )
    
    with patch('app.main.app_config', test_config):
        with patch('app.monitor.GlancesMonitor.check_cpu', return_value=mock_result):
            response = client.get("/cpu")
            
            assert response.status_code == 200
            data = response.json()
            assert data["ok"] is True
            assert data["value"] == 45.5


def test_disk_endpoint(client, test_config):
    """Test disk endpoint."""
    mock_result = DiskMetricResponse(
        ok=True,
        disks=[{
            "mount_point": "/",
            "percent_used": 50.0,
            "size_gb": 500.0,
            "ok": True
        }],
        threshold=85.0
    )
    
    with patch('app.main.app_config', test_config):
        with patch('app.monitor.GlancesMonitor.check_disk', return_value=mock_result):
            response = client.get("/disk")
            
            assert response.status_code == 200
            data = response.json()
            assert data["ok"] is True
            assert len(data["disks"]) == 1
            assert data["disks"][0]["mount_point"] == "/"


def test_status_endpoint(client, test_config):
    """Test overall status endpoint."""
    from app.models import StatusResponse
    
    mock_result = StatusResponse(
        ok=True,
        ram={"ok": True, "value": 50.0},
        cpu={"ok": True, "value": 45.0},
        disk={"ok": True, "disks": []}
    )
    
    with patch('app.main.app_config', test_config):
        with patch('app.monitor.GlancesMonitor.check_status', return_value=mock_result):
            response = client.get("/status")
            
            assert response.status_code == 200
            data = response.json()
            assert data["ok"] is True
            assert "ram" in data
            assert "cpu" in data
            assert "disk" in data


def test_config_endpoint(client, test_config):
    """Test config endpoint."""
    with patch('app.main.app_config', test_config):
        response = client.get("/config")
        
        assert response.status_code == 200
        data = response.json()
        assert data["glances_base_url"] == "http://localhost:61208"
        assert "thresholds" in data
        assert data["thresholds"]["ram_percent"] == 80.0
        assert "disk_mounts" in data


def test_error_handling(client, test_config):
    """Test error handling when monitor raises exception."""
    with patch('app.main.app_config', test_config):
        with patch('app.monitor.GlancesMonitor.check_ram', side_effect=Exception("Test error")):
            response = client.get("/ram")
            
            # Should return 200 with error in response
            assert response.status_code == 200
            data = response.json()
            assert data["ok"] is False
            assert "error" in data
