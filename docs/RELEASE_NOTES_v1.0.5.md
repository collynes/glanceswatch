# Release Notes - v1.0.5

**Release Date:** November 12, 2025

## 🐛 Critical Bug Fix

### UI Files Now Included in Package
- **Fixed:** UI files (index.html, docs.html) are now properly included in the pip package
- **Issue:** v1.0.4 showed JSON response instead of HTML UI when accessing the root URL
- **Solution:** Updated `pyproject.toml` to include UI directory in package data
- **Impact:** Users can now access the full web interface immediately after `pip install glancewatch`

## 📦 What Changed

### Package Configuration
- Updated `pyproject.toml` to properly include UI files in distribution
- Added `include-package-data = true` to setuptools configuration
- Updated `package-data` to include all HTML files from UI directory
- Enhanced `MANIFEST.in` to ensure UI files are bundled

### Version Updates
- Version bumped to 1.0.5 across all files
- Updated version display in UI components

## 🔧 Technical Details

**Before (v1.0.4):**
- UI files were not included in the wheel/sdist
- Users saw JSON fallback when accessing root URL
- Manual file copying was required

**After (v1.0.5):**
- UI files automatically included in package
- Full web interface works immediately after installation
- No manual setup required

## 📦 Installation

```bash
# Fresh install
pip install glancewatch==1.0.5

# Upgrade from previous version
pip install --upgrade glancewatch

# Start the server
glancewatch
```

## ✅ Verification

After installing v1.0.5, you should be able to:

1. Install: `pip install glancewatch`
2. Run: `glancewatch`
3. Access: `http://localhost:8000/` → See the full dashboard UI (not JSON)
4. Access: `http://localhost:8000/docs` → See the documentation page

## 🙏 Thanks

Special thanks to users who reported the UI file issue. This release ensures a smooth out-of-the-box experience for all new installations.

---

**Full Changelog:** v1.0.4...v1.0.5
