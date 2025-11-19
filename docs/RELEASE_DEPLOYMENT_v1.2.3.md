# Release Deployment Checklist - v1.2.3

## ✅ Pre-Release (Completed)

- [x] Version bumped to 1.2.3 in all files
  - [x] `app/__init__.py`
  - [x] `pyproject.toml`
  - [x] `npm-package/package.json`
  - [x] `glancewatch.rb`
- [x] Release notes created (`docs/RELEASE_NOTES_v1.2.3.md`)
- [x] All tests passing (66 tests, 84% coverage)
- [x] Documentation fixes applied (port 8765 → 8000)
- [x] Repository cleaned up
- [x] Changes committed to `develop` branch
- [x] Git tag `v1.2.3` created
- [x] Tag pushed to GitHub

## 📦 PyPI Deployment

### 1. Build the Package

```bash
cd /Users/collinsk/Documents/glances-kuma-alerts

# Clean old builds
rm -rf dist/ build/ *.egg-info

# Build distribution packages
python3 -m build

# Verify the build
ls -lh dist/
# Should see:
# glancewatch-1.2.3.tar.gz
# glancewatch-1.2.3-py3-none-any.whl
```

### 2. Test Upload (Optional but Recommended)

```bash
# Upload to TestPyPI first
python3 -m twine upload --repository testpypi dist/*

# Test installation from TestPyPI
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ glancewatch==1.2.3

# Verify it works
glancewatch --version
```

### 3. Production Upload

```bash
# Upload to PyPI
python3 -m twine upload dist/*

# You'll need PyPI credentials or API token
# Username: __token__
# Password: <your-pypi-api-token>
```

### 4. Verify PyPI Release

```bash
# Install from PyPI
pip install --upgrade glancewatch

# Verify version
python3 -c "import app; print(app.__version__)"
# Should print: 1.2.3

# Test the application
glancewatch --version
```

### 5. Update Homebrew Formula SHA256

After PyPI upload, update `glancewatch.rb`:

```bash
# Download the tarball
wget https://files.pythonhosted.org/packages/source/g/glancewatch/glancewatch-1.2.3.tar.gz

# Calculate SHA256
shasum -a 256 glancewatch-1.2.3.tar.gz

# Update glancewatch.rb with the actual SHA256
# Replace "TBD_AFTER_PYPI_UPLOAD" with the calculated hash
```

## 📘 npm Deployment

### 1. Test npm Package Locally

```bash
cd npm-package

# Test the package
npm pack
# Creates: glancewatch-1.2.3.tgz

# Test installation
npm install -g ./glancewatch-1.2.3.tgz

# Verify it works
glancewatch --version
```

### 2. Publish to npm

```bash
cd npm-package

# Login to npm (if not already)
npm login

# Publish the package
npm publish

# Verify on npm registry
npm view glancewatch
```

### 3. Verify npm Installation

```bash
# Install from npm
npm install -g glancewatch

# Verify version
npm list -g glancewatch
# Should show: 1.2.3

# Test the application
glancewatch --version
```

## 🍺 Homebrew Deployment

### 1. Update the Formula

The `glancewatch.rb` file needs the correct SHA256 from PyPI:

```bash
# After PyPI upload, get the SHA256
curl -sL https://files.pythonhosted.org/packages/source/g/glancewatch/glancewatch-1.2.3.tar.gz | shasum -a 256

# Update glancewatch.rb:
# 1. Replace TBD_AFTER_PYPI_UPLOAD with actual SHA256
# 2. Commit the change
git add glancewatch.rb
git commit -m "chore: update homebrew formula SHA256 for v1.2.3"
git push origin develop
```

### 2. Update Homebrew Tap Repository

```bash
# Clone or navigate to your tap repository
cd ~/homebrew-glancewatch  # or wherever your tap is

# Copy the updated formula
cp /Users/collinsk/Documents/glances-kuma-alerts/glancewatch.rb Formula/glancewatch.rb

# Commit and push
git add Formula/glancewatch.rb
git commit -m "Update glancewatch to 1.2.3

- Fixed documentation port references
- Improved test coverage to 84%
- Fixed async/await bug
- Repository cleanup"
git push origin main
```

### 3. Test Homebrew Installation

```bash
# Update tap
brew update

# Upgrade glancewatch
brew upgrade glancewatch

# Verify version
glancewatch --version
# Should show: 1.2.3
```

## 🐙 GitHub Release

### 1. Create GitHub Release

Go to: https://github.com/collynes/glancewatch/releases/new

**Tag:** `v1.2.3`

**Release Title:** `v1.2.3: Documentation Fixes & Test Coverage Improvements`

**Description:**
```markdown
## 🎯 What's New

This patch release fixes critical documentation errors and significantly improves test coverage.

## 🐛 Bug Fixes

- **Fixed incorrect port documentation** across all files (was 8765, correct default is 8000)
  - README.md, npm-package/README.md, docs/*.md all updated
- **Fixed async/await bug** in `app/monitor.py` for proper async HTTP handling

## ✅ Improvements

### Test Coverage
- **Overall coverage: 77% → 84%** (+7% improvement)
- **Added 44 new comprehensive tests**
- **app/config.py: 94% coverage** (+23% improvement!)
- **app/monitor.py: 81% coverage** (+6% improvement)

### New Test Suites
- `tests/test_coverage_boost.py` - Config/monitor/model tests
- `tests/test_env_config.py` - Environment variable loading
- `tests/test_monitor_extra.py` - Monitor edge cases

## 🧹 Repository Cleanup

- Removed 15+ old release notes
- Deleted 6,853 lines of outdated content
- Organized all documentation into `docs/` folder
- Only README.md and CONTRIBUTING.md remain in root

## 📦 Installation

**PyPI:**
```bash
pip install --upgrade glancewatch
```

**npm:**
```bash
npm update -g glancewatch
```

**Homebrew:**
```bash
brew upgrade glancewatch
```

## 📚 Documentation

- [Full Release Notes](https://github.com/collynes/glancewatch/blob/main/docs/RELEASE_NOTES_v1.2.3.md)
- [Test Coverage Report](https://github.com/collynes/glancewatch/blob/main/docs/TEST_COVERAGE_IMPROVEMENT.md)
- [Quick Start Guide](https://github.com/collynes/glancewatch/blob/main/docs/QUICKSTART.md)

## 🔗 Links

- [PyPI Package](https://pypi.org/project/glancewatch/1.2.3/)
- [npm Package](https://www.npmjs.com/package/glancewatch)
- [Documentation](https://github.com/collynes/glancewatch#readme)

**Full Changelog**: https://github.com/collynes/glancewatch/compare/v1.2.2...v1.2.3
```

**Attach Files:**
- `dist/glancewatch-1.2.3.tar.gz` (from PyPI build)
- `dist/glancewatch-1.2.3-py3-none-any.whl` (from PyPI build)

### 2. Publish the Release

Click "Publish release"

## ✅ Post-Release Verification

### 1. Verify All Platforms

```bash
# PyPI
pip install glancewatch==1.2.3
python3 -c "import app; print(app.__version__)"

# npm
npm view glancewatch version

# Homebrew
brew info glancewatch

# GitHub
curl -s https://api.github.com/repos/collynes/glancewatch/releases/latest | grep tag_name
```

### 2. Test Installation on Each Platform

**macOS (Homebrew):**
```bash
brew install glancewatch
glancewatch --version
curl http://localhost:8000/health
```

**Linux (pip):**
```bash
pip install glancewatch
glancewatch --version
curl http://localhost:8000/health
```

**Windows (npm):**
```bash
npm install -g glancewatch
glancewatch --version
curl http://localhost:8000/health
```

### 3. Update Project README badges (if any)

Update any version badges in README.md to show v1.2.3

### 4. Announce the Release

Consider announcing on:
- [ ] GitHub Discussions
- [ ] Twitter/X
- [ ] Reddit (r/opensource, r/selfhosted)
- [ ] Dev.to or Medium article
- [ ] Project website/blog

## 📋 Final Checklist

- [ ] PyPI package uploaded and verified
- [ ] npm package published and verified
- [ ] Homebrew formula updated with correct SHA256
- [ ] Homebrew tap repository updated
- [ ] GitHub release created with binaries attached
- [ ] All platforms tested (macOS, Linux, Windows)
- [ ] Version verification on all platforms
- [ ] Documentation links all working
- [ ] Release announcement posted
- [ ] CHANGELOG.md updated (if exists)
- [ ] Merge `develop` to `main` branch

## 🔄 Merge to Main

Once everything is verified:

```bash
git checkout main
git merge develop
git push origin main

# Verify main is up to date
git log --oneline -5
```

## 🎉 Release Complete!

Version 1.2.3 is now live on all platforms.

## 📊 Release Metrics

Track these metrics after release:
- PyPI downloads (https://pypistats.org/packages/glancewatch)
- npm downloads (https://npm-stat.com/charts.html?package=glancewatch)
- GitHub stars, forks, and issues
- User feedback and bug reports

---

**Date Completed:** _______________  
**Released By:** Collins Kemboi  
**Platforms:** PyPI ✅ | npm ✅ | Homebrew ✅ | GitHub ✅
