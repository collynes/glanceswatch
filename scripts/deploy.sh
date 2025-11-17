#!/bin/bash

# GlanceWatch Multi-Platform Deployment Script
# Deploys to PyPI, Homebrew, npm, and Chocolatey registries

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get version from app/__init__.py
VERSION=$(grep "__version__" app/__init__.py | cut -d'"' -f2)

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   GlanceWatch Deployment Script v${VERSION}       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Show menu
echo -e "${YELLOW}Select deployment target:${NC}"
echo "1) PyPI (Python)"
echo "2) Homebrew (macOS/Linux)"
echo "3) npm (Node.js)"
echo "4) Chocolatey (Windows - requires Windows)"
echo "5) All platforms"
echo "6) Exit"
echo ""
read -p "Enter choice [1-6]: " choice

deploy_pypi() {
    echo -e "\n${BLUE}═══ Deploying to PyPI ═══${NC}"
    
    # Check if version already exists
    if pip index versions glancewatch 2>/dev/null | grep -q "$VERSION"; then
        echo -e "${YELLOW}⚠ Version $VERSION already exists on PyPI${NC}"
        read -p "Continue anyway? (y/n): " confirm
        [[ "$confirm" != "y" ]] && return
    fi
    
    # Clean old builds
    echo "Cleaning old builds..."
    rm -rf dist/ build/ *.egg-info
    
    # Build package
    echo "Building package..."
    python3 -m build
    
    # Check package
    echo "Checking package..."
    twine check dist/*
    
    # Upload
    echo "Uploading to PyPI..."
    twine upload dist/*
    
    echo -e "${GREEN}✅ Successfully deployed to PyPI${NC}"
    echo -e "   View at: https://pypi.org/project/glancewatch/$VERSION/"
}

deploy_homebrew() {
    echo -e "\n${BLUE}═══ Deploying to Homebrew ═══${NC}"
    
    # Check if homebrew-glancewatch repo exists
    if [ ! -d "$HOME/Documents/homebrew-glancewatch" ]; then
        echo -e "${RED}❌ Homebrew tap repository not found${NC}"
        echo "Expected: $HOME/Documents/homebrew-glancewatch"
        return 1
    fi
    
    cd "$HOME/Documents/homebrew-glancewatch"
    
    # Download package from PyPI and get SHA256
    echo "Downloading package from PyPI..."
    curl -L "https://files.pythonhosted.org/packages/source/g/glancewatch/glancewatch-${VERSION}.tar.gz" -o "/tmp/glancewatch-${VERSION}.tar.gz"
    
    echo "Calculating SHA256..."
    SHA256=$(shasum -a 256 "/tmp/glancewatch-${VERSION}.tar.gz" | cut -d' ' -f1)
    
    # Update formula
    echo "Updating formula..."
    sed -i '' "s|url \".*\"|url \"https://files.pythonhosted.org/packages/source/g/glancewatch/glancewatch-${VERSION}.tar.gz\"|" Formula/glancewatch.rb
    sed -i '' "s|sha256 \".*\"|sha256 \"${SHA256}\"|" Formula/glancewatch.rb
    
    # Commit and push
    git add Formula/glancewatch.rb
    git commit -m "Update GlanceWatch to v${VERSION}"
    git push origin main
    
    echo -e "${GREEN}✅ Successfully deployed to Homebrew${NC}"
    echo -e "   View at: https://github.com/collynes/homebrew-glancewatch"
    
    cd - > /dev/null
}

deploy_npm() {
    echo -e "\n${BLUE}═══ Deploying to npm ═══${NC}"
    
    cd npm-package
    
    # Check if already published
    if npm view glancewatch@${VERSION} version 2>/dev/null; then
        echo -e "${YELLOW}⚠ Version $VERSION already exists on npm${NC}"
        cd ..
        return
    fi
    
    # Update version in package.json
    echo "Updating package.json version..."
    sed -i '' "s/\"version\": \".*\"/\"version\": \"${VERSION}\"/" package.json
    
    # Update version in postinstall.js
    sed -i '' "s/const version = '.*'/const version = '${VERSION}'/" postinstall.js
    
    # Make bin executable
    chmod +x bin/glancewatch.js
    
    # Publish
    echo "Publishing to npm..."
    npm publish
    
    echo -e "${GREEN}✅ Successfully deployed to npm${NC}"
    echo -e "   View at: https://www.npmjs.com/package/glancewatch"
    
    cd ..
}

deploy_chocolatey() {
    echo -e "\n${BLUE}═══ Deploying to Chocolatey ═══${NC}"
    
    # Check if on Windows
    if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "win32" ]]; then
        echo -e "${YELLOW}⚠ Chocolatey deployment requires Windows${NC}"
        echo "Package files are ready in chocolatey/ folder"
        echo ""
        echo "To deploy on Windows:"
        echo "  1. cd chocolatey"
        echo "  2. choco pack"
        echo "  3. choco push glancewatch.${VERSION}.nupkg --source https://push.chocolatey.org/"
        return
    fi
    
    cd chocolatey
    
    # Update version in nuspec
    sed -i "s/<version>.*<\/version>/<version>${VERSION}<\/version>/" glancewatch.nuspec
    
    # Update version in install script
    sed -i "s/\$version = '.*'/\$version = '${VERSION}'/" tools/chocolateyinstall.ps1
    
    # Pack
    echo "Packing Chocolatey package..."
    choco pack
    
    # Push
    echo "Pushing to Chocolatey..."
    choco push "glancewatch.${VERSION}.nupkg" --source https://push.chocolatey.org/
    
    echo -e "${GREEN}✅ Successfully deployed to Chocolatey${NC}"
    echo -e "   View at: https://community.chocolatey.org/packages/glancewatch"
    
    cd ..
}

# Execute based on choice
case $choice in
    1)
        deploy_pypi
        ;;
    2)
        deploy_homebrew
        ;;
    3)
        deploy_npm
        ;;
    4)
        deploy_chocolatey
        ;;
    5)
        echo -e "\n${YELLOW}Deploying to all platforms...${NC}"
        deploy_pypi
        echo ""
        read -p "Press Enter to continue to Homebrew..."
        deploy_homebrew
        echo ""
        read -p "Press Enter to continue to npm..."
        deploy_npm
        echo ""
        read -p "Press Enter to continue to Chocolatey..."
        deploy_chocolatey
        ;;
    6)
        echo -e "${BLUE}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Deployment Complete! ✨               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
