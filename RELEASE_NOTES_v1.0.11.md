# Release Notes - v1.0.11

**Release Date:** November 14, 2025

## Overview

Version 1.0.11 brings significant UI/UX improvements focused on visual clarity, better data presentation, and enhanced user control over threshold configuration.

---

## What's New

### Visual Improvements

#### 🎨 Enhanced Health Status Indicators
- **Thin Green Rings for Healthy Metrics**: Circle metrics now display with thin (2px) green borders when within thresholds
- **Red Rings for Critical Status**: Thresholds exceeded show clear red borders with pulse animation
- **Improved Visual Hierarchy**: Cleaner, more professional appearance with better contrast

#### 📊 New System Health Monitor Section
- **System Uptime**: Real-time display of system uptime (format: "HH:MM:SS")
- **Load Average**: Shows 1-minute, 5-minute, and 15-minute load averages
- **Network Activity**: Displays total network traffic (upload/download) since boot
- **Uptime Kuma-Inspired Design**: Horizontal status cards with left-colored borders and hover effects

### Configuration Enhancements

#### ⚙️ Improved Threshold Controls
- **Ultra-Low CPU Threshold**: CPU threshold now supports values as low as 0.1% with decimal precision
- **Flexible Range**: RAM and Disk thresholds now support 1-100% range
- **Always-Available Reset**: "Reset to Defaults" button is now always enabled
- **Clear Default Values**: Reset button now clearly indicates it restores default values (RAM: 80%, CPU: 80%, Disk: 85%)

### UI Layout Optimization

#### 📐 Better Section Organization
- **Reorganized Layout**: Threshold Configuration now appears before System Health Monitor for better workflow
- **Logical Grouping**: Metrics → Configuration → System Info → Footer

### Documentation Cleanup

#### 📝 Professional Polish
- **Removed AI Emojis**: Cleaned up unsolicited emojis from documentation files for professional appearance
- **Consistent Branding**: Maintained only essential emoji icons for UI navigation (⏱️ 📈 🌐)
- **Cleaner Startup Messages**: Removed decorative emojis from console output

---

## Technical Details

### Backend Changes
- Added `/system-info` API endpoint for additional system metrics
- New `get_system_info()` method in `GlancesMonitor` class
- Proper handling of Glances API response formats (uptime as string, network byte fields)

### Frontend Changes
- New `loadSystemInfo()` JavaScript function for real-time system data
- Fixed field name mapping for Glances network API (`bytes_recv`/`bytes_sent`)
- Enhanced slider controls with configurable min/max/step values
- Improved button state management for better UX

### CSS Improvements
- Refined circle border styles (thin green for OK, red for critical)
- Uptime Kuma-style card design with colored left borders
- Better hover effects and transitions
- Optimized spacing and typography

---

## Bug Fixes

- Fixed system health monitor showing "--" by correcting Glances API field names
- Resolved slider minimum value restrictions
- Fixed button disable logic for better user control

---

## Upgrade Guide

### From v1.0.10 to v1.0.11

**Using pip:**
```bash
pip install --upgrade glancewatch
```

**Using systemd service:**
```bash
# Upgrade package
pip install --upgrade glancewatch

# Restart service
sudo systemctl restart glancewatch
```

**Using Docker:**
```bash
docker pull glancewatch:1.0.11
docker-compose up -d
```

No configuration changes required - all improvements are backward compatible.

---

## Configuration Defaults

Default threshold values remain unchanged:
- **RAM**: 80%
- **CPU**: 80%
- **Disk**: 85%

New capabilities:
- **CPU**: Can now be set as low as 0.1%
- **RAM/Disk**: Can now be set as low as 1%

---

## Known Issues

None reported for this release.

---

## Acknowledgments

Special thanks to users who requested:
- Better visual distinction between healthy/critical states
- More granular CPU threshold control
- Additional system metrics beyond basic RAM/CPU/Disk

---

## What's Next (v1.0.12)

Potential future enhancements:
- Temperature monitoring (if supported by Glances)
- Process-level monitoring
- Historical data graphs
- Email/webhook alerting
- Multi-server dashboard

---

## Links

- **PyPI**: https://pypi.org/project/glancewatch/
- **GitHub**: https://github.com/collynes/glancewatch
- **Documentation**: https://github.com/collynes/glancewatch#readme
- **Issues**: https://github.com/collynes/glancewatch/issues

---

**Full Changelog**: https://github.com/collynes/glancewatch/compare/v1.0.10...v1.0.11
