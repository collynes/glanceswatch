# GlanceWatch - Now Pip Installable! 🎉

GlanceWatch is now fully pip-installable with everything included out-of-the-box!

## Installation (3 simple steps)

### 1. Install Glances
```bash
sudo apt install -y glances  # Ubuntu/Debian
# or: pip install glances
```

### 2. Start Glances API
```bash
glances -w  # Starts API server on port 61208
```

### 3. Install & Run GlanceWatch
```bash
# From GitHub (until published to PyPI)
pip install git+https://github.com/collynes/glancewatch.git

# Run it
glancewatch
```

That's it! 🚀

- **Web UI**: http://localhost:8000/configure/
- **API**: http://localhost:8000/status
- **Docs**: http://localhost:8000/docs

## What Changed?

### Before:
```bash
git clone https://github.com/collynes/glancewatch.git
cd glancewatch
pip install -r requirements.txt
python -m app.main
```

### After:
```bash
pip install git+https://github.com/collynes/glancewatch.git
glancewatch
```

## Features Included

✅ Web UI with threshold sliders  
✅ REST API for monitoring  
✅ Configuration persistence  
✅ HTTP 200/503 status codes for Uptime Kuma  
✅ Real-time dashboard  
✅ Auto-refresh every 5 seconds  
✅ No Docker required (but still available)  

## Configuration

Default config created at `~/.config/glancewatch/config.yaml`:

```yaml
thresholds:
  ram_percent: 80.0
  cpu_percent: 80.0
  disk_percent: 85.0
```

Or configure via Web UI at http://localhost:8000/configure/

## Running as a Service

```bash
# Create systemd service
sudo tee /etc/systemd/system/glancewatch.service > /dev/null <<EOF
[Unit]
Description=GlanceWatch Monitoring Service
After=network.target glances.service

[Service]
Type=simple
User=$USER
ExecStart=$(which glancewatch)
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable glancewatch
sudo systemctl start glancewatch
```

## Uptime Kuma Integration

1. Add monitor: HTTP(s) type
2. URL: `http://your-server:8000/status`
3. Expected status: 2xx
4. Done!

Returns:
- **HTTP 200** = All thresholds OK ✅
- **HTTP 503** = Threshold exceeded ⚠️

## Update Instructions (for your Ubuntu server)

```bash
# Stop current installation
sudo systemctl stop glancewatch

# Uninstall old version
cd ~/glanceswatch
# (This was the git clone method)

# Install new pip version
pip install git+https://github.com/collynes/glancewatch.git

# Verify
which glancewatch
glancewatch --help

# Update systemd service
sudo vim /etc/systemd/system/glancewatch.service
# Change ExecStart to: /home/ubuntu/.local/bin/glancewatch

sudo systemctl daemon-reload
sudo systemctl start glancewatch
sudo systemctl status glancewatch
```

## Documentation

- **[INSTALL.md](INSTALL.md)** - Detailed installation guide
- **[README.md](README.md)** - Quick start and overview
- **[QUICKSTART-UBUNTU.md](QUICKSTART-UBUNTU.md)** - Ubuntu-specific guide
- **[PUBLISHING.md](PUBLISHING.md)** - How to publish to PyPI

## Coming Soon

Once published to PyPI, installation will be even simpler:

```bash
pip install glancewatch
glancewatch
```

(Currently available via GitHub until first PyPI release)

## What You Need to Know

### Requirements
- **Python 3.8+** (lowered from 3.11 for wider compatibility)
- **Glances** running with web API enabled (`glances -w`)

### What's Included
- FastAPI web server
- Web UI (HTML/CSS/JS)
- Configuration management
- All dependencies

### What's NOT Included
- Glances itself (must install separately)

This keeps GlanceWatch lightweight and lets you manage Glances independently!

## Development

Want to contribute or modify?

```bash
git clone https://github.com/collynes/glancewatch.git
cd glancewatch
pip install -e ".[dev]"  # Installs in editable mode
glancewatch
```

Changes to code take effect immediately!

## Support

- GitHub Issues: https://github.com/collynes/glancewatch/issues
- Documentation: See INSTALL.md for detailed setup
- API Docs: http://localhost:8000/docs (when running)
