# Publishing GlanceWatch to PyPI

Complete guide for publishing GlanceWatch to the Python Package Index (PyPI).

## Prerequisites

### 1. Create PyPI Account

1. Go to https://pypi.org/account/register/
2. Create an account and verify your email
3. Enable 2FA (Two-Factor Authentication) - **required for new projects**

### 2. Generate API Token

1. Log in to PyPI
2. Go to https://pypi.org/manage/account/token/
3. Click **"Add API token"**
4. Name: `glancewatch-upload`
5. Scope: "Entire account" (change to project-specific after first upload)
6. **Copy the token** - you won't see it again!

### 3. Configure ~/.pypirc

Create or edit `~/.pypirc`:

```ini
[pypi]
username = __token__
password = pypi-AgEIcHlwaS5vcmc...YOUR_TOKEN_HERE
```

Set correct permissions:
```bash
chmod 600 ~/.pypirc
```

## Pre-Publication Checklist

Before publishing, verify:

- [ ] Version number updated in `pyproject.toml`
- [ ] `README.md` is complete and accurate
- [ ] `LICENSE` file exists (MIT)
- [ ] Email in `pyproject.toml` is correct
- [ ] All tests pass: `pytest`
- [ ] Git repo is clean: `git status`
- [ ] Latest changes are committed and pushed

## Quick Publish (Using Script)

We provide a convenience script that handles everything:

```bash
# Make it executable (first time only)
chmod +x publish.sh

# Run it
./publish.sh
```

The script will:
1. Clean old builds
2. Build the package
3. Check for issues
4. Show what will be uploaded
5. Prompt for confirmation
6. Upload to PyPI

## Manual Publishing Steps

### Step 1: Install Build Tools

```bash
pip install --upgrade build twine
```

### Step 2: Test Locally First

```bash
# Install locally in development mode
pip install -e .

# Test the CLI
glancewatch --help

# Test it works
glancewatch
```

### Step 3: Build the Package

```bash
# Clean old builds
rm -rf dist/ build/ *.egg-info

# Build
python3 -m build

# Verify contents
ls -lh dist/
# Should show: glancewatch-1.0.0-py3-none-any.whl and glancewatch-1.0.0.tar.gz
```

### Step 4: Check Package Quality

```bash
# Check package for common issues
twine check dist/*

# Should output: Checking dist/... PASSED
```

### Step 5: Upload to PyPI

```bash
# Upload to PyPI
twine upload dist/*
```

You'll be prompted for credentials (use `__token__` as username and your API token as password, or use `~/.pypirc`).

### Step 6: Verify Publication

```bash
# Wait a minute for PyPI to index

# Install from PyPI
pip install glancewatch

# Test it
glancewatch --help
glancewatch
```

Visit https://pypi.org/project/glancewatch/ to see your published package!

## Troubleshooting

### Build fails with "Multiple top-level packages"

Ensure `[tool.setuptools]` in `pyproject.toml` specifies packages:

```toml
[tool.setuptools]
packages = ["app", "app.api"]
```

### Upload fails with 403 Forbidden

- Verify API token is correct
- Check token has upload permissions
- Ensure version number hasn't been used before

### Package not found after upload

Wait 1-2 minutes for PyPI to process the upload.

### Import errors after install

Check that `MANIFEST.in` includes necessary files:

```
include README.md
include LICENSE
recursive-include app *.py
recursive-include ui *.html
```

## Resources

- PyPI: https://pypi.org
- TestPyPI: https://test.pypi.org
- Python Packaging Guide: https://packaging.python.org
- Twine docs: https://twine.readthedocs.io
