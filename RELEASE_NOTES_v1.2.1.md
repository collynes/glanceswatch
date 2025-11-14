# Release Notes - v1.2.1

**Release Date:** November 14, 2025

## Overview

Version 1.2.1 is a patch release that fixes hardcoded version strings in the UI by implementing dynamic version injection from the package metadata.

---

## Bug Fixes

### Version Display Issue
- **Fixed**: Hardcoded version strings in HTML template (showed v1.0.10 in header, v1.2.0 in footer)
- **Solution**: Implemented dynamic version injection using `{{VERSION}}` template variable
- **Result**: UI now always displays the correct installed package version

### Technical Changes
- Added `HTMLResponse` to serve index.html with template replacement
- Modified root endpoint (`/`) to inject `__version__` into HTML content
- Replaced hardcoded version strings with `{{VERSION}}` template variable in:
  - Header: `<span class="version">v{{VERSION}}</span>`
  - Footer: `GlanceWatch v{{VERSION}}`

---

## Why This Matters

Previously, if you upgraded GlanceWatch, the UI would still show old version numbers because they were hardcoded in the HTML file. Now the version is dynamically injected from the Python package, ensuring:

- ✅ Version displayed always matches installed package
- ✅ No need to manually update HTML during releases
- ✅ Users can verify they're running the correct version
- ✅ Reduces maintenance overhead for version bumps

---

## Upgrade Guide

### From v1.2.0 to v1.2.1

**Using pip:**
```bash
pip3 install --upgrade glancewatch
```

**Using systemd service:**
```bash
# Upgrade package
pip3 install --upgrade glancewatch

# Restart service to load new version
sudo systemctl restart glancewatch
```

**Verify version:**
```bash
pip3 show glancewatch | grep Version
```

Or check the UI header/footer - they will now show **v1.2.1**.

---

## No Breaking Changes

This is a pure bug fix release:
- ✅ No configuration changes required
- ✅ No API changes
- ✅ No database migrations
- ✅ Fully backward compatible with v1.2.0

---

## Links

- **PyPI**: https://pypi.org/project/glancewatch/1.2.1/
- **GitHub**: https://github.com/collynes/glancewatch
- **Documentation**: https://github.com/collynes/glancewatch#readme
- **Issues**: https://github.com/collynes/glancewatch/issues

---

**Full Changelog**: https://github.com/collynes/glancewatch/compare/v1.2.0...v1.2.1
