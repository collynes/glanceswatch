# GlanceWatch Installation Guide

## Quick Install

GlanceWatch requires only **Glances** to be running. Everything else is bundled!

### 1. Install Glances

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y glances
```

**Using pip:**
```bash
pip install glances
```

### 2. Start Glances API Server

```bash
# Start Glances in API mode (runs on port 61208 by default)
glances -w &

# Or run in foreground to see logs:
glances -w
```

### 3. Install GlanceWatch

```bash
# Install from PyPI
pip install glancewatch

# Or install from source
pip install git+https://github.com/collynes/glancewatch.git
```

### 4. Run GlanceWatch

```bash
glancewatch
```

That's it! 🎉

GlanceWatch will:
- Start a web server on `http://localhost:8000`
- Provide a web UI at `http://localhost:8000/configure/`
- Monitor your system via Glances API
- Expose endpoints for Uptime Kuma monitoring

## Configuration

GlanceWatch creates a default config on first run at `~/.config/glancewatch/config.yaml`.

You can configure thresholds in two ways:

1. **Via Web UI**: Visit `http://localhost:8000/configure/` and use the sliders
2. **Edit config file**: Edit `~/.config/glancewatch/config.yaml`

**Default configuration:**
```yaml
thresholds:
  ram_percent: 80.0
  cpu_percent: 80.0
  disk_percent: 85.0
```

## Running as a Service (Ubuntu/Debian)

### Create systemd service for Glances:

```bash
sudo tee /etc/systemd/system/glances.service > /dev/null <<EOF
[Unit]
Description=Glances API Server
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=$(which glances) -w
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable glances
sudo systemctl start glances
```

### Create systemd service for GlanceWatch:

```bash
sudo tee /etc/systemd/system/glancewatch.service > /dev/null <<EOF
[Unit]
Description=GlanceWatch Monitoring Service
After=network.target glances.service
Requires=glances.service

[Service]
Type=simple
User=$USER
ExecStart=$(which glancewatch)
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable glancewatch
sudo systemctl start glancewatch
```

### Check status:

```bash
sudo systemctl status glances
sudo systemctl status glancewatch
```

## Integration with Uptime Kuma

Once GlanceWatch is running, add it to Uptime Kuma:

1. **Add New Monitor** in Uptime Kuma
2. **Monitor Type**: HTTP(s)
3. **URL**: `http://your-server:8000/status`
4. **Heartbeat Interval**: 20 seconds (or your preference)
5. **Status Codes**: Success when HTTP status is 2xx
6. **Save**

GlanceWatch returns:
- **HTTP 200** when all thresholds are OK ✅
- **HTTP 503** when any threshold is exceeded ⚠️

This allows Uptime Kuma to automatically alert you when system resources exceed configured limits.

## Environment Variables

You can override config using environment variables:

```bash
export GLANCEWATCH_HOST=0.0.0.0
export GLANCEWATCH_PORT=8000
export GLANCEWATCH_GLANCES_URL=http://localhost:61208
export GLANCEWATCH_RAM_THRESHOLD=80.0
export GLANCEWATCH_CPU_THRESHOLD=80.0
export GLANCEWATCH_DISK_THRESHOLD=85.0

glancewatch
```

## Endpoints

- `GET /` - Service information
- `GET /status` - Overall system status (use this for Uptime Kuma)
- `GET /health` - Health check
- `GET /ram` - RAM usage
- `GET /cpu` - CPU usage
- `GET /disk` - Disk usage
- `GET /config` - View current configuration
- `PUT /config` - Update thresholds
- `GET /configure/` - Web UI for configuration

## Troubleshooting

### Glances not running
```bash
# Check if Glances is running
curl http://localhost:61208/api/4/all

# If not, start it:
glances -w
```

### Port already in use
```bash
# Change the port
export GLANCEWATCH_PORT=8001
glancewatch
```

### Permission denied
```bash
# Install in user directory
pip install --user glancewatch

# Or use a virtual environment
python3 -m venv venv
source venv/bin/activate
pip install glancewatch
glancewatch
```

## Uninstall

```bash
# Stop services
sudo systemctl stop glancewatch glances
sudo systemctl disable glancewatch glances

# Remove service files
sudo rm /etc/systemd/system/glancewatch.service
sudo rm /etc/systemd/system/glances.service
sudo systemctl daemon-reload

# Uninstall packages
pip uninstall -y glancewatch glances

# Remove config (optional)
rm -rf ~/.config/glancewatch
```

## Development

To install in development mode:

```bash
git clone https://github.com/collynes/glancewatch.git
cd glancewatch
pip install -e ".[dev]"
glancewatch
```

This installs GlanceWatch in editable mode, so changes to the code take effect immediately.
