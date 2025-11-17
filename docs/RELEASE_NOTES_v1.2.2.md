# GlanceWatch v1.2.2 Release Notes

**Release Date**: November 17, 2025  
**Type**: Patch Release (Bug Fix)

---

## 🐛 Bug Fixes

### Critical: Windows Encoding Issue Fixed

**Problem**: Application crashed on Windows when loading the UI with `UnicodeDecodeError: 'charmap' codec can't decode byte 0x8f`

**Root Cause**: 
- Windows uses `cp1252` encoding by default
- The HTML file contains UTF-8 characters (circle indicators: ●, ○)
- Python's `Path.read_text()` was using system default encoding instead of UTF-8

**Solution**: 
- Explicitly specified UTF-8 encoding when reading HTML file
- Changed `ui_file.read_text()` → `ui_file.read_text(encoding="utf-8")`

**Impact**:
- ✅ Fixes crash on Windows installations (pip, npm)
- ✅ No changes to functionality or features
- ✅ Cross-platform compatibility restored

---

## 📦 Installation

### PyPI (Recommended)
```bash
pip install --upgrade glancewatch
```

### npm
```bash
npm install -g glancewatch
```

### Homebrew (macOS/Linux)
```bash
brew upgrade glancewatch
```

### Chocolatey (Windows - Coming Soon)
```bash
choco upgrade glancewatch
```

---

## 🔧 Technical Details

**Changed Files**:
- `app/main.py` (line 157): Added `encoding="utf-8"` parameter

**Before**:
```python
html_content = ui_file.read_text()
```

**After**:
```python
html_content = ui_file.read_text(encoding="utf-8")
```

---

## 🧪 Testing

**Verified on**:
- ✅ Windows 10/11 (Python 3.12)
- ✅ macOS (Python 3.11)
- ✅ Linux Ubuntu (Python 3.10)

**Test Scenario**:
1. Install via pip/npm on Windows
2. Run `glancewatch`
3. Access http://localhost:8000/
4. ✅ UI loads without errors

---

## 📝 Notes

This is a **critical patch** for Windows users who experienced crashes after v1.2.0/v1.2.1 releases. The issue was introduced when we added special Unicode characters (●, ○) for status indicators in the UI.

**Upgrade Recommended**: All Windows users should upgrade immediately.

---

## 🔗 Links

- **GitHub**: https://github.com/collynes/glanceswatch
- **PyPI**: https://pypi.org/project/glancewatch/
- **npm**: https://www.npmjs.com/package/glancewatch
- **Homebrew**: `brew tap collynes/glancewatch`

---

## 🙏 Thanks

Special thanks to @collynes for identifying and reporting this Windows-specific issue!
