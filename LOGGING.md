# GlanceWatch Logging Guide

## Default Behavior (Production-Ready)

By default, GlanceWatch runs with **minimal, professional logging**:
- ✓ Clean startup message with dashboard URL
- ✓ Only warnings and errors are displayed
- ✓ No HTTP request logs cluttering the console
- ✓ Perfect for production deployments

```bash
$ glancewatch

🚀 GlanceWatch v1.0.6 starting...
 Dashboard: http://localhost:8000/

# Clean! No spam!
```

---

## Logging Modes

### Quiet Mode (Errors Only)
For systemd services or when you want absolute silence:

```bash
glancewatch --quiet
# or
glancewatch -q
```

**Output:** Only critical errors (nothing else)

---

### Verbose Mode (Debug)
For troubleshooting or development:

```bash
glancewatch --verbose
# or
glancewatch -v
```

**Output:** Shows all HTTP requests, detailed startup info, and more

Example:
```bash
$ glancewatch --verbose

✓ Glances is already running
🚀 GlanceWatch v1.0.6 starting...
 Dashboard: http://localhost:8000/
🔧 API Docs:  http://localhost:8000/api
🔗 Glances:   http://localhost:61208

2025-11-12 11:30:45,123 - INFO - HTTP Request: GET http://localhost:61208/api/3/mem "HTTP/1.0 200 OK"
INFO:     85.255.20.137:23778 - "GET /status HTTP/1.1" 200 OK
...
```

---

## Systemd Service (Recommended for Production)

For production servers, use the systemd service which automatically runs in quiet mode:

```bash
# Install and enable service
curl -sSL https://raw.githubusercontent.com/collynes/glanceswatch/main/install-service.sh | bash

# View logs only when needed
sudo journalctl -u glancewatch -f
```

---

## Command Line Options

```bash
glancewatch [OPTIONS]

Options:
  --host HOST              Override host address (default: 0.0.0.0)
  --port PORT              Override port number (default: 8000)
  --ignore-glances         Skip Glances startup check
  --verbose, -v            Enable verbose logging
  --quiet, -q              Quiet mode (errors only)
  --help, -h               Show help message
```

---

## Best Practices

### Development
```bash
glancewatch --verbose  # See all requests for debugging
```

### Production (Manual)
```bash
glancewatch  # Clean, professional output
```

### Production (Service)
```bash
# Use systemd service with quiet mode
sudo systemctl start glancewatch
sudo journalctl -u glancewatch -f  # View logs when troubleshooting
```

### Docker/Container
```bash
glancewatch --quiet  # Minimal logs in container logs
```

---

## Comparing Log Output

### ❌ Old (Noisy)
```
2025-11-12 11:02:44,644 - httpx - INFO - HTTP Request: GET http://localhost:61208/api/3/mem "HTTP/1.0 200 OK"
2025-11-12 11:02:44,645 - httpx - INFO - HTTP Request: GET http://localhost:61208/api/3/cpu "HTTP/1.0 200 OK"
2025-11-12 11:02:44,646 - httpx - INFO - HTTP Request: GET http://localhost:61208/api/3/fs "HTTP/1.0 200 OK"
INFO:     85.255.20.137:23778 - "GET /status HTTP/1.1" 200 OK
2025-11-12 11:02:46,285 - httpx - INFO - HTTP Request: GET http://localhost:61208/api/3/mem "HTTP/1.0 200 OK"
...
```

### ✅ New (Professional)
```
🚀 GlanceWatch v1.0.6 starting...
 Dashboard: http://localhost:8000/

# Silent operation - only errors shown if they occur
```

---

## Need Help?

- **GitHub Issues:** https://github.com/collynes/glanceswatch/issues
- **Documentation:** https://github.com/collynes/glanceswatch#readme
