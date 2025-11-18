# GlanceWatch

[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.109+-green.svg)](https://fastapi.tiangolo.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PyPI version](https://badge.fury.io/py/glancewatch.svg)](https://pypi.org/project/glancewatch/)
[![Tests](https://github.com/collynes/glancewatch/workflows/Tests/badge.svg)](https://github.com/collynes/glancewatch/actions)
[![Coverage](https://img.shields.io/badge/coverage-78%25-brightgreen.svg)](https://github.com/collynes/glancewatch)

**GlanceWatch** is a lightweight monitoring adapter that bridges [Glances](https://nicolargo.github.io/glances/) system metrics with [Uptime Kuma](https://github.com/louislam/uptime-kuma) and other monitoring tools. It exposes simple HTTP endpoints with configurable thresholds that answer: *"Is my system healthy?"*

## Features

- **One-Command Install**: `pip install glancewatch` - everything included
- **Auto-Glances Management**: Automatically installs and starts Glances for you
- **HTTP Status Alerting**: Returns HTTP 200 (OK) or 503 (unhealthy) based on thresholds
- **Router-Style Web UI**: Clean admin interface at `/` (root)
- **Configurable Thresholds**: Set custom limits for RAM, CPU, and disk usage
- **Persistent Configuration**: Changes saved to config.yaml automatically
- **Multiple Disk Monitoring**: Monitor all or specific mount points
- **Health Checks**: Built-in health endpoint for service monitoring
- **OpenAPI Docs**: Auto-generated API documentation at `/api`
- **Real-Time Metrics**: Auto-refreshing dashboard shows live system status

## Installation

### macOS (Homebrew)
```bash
brew tap collynes/glancewatch
brew install glancewatch
glancewatch
```

### Windows (Chocolatey)
```powershell
choco install glancewatch
glancewatch
```

### Node.js/npm (All platforms)
```bash
# Global installation
npm install -g glancewatch
glancewatch

# Or use npx
npx glancewatch
```

### Python/pip (All platforms)
```bash
pip install glancewatch
glancewatch
```

## Quick Start

### Background Service (Recommended for Production)

**Linux/Ubuntu (systemd):**
```bash
# One-command install as background service
curl -sSL https://raw.githubusercontent.com/collynes/glancewatch/main/scripts/install-pip.sh | bash

# Service automatically starts on boot and runs in background
```

**Simple background start (nohup):**
```bash
# Start in background
nohup glancewatch > /dev/null 2>&1 &

# Check if running
ps aux | grep glancewatch
```

See [docs/BACKGROUND-SERVICE.md](docs/BACKGROUND-SERVICE.md) for complete guide including screen/tmux options.

### Foreground (Development)

```bash
# Run GlanceWatch (auto-starts Glances if needed)
glancewatch

# Access the web UI
open http://localhost:8765
```

**That's it!** 🎉 GlanceWatch automatically handles Glances installation and startup.

## Usage

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

## 📚 Documentation

- [Installation Guide](docs/INSTALL.md) - Detailed installation instructions
- [Quick Start Guide](docs/QUICKSTART.md) - Get started in minutes
- [Ubuntu Quick Start](docs/QUICKSTART-UBUNTU.md) - Ubuntu-specific guide
- [Background Service Setup](docs/BACKGROUND-SERVICE.md) - Run as a service
- [UI Guide](docs/UI-GUIDE.md) - Web interface overview
- [Pip Installation](docs/PIP-INSTALL.md) - Python package details
- [Release Notes](docs/) - All version history

## 📡 API Endpoints

- `GET /` - Web UI (root endpoint)
- `GET /status` - Combined status (HTTP 503 on threshold violation)
- `GET /ram` - RAM usage check
- `GET /cpu` - CPU usage check
- `GET /disk` - Disk usage check
- `GET /health` - Service health check
- `GET /config` - Get configuration
- `PUT /config` - Update thresholds
- `GET /docs` - Interactive API documentation

## 🔔 Uptime Kuma Integration

1. In Uptime Kuma, create a new **HTTP(s)** monitor
2. Set URL to: `http://your-server:8765/status`
3. Set "Accepted Status Codes" to: `200`

When any metric exceeds its threshold, GlanceWatch returns **HTTP 503**, triggering an alert.

## Configuration

GlanceWatch creates `~/.config/glancewatch/config.yaml`:

```yaml
glances_base_url: "http://localhost:61208/api/4"
host: "0.0.0.0"
port: 8765
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

See [docs/TEST_SUMMARY.md](docs/TEST_SUMMARY.md) for detailed test documentation.

## 🆕 What's New in v1.2.1

- ✅ **Dynamic Version Display**: Fixed version display bug - now shows correct version in UI
- ✅ **Template-based Version**: Uses {{VERSION}} placeholder replaced at runtime
- ✅ **Improved UI**: Green/red circle status indicators with thin borders
- ✅ **System Health Monitor**: Added uptime, load average, and network statistics
- ✅ **Better Thresholds**: CPU now supports 0.1% minimum threshold
- ✅ **Reset Defaults**: Reset button always enabled with proper default values (80/80/85)
- ✅ **Clean Documentation**: Removed all unsolicited emojis from docs
- ✅ **Section Reordering**: Moved threshold configuration before system health

See [docs/RELEASE_NOTES_v1.2.1.md](docs/RELEASE_NOTES_v1.2.1.md) for complete release notes.

## 🤝 Contributing

We welcome contributions! GlanceWatch is an open-source project and we'd love your help making it better.

### How to Contribute

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
3. **Create a feature branch** from `develop`
4. **Make your changes** following our coding standards
5. **Write/update tests** for your changes
6. **Submit a pull request** to the `develop` branch

### Quick Start for Contributors

```bash
# Fork on GitHub first, then:
git clone https://github.com/YOUR_USERNAME/glanceswatch.git
cd glanceswatch

# Create a feature branch
git checkout -b feature/your-feature-name

# Install development dependencies
pip install -e ".[dev]"

# Make changes, then test
pytest --cov=app
black app/ tests/
ruff check app/ tests/

# Commit and push
git commit -m "feat: add your feature"
git push origin feature/your-feature-name

# Create a Pull Request on GitHub targeting 'develop' branch
```

### Branch Strategy

- **`main`** - Production releases (protected)
- **`develop`** - Integration branch (protected, default for PRs)
- **`feature/*`** - Your feature branches

### Resources

- 📖 **[Contributing Guide](CONTRIBUTING.md)** - Detailed contribution guidelines
- 🛡️ **[Branch Protection Setup](docs/BRANCH_PROTECTION_GUIDE.md)** - How we protect code quality
- 📝 **[Pull Request Template](.github/PULL_REQUEST_TEMPLATE.md)** - What to include in PRs
- 🐛 **[Bug Report Template](.github/ISSUE_TEMPLATE/bug_report.md)** - Report bugs
- ✨ **[Feature Request Template](.github/ISSUE_TEMPLATE/feature_request.md)** - Suggest features

### Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what's best for the community

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 📧 Support

- **Issues**: [GitHub Issues](https://github.com/collynes/glancewatch/issues)
- **Discussions**: [GitHub Discussions](https://github.com/collynes/glancewatch/discussions)
- **PyPI**: [pypi.org/project/glancewatch](https://pypi.org/project/glancewatch/)
- **npm**: [npmjs.com/package/glancewatch](https://www.npmjs.com/package/glancewatch)

---

**Made with ❤️ for simple system monitoring**
