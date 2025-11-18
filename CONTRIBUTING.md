# Contributing to GlanceWatch

Thank you for your interest in contributing to GlanceWatch! 🎉

We welcome contributions of all kinds: bug reports, feature requests, documentation improvements, and code contributions.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Release Process](#release-process)

---

## 📜 Code of Conduct

This project follows a simple code of conduct:
- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

---

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating a bug report, please check existing issues to avoid duplicates.

**When reporting bugs, include:**
- Clear, descriptive title
- Steps to reproduce the issue
- Expected vs actual behavior
- Your environment (OS, Python version, GlanceWatch version)
- Relevant logs or error messages

**Create a bug report:**
```bash
# Title: [BUG] Brief description
# Labels: bug
```

### Suggesting Features

Feature requests are welcome! Please:
- Check if the feature has already been requested
- Provide a clear use case
- Explain why this feature would be useful
- Consider the scope and complexity

**Create a feature request:**
```bash
# Title: [FEATURE] Brief description
# Labels: enhancement
```

### Contributing Code

We love pull requests! Here's how to contribute:

1. **Fork the repository**
2. **Create a feature branch** from `develop`
3. **Make your changes** following our coding standards
4. **Write/update tests** for your changes
5. **Ensure all tests pass**
6. **Submit a pull request** to the `develop` branch

---

## 🛠️ Development Setup

### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- Git
- A running Glances instance (for testing)

### Clone the Repository

```bash
# Fork the repo on GitHub first, then:
git clone https://github.com/YOUR_USERNAME/glanceswatch.git
cd glanceswatch

# Add upstream remote
git remote add upstream https://github.com/collynes/glanceswatch.git
```

### Create a Virtual Environment

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate
```

### Install Dependencies

```bash
# Install package in development mode with dev dependencies
pip install -e ".[dev]"

# Or install from requirements files:
pip install -r requirements.txt
pip install -r requirements-dev.txt
```

### Verify Installation

```bash
# Check installation
glancewatch --version

# Run tests
pytest

# Check code coverage
pytest --cov=app --cov-report=html
```

---

## 🔄 Development Workflow

### Branch Strategy

We use a **Git Flow** inspired workflow:

- `main` - Production-ready code, tagged releases only
- `develop` - Integration branch for features (default branch for PRs)
- `feature/*` - Feature branches (created from `develop`)
- `bugfix/*` - Bug fix branches (created from `develop`)
- `hotfix/*` - Emergency fixes (created from `main`, merged to both `main` and `develop`)

### Creating a Feature Branch

```bash
# Update develop branch
git checkout develop
git pull upstream develop

# Create feature branch
git checkout -b feature/your-feature-name

# Make changes...
git add .
git commit -m "feat: add your feature description"

# Push to your fork
git push origin feature/your-feature-name
```

### Keeping Your Branch Updated

```bash
# Fetch upstream changes
git fetch upstream

# Rebase your branch on develop
git checkout feature/your-feature-name
git rebase upstream/develop

# Resolve conflicts if any, then:
git push origin feature/your-feature-name --force-with-lease
```

---

## 📝 Coding Standards

### Code Style

We follow **PEP 8** and use automated formatters:

```bash
# Format code with Black
black app/ tests/

# Check code style with Ruff
ruff check app/ tests/

# Type checking with mypy (optional but recommended)
mypy app/
```

### Code Structure

```python
# Good: Clear, descriptive names
def check_cpu_threshold(current_usage: float, threshold: float) -> bool:
    """Check if CPU usage exceeds threshold."""
    return current_usage > threshold

# Good: Type hints
from typing import Dict, Optional

def get_metrics(config: Dict[str, Any]) -> Optional[MetricResponse]:
    """Fetch metrics from Glances API."""
    # Implementation...
```

### Best Practices

1. **Type Hints**: Add type hints to all functions
2. **Docstrings**: Document all public functions and classes
3. **Error Handling**: Use specific exceptions, not bare `except`
4. **Constants**: Extract magic numbers to constants
5. **DRY Principle**: Don't repeat yourself
6. **SOLID Principles**: Follow object-oriented design principles

### Commit Messages

Follow **Conventional Commits** format:

```bash
# Format: <type>(<scope>): <subject>

feat: add circuit breaker for Glances connection
fix: resolve Windows encoding issue in UI
docs: update installation instructions
test: add integration tests for monitor module
refactor: extract threshold logic to separate function
chore: update dependencies
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `test`: Adding or updating tests
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html --cov-report=term

# Run specific test file
pytest tests/test_monitor.py

# Run specific test
pytest tests/test_api.py::test_health_check

# Run with verbose output
pytest -v

# Run only failed tests
pytest --lf
```

### Writing Tests

```python
import pytest
from app.monitor import GlancesMonitor

@pytest.mark.asyncio
async def test_check_cpu_threshold():
    """Test CPU threshold checking."""
    monitor = GlancesMonitor("http://localhost:61208")
    
    # Test normal operation
    result = await monitor.check_cpu(threshold=80.0)
    assert result.status in ["healthy", "warning", "critical"]
    
    # Test error handling
    # ...

# Use fixtures for common setup
@pytest.fixture
def mock_config():
    """Provide test configuration."""
    return {
        "glances_url": "http://localhost:61208",
        "thresholds": {"cpu": 80.0, "ram": 85.0}
    }
```

### Test Coverage Goals

- **Minimum**: 80% coverage (current: 78%)
- **Target**: 90% coverage
- **Critical paths**: 100% coverage for core monitoring logic

---

## 🚀 Submitting Changes

### Before Submitting

1. **Update your branch** with latest `develop`
2. **Run all tests** and ensure they pass
3. **Check code style** with `black` and `ruff`
4. **Update documentation** if needed
5. **Add/update tests** for your changes
6. **Update CHANGELOG** (if applicable)

### Creating a Pull Request

1. **Push your branch** to your fork
2. **Go to GitHub** and create a Pull Request
3. **Target the `develop` branch** (not `main`)
4. **Fill out the PR template**:
   - Clear title following conventional commits
   - Description of changes
   - Related issue numbers
   - Testing performed
   - Screenshots (if UI changes)

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change (fix or feature that changes existing functionality)
- [ ] Documentation update

## Related Issues
Fixes #123, Related to #456

## How Has This Been Tested?
- [ ] Unit tests
- [ ] Integration tests
- [ ] Manual testing (describe)

## Checklist
- [ ] My code follows the code style of this project
- [ ] I have added tests that prove my fix/feature works
- [ ] All tests pass locally
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
```

### PR Review Process

1. **Automated checks** must pass (tests, linting)
2. **Code review** by maintainer(s)
3. **Address feedback** if requested
4. **Approval** and merge to `develop`
5. **Included in next release** after merge to `main`

---

## 📦 Release Process

### Version Numbering

We follow **Semantic Versioning** (SemVer):
- `MAJOR.MINOR.PATCH` (e.g., 1.2.2)
- `MAJOR`: Breaking changes
- `MINOR`: New features (backwards compatible)
- `PATCH`: Bug fixes (backwards compatible)

### Release Workflow

1. **Development** happens in `develop` branch
2. **Testing** and stabilization
3. **Merge** `develop` → `main`
4. **Tag** the release (e.g., `v1.2.3`)
5. **Deploy** to PyPI, npm, Homebrew
6. **Update** documentation and release notes

### For Maintainers

```bash
# 1. Update version in files
# - app/__init__.py
# - pyproject.toml
# - npm-package/package.json

# 2. Create release branch
git checkout -b release/v1.2.3 develop

# 3. Update CHANGELOG
# Add release notes to docs/RELEASE_NOTES_v1.2.3.md

# 4. Merge to main
git checkout main
git merge --no-ff release/v1.2.3
git tag -a v1.2.3 -m "Release version 1.2.3"

# 5. Merge back to develop
git checkout develop
git merge --no-ff release/v1.2.3

# 6. Push everything
git push origin main develop --tags

# 7. Deploy using unified script
bash scripts/deploy.sh
```

---

## 🎯 Quick Reference

### Common Commands

```bash
# Setup
git clone https://github.com/YOUR_USERNAME/glanceswatch.git
cd glanceswatch
python3 -m venv venv
source venv/bin/activate
pip install -e ".[dev]"

# Development
git checkout develop
git checkout -b feature/my-feature
# Make changes...
black app/ tests/
ruff check app/ tests/
pytest --cov=app
git commit -m "feat: my new feature"
git push origin feature/my-feature

# Testing
pytest                          # Run all tests
pytest --cov=app               # With coverage
pytest tests/test_monitor.py   # Specific file
pytest -v                      # Verbose
pytest --lf                    # Last failed

# Code Quality
black app/ tests/              # Format code
ruff check app/ tests/         # Lint code
mypy app/                      # Type check
```

### Getting Help

- **Documentation**: [README.md](README.md)
- **Issues**: [GitHub Issues](https://github.com/collynes/glanceswatch/issues)
- **Discussions**: [GitHub Discussions](https://github.com/collynes/glanceswatch/discussions)

---

## 💡 Tips for Contributors

1. **Start small**: Begin with documentation fixes or small bug fixes
2. **Ask questions**: Use GitHub Discussions or Issues if you're unsure
3. **Be patient**: Reviews may take a few days
4. **Stay updated**: Keep your fork synced with upstream
5. **Have fun**: We're building something useful together! 🎉

---

## 🙏 Thank You!

Your contributions make GlanceWatch better for everyone. We appreciate your time and effort!

**Happy coding!** 💻✨
