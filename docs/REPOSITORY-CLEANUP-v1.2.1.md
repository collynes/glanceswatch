# Repository Cleanup & Multi-Platform Support - Complete

## Changes Made

### 1. Repository Organization ✅

**Documentation Cleanup:**
- Created `docs/` folder
- Moved 29 markdown files from root to `docs/`
- Kept `README.md` in root (as expected)
- All release notes, guides, and specs now organized

**Scripts Cleanup:**
- Created `scripts/` folder
- Moved `install-pip.sh` and `publish.sh` to `scripts/`
- Removed redundant scripts:
  - ❌ `install-service.sh` (covered in documentation)
  - ❌ `restart.sh` (use systemctl)
  - ❌ `start.sh` (use systemctl)
  - ❌ `stop.sh` (use systemctl)

### 2. Multi-Platform Installation Support ✅

#### Homebrew (macOS/Linux)
**File Created:** `glancewatch.rb`
- Full Homebrew formula with all dependencies
- Includes service configuration for launchd
- Test suite integration
- Ready for tap: `brew tap collynes/glancewatch`

**Usage:**
```bash
brew tap collynes/glancewatch
brew install glancewatch
glancewatch
```

#### Chocolatey (Windows)
**Files Created:**
- `chocolatey/glancewatch.nuspec` - Package metadata
- `chocolatey/tools/chocolateyinstall.ps1` - Installation script
- `chocolatey/tools/chocolateyuninstall.ps1` - Uninstallation script

**Usage:**
```powershell
choco install glancewatch
glancewatch
```

#### npm (Node.js)
**Files Created:**
- `npm-package/package.json` - Package metadata
- `npm-package/postinstall.js` - Python pip installation handler
- `npm-package/bin/glancewatch.js` - CLI wrapper
- `npm-package/index.js` - Module entry point
- `npm-package/README.md` - npm-specific documentation

**Usage:**
```bash
# Global
npm install -g glancewatch
glancewatch

# Or npx
npx glancewatch
```

### 3. Documentation Updates ✅

**README.md Updates:**
- ✅ Added multi-platform installation section (brew, choco, npm, pip)
- ✅ Updated Quick Start with new paths (`docs/` references)
- ✅ Fixed port references (8000 → 8765)
- ✅ Added Documentation section with links to docs folder
- ✅ Updated "What's New" to reflect v1.2.1 features
- ✅ Updated all internal documentation links

**New Documentation:**
- ✅ `docs/PACKAGE-MANAGERS.md` - Complete publishing guide for maintainers

## Repository Structure (After Cleanup)

```
glances-kuma-alerts/
├── README.md                  # Main documentation (updated)
├── LICENSE
├── pyproject.toml
├── requirements.txt
├── requirements-dev.txt
│
├── app/                       # Application code
│   ├── __init__.py           # v1.2.1
│   ├── main.py
│   ├── config.py
│   ├── models.py
│   ├── monitor.py
│   ├── api/
│   └── ui/
│
├── docs/                      # All documentation (29 files)
│   ├── INSTALL.md
│   ├── QUICKSTART.md
│   ├── QUICKSTART-UBUNTU.md
│   ├── BACKGROUND-SERVICE.md
│   ├── UI-GUIDE.md
│   ├── PACKAGE-MANAGERS.md   # NEW: Publishing guide
│   ├── RELEASE_NOTES_*.md
│   └── ... (all other docs)
│
├── scripts/                   # Essential scripts only
│   ├── install-pip.sh
│   └── publish.sh
│
├── glancewatch.rb             # Homebrew formula
│
├── chocolatey/                # Windows Chocolatey package
│   ├── glancewatch.nuspec
│   └── tools/
│       ├── chocolateyinstall.ps1
│       └── chocolateyuninstall.ps1
│
├── npm-package/               # Node.js npm package
│   ├── package.json
│   ├── postinstall.js
│   ├── index.js
│   ├── README.md
│   └── bin/
│       └── glancewatch.js
│
├── docker/                    # Docker configuration
├── systemd/                   # Systemd service file
├── tests/                     # Test suite
└── ui/                        # UI development files
```

## Installation Methods Summary

| Platform | Command | Package Manager |
|----------|---------|-----------------|
| **macOS** | `brew install glancewatch` | Homebrew |
| **Windows** | `choco install glancewatch` | Chocolatey |
| **Node.js** | `npm install -g glancewatch` | npm |
| **Python** | `pip install glancewatch` | PyPI |

## Next Steps for Publishing

### 1. Homebrew
```bash
# Create tap repository
git clone https://github.com/collynes/homebrew-glancewatch.git
cd homebrew-glancewatch
mkdir -p Formula
cp /path/to/glancewatch.rb Formula/

# Calculate SHA256 from PyPI package
curl -L https://files.pythonhosted.org/packages/.../glancewatch-1.2.1.tar.gz -o glancewatch.tar.gz
shasum -a 256 glancewatch.tar.gz

# Update SHA256 in formula
# Push to GitHub
```

### 2. Chocolatey
```powershell
cd chocolatey
choco pack
choco apikey --key YOUR-API-KEY --source https://push.chocolatey.org/
choco push glancewatch.1.2.1.nupkg --source https://push.chocolatey.org/
```

### 3. npm
```bash
cd npm-package
chmod +x bin/glancewatch.js
npm login
npm publish
```

## Benefits Achieved

✅ **Clean Repository**
- Root folder no longer cluttered with 29 markdown files
- Professional appearance
- Easy navigation

✅ **Better Organization**
- Documentation in `docs/`
- Essential scripts in `scripts/`
- Package manager files in dedicated folders

✅ **Multi-Platform Support**
- macOS users can use Homebrew (preferred)
- Windows users can use Chocolatey (preferred)
- Node.js developers can use npm
- Python developers can use pip

✅ **Improved Accessibility**
- Wider audience reach
- Native package manager experience
- Easier installation for non-Python users

✅ **Maintainability**
- Single version source (`app/__init__.py`)
- Clear publishing workflow documented
- All package definitions version-synced

## Files Changed

**Created:**
- `glancewatch.rb` (Homebrew formula)
- `chocolatey/glancewatch.nuspec`
- `chocolatey/tools/chocolateyinstall.ps1`
- `chocolatey/tools/chocolateyuninstall.ps1`
- `npm-package/package.json`
- `npm-package/postinstall.js`
- `npm-package/bin/glancewatch.js`
- `npm-package/index.js`
- `npm-package/README.md`
- `docs/PACKAGE-MANAGERS.md`

**Modified:**
- `README.md` (installation methods, doc links, version info)

**Moved:**
- 29 .md files: root → `docs/`
- 2 .sh files: root → `scripts/`

**Deleted:**
- `install-service.sh`
- `restart.sh`
- `start.sh`
- `stop.sh`

## Testing Required

Before publishing, test each installation method:

1. **Homebrew**: `brew install --build-from-source Formula/glancewatch.rb`
2. **Chocolatey**: `choco install glancewatch -s . -f`
3. **npm**: `npm link && glancewatch --version && npm unlink`
4. **PyPI**: Already tested (v1.2.1 published)

---

**Status**: ✅ Repository cleanup complete, ready for multi-platform publishing
**Version**: 1.2.1
**Date**: November 17, 2024
