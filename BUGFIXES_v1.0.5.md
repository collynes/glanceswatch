# GlanceWatch v1.0.5 Release Summary

## ✅ Release Complete

**Version:** 1.0.5  
**Release Date:** November 12, 2025  
**PyPI:** https://pypi.org/project/glancewatch/1.0.5/  
**GitHub:** https://github.com/collynes/glanceswatch/releases/tag/v1.0.5

---

## 🐛 Critical Bug Fixed

### Issue
Version 1.0.4 had a critical packaging bug where UI files were not included in the pip distribution. Users who installed via `pip install glancewatch` would see JSON output instead of the HTML dashboard when accessing the root URL.

### Root Cause
The UI files were located in the `ui/` directory at the repository root, but setuptools was not configured to include them in the Python package distribution. The `MANIFEST.in` configuration alone was insufficient.

### Solution
1. **Moved UI files into the app package:** `ui/*.html` → `app/ui/*.html`
2. **Updated pyproject.toml:** Added `app.ui` to the packages list
3. **Updated app/main.py:** Changed UI file paths from `Path(__file__).parent.parent / "ui"` to `Path(__file__).parent / "ui"`
4. **Created app/ui/__init__.py:** Made `app/ui` a proper Python package
5. **Updated MANIFEST.in:** Added `*.html` to recursive-include for app directory

---

## 📦 Verification

### Package Contents Confirmed
```bash
$ unzip -l dist/glancewatch-1.0.5-py3-none-any.whl | grep "app/ui"
       46  11-12-2025 10:51   app/ui/__init__.py
    22782  11-12-2025 10:51   app/ui/docs.html
    19055  11-12-2025 10:51   app/ui/index-simple.html
    34997  11-12-2025 10:51   app/ui/index.html
```

All UI files are now properly included in the distribution!

---

## 🚀 Deployment Instructions

### For Production Server (18.209.250.77)

```bash
# SSH into the server
ssh ubuntu@18.209.250.77

# Upgrade to v1.0.5
pip install --upgrade glancewatch

# Restart GlanceWatch
pkill -f glancewatch
glancewatch
```

### Verify the Fix

After upgrading, visit:
- **http://18.209.250.77:8000/** → Should show the full HTML dashboard (not JSON)
- **http://18.209.250.77:8000/docs** → Should show the Uptime Kuma setup documentation

---

## 📝 Files Changed

### Modified Files
- `pyproject.toml` - Version bump and package configuration
- `app/main.py` - Updated UI file paths
- `MANIFEST.in` - Added HTML file inclusion for app directory
- `ui/index.html` - Version display updated to v1.0.5
- `ui/docs.html` - Version display updated to v1.0.5

### New Files
- `app/ui/__init__.py` - Package initialization
- `app/ui/index.html` - Dashboard UI (moved from root ui/)
- `app/ui/docs.html` - Documentation page (moved from root ui/)
- `app/ui/index-simple.html` - Simple UI variant (moved from root ui/)
- `RELEASE_NOTES_v1.0.5.md` - Release notes

---

## 🔗 GitHub & PyPI

### GitHub
- **Commit:** 7862ce1
- **Tag:** v1.0.5
- **Repository:** https://github.com/collynes/glanceswatch

### PyPI
- **Package:** https://pypi.org/project/glancewatch/1.0.5/
- **Installation:** `pip install glancewatch==1.0.5`

---

## ✅ Testing Checklist

Before notifying users, verify on production:

- [ ] Install v1.0.5: `pip install --upgrade glancewatch`
- [ ] Restart service: `pkill -f glancewatch && glancewatch`
- [ ] Access root URL: http://18.209.250.77:8000/
- [ ] Confirm HTML dashboard displays (not JSON)
- [ ] Access docs page: http://18.209.250.77:8000/docs
- [ ] Confirm documentation page displays
- [ ] Test API endpoints: /health, /status, /ram, /cpu, /disk
- [ ] Test configuration UI (dark/light mode, threshold updates)

---

## 🎉 Release Status: **COMPLETE**

GlanceWatch v1.0.5 has been successfully:
- ✅ Built and verified locally
- ✅ Committed to GitHub with detailed commit message
- ✅ Tagged as v1.0.5 with release notes
- ✅ Pushed to GitHub (main branch + tag)
- ✅ Published to PyPI
- ✅ Release notes created (RELEASE_NOTES_v1.0.5.md)

**Next Action:** Upgrade on production server and verify the fix works correctly.
