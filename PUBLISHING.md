# Publishing GlanceWatch to PyPI

## Prerequisites

1. **PyPI account**: Create accounts on:
   - https://test.pypi.org (for testing)
   - https://pypi.org (for production)

2. **Install build tools**:
   ```bash
   pip install --upgrade build twine
   ```

3. **API tokens**: Generate API tokens from PyPI/TestPyPI account settings

## Building the Package

### 1. Update Version

Edit `pyproject.toml` and update the version:

```toml
[project]
name = "glancewatch"
version = "1.0.1"  # <-- Update this
```

### 2. Build Distribution

```bash
# Clean previous builds
rm -rf dist/ build/ *.egg-info

# Build the package
python3 -m build
```

This creates:
- `dist/glancewatch-1.0.0-py3-none-any.whl` (wheel distribution)
- `dist/glancewatch-1.0.0.tar.gz` (source distribution)

### 3. Check the Package

```bash
# Verify the build
twine check dist/*
```

Should output:
```
Checking dist/glancewatch-1.0.0-py3-none-any.whl: PASSED
Checking dist/glancewatch-1.0.0.tar.gz: PASSED
```

## Testing on TestPyPI

Always test on TestPyPI before publishing to production PyPI:

### 1. Upload to TestPyPI

```bash
twine upload --repository testpypi dist/*
```

Enter your TestPyPI username and API token when prompted.

### 2. Test Install

```bash
# Create a test environment
python3 -m venv test-env
source test-env/bin/activate

# Install from TestPyPI
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ glancewatch

# Test the command
glancewatch --help

# Clean up
deactivate
rm -rf test-env
```

## Publishing to PyPI

Once tested on TestPyPI:

```bash
twine upload dist/*
```

Enter your PyPI username and API token.

## Post-Publishing

### 1. Verify Installation

```bash
# Install from PyPI
pip install glancewatch

# Test
glancewatch
```

### 2. Tag the Release

```bash
git tag v1.0.0
git push origin v1.0.0
```

### 3. Create GitHub Release

Go to https://github.com/collinskramp/glancewatch/releases/new

- Tag: `v1.0.0`
- Title: `GlanceWatch v1.0.0`
- Description: Release notes and changelog
- Attach: dist files (optional)

## Using API Tokens

Instead of username/password, use API tokens:

### Create .pypirc

```bash
cat > ~/.pypirc << 'EOF'
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
username = __token__
password = pypi-your-api-token-here

[testpypi]
repository = https://test.pypi.org/legacy/
username = __token__
password = pypi-your-testpypi-token-here
EOF

chmod 600 ~/.pypirc
```

Now you can upload without entering credentials:

```bash
twine upload --repository testpypi dist/*
twine upload dist/*
```

## Automated Publishing with GitHub Actions

Create `.github/workflows/publish.yml`:

```yaml
name: Publish to PyPI

on:
  release:
    types: [published]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install build tools
        run: |
          python -m pip install --upgrade pip
          pip install build twine
      
      - name: Build package
        run: python -m build
      
      - name: Publish to PyPI
        env:
          TWINE_USERNAME: __token__
          TWINE_PASSWORD: ${{ secrets.PYPI_API_TOKEN }}
        run: twine upload dist/*
```

Add `PYPI_API_TOKEN` to repository secrets:
1. Go to Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `PYPI_API_TOKEN`
4. Value: Your PyPI API token

Now whenever you create a GitHub release, it will automatically publish to PyPI!

## Version Bumping Strategy

Follow semantic versioning (https://semver.org/):

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features, backward compatible
- **PATCH** (1.0.0 → 1.0.1): Bug fixes

Example workflow:

```bash
# Bump version in pyproject.toml
vim pyproject.toml

# Commit
git add pyproject.toml
git commit -m "Bump version to 1.0.1"

# Tag
git tag v1.0.1
git push origin main --tags

# Build and publish
rm -rf dist/
python3 -m build
twine check dist/*
twine upload dist/*
```

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
