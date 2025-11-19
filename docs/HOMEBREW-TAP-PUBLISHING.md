# Publishing GlanceWatch to Homebrew Tap

## Prerequisites
✅ Homebrew formula tested locally and working
✅ PyPI package published (v1.2.1)
✅ GitHub account (collynes)

## Step 1: Create Homebrew Tap Repository

1. **Create new GitHub repository**: `homebrew-glancewatch`
   - Go to: https://github.com/new
   - Repository name: **homebrew-glancewatch**
   - Description: "Homebrew tap for GlanceWatch - Lightweight monitoring adapter"
   - Public repository
   - Initialize with README ✅

2. **Clone the repository**:
```bash
cd ~/Documents
git clone https://github.com/collynes/homebrew-glancewatch.git
cd homebrew-glancewatch
```

## Step 2: Add Formula to Tap

1. **Create Formula directory**:
```bash
mkdir -p Formula
```

2. **Copy the tested formula**:
```bash
cp /Users/collinsk/Documents/glances-kuma-alerts/glancewatch.rb Formula/glancewatch.rb
```

3. **Calculate SHA256 from PyPI** (important!):
```bash
# Download the exact package from PyPI
curl -L https://files.pythonhosted.org/packages/source/g/glancewatch/glancewatch-1.2.1.tar.gz -o glancewatch-1.2.1.tar.gz

# Calculate SHA256
shasum -a 256 glancewatch-1.2.1.tar.gz
```

4. **Update the SHA256 in Formula/glancewatch.rb**:
   - Replace the empty `sha256 ""` with the calculated hash
   - Example: `sha256 "abc123def456..."`

## Step 3: Create README for the Tap

Create `README.md`:
```markdown
# GlanceWatch Homebrew Tap

Homebrew tap for [GlanceWatch](https://github.com/collynes/glancewatch) - Lightweight monitoring adapter for Glances + Uptime Kuma.

## Installation

```bash
brew tap collynes/glancewatch
brew install glancewatch
```

## Usage

```bash
# Start GlanceWatch
glancewatch

# Web UI: http://localhost:8000
# API Docs: http://localhost:8000/docs
```

## Run as a Service

```bash
# Start service
brew services start glancewatch

# Stop service
brew services stop glancewatch

# View logs
tail -f /opt/homebrew/var/log/glancewatch.log
```

## Updating

```bash
brew update
brew upgrade glancewatch
```

## Documentation

- [Main Repository](https://github.com/collynes/glancewatch)
- [PyPI Package](https://pypi.org/project/glancewatch/)
- [Documentation](https://github.com/collynes/glancewatch/tree/main/docs)

## License

MIT License - see [LICENSE](https://github.com/collynes/glancewatch/blob/main/LICENSE)
```

## Step 4: Test the Tap Locally (Before Publishing)

```bash
# Uninstall local version first
brew uninstall glancewatch
brew untap collynes/glancewatch

# Install from your local tap repository
brew tap collynes/glancewatch file:///Users/collinsk/Documents/homebrew-glancewatch
brew install glancewatch

# Test it works
glancewatch --help
```

## Step 5: Publish to GitHub

```bash
cd ~/Documents/homebrew-glancewatch

# Add all files
git add Formula/glancewatch.rb README.md

# Commit
git commit -m "Add GlanceWatch formula v1.2.1"

# Push to GitHub
git push origin main
```

## Step 6: Users Can Now Install

Once pushed, anyone can install with:

```bash
brew tap collynes/glancewatch
brew install glancewatch
```

## Updating the Formula (For Future Releases)

When you release a new version (e.g., v1.2.2):

1. **Update the formula**:
   ```bash
   cd ~/Documents/homebrew-glancewatch
   ```

2. **Edit `Formula/glancewatch.rb`**:
   - Update version in `url` line
   - Update `sha256` with new hash
   - Update any dependency versions if needed

3. **Download new package and calculate SHA256**:
   ```bash
   curl -L https://files.pythonhosted.org/packages/source/g/glancewatch/glancewatch-1.2.2.tar.gz -o glancewatch-1.2.2.tar.gz
   shasum -a 256 glancewatch-1.2.2.tar.gz
   ```

4. **Commit and push**:
   ```bash
   git add Formula/glancewatch.rb
   git commit -m "Update GlanceWatch to v1.2.2"
   git push origin main
   ```

5. **Users upgrade with**:
   ```bash
   brew update
   brew upgrade glancewatch
   ```

## Troubleshooting

### Formula fails to install
- Check SHA256 hash matches the PyPI package
- Verify all resource URLs are accessible
- Test with `brew install --build-from-source --verbose Formula/glancewatch.rb`

### Users report issues
- Add GitHub Issues to homebrew-glancewatch repo
- Direct to main repo for app issues

### Want to add bottles (pre-compiled binaries)
- Requires CI/CD setup (GitHub Actions)
- See [Homebrew bottles documentation](https://docs.brew.sh/Bottles)

## Resources

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Homebrew Taps](https://docs.brew.sh/Taps)
- [Python Virtualenv Formula](https://docs.brew.sh/Python-for-Formula-Authors)

---

**Status**: Ready to publish! 🚀
**Tap URL**: https://github.com/collynes/homebrew-glancewatch
**Install**: `brew tap collynes/glancewatch && brew install glancewatch`
