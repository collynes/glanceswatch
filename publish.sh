#!/bin/bash
# Script to build and publish GlanceWatch to PyPI

set -e

echo "🚀 Publishing GlanceWatch to PyPI..."
echo ""

# Check if we're in the right directory
if [ ! -f "pyproject.toml" ]; then
    echo "❌ Error: pyproject.toml not found. Are you in the project root?"
    exit 1
fi

# Check for required tools
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.8+"
    exit 1
fi

# Install build tools if needed
echo "📦 Checking build tools..."
pip3 install --quiet --upgrade build twine

# Clean old builds
echo "🧹 Cleaning old builds..."
rm -rf dist/ build/ *.egg-info app/*.egg-info

# Build the package
echo "📦 Building package..."
python3 -m build

# Check the package
echo "✅ Checking package..."
twine check dist/*

# Show what will be uploaded
echo ""
echo "📂 Package contents:"
ls -lh dist/

# Ask for confirmation
echo ""
read -p "🔄 Upload to PyPI? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Upload cancelled"
    exit 0
fi

# Upload to PyPI
echo "📤 Uploading to PyPI..."
twine upload dist/*

echo ""
echo "✅ Published successfully!"
echo ""
echo "📦 Users can now install with:"
echo "   pip install glancewatch"
echo ""
echo "🧪 Test the installation:"
echo "   pip install --upgrade glancewatch"
echo "   glancewatch --help"
echo ""
