# Running GlanceWatch in Background

## Problem
When you close the terminal, GlanceWatch stops running. This guide shows you how to run it in the background so it keeps running even after you log out.

---

## ✅ Recommended: Systemd Service (Linux)

### One-Command Install
```bash
curl -sSL https://raw.githubusercontent.com/collinskramp/glanceswatch/main/install-service.sh | bash
```

This will:
- ✅ Install GlanceWatch as a systemd service
- ✅ Start automatically on boot
- ✅ Restart automatically if it crashes
- ✅ Run in the background forever
- ✅ Keep running when you close terminal or logout

### Manual Systemd Setup

1. **Create service file:**
```bash
sudo nano /etc/systemd/system/glancewatch.service
```

2. **Paste this configuration:**
```ini
[Unit]
Description=GlanceWatch - System Monitoring Dashboard
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu
Environment="PATH=/home/ubuntu/.local/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=/home/ubuntu/.local/bin/glancewatch --quiet
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=glancewatch

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=/home/ubuntu/.config/glancewatch

[Install]
WantedBy=multi-user.target
```

**Note:** Replace `ubuntu` with your username if different.

3. **Enable and start service:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable glancewatch.service
sudo systemctl start glancewatch.service
```

4. **Check status:**
```bash
sudo systemctl status glancewatch
```

### Systemd Management Commands

```bash
# Check if running
sudo systemctl status glancewatch

# Start service
sudo systemctl start glancewatch

# Stop service
sudo systemctl stop glancewatch

# Restart service
sudo systemctl restart glancewatch

# Enable auto-start on boot
sudo systemctl enable glancewatch

# Disable auto-start on boot
sudo systemctl disable glancewatch

# View logs
sudo journalctl -u glancewatch -f

# View last 50 lines of logs
sudo journalctl -u glancewatch -n 50
```

---

## 🔧 Alternative 1: nohup (Quick & Simple)

Good for quick testing or when you don't have systemd.

### Start in Background
```bash
nohup glancewatch > /dev/null 2>&1 &
```

**Explanation:**
- `nohup` = Keep running after logout
- `> /dev/null 2>&1` = Don't save output logs
- `&` = Run in background

### With Log File
```bash
nohup glancewatch > glancewatch.log 2>&1 &
```

This saves logs to `glancewatch.log` file.

### Check if Running
```bash
ps aux | grep glancewatch
```

### Stop It
```bash
pkill -f glancewatch
```

---

## 🖥️ Alternative 2: Screen (Keep Terminal Session)

Good if you want to reattach and see the output later.

### Install Screen
```bash
sudo apt install screen  # Ubuntu/Debian
sudo yum install screen  # CentOS/RHEL
```

### Start GlanceWatch in Screen
```bash
# Create a screen session named "glancewatch"
screen -S glancewatch

# Inside screen, start glancewatch
glancewatch

# Detach from screen: Press Ctrl+A, then D
```

### Reattach to Screen
```bash
# List screen sessions
screen -ls

# Reattach to glancewatch session
screen -r glancewatch
```

### Kill Screen Session
```bash
# Reattach first
screen -r glancewatch

# Then press Ctrl+C to stop, then exit
```

---

## 🪟 Alternative 3: tmux (Modern Screen Alternative)

Similar to screen but more modern.

### Install tmux
```bash
sudo apt install tmux  # Ubuntu/Debian
sudo yum install tmux  # CentOS/RHEL
```

### Start GlanceWatch in tmux
```bash
# Create tmux session
tmux new -s glancewatch

# Inside tmux, start glancewatch
glancewatch

# Detach from tmux: Press Ctrl+B, then D
```

### Reattach to tmux
```bash
# List sessions
tmux ls

# Reattach to session
tmux attach -t glancewatch
```

---

## 📊 Comparison Table

| Method | Auto-Start on Boot | Survives Logout | Easy to Manage | Logs |
|--------|-------------------|-----------------|----------------|------|
| **Systemd** | ✅ Yes | ✅ Yes | ✅ Yes (systemctl) | ✅ journalctl |
| **nohup** | ❌ No | ✅ Yes | ⚠️ Manual (ps/pkill) | ⚠️ File or none |
| **screen** | ❌ No | ✅ Yes | ⚠️ Manual | ✅ In session |
| **tmux** | ❌ No | ✅ Yes | ⚠️ Manual | ✅ In session |

---

## 🎯 Best Practices

### Production Server (Ubuntu 18.209.250.77)
```bash
# Use systemd service
curl -sSL https://raw.githubusercontent.com/collinskramp/glanceswatch/main/install-service.sh | bash
```

**Benefits:**
- Starts on boot automatically
- Restarts if crashes
- Professional logging with journalctl
- Easy management with systemctl

### Development/Testing
```bash
# Use nohup for quick testing
nohup glancewatch --verbose > glancewatch.log 2>&1 &
```

### Interactive Debugging
```bash
# Use screen or tmux
screen -S glancewatch
glancewatch --verbose
# Ctrl+A, then D to detach
```

---

## 🚀 Quick Start for Your Server

**For your Ubuntu server (18.209.250.77):**

```bash
# SSH into server
ssh ubuntu@18.209.250.77

# Install GlanceWatch if not already
pip install glancewatch

# Install as systemd service (recommended)
curl -sSL https://raw.githubusercontent.com/collinskramp/glanceswatch/main/install-service.sh | bash

# Or quick nohup method
nohup glancewatch > /dev/null 2>&1 &

# Check if running
ps aux | grep glancewatch

# Access dashboard
# http://18.209.250.77:8000
```

Now you can close your terminal and GlanceWatch will keep running! 🎉

---

## ❓ Troubleshooting

### Service won't start
```bash
# Check logs
sudo journalctl -u glancewatch -xe

# Check status
sudo systemctl status glancewatch

# Verify glancewatch command works
glancewatch --help
```

### Can't find glancewatch binary
```bash
# Find where it's installed
which glancewatch

# If not found, check pip install location
python3 -m site --user-base

# Update PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Port 8000 already in use
```bash
# Use different port
glancewatch --port 8080

# Or update systemd service
sudo nano /etc/systemd/system/glancewatch.service
# Change ExecStart line to: ExecStart=/path/to/glancewatch --port 8080
sudo systemctl daemon-reload
sudo systemctl restart glancewatch
```

---

## 📚 See Also

- `QUICKSTART.md` - General installation guide
- `QUICKSTART-UBUNTU.md` - Ubuntu-specific setup
- `LOGGING.md` - Logging configuration guide
- `README.md` - Full documentation
