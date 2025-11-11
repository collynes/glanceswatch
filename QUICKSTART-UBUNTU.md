# Quick Start on Ubuntu (Without Docker)

This guide shows how to run GlanceWatch directly on Ubuntu without Docker.

## Prerequisites

```bash
# Update system
sudo apt update

# Install Python 3.11+ and pip
sudo apt install python3 python3-pip python3-venv -y

# Install Glances
sudo apt install glances -y
# OR use pip:
# pip3 install glances
```

## Installation Steps

### 1. Clone/Copy the Project

```bash
cd ~
# If you have the project, navigate to it
cd glances-kuma-alerts
```

### 2. Create Virtual Environment

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate
```

### 3. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 4. Start Glances in Web Mode

Open a new terminal and run:

```bash
# Start Glances web server on port 61208
glances -w --port 61208
```

Or run it in the background:

```bash
# Run in background
nohup glances -w --port 61208 > /tmp/glances.log 2>&1 &

# Check it's running
curl http://localhost:61208/api/4/cpu
```

### 5. Configure GlanceWatch

Create a config file (optional - defaults work fine):

```bash
mkdir -p ~/.config/glancewatch
cat > ~/.config/glancewatch/config.yaml << 'EOF'
glances_base_url: http://localhost:61208/api/4
host: 0.0.0.0
port: 8100
log_level: INFO

thresholds:
  ram_percent: 80.0
  cpu_percent: 80.0
  disk_percent: 85.0

disk:
  mounts:
    - /
  exclude_types:
    - tmpfs
    - devtmpfs
    - squashfs
EOF
```

### 6. Run GlanceWatch

```bash
# Make sure you're in the project directory
cd ~/glances-kuma-alerts

# Activate venv if not already active
source venv/bin/activate

# Run the application
python -m app.main
```

Or use uvicorn directly:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8100
```

### 7. Access the UI

Open your browser and go to:
- **Web UI**: http://localhost:8100/configure/
- **API Health**: http://localhost:8100/health
- **System Status**: http://localhost:8100/status
- **Configuration**: http://localhost:8100/config

## Run as Systemd Service (Optional)

To run GlanceWatch as a background service:

### 1. Create Service File for Glances

```bash
sudo tee /etc/systemd/system/glances.service > /dev/null << 'EOF'
[Unit]
Description=Glances System Monitor
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
ExecStart=/usr/bin/glances -w --port 61208
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

Replace `YOUR_USERNAME` with your actual username:
```bash
sudo sed -i "s/YOUR_USERNAME/$(whoami)/" /etc/systemd/system/glances.service
```

### 2. Create Service File for GlanceWatch

```bash
sudo tee /etc/systemd/system/glancewatch.service > /dev/null << 'EOF'
[Unit]
Description=GlanceWatch Monitoring Service
After=network.target glances.service
Requires=glances.service

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/glances-kuma-alerts
Environment="PATH=/home/YOUR_USERNAME/glances-kuma-alerts/venv/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=/home/YOUR_USERNAME/glances-kuma-alerts/venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8100
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

Replace placeholders with your username:
```bash
sudo sed -i "s/YOUR_USERNAME/$(whoami)/g" /etc/systemd/system/glancewatch.service
```

### 3. Enable and Start Services

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable services to start on boot
sudo systemctl enable glances
sudo systemctl enable glancewatch

# Start services
sudo systemctl start glances
sudo systemctl start glancewatch

# Check status
sudo systemctl status glances
sudo systemctl status glancewatch
```

### 4. View Logs

```bash
# Glances logs
sudo journalctl -u glances -f

# GlanceWatch logs
sudo journalctl -u glancewatch -f
```

## Testing

```bash
# Test Glances API
curl http://localhost:61208/api/4/cpu | python3 -m json.tool

# Test GlanceWatch Health
curl http://localhost:8100/health | python3 -m json.tool

# Test System Status
curl http://localhost:8100/status | python3 -m json.tool

# Test Configuration
curl http://localhost:8100/config | python3 -m json.tool
```

## Quick One-Liner Setup

For a super quick test (all in one terminal):

```bash
# Install dependencies
sudo apt update && sudo apt install -y python3 python3-pip python3-venv glances

# Go to project
cd ~/glances-kuma-alerts

# Setup venv
python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt

# Start Glances in background
nohup glances -w --port 61208 > /tmp/glances.log 2>&1 &

# Wait a moment for Glances to start
sleep 3

# Run GlanceWatch
python -m app.main
```

Then open http://localhost:8100/configure/ in your browser!

## Environment Variables

You can also configure using environment variables instead of config file:

```bash
export GLANCES_BASE_URL=http://localhost:61208/api/4
export RAM_THRESHOLD=80.0
export CPU_THRESHOLD=80.0
export DISK_THRESHOLD=85.0
export DISK_MOUNTS=/
export LOG_LEVEL=INFO

python -m app.main
```

## Troubleshooting

### Glances not accessible
```bash
# Check if Glances is running
ps aux | grep glances

# Check if port is listening
sudo netstat -tlnp | grep 61208

# Try accessing directly
curl http://localhost:61208/api/4
```

### GlanceWatch can't connect to Glances
```bash
# Check config
cat ~/.config/glancewatch/config.yaml

# Test connectivity
curl http://localhost:61208/api/4/cpu
```

### Port already in use
```bash
# Find what's using port 8100
sudo lsof -i :8100

# Kill the process
sudo kill -9 <PID>

# Or use a different port
uvicorn app.main:app --host 0.0.0.0 --port 8200
```

## Stopping Services

```bash
# If running in terminal, just Ctrl+C

# If running as systemd service
sudo systemctl stop glancewatch
sudo systemctl stop glances

# To disable auto-start
sudo systemctl disable glancewatch
sudo systemctl disable glances
```

## Performance Tips

1. **RAM Usage**: Both Glances and GlanceWatch are lightweight (~50MB RAM each)
2. **CPU Usage**: Minimal (<1% CPU when idle)
3. **Network**: Only localhost communication, no external traffic
4. **Disk**: Configuration stored in `~/.config/glancewatch/config.yaml`

## Remote Access

To access from another machine:

```bash
# Allow through firewall
sudo ufw allow 8100/tcp

# GlanceWatch is already configured to listen on 0.0.0.0
# Access from another machine: http://YOUR_SERVER_IP:8100/configure/
```

## Next Steps

- Configure Uptime Kuma to monitor the endpoints
- Set custom thresholds via the Web UI
- Add more disk mount points to monitor
- Set up SSL/TLS with nginx reverse proxy
