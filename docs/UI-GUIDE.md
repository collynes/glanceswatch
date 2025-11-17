# GlanceWatch Web UI Guide 🎨

The GlanceWatch Web UI provides an intuitive interface for monitoring your system and configuring alert thresholds in real-time.

## Accessing the UI

Once GlanceWatch is running, access the web interface at:

```
http://localhost:8100/ui
```

(Replace `localhost:8100` with your server's address if running remotely)

## Features

###  Real-Time Dashboard

The dashboard displays three key metrics:

1. **RAM Usage** 💾
   - Current memory usage percentage
   - Visual progress bar with color-coded status
   - Updates every 5 seconds

2. **CPU Usage** ⚡
   - Average CPU usage across all cores
   - Real-time percentage display
   - Threshold indicator

3. **Disk Usage** 💿
   - Usage per monitored mount point
   - Shows all configured disks (default: `/`)
   - Individual bars for each volume

### 🎚️ Threshold Configuration

Easily adjust alert thresholds using intuitive sliding bars:

- **RAM Threshold**: 10-100% (default: 80%)
- **CPU Threshold**: 10-100% (default: 80%)
- **Disk Threshold**: 10-100% (default: 85%)

**How to adjust:**

1. Drag the slider to your desired threshold
2. The value updates in real-time
3. Click "Save Changes" to persist
4. Changes are saved to `config.yaml` automatically

### 🎨 Status Indicators

Visual feedback for system health:

| Color | Meaning | Threshold Range |
|-------|---------|----------------|
| 🟢 Green | Healthy | < 75% of threshold |
| 🟡 Yellow | Warning | 75-90% of threshold |
| 🔴 Red | Critical | > 90% of threshold |

### ⚙️ Configuration Panel

Located below the dashboard, the configuration panel shows:

- Current threshold values for all metrics
- Save/Reset buttons
- Success/error message feedback
- Configuration loading states

## Usage Examples

### Example 1: Increase RAM Alert Threshold

If you're seeing too many false alarms for RAM:

1. Go to **Threshold Configuration**
2. Find the **RAM Threshold** slider
3. Drag it from 80% to 90%
4. Click **Save Changes**
5. Confirmation message appears
6. New threshold active immediately

### Example 2: Tighten CPU Monitoring

For more sensitive CPU monitoring:

1. Locate **CPU Threshold** slider
2. Adjust from 80% down to 70%
3. Click **Save Changes**
4. Dashboard will show warning colors sooner

### Example 3: Monitor Disk Space Closely

For servers with limited storage:

1. Find **Disk Threshold** slider
2. Lower from 85% to 75%
3. Click **Save Changes**
4. Earlier warnings when disk fills up

## Dashboard Sections

### System Status Overview

Top section shows:
- Overall health badge (✓ Healthy / ⚠ Alert)
- Service uptime
- Glances connection status

### Metrics Grid

Three cards displaying:
- Current usage value (large number)
- Progress bar with gradient fill
- Threshold comparison
- Status icon (✓/◐/⚠)

### Last Update Timestamp

Bottom of dashboard shows:
- When metrics were last fetched
- Pulsing indicator showing active monitoring

## Keyboard Shortcuts

- **Tab**: Navigate between sliders
- **Arrow Keys**: Fine-tune slider values (when focused)
- **Enter**: Save changes (when button focused)

## Troubleshooting

### UI Shows "Loading metrics..."

**Cause**: Cannot connect to GlanceWatch API

**Solutions**:
1. Check if GlanceWatch container is running: `docker ps`
2. Verify port 8100 is accessible
3. Check logs: `docker logs glancewatch`

### UI Shows "Failed to load configuration"

**Cause**: API endpoint `/config` not responding

**Solutions**:
1. Refresh the page
2. Check GlanceWatch logs for errors
3. Verify Glances is running: `curl http://localhost:61208/api/4/status`

### Changes Don't Persist

**Cause**: Configuration file not writable

**Solutions**:
1. Check Docker volume permissions
2. Verify `/var/lib/glancewatch/config.yaml` is writable
3. Check container logs for permission errors

### Metrics Show "No data available"

**Cause**: Glances not reporting metrics

**Solutions**:
1. Restart Glances container: `docker-compose restart glances`
2. Check Glances API: `curl http://localhost:61208/api/4/mem`
3. Verify network connectivity between containers

## Advanced Usage

### Accessing from Remote Server

If GlanceWatch is running on a remote server:

```bash
# SSH tunnel method
ssh -L 8100:localhost:8100 user@remote-server

# Then access: http://localhost:8100/ui
```

### Embedding in Dashboard

The UI can be embedded in an iframe:

```html
<iframe src="http://your-server:8100/ui" 
        width="100%" 
        height="800px" 
        frameborder="0">
</iframe>
```

### Mobile Access

The UI is responsive and works on mobile devices:
- Touch-friendly sliders
- Optimized layout for small screens
- All features available on mobile

## API Alternative

Prefer API over UI? Update thresholds programmatically:

```bash
curl -X PUT http://localhost:8100/config \
  -H "Content-Type: application/json" \
  -d '{
    "thresholds": {
      "ram_percent": 85,
      "cpu_percent": 90,
      "disk_percent": 80
    }
  }'
```

## Best Practices

1. **Start Conservative**: Begin with default thresholds (80/80/85)
2. **Monitor Patterns**: Watch for a week before adjusting
3. **Avoid Too Low**: Below 50% causes excessive alerts
4. **Test Changes**: Adjust one metric at a time
5. **Document Why**: Keep notes on threshold reasoning

## Design Philosophy

The UI follows these principles:

- **Simplicity**: Core function visible at a glance
- **Immediacy**: Changes apply instantly
- **Visibility**: Always show current state
- **Feedback**: Confirm every action
- **Persistence**: Never lose configuration

---

For API documentation, see: `http://localhost:8100/docs`
For questions or issues, visit: [GitHub Issues](https://github.com/yourusername/glancewatch/issues)
