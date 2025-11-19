# GlanceWatch (npm wrapper)

This is an npm wrapper for [GlanceWatch](https://github.com/collynes/glancewatch), a lightweight monitoring adapter for Glances + Uptime Kuma.

## Installation

### Global installation (recommended)
```bash
npm install -g glancewatch
glancewatch
```

### Local installation
```bash
npm install glancewatch
npx glancewatch
```

## Requirements

- **Node.js** 14.0.0 or higher
- **Python** 3.8 or higher
- **Glances** running on `localhost:61208`

## Quick Start

1. Install and start Glances:
```bash
pip3 install glances
glances -w
```

2. Install and run GlanceWatch:
```bash
npm install -g glancewatch
glancewatch
```

3. Open your browser to:
   - **Web UI**: http://localhost:8000
   - **API Docs**: http://localhost:8000/docs

## Features

- 🎯 Real-time system metrics (CPU, RAM, Disk)
- ⚙️ Configurable thresholds
- 🌐 Beautiful web UI with live status
- 🔌 REST API for Uptime Kuma integration
- 📊 System health monitoring (uptime, load, network)
- 🔄 Automatic refresh every 5 seconds

## Documentation

For full documentation, visit:
https://github.com/collynes/glancewatch

## License

MIT License - see [LICENSE](https://github.com/collynes/glancewatch/blob/main/LICENSE)

## Author

Collins Kemboi

## Links

- [GitHub Repository](https://github.com/collynes/glancewatch)
- [PyPI Package](https://pypi.org/project/glancewatch/)
- [Issue Tracker](https://github.com/collynes/glancewatch/issues)
