# Multi-Platform Package Publishing Guide

This guide covers publishing GlanceWatch to Homebrew, Chocolatey, and npm package managers.

## Prerequisites

- GlanceWatch v1.2.1 published to PyPI
- Git repository with latest changes
- Accounts on respective package registries

## 1. Homebrew (macOS/Linux)

### Option A: Create a Tap (Easier to maintain)

1. **Create a new GitHub repository**: `homebrew-glancewatch`

2. **Add the formula**:
```bash
git clone https://github.com/collynes/homebrew-glancewatch.git
cd homebrew-glancewatch
mkdir -p Formula
cp /path/to/glancewatch.rb Formula/glancewatch.rb
```

3. **Calculate SHA256 hash** (after PyPI release):
```bash
# Download the package from PyPI
curl -L https://files.pythonhosted.org/packages/source/g/glancewatch/glancewatch-1.2.1.tar.gz -o glancewatch-1.2.1.tar.gz

# Calculate SHA256
shasum -a 256 glancewatch-1.2.1.tar.gz
```

4. **Update formula** with SHA256 hash in `glancewatch.rb`

5. **Test locally**:
```bash
brew install --build-from-source Formula/glancewatch.rb
brew test glancewatch
glancewatch --version
```

6. **Push to GitHub**:
```bash
git add Formula/glancewatch.rb
git commit -m "Add GlanceWatch formula v1.2.1"
git push origin main
```

7. **Users can install via**:
```bash
brew tap collynes/glancewatch
brew install glancewatch
```

### Option B: Submit to Homebrew Core (More visibility)

1. Fork [homebrew-core](https://github.com/Homebrew/homebrew-core)
2. Add formula to `Formula/g/glancewatch.rb`
3. Submit PR to homebrew-core

**Note**: Homebrew core has stricter requirements and review process.

---

## 2. Chocolatey (Windows)

### Setup Chocolatey Account

1. Create account at [chocolatey.org](https://community.chocolatey.org/)
2. Get your API key from account settings

### Package and Publish

1. **Navigate to chocolatey folder**:
```powershell
cd chocolatey
```

2. **Test package locally** (optional):
```powershell
choco pack
choco install glancewatch -s . -f
```

3. **Publish to Chocolatey**:
```powershell
choco apikey --key YOUR-API-KEY --source https://push.chocolatey.org/
choco push glancewatch.1.2.1.nupkg --source https://push.chocolatey.org/
```

4. **Wait for moderation** (first-time packages require manual approval, ~24-48 hours)

5. **Users can install via**:
```powershell
choco install glancewatch
```

### Update Package

For updates, increment version in:
- `glancewatch.nuspec` (version field)
- `chocolateyinstall.ps1` (version variable)

Then run `choco pack` and `choco push` again.

---

## 3. npm (Node.js)

### Setup npm Account

1. Create account at [npmjs.com](https://www.npmjs.com/)
2. Login via CLI:
```bash
npm login
```

### Publish Package

1. **Navigate to npm package folder**:
```bash
cd npm-package
```

2. **Make bin script executable**:
```bash
chmod +x bin/glancewatch.js
```

3. **Test locally** (optional):
```bash
npm link
glancewatch --version
npm unlink
```

4. **Publish to npm**:
```bash
npm publish
```

5. **Users can install via**:
```bash
# Global
npm install -g glancewatch

# Or use npx
npx glancewatch
```

### Update Package

For updates:
1. Update version in `package.json`
2. Run `npm publish` again

---

## 4. PyPI (Python) - Already Published

Maintained via:
```bash
cd /path/to/glancewatch
./scripts/publish.sh
```

---

## Version Management Checklist

When releasing a new version (e.g., v1.2.2), update version in:

- [ ] `app/__init__.py` - `__version__ = "1.2.2"`
- [ ] `pyproject.toml` - `version = "1.2.2"`
- [ ] `glancewatch.rb` - `version "1.2.2"` and update SHA256
- [ ] `chocolatey/glancewatch.nuspec` - `<version>1.2.2</version>`
- [ ] `chocolatey/tools/chocolateyinstall.ps1` - `$version = '1.2.2'`
- [ ] `npm-package/package.json` - `"version": "1.2.2"`
- [ ] `npm-package/postinstall.js` - `const version = '1.2.2'`

Then publish in order:
1. PyPI (via `./scripts/publish.sh`)
2. Calculate new SHA256 for Homebrew
3. Homebrew (push to tap repo)
4. Chocolatey (pack and push)
5. npm (publish)

---

## Troubleshooting

### Homebrew
- **Formula fails to install**: Check dependency versions match PyPI
- **Bottle build fails**: Test with `brew install --build-from-source`
- **SHA256 mismatch**: Recalculate hash from actual PyPI download

### Chocolatey
- **Package stuck in moderation**: First-time packages require manual review
- **Installation fails**: Check Python dependency in `chocolateyinstall.ps1`
- **Uninstall issues**: Test `chocolateyuninstall.ps1` script

### npm
- **postinstall fails**: Check Python availability on target system
- **bin script not found**: Ensure `bin/glancewatch.js` has execute permissions
- **Version mismatch**: Keep version in sync across all package.json files

---

## Resources

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Chocolatey Package Creation](https://docs.chocolatey.org/en-us/create/create-packages)
- [npm Publishing Guide](https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry)
- [PyPI Publishing Guide](https://packaging.python.org/en/latest/tutorials/packaging-projects/)

---

**Maintained by Collins Kemboi**  
Last updated: 2024
