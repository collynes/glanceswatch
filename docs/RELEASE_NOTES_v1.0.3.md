# GlanceWatch v1.0.3 Release Notes

Released: 2025-01-XX

## 🎉 What's New

### ✨ Features
- **Dark Mode Toggle**: Added a beautiful theme toggle button in the top-right corner
  - Switch between dark and light themes with a single click
  - Theme preference is saved in localStorage and persists across sessions
  - Smooth transitions between themes
  - Both themes feature glassmorphism design

### 🐛 Bug Fixes
- **HTTP 503 Handling**: Fixed critical bug where HTTP 503 responses (threshold alerts) caused "Failed to load metrics" error for all metrics
  - UI now properly handles HTTP 503 responses from Uptime Kuma compatibility
  - Individual metric statuses are correctly displayed even when thresholds are exceeded
  - Error messages now only show for actual connection failures
  
- **Auto-Refresh After Config Save**: Fixed UX issue where metrics didn't refresh automatically after saving configuration
  - Metrics now reload immediately after applying threshold changes
  - No more manual page refresh required to see new threshold effects

### 🎨 Design Improvements
- **Professional Theme**: Changed from purple gradient to elegant black/white gradient
  - Dark mode: Black gradient background (#1a1a1a → #2d2d2d)
  - Light mode: Light gray gradient background (#f5f5f5 → #e0e0e0)
  - Improved readability and professional appearance
  - Better contrast ratios for accessibility

### 🧪 Quality Improvements
- **Pre-Publish Testing**: Added automatic test verification to publish script
  - `./publish.sh` now runs full test suite before allowing PyPI upload
  - Prevents publishing releases with failing tests
  - Ensures quality gate is enforced

## 📝 Full Changelog

### UI Changes
- Added theme toggle button with sun (☀️) and moon (🌙) icons
- Implemented light mode with full color scheme adjustments
- Updated all UI elements to support both themes (cards, tables, sliders, buttons)
- Fixed metric cards to show individual statuses correctly
- Updated version display to v1.0.3 in header and footer

### Backend Changes
- No backend changes in this release (all fixes were UI-side)

### Testing
- All 63 existing tests pass
- Test coverage maintained at 78%
- CI/CD pipeline validates all changes

## 🔄 Upgrade Instructions

### From v1.0.2
```bash
pip install --upgrade glancewatch
```

### From Earlier Versions
```bash
pip install --upgrade glancewatch
# Clear browser cache to see new UI features
```

## 🐛 Known Issues
None at this time.

## 📚 Documentation
- [Installation Guide](INSTALL.md)
- [Quick Start Guide](QUICKSTART.md)
- [Testing Documentation](TESTING_COMPLETE.md)
- [Bug Fixes v1.0.3](BUGFIXES_v1.0.3.md)

## 🙏 Acknowledgments
Thanks to users for reporting the HTTP 503 bug and requesting the dark mode toggle feature!

## 📦 Distribution
- PyPI: https://pypi.org/project/glancewatch/
- GitHub: https://github.com/collynes/glancewatch

---
**Note**: This release focuses on UI/UX improvements and critical bug fixes. No breaking changes.
