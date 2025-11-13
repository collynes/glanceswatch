# GlanceWatch v1.0.10 Release Notes

**Release Date:** November 13, 2025

## 🎨 What's New

### Visual Enhancement: Professional Logo
Added official GlanceWatch logo to the dashboard for a more polished, professional appearance.

## ✨ Key Changes

### UI Improvements
- **✅ Logo Integration** - Replaced emoji icon with professional GlanceWatch logo
- **✅ Light Mode Improvements** - Enhanced slider visibility with green thumbs in light mode
- **✅ Button Text Contrast** - Improved button text visibility in light mode
- **✅ Better Visual Hierarchy** - Logo adds brand identity to the dashboard

### Technical Improvements
- **✅ Static File Serving** - Added `/static` route for serving logo and assets
- **✅ Package Data** - Updated MANIFEST.in to include PNG files in distribution
- **✅ Clean Codebase** - Removed unused backup and temporary files

## 🔧 What Changed

### Before (v1.0.9)
```html
<h1>
    <span class="icon">📊</span>
    GlanceWatch
</h1>
```

### Now (v1.0.10)
```html
<img src="/static/logo.png" alt="GlanceWatch Logo" style="height: 80px;">
<h1>GlanceWatch</h1>
```

### Light Mode Enhancements
- Slider thumbs: White → **Green (#4CAF50)** for better visibility
- Button text: Added `!important` to ensure dark text in light mode
- Slider values: Enhanced contrast in light mode

## 📦 Installation

### Upgrade from Previous Version
```bash
pip install --upgrade glancewatch
```

### Fresh Install
```bash
# Automated installer (recommended)
curl -sSL https://raw.githubusercontent.com/collinskramp/glanceswatch/main/install-service.sh | bash

# Or just pip
pip install glancewatch
```

## 🎯 Benefits

### Professional Appearance
- Custom logo gives GlanceWatch a distinct brand identity
- More polished look for production environments
- Better first impression for new users

### Improved UX
- Light mode is now fully usable with proper contrast
- Sliders are visible in both dark and light themes
- Consistent visual experience across all UI elements

## 🐛 Bug Fixes

None - this is a pure enhancement release

## 📊 Technical Details

### Files Modified
- ✅ `app/ui/index.html` - Added logo, updated version to 1.0.10
- ✅ `app/ui/docs.html` - Updated version to 1.0.10
- ✅ `app/main.py` - Added `/static` mount for serving logo
- ✅ `app/__init__.py` - Bumped version to 1.0.10
- ✅ `pyproject.toml` - Updated version to 1.0.10
- ✅ `MANIFEST.in` - Added *.png to include logo in package

### Files Added
- ✅ `app/ui/logo.png` - Official GlanceWatch logo (542KB)

### Files Removed
- ❌ `README.md.backup` - Backup file no longer needed
- ❌ `install-pip.sh` - Redundant script
- ❌ `medium.txt` - Temporary blog post draft
- ❌ `medium-plain.txt` - Temporary plain text version

## 🔄 Upgrade Path

### From v1.0.9
No breaking changes! Simply upgrade:
```bash
pip install --upgrade glancewatch
pkill -f glancewatch
glancewatch
```

The logo will appear automatically on your dashboard.

### From Earlier Versions
Follow the same upgrade path. All previous features remain intact.

## 🌟 What Users Will See

### Dashboard Changes
1. **Professional Logo** at the top of the dashboard
2. **Better Light Mode** - sliders and buttons now clearly visible
3. **Same Great Features** - all monitoring functionality unchanged

### No Configuration Needed
The logo is included in the package and served automatically. No extra setup required!

## 📝 Notes

### Logo Details
- **Format:** PNG
- **Size:** 542KB (optimized for web)
- **Design:** Blue/white pigeon silhouette with "GW" text
- **Location:** Served from `/static/logo.png`

### Backwards Compatibility
- ✅ 100% backwards compatible
- ✅ All API endpoints unchanged
- ✅ Configuration format unchanged
- ✅ No database migrations needed

## 🚀 What's Next (Future Ideas)

Potential enhancements for future releases:
- Favicon support
- Customizable logo (upload your own)
- Dark/light mode logo variants
- SVG logo for better scaling
- Logo in documentation pages

## 🙏 Acknowledgments

Thanks to the community for feedback on UI improvements!

## 🔗 Links

- **PyPI:** https://pypi.org/project/glancewatch/1.0.10/
- **GitHub:** https://github.com/collinskramp/glanceswatch
- **Documentation:** Included in dashboard at `/docs`

---

**Full Changelog:** v1.0.9...v1.0.10

**Key Improvement:** Professional branding with custom logo + enhanced light mode! 🎨
