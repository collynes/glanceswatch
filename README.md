# GlanceWatch 🎯

[![Python 3.11+](https://img.shields.io/badge/python-3.11+-blue.svg)](https://www.python.org/downloads/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.109+-green.svg)](https://fastapi.tiangolo.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**GlanceWatch** is a lightweight monitoring adapter that bridges [Glances](https://nicolargo.github.io/glances/) system metrics with [Uptime Kuma](https://github.com/louislam/uptime-kuma) (and other monitoring tools). It exposes simple boolean JSON endpoints that answer the question: *"Is my system healthy?"*

## ✨ Features

- 🎯 **Simple Boolean Endpoints**: `/ram`, `/cpu`, `/disk` return `{"ok": true/false}`
- 🎨 **Web UI**: Modern dashboard with sliding bars to configure thresholds
- ⚙️ **Configurable Thresholds**: Set custom limits for RAM, CPU, and disk usage
- � **Persistent Configuration**: Changes saved to config.yaml automatically
- �🐳 **Docker-First Design**: Ready for containerized deployments
- 🚀 **Async & Fast**: Built on FastAPI + httpx for high performance
- 📊 **Multiple Disk Monitoring**: Monitor all or specific mount points
- 🔧 **Flexible Configuration**: Environment variables, YAML, or both
- 🏥 **Health Checks**: Built-in health endpoint for service monitoring
- 📝 **OpenAPI Docs**: Auto-generated API documentation
- 📈 **Real-Time Metrics**: Auto-refreshing dashboard shows live system status

## 🚀 Quick Start

### Option 1: Docker Compose (Recommended)

```bash
# Clone the repository
git clone https://github.com/yourusername/glancewatch.git
cd glancewatch

# Start both Glances and GlanceWatch
cd docker
docker-compose up -d

# Access Web UI
open http://localhost:8100/ui

# Check API status
curl http://localhost:8100/status
```

The Web UI provides:
- 📊 **Real-time dashboard** showing current RAM, CPU, and disk usage
- 🎚️ **Sliding bars** to adjust thresholds (10-100%)
- 💾 **Instant persistence** - changes saved to config.yaml automatically
- 🔄 **Auto-refresh** every 5 seconds
- 🎨 **Modern dark theme** with color-coded status indicators

### Option 2: Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Start Glances (in another terminal)
glances -w

# Run GlanceWatch
python -m app.main

# Test the API
curl http://localhost:8000/health
```

## 📡 API Endpoints

### Core Monitoring Endpoints

#### `GET /status`
Overall system status combining all metrics.

```json
{
  "ok": true,
  "ram": {
    "ok": true,
    "value": 45.2,
    "threshold": 80.0,
    "unit": "%"
  },
  "cpu": {
    "ok": true,
    "value": 32.5,
    "threshold": 80.0,
    "unit": "%"
  },
  "disk": {
    "ok": true,
    "disks": [
      {
        "mount_point": "/",
        "percent_used": 62.3,
        "size_gb": 500.0,
        "ok": true
      }
    ],
    "threshold": 85.0
  },
  "last_check": "2025-11-11T10:30:00"
}
```

#### `GET /ram`
RAM usage check.

```json
{
  "ok": true,
  "value": 45.2,
  "threshold": 80.0,
  "unit": "%",
  "last_check": "2025-11-11T10:30:00"
}
```

#### `GET /cpu`
CPU usage check (average across all cores).

```json
{
  "ok": true,
  "value": 32.5,
  "threshold": 80.0,
  "unit": "%",
  "last_check": "2025-11-11T10:30:00"
}
```

#### `GET /disk`
Disk usage check for monitored mount points.

```json
{
  "ok": true,
  "disks": [
    {
      "mount_point": "/",
      "fs_type": "ext4",
      "percent_used": 62.3,
      "size_gb": 500.0,
      "used_gb": 311.5,
      "free_gb": 188.5,
      "ok": true
    }
  ],
  "threshold": 85.0,
  "last_check": "2025-11-11T10:30:00"
}
```

### Utility Endpoints

#### `GET /health`
Service health check.

```json
{
  "status": "healthy",
  "version": "1.0.0",
  "glances_connected": true,
  "glances_url": "http://localhost:61208",
  "uptime_seconds": 3600.5,
  "timestamp": "2025-11-11T10:30:00"
}
```

#### `GET /config`
View current configuration.

```json
{
  "glances_base_url": "http://localhost:61208",
  "thresholds": {
    "ram_percent": 80.0,
    "cpu_percent": 80.0,
    "disk_percent": 85.0
  },
  "disk_mounts": ["/"],
  "timestamp": "2025-11-11T10:30:00"
}
```

#### `PUT /config`
Update monitoring thresholds (also available via Web UI).

**Request:**
```json
{
  "thresholds": {
    "ram_percent": 75.0,
    "cpu_percent": 85.0,
    "disk_percent": 90.0
  }
}
```

**Response:**
```json
{
  "ok": true,
  "message": "Configuration updated successfully",
  "thresholds": {
    "ram_percent": 75.0,
    "cpu_percent": 85.0,
    "disk_percent": 90.0
  }
}
```

Changes are persisted to `/var/lib/glancewatch/config.yaml` and take effect immediately.

### Web UI

Access the configuration interface at `http://localhost:8100/ui`

- **Dashboard**: Real-time metrics with visual indicators
- **Sliders**: Adjust RAM, CPU, and Disk thresholds (10-100%)
- **Persistence**: Changes saved automatically to config.yaml
- **Auto-refresh**: Dashboard updates every 5 seconds
- **Status Colors**:
  - 🟢 Green: < 75% of threshold
  - 🟡 Yellow: 75-90% of threshold
  - 🔴 Red: > 90% of threshold

## ⚙️ Configuration

### Environment Variables

Create a `.env` file or set environment variables:

```bash
# Glances Connection
GLANCES_BASE_URL=http://localhost:61208
GLANCES_TIMEOUT=5

# Server Settings
HOST=0.0.0.0
PORT=8000

# Thresholds (0-100)
RAM_THRESHOLD=80.0
CPU_THRESHOLD=80.0
DISK_THRESHOLD=85.0

# Disk Monitoring
DISK_MOUNTS=/                           # Single mount
# DISK_MOUNTS=/,/home,/data            # Multiple mounts
# DISK_MOUNTS=all                      # All mounts
DISK_EXCLUDE_TYPES=tmpfs,devtmpfs,overlay,squashfs

# Error Handling
RETURN_HTTP_ON_FAILURE=                 # 200 with ok=false (default)
# RETURN_HTTP_ON_FAILURE=503           # Return 503 on failure

# Logging
LOG_LEVEL=INFO
```

### YAML Configuration

Create `~/.config/glancewatch/config.yaml` (or `/var/lib/glancewatch/config.yaml` in Docker):

```yaml
glances_base_url: http://localhost:61208
glances_timeout: 5

host: 0.0.0.0
port: 8000

thresholds:
  ram_percent: 80.0
  cpu_percent: 80.0
  disk_percent: 85.0

disk:
  mounts:
    - /
    - /home
  exclude_types:
    - tmpfs
    - devtmpfs

log_level: INFO
```

**Note**: Environment variables override YAML settings.

## 🔗 Uptime Kuma Integration

1. Add a new monitor in Uptime Kuma
2. Choose **HTTP(s) - Keyword** monitor type
3. Set URL to: `http://your-server:8000/status`
4. Set keyword to: `"ok":true` or `"ok": true`
5. Set check interval (e.g., 60 seconds)

### Alternative: HTTP Status Code

If you prefer HTTP status codes:

1. Set `RETURN_HTTP_ON_FAILURE=503`
2. Use **HTTP(s)** monitor type (no keyword needed)
3. Uptime Kuma will alert on non-200 responses

## 🐳 Docker Deployment

### Using Docker Compose

The provided `docker-compose.yml` includes both Glances and GlanceWatch:

```bash
cd docker
docker-compose up -d
```

Access points:
- GlanceWatch API: http://localhost:8000
- Glances Web UI: http://localhost:61208

### Standalone Docker

```bash
# Build image
docker build -f docker/Dockerfile -t glancewatch:latest .

# Run container
docker run -d \
  --name glancewatch \
  -p 8000:8000 \
  -e GLANCES_BASE_URL=http://your-glances-host:61208 \
  -e RAM_THRESHOLD=80 \
  -e CPU_THRESHOLD=80 \
  -e DISK_THRESHOLD=85 \
  glancewatch:latest
```

## 🧪 Testing

Run the test suite:

```bash
# Install dev dependencies
pip install -r requirements-dev.txt

# Run tests
pytest tests/ -v

# With coverage
pytest tests/ --cov=app --cov-report=html
```

## 📊 Example Use Cases

### 1. Alert When RAM Exceeds 80%
```bash
# Set threshold
export RAM_THRESHOLD=80

# Monitor endpoint
curl http://localhost:8000/ram
# Returns: {"ok": false, "value": 85.2, ...} when exceeded
```

### 2. Monitor Multiple Disks
```bash
# Monitor root and data partitions
export DISK_MOUNTS=/,/data

curl http://localhost:8000/disk
```

### 3. Integration with Scripts
```bash
#!/bin/bash
RESPONSE=$(curl -s http://localhost:8000/status)
OK=$(echo $RESPONSE | jq -r '.ok')

if [ "$OK" != "true" ]; then
    echo "System unhealthy!"
    # Send notification, trigger action, etc.
fi
```

## 🛠️ Development

### Code Quality

```bash
# Format code
black app/ tests/

# Lint
ruff check app/ tests/

# Type checking
mypy app/
```

### Project Structure

```
glancewatch/
├── app/
│   ├── __init__.py          # Package initialization
│   ├── main.py              # FastAPI application
│   ├── monitor.py           # Core monitoring logic
│   ├── config.py            # Configuration management
│   ├── models.py            # Pydantic data models
│   └── api/
│       ├── __init__.py
│       └── health.py        # Health check endpoint
├── tests/
│   ├── test_monitor.py      # Monitor tests
│   └── test_api.py          # API endpoint tests
├── docker/
│   ├── Dockerfile           # Container image
│   └── docker-compose.yml   # Development stack
├── requirements.txt         # Production dependencies
├── requirements-dev.txt     # Development dependencies
└── README.md               # This file
```

## 🔧 Troubleshooting

### Glances Connection Failed

**Problem**: `"error": "Failed to fetch RAM data"`

**Solutions**:
1. Check Glances is running: `ps aux | grep glances`
2. Verify Glances API: `curl http://localhost:61208/api/3/mem`
3. Check `GLANCES_BASE_URL` configuration
4. Ensure Glances web server is enabled: `glances -w`

### High False Positive Rate

**Problem**: Alerts trigger too frequently

**Solutions**:
1. Increase thresholds: `RAM_THRESHOLD=90`
2. Adjust check interval in monitoring tool
3. Use `/status` for combined health (all metrics must fail)

### Docker Container Unhealthy

**Problem**: Health checks failing

**Solutions**:
1. Check logs: `docker logs glancewatch`
2. Verify Glances connectivity from container
3. Increase health check timeout in compose file

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Write tests for new features
4. Ensure tests pass: `pytest tests/`
5. Submit a pull request

## 🙏 Acknowledgments

- [Glances](https://nicolargo.github.io/glances/) - Excellent system monitoring tool
- [Uptime Kuma](https://github.com/louislam/uptime-kuma) - Self-hosted monitoring solution
- [FastAPI](https://fastapi.tiangolo.com/) - Modern Python web framework

## 📞 Support

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/yourusername/glancewatch/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/yourusername/glancewatch/discussions)
- 📖 **Documentation**: [API Docs](http://localhost:8000/docs) (when running)

---

**Made with ❤️ for the self-hosted community**
