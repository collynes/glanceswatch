# Release Notes - v1.0.6

**Release Date:** November 12, 2025

## 🎯 Professional Logging Improvements

### Clean, Industry-Standard Output
- **Default Mode:** Minimal, professional logging - only warnings and errors
- **No More Spam:** Suppressed noisy HTTP request logs (httpx, httpcore, uvicorn)
- **Clean Startup:** Beautiful, concise startup messages with emoji indicators
- **Production-Ready:** Perfect for systemd services and production deployments

---

## ✨ New Features

### Configurable Logging Modes

**Default (Professional)**
```bash
$ glancewatch
🚀 GlanceWatch v1.0.6 starting...
 Dashboard: http://localhost:8000/

# Clean! Silent operation - only errors shown if they occur
```

**Quiet Mode (Systemd/Production)**
```bash
$ glancewatch --quiet   # or -q
# Absolute silence - only critical errors
```

**Verbose Mode (Development/Debug)**
```bash
$ glancewatch --verbose  # or -v
# Shows all HTTP requests, detailed logs, perfect for troubleshooting
```

---

## 🔧 What Changed

### Before v1.0.6 (Noisy)
```
2025-11-12 11:02:44,644 - httpx - INFO - HTTP Request: GET http://localhost:61208/api/3/mem "HTTP/1.0 200 OK"
2025-11-12 11:02:44,645 - httpx - INFO - HTTP Request: GET http://localhost:61208/api/3/cpu "HTTP/1.0 200 OK"
2025-11-12 11:02:44,646 - httpx - INFO - HTTP Request: GET http://localhost:61208/api/3/fs "HTTP/1.0 200 OK"
INFO:     85.255.20.137:23778 - "GET /status HTTP/1.1" 200 OK
...hundreds of lines of logs...
```

### After v1.0.6 (Professional)
```
🚀 GlanceWatch v1.0.6 starting...
 Dashboard: http://localhost:8000/

# Clean, silent operation ✨
```

---

## 📦 Installation

```bash
# Fresh install
pip install glancewatch==1.0.6

# Upgrade from previous version
pip install --upgrade glancewatch
```

---

## 🚀 Usage

### Basic (Clean, Professional)
```bash
glancewatch
```

### Quiet Mode (Production/Systemd)
```bash
glancewatch --quiet
```

### Verbose Mode (Development)
```bash
glancewatch --verbose
```

### With Options
```bash
glancewatch --host 0.0.0.0 --port 8080 --verbose
```

---

## 📝 Technical Details

### Logging Configuration Changes
- **Default log level:** `WARNING` (was `INFO`)
- **httpx logger:** Suppressed to `WARNING`
- **httpcore logger:** Suppressed to `WARNING`  
- **uvicorn.access:** Suppressed to `WARNING`
- **Startup messages:** Cleaned up, removed unnecessary info logs
- **Shutdown messages:** Removed (silent, clean exit)

### New CLI Options
- `--verbose` / `-v`: Enable detailed logging
- `--quiet` / `-q`: Only show errors
- Uvicorn log level automatically adjusted based on mode

### Code Changes
- `app/main.py`: Updated logging configuration
- `app/main.py`: Added verbose/quiet CLI flags
- `app/main.py`: Cleaned up startup/shutdown messages
- `app/main.py`: Professional startup output with emojis

---

## 📚 Documentation

New documentation added:
- **LOGGING.md** - Complete logging guide with examples
- **install-service.sh** - Systemd service auto-installer (updated for quiet mode)

---

## 🎯 Best Practices

### Development
```bash
glancewatch --verbose  # See everything
```

### Production (Manual)
```bash
glancewatch  # Clean, professional
```

### Production (Systemd Service)
```bash
sudo systemctl start glancewatch  # Runs in quiet mode
sudo journalctl -u glancewatch -f  # View logs only when needed
```

### Docker/Containers
```bash
glancewatch --quiet  # Minimal logs in container output
```

---

## 🐛 Bug Fixes

- Fixed excessive logging in production environments
- Removed noisy HTTP request logs cluttering console
- Cleaned up startup/shutdown message spam

---

## ⬆️ Upgrade Instructions

### For Production Server (18.209.250.77)

```bash
# SSH into server
ssh ubuntu@18.209.250.77

# Upgrade
pip install --upgrade glancewatch

# Restart
pkill -f glancewatch
glancewatch

# Or if using systemd:
sudo systemctl restart glancewatch
```

### Verify
After upgrade, you should see clean, professional output:
```
🚀 GlanceWatch v1.0.6 starting...
 Dashboard: http://localhost:8000/
```

No more log spam! 🎉

---

## 🙏 Feedback

Thanks for the feedback about logging! This release makes GlanceWatch truly production-ready with industry-standard, professional output.

**Full Changelog:** v1.0.5...v1.0.6
