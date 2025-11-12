# Release Notes - v1.0.7

**Release Date:** November 12, 2025

## 🎯 Background Service Support

### Problem Solved
When you close the terminal, GlanceWatch stops running. Users need a way to run it in the background so it keeps running 24/7.

### New Features

#### 1. **One-Command Systemd Service Installer**
```bash
curl -sSL https://raw.githubusercontent.com/collinsKemboi/glanceswatch/main/install-service.sh | bash
```

Automatically:
- ✅ Installs GlanceWatch as a systemd service
- ✅ Starts on boot automatically  
- ✅ Restarts if it crashes
- ✅ Runs in background forever
- ✅ Professional management with systemctl

#### 2. **Helper Scripts**
- `start.sh` - Start GlanceWatch in background with nohup
- `stop.sh` - Stop GlanceWatch gracefully
- `restart.sh` - Restart GlanceWatch

#### 3. **Complete Documentation**
- `BACKGROUND-SERVICE.md` - Comprehensive guide for running in background
  * Systemd service (recommended)
  * nohup method (quick & simple)
  * screen method (interactive)
  * tmux method (modern)

---

## 📦 What's Included

### Systemd Service Template
Professional systemd service file that:
- Runs in quiet mode (no log spam)
- Auto-restarts on failure (RestartSec=10)
- Includes security hardening
- Integrated with systemd journal

### Installation Methods

**Recommended (Systemd):**
```bash
curl -sSL https://raw.githubusercontent.com/collinsKemboi/glanceswatch/main/install-service.sh | bash
```

**Quick (nohup):**
```bash
nohup glancewatch > /dev/null 2>&1 &
```

**With scripts:**
```bash
./start.sh              # Start in background
./stop.sh               # Stop service
./restart.sh            # Restart service
```

---

## 🔧 Systemd Service Management

```bash
# Check status
sudo systemctl status glancewatch

# Start service
sudo systemctl start glancewatch

# Stop service
sudo systemctl stop glancewatch

# Restart service
sudo systemctl restart glancewatch

# Enable auto-start on boot
sudo systemctl enable glancewatch

# View logs
sudo journalctl -u glancewatch -f
```

---

## 📊 Comparison of Methods

| Method | Auto-Start on Boot | Survives Logout | Easy to Manage | Logs |
|--------|-------------------|-----------------|----------------|------|
| **Systemd** | ✅ Yes | ✅ Yes | ✅ Yes (systemctl) | ✅ journalctl |
| **nohup** | ❌ No | ✅ Yes | ⚠️ Manual (ps/pkill) | ⚠️ File or none |
| **screen** | ❌ No | ✅ Yes | ⚠️ Manual | ✅ In session |
| **tmux** | ❌ No | ✅ Yes | ⚠️ Manual | ✅ In session |

---

## 🚀 Upgrade Instructions

### For Production Server (18.209.250.77)

```bash
# SSH into server
ssh ubuntu@18.209.250.77

# Upgrade GlanceWatch
pip install --upgrade glancewatch

# Install as systemd service (recommended)
curl -sSL https://raw.githubusercontent.com/collinsKemboi/glanceswatch/main/install-service.sh | bash

# Or use nohup method
nohup glancewatch > /dev/null 2>&1 &

# Verify it's running
ps aux | grep glancewatch
# or
sudo systemctl status glancewatch
```

Now you can close your terminal and GlanceWatch will keep running! 🎉

---

## 📝 Files Added

- `BACKGROUND-SERVICE.md` - Complete background service guide
- `install-service.sh` - One-command systemd installer
- `start.sh` - Quick start script (nohup)
- `stop.sh` - Stop script
- `restart.sh` - Restart script
- `systemd/glancewatch.service` - Systemd service template

---

## 📝 Files Updated

- `README.md` - Added background service section
- `pyproject.toml` - Version bump to 1.0.7
- `app/ui/index.html` - Version display updated
- `app/ui/docs.html` - Version display updated

---

## 🎯 Use Cases

### Production Server
```bash
# Install as systemd service - runs forever
curl -sSL https://raw.githubusercontent.com/collinsKemboi/glanceswatch/main/install-service.sh | bash
```

### Quick Testing
```bash
# Start in background with nohup
./start.sh

# Stop when done
./stop.sh
```

### Development
```bash
# Run in foreground with verbose logging
glancewatch --verbose
```

---

## ✅ Benefits

1. **Never stops running** - Survives terminal close, SSH disconnect, logout
2. **Auto-starts on boot** - No manual intervention needed after reboot
3. **Auto-restarts on crash** - Built-in fault tolerance
4. **Professional management** - systemctl commands for easy control
5. **Proper logging** - Integrated with systemd journal

---

## 📚 Documentation

- **Background Service:** `BACKGROUND-SERVICE.md`
- **Logging:** `LOGGING.md`
- **Release Notes:** `RELEASE_NOTES_v1.0.7.md`
- **Quick Start:** `QUICKSTART.md`
- **README:** `README.md`

---

## 🙏 Thanks

Thanks for the feedback about terminal disconnect issues! This release makes GlanceWatch production-ready for 24/7 operation.

**Full Changelog:** v1.0.6...v1.0.7
