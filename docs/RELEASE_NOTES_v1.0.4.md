# Release Notes - v1.0.4

**Release Date:** November 12, 2025

## 🎉 New Features

### Documentation Page
- **Added comprehensive `/docs` page** - Complete setup guide for integrating GlanceWatch with Uptime Kuma
  - Step-by-step instructions for adding monitors to Uptime Kuma
  - Detailed endpoint documentation with examples
  - Troubleshooting section with common issues and solutions
  - Advanced configuration tips (individual metrics, check intervals, remote monitoring)
  - Professional design matching the main dashboard theme (dark/light mode support)

### UI Enhancements
- **Added Documentation link** in the footer for easy navigation
- Footer now includes: Documentation, API Documentation, Health Check, Glances, and Uptime Kuma links
- Updated version display to v1.0.4 across all pages

## 📝 What's Changed

### Frontend
- `ui/docs.html` - New comprehensive documentation page (NEW FILE)
- `ui/index.html` - Added "Documentation" link to footer, updated version to v1.0.4

### Backend
- `app/main.py` - Added `/docs` route to serve the documentation page
- Updated root endpoint to include "docs" in available endpoints list

### Configuration
- `pyproject.toml` - Version bumped to 1.0.4

## 🔗 Quick Links

- **Dashboard:** http://localhost:8000/
- **Documentation:** http://localhost:8000/docs (NEW!)
- **API Docs:** http://localhost:8000/api
- **Health Check:** http://localhost:8000/health

## 📦 Installation

```bash
# Install from PyPI
pip install glancewatch==1.0.4

# Or upgrade
pip install --upgrade glancewatch
```

## 🚀 Usage

```bash
# Start GlanceWatch
glancewatch

# Access the new documentation page
# Open http://localhost:8000/docs in your browser
```

## 💡 Why This Release?

This release adds comprehensive documentation to help users integrate GlanceWatch with Uptime Kuma. The new `/docs` page provides:
- Clear instructions for setting up monitoring
- Examples of all API endpoints
- Troubleshooting guides
- Best practices for production deployments

This makes it much easier for new users to get started and reduces setup time significantly.

## 🙏 Feedback

Found a bug or have a feature request? Please [open an issue](https://github.com/collynes/glancewatch/issues).

---

**Full Changelog:** v1.0.3...v1.0.4
