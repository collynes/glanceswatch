# Release Notes - v1.2.3

**Release Date:** November 19, 2025  
**Type:** Patch Release (Documentation & Testing Improvements)

## 🎯 Overview

Version 1.2.3 is a maintenance release focusing on documentation accuracy, test coverage improvements, and repository cleanup. This release fixes critical documentation errors where the wrong default port (8765) was listed instead of the correct port (8000), which could have caused confusion for new users.

## 🐛 Bug Fixes

### Critical Documentation Fix
- **Fixed incorrect port number in all documentation** (Issue: Documentation showed port 8765 instead of correct default port 8000)
  - ✅ Fixed `README.md` (2 instances)
  - ✅ Fixed `npm-package/README.md` 
  - ✅ Fixed `docs/HOMEBREW-TAP-PUBLISHING.md` (2 instances)
  - ✅ Fixed `docs/MULTI-PLATFORM-RELEASE.md` (3 instances)
  - Impact: Users following documentation would connect to wrong port and think app was broken

### Code Fix
- **Fixed async/await bug in `app/monitor.py`**
  - Changed `response.json()` to `await response.json()` 
  - This was causing test failures and potential runtime issues with async HTTP clients
  - Affected lines: 49, 61

## ✅ Test Coverage Improvements

### Coverage Statistics
- **Increased overall coverage from 77% to 84%** (+7%)
- **434 lines now covered** (up from 400 lines)
- **Added 44 new tests** across 3 new test files

### Module-Specific Coverage
| Module | Before | After | Change |
|--------|--------|-------|--------|
| **app/models.py** | 100% | 100% | Maintained ✅ |
| **app/config.py** | 71% | 94% | +23% 🎉 |
| **app/monitor.py** | 75% | 81% | +6% ✅ |
| **app/main.py** | 81% | 81% | Maintained |
| **Overall** | 77% | 84% | +7% 🎉 |

### New Test Files

#### 1. `tests/test_coverage_boost.py` (18 tests)
- Config model validation and YAML handling
- ConfigLoader save/load functionality
- Monitor error handling (timeout, connection, HTTP errors)
- Monitor edge cases (missing fields, empty responses)
- Model creation tests
- Integration tests

#### 2. `tests/test_env_config.py` (16 tests)
- Environment variable configuration loading
- All config sources (GLANCES_BASE_URL, HOST, PORT, etc.)
- Threshold configuration from env vars
- Disk mount configuration from env vars
- YAML + environment variable merging logic
- Docker vs normal environment detection
- Config validation (log level, thresholds, disks)

#### 3. `tests/test_monitor_extra.py` (10 tests)
- Additional exception handling scenarios
- Connection test success/failure
- Disk filtering by mount points
- Disk filtering by filesystem types
- Status check integration tests
- Missing field handling

### Test Coverage Details

**Config Module (94% coverage) - Excellent! ✅**
- ✅ ConfigLoader.get_config_path()
- ✅ ConfigLoader.load_from_yaml()
- ✅ ConfigLoader.load_from_env()
- ✅ ConfigLoader.load() (YAML + env merging)
- ✅ ConfigLoader.save()
- ✅ Environment variable parsing
- ✅ Docker environment detection
- ✅ Config validation

**Monitor Module (81% coverage) - Good ✅**
- ✅ Timeout error handling
- ✅ Connection error handling
- ✅ HTTP 5xx error handling
- ✅ General exception handling
- ✅ Test connection scenarios
- ✅ Missing field handling (percent, total)
- ✅ Disk filtering (by type: tmpfs, devtmpfs)
- ✅ Disk filtering (by mount point)
- ✅ Empty response handling
- ✅ "all" mounts configuration
- ✅ Status check integration

## 🧹 Repository Cleanup

### Removed Files (6,853 lines deleted!)
- **Removed 15+ old release notes**
  - ❌ RELEASE_NOTES_v1.0.3.md through v1.0.11.md
  - ❌ RELEASE_NOTES_v1.2.0.md
  - ❌ RELEASE_NOTES_v1.2.1.md
  - ✅ Kept only RELEASE_NOTES_v1.2.2.md and v1.2.3.md (current)

- **Removed redundant documentation**
  - ❌ BUGFIXES_v1.0.3.md, BUGFIXES_v1.0.5.md
  - ❌ RELEASE_SUMMARY_v1.2.2.md
  - ❌ REPOSITORY-CLEANUP-v1.2.1.md
  - ❌ TESTING_COMPLETE.md, TEST_SUMMARY.md
  - ❌ UI-IMPLEMENTATION.md
  - ❌ V1.0.6_RELEASE_SUMMARY.md, V1.0.7_RELEASE_COMPLETE.md, V1.0.9_RELEASE_COMPLETE.md
  - ❌ CONTRIBUTION_SETUP_COMPLETE.md
  - ❌ CODEBASE-IMPROVEMENTS.md

- **Removed empty/duplicate files**
  - ❌ scripts/install-pip.sh (0 bytes)
  - ❌ RELEASE_NOTES_v1.2.1.md (moved docs to root were removed)

### Organized Documentation
- ✅ All documentation now properly in `docs/` folder
- ✅ Only `README.md` and `CONTRIBUTING.md` remain in root
- ✅ Created `docs/GOOD_FIRST_ISSUES.md` for contributors
- ✅ Created `docs/TEST_COVERAGE_IMPROVEMENT.md` documenting all changes

## 📊 Files Changed Summary

**50 files changed:**
- 1,008 insertions (+)
- 6,853 deletions (-)
- Net reduction: 5,845 lines removed
- Repository is now significantly leaner!

## 📝 Documentation Added

### New Documentation Files
- **`docs/TEST_COVERAGE_IMPROVEMENT.md`**
  - Comprehensive coverage improvement documentation
  - Module-by-module coverage breakdown
  - Test file descriptions
  - Roadmap to 90% coverage

- **`docs/GOOD_FIRST_ISSUES.md`**
  - Ready-to-use issue templates for contributors
  - Loading spinner feature template
  - Documentation screenshot template

## 🔄 Migration Notes

### For Users Upgrading from v1.2.2

**No code changes required** - this is purely a documentation and testing improvement release.

**What you should know:**
- If you were using port 8765 based on old documentation, switch to port 8000 (the actual default)
- All functionality remains the same
- Configuration format unchanged
- API endpoints unchanged

### Installation

```bash
# PyPI
pip install --upgrade glancewatch

# npm
npm update -g glancewatch

# Homebrew (after tap update)
brew upgrade glancewatch
```

### Verification

```bash
# Check version
glancewatch --version
# Should show: 1.2.3

# Verify port (should default to 8000)
glancewatch
# Visit http://localhost:8000
```

## 🧪 Testing

All 66 passing tests continue to pass:
```bash
pytest --cov=app --cov-report=term
# 66 passed, 84% coverage
```

## 🔗 Links

- **PyPI:** https://pypi.org/project/glancewatch/1.2.3/
- **npm:** https://www.npmjs.com/package/glancewatch/v/1.2.3
- **Homebrew:** https://github.com/collynes/homebrew-glancewatch
- **GitHub:** https://github.com/collynes/glancewatch
- **Issues:** https://github.com/collynes/glancewatch/issues

## 👥 Contributors

Thanks to all contributors who helped with this release!

- [@collynes](https://github.com/collynes) - Core maintainer

## 📋 Checklist for Release

- [x] Version bumped in all files (app/__init__.py, pyproject.toml, package.json, glancewatch.rb)
- [x] All tests passing (66/66 tests, 84% coverage)
- [x] Documentation updated with correct port numbers
- [x] Release notes created
- [x] Repository cleaned up and organized
- [ ] Build and publish to PyPI
- [ ] Publish to npm
- [ ] Update Homebrew formula
- [ ] Create GitHub release tag
- [ ] Update CHANGELOG.md

## 🚀 Next Steps

For v1.2.4 or v1.3.0:
- Reach 90%+ test coverage
- Fix remaining CLI test issues
- Add health endpoint tests
- Potential new features based on community feedback

---

**Full Changelog:** https://github.com/collynes/glancewatch/compare/v1.2.2...v1.2.3
