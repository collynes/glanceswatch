# GlanceWatch 🎯

[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.109+-green.svg)](https://fastapi.tiangolo.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PyPI version](https://badge.fury.io/py/glancewatch.svg)](https://pypi.org/project/glancewatch/)
[![Tests](https://github.com/collinsKemboi/glancewatch/workflows/Tests/badge.svg)](https://github.com/collinsKemboi/glancewatch/actions)
[![Coverage](https://img.shields.io/badge/coverage-78%25-brightgreen.svg)](https://github.com/collinsKemboi/glancewatch)

**GlanceWatch** is a lightweight monitoring adapter that bridges [Glances](https://nicolargo.github.io/glances/) system metrics with [Uptime Kuma](https://github.com/louislam/uptime-kuma) and other monitoring tools. It exposes simple HTTP endpoints with configurable thresholds that answer: *"Is my system healthy?"*

## ✨ Features

- 🚀 **One-Command Install**: `pip install glancewatch` - everything included
- 🔄 **Auto-Glances Management**: Automatically installs and starts Glances for you
- 🎯 **HTTP Status Alerting**: Returns HTTP 200 (OK) or 503 (unhealthy) based on thresholds
- 🎨 **Router-Style Web UI**: Clean admin interface at `/` (root)
- ⚙️ **Configurable Thresholds**: Set custom limits for RAM, CPU, and disk usage
- 💾 **Persistent Configuration**: Changes saved to config.yaml automatically
- 📊 **Multiple Disk Monitoring**: Monitor all or specific mount points
- 🏥 **Health Checks**: Built-in health endpoint for service monitoring
- 📝 **OpenAPI Docs**: Auto-generated API documentation at `/api`
- 📈 **Real-Time Metrics**: Auto-refreshing dashboard shows live system status

## 🚀 Quick Start

### Option 1: Background Service (Recommended for Production)

**Linux/Ubuntu (systemd):**
```bash
# One-command install as background service
curl -sSL https://raw.githubusercontent.com/collinsKemboi/glanceswatch/main/install-service.sh | bash

# Service automatically starts on boot and runs in background
```

**Simple background start (nohup):**
```bash
# Install
pip install glancewatch

# Start in background
nohup glancewatch > /dev/null 2>&1 &

# Check if running
ps aux | grep glancewatch
```

See [BACKGROUND-SERVICE.md](BACKGROUND-SERVICE.md) for complete guide including screen/tmux options.

### Option 2: Foreground (Development)

```bash
# Install GlanceWatch (automatically installs Glances dependency)
pip install glancewatch

# Run GlanceWatch (auto-starts Glances if needed)
glancewatch

# Access the web UI
open http://localhost:8000
```

**That's it!** 🎉 GlanceWatch automatically handles Glances installation and startup.

## 🎯 Usage

```bash
# Start GlanceWatch (auto-starts Glances)
glancewatch

# Start without auto-starting Glances
glancewatch --ignore-glances

# Custom port
glancewatch --port 9000

# Custom host
glancewatch --host 0.0.0.0
```

## 📡 API Endpoints

- `GET /` - Web UI (root endpoint)
- `GET /status` - Combined status (HTTP 503 on threshold violation)
- `GET /ram` - RAM usage check
- `GET /cpu` - CPU usage check
- `GET /disk` - Disk usage check
- `GET /health` - Service health check
- `GET /config` - Get configuration
- `PUT /config` - Update thresholds
- `GET /api` - Interactive API documentation

## 🔔 Uptime Kuma Integration

1. In Uptime Kuma, create a new **HTTP(s)** monitor
2. Set URL to: `http://your-server:8000/status`
3. Set "Accepted Status Codes" to: `200`

When any metric exceeds its threshold, GlanceWatch returns **HTTP 503**, triggering an alert.

## ⚙️ Configuration

GlanceWatch creates `~/.config/glancewatch/config.yaml`:

```yaml
glances_base_url: "http://localhost:61208/api/4"
host: "0.0.0.0"
port: 8000
log_level: "INFO"
return_http_on_failure: 503

thresholds:
  ram_percent: 80
  cpu_percent: 80
  disk_percent: 85

disk:
  mounts:
    - "/"
```

Adjust thresholds via the Web UI at `/` or edit the config file.

## 🧪 Testing & Development

GlanceWatch has comprehensive test coverage to ensure reliability:

### Running Tests

```bash
# Install development dependencies
pip install -e ".[dev]"

# Run all tests
pytest tests/ -v

# Run with coverage report
pytest tests/ --cov=app --cov-report=html

# Run specific test file
pytest tests/test_api.py -v

# Run and stop on first failure
pytest tests/ -x
```

### Test Coverage

- **78%+ code coverage** with 63+ test cases
- All endpoints tested (including new `/thresholds` endpoints)
- CLI functionality tests
- Error handling and edge cases
- Integration workflow tests

### CI/CD

Every push and pull request automatically runs:
- ✅ Tests on Python 3.8, 3.9, 3.10, 3.11, 3.12
- ✅ Code linting
- ✅ Coverage checks (minimum 75%)
- ✅ Package build verification

See [TEST_SUMMARY.md](TEST_SUMMARY.md) for detailed test documentation.

## 🆕 What's New in v1.0.2

- ✅ **Fixed critical bug**: DateTime serialization in error responses
- ✅ **New endpoint**: `/thresholds` for easier threshold management
- ✅ **Comprehensive tests**: 63+ test cases covering all functionality
- ✅ **CI/CD pipeline**: Automated testing on every commit
- ✅ **78% code coverage**: Major quality improvement
- ✅ Bug fixes from v1.0.1 (missing import uvicorn)

## 🆕 What's New in v1.0.1

- ✅ **Auto-Glances Management**: Glances is now auto-installed and auto-started
- ✅ **New CLI Flag**: `--ignore-glances` to skip automatic Glances management
- ✅ **Route Reorganization**: API docs moved from `/docs` to `/api`, UI now at root `/`
- ✅ **UI Redesign**: Clean router-style admin interface with plain colors
- ✅ **Improved UX**: Single command to install and run everything

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 📧 Support

- **Issues**: [GitHub Issues](https://github.com/collinsKemboi/glancewatch/issues)
- **PyPI**: [pypi.org/project/glancewatch](https://pypi.org/project/glancewatch/)

---

**Made with ❤️ for simple system monitoring**
