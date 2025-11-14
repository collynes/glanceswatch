# Release Notes - v1.2.0

**Release Date:** November 14, 2025

## Overview

Version 1.2.0 brings **major UI/UX improvements** with breaking changes to the dashboard layout and behavior. This release focuses on visual clarity, better data presentation, and enhanced user control.

---

## ⚠️ Breaking Changes

### UI Layout Changes
- **Section Reordering**: Threshold Configuration now appears BEFORE System Health Monitor
- **Circle Visual Behavior**: Changed from thick white borders to thin green/red status indicators
- **Reset Button Logic**: Now always enabled and resets to defaults instead of reverting to last saved
- **System Health Monitor Content**: Replaced duplicate RAM/CPU/Disk cards with unique metrics (Uptime, Load, Network)

### Configuration Changes
- **CPU Threshold Range**: Now supports 0.1% - 100% (previously 10% - 100%)
- **RAM/Disk Threshold Range**: Now supports 1% - 100% (previously 10% - 100%)

**Migration Notes**: No action required for existing installations. All changes are cosmetic/behavioral. Your saved thresholds will continue to work.

---

## What's New

### Visual Improvements

#### 🎨 Enhanced Health Status Indicators
- **Thin Green Rings for Healthy Metrics**: Circle metrics now display with thin (2px) green borders when within thresholds
- **Red Rings for Critical Status**: Thresholds exceeded show clear red borders with pulse animation
- **Improved Visual Hierarchy**: Cleaner, more professional appearance with better contrast
- **Default Green State**: Circles show green by default instead of neutral gray/white

#### 📊 New System Health Monitor Section
- **System Uptime**: Real-time display of system uptime (format: "HH:MM:SS")
- **Load Average**: Shows 1-minute, 5-minute, and 15-minute load averages
- **Network Activity**: Displays total network traffic (upload/download) since boot
- **Uptime Kuma-Inspired Design**: Horizontal status cards with left-colored borders and hover effects
- **Meaningful Data**: No more duplicate metrics - shows complementary system information

### Configuration Enhancements

#### ⚙️ Improved Threshold Controls
- **Ultra-Low CPU Threshold**: CPU threshold now supports values as low as 0.1% with decimal precision (0.1 step)
- **Flexible Range**: RAM and Disk thresholds now support 1-100% range (1% step)
- **Always-Available Reset**: "Reset to Defaults" button is now always enabled
- **Clear Default Values**: Reset button clearly indicates it restores default values (RAM: 80%, CPU: 80%, Disk: 85%)
- **Better UX**: Can reset anytime without needing pending changes

### UI Layout Optimization

#### 📐 Better Section Organization
- **Reorganized Layout**: 
  1. Metric Circles (RAM/CPU/Disk)
  2. Threshold Configuration (adjust limits)
  3. System Health Monitor (uptime/load/network)
  4. Footer
- **Logical Workflow**: Configure thresholds before viewing detailed system stats
- **Progressive Disclosure**: Most important info (circles) at top, details below

### Documentation Cleanup

#### 📝 Professional Polish
- **Removed AI Emojis**: Cleaned up unsolicited emojis from documentation files for professional appearance
- **Consistent Branding**: Maintained only essential emoji icons for UI navigation (⏱️ 📈 🌐)
- **Cleaner Startup Messages**: Removed decorative emojis from console output
- **Professional Tone**: All docs now have consistent, enterprise-ready presentation

---

## Technical Details

### Backend Changes
- Added `/system-info` API endpoint for additional system metrics
- New `get_system_info()` method in `GlancesMonitor` class
- Proper handling of Glances API response formats:
  - Uptime: String format "HH:MM:SS"
  - Load: Object with `min1`, `min5`, `min15`, `cpucore` fields
  - Network: Array with `bytes_recv`/`bytes_sent` per interface

### Frontend Changes
- New `loadSystemInfo()` JavaScript function for real-time system data
- Fixed field name mapping for Glances network API (`bytes_recv`/`bytes_sent` instead of `rx_bytes`/`tx_bytes`)
- Enhanced slider controls with configurable min/max/step values:
  - CPU: `min="0.1" step="0.1"`
  - RAM/Disk: `min="1" step="1"`
- Improved button state management for better UX
- Separated metrics loading from system info loading for better performance

### CSS Improvements
- Refined circle border styles:
  - Default: `border: 2px solid rgba(16, 185, 129, 0.6)` (thin green)
  - Critical: `border: 2px solid #ef4444` (red) with pulse animation
- Uptime Kuma-style card design with colored left borders
- Better hover effects and transitions (`translateX(4px)`)
- Optimized spacing and typography throughout

---

## Bug Fixes

- ✅ Fixed system health monitor showing "--" by correcting Glances API field names
- ✅ Resolved slider minimum value restrictions preventing low thresholds
- ✅ Fixed button disable logic preventing reset when no changes made
- ✅ Corrected network traffic calculation (was using wrong field names)
- ✅ Fixed uptime display (was trying to parse string as seconds)

---

## Upgrade Guide

### From v1.0.x to v1.2.0

**Using pip:**
```bash
pip install --upgrade glancewatch
```

**Using systemd service:**
```bash
# Upgrade package
pip install --upgrade glancewatch

# Restart service to load new UI
sudo systemctl restart glancewatch
```

**Using Docker:**
```bash
docker pull glancewatch:1.2.0
docker-compose up -d
```

**⚠️ UI Changes**: 
- The dashboard layout has changed - sections are reordered
- Circle visual appearance is different (thin green/red borders)
- Reset button behavior changed (always enabled, resets to defaults)
- New metrics in System Health Monitor section

No configuration file changes required - all improvements are in the UI layer.

---

## Configuration Defaults

Default threshold values remain unchanged:
- **RAM**: 80%
- **CPU**: 80%
- **Disk**: 85%

New capabilities:
- **CPU**: Can now be set as low as 0.1% (for high-precision monitoring)
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
- Removal of decorative emojis for professional deployments

---

## What's Next (v1.3.0)

Potential future enhancements:
- Temperature monitoring (if supported by Glances)
- Process-level monitoring
- Historical data graphs with time-series visualization
- Email/webhook alerting system
- Multi-server dashboard view
- Custom alert rules (e.g., "alert if load > 5.0 for 10 minutes")

---

## Links

- **PyPI**: https://pypi.org/project/glancewatch/
- **GitHub**: https://github.com/collynes/glancewatch
- **Documentation**: https://github.com/collynes/glancewatch#readme
- **Issues**: https://github.com/collynes/glancewatch/issues

---

**Full Changelog**: https://github.com/collynes/glancewatch/compare/v1.0.10...v1.2.0
