$ErrorActionPreference = 'Stop'

$packageName = 'glancewatch'
$version = '1.2.1'

# Check if Python is installed
try {
    $pythonVersion = & python --version 2>&1
    Write-Host "Found Python: $pythonVersion"
} catch {
    throw "Python is not installed. Please install Python 3.8 or higher first."
}

# Check Python version
$pythonVersionNumber = & python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>&1
if ([double]$pythonVersionNumber -lt 3.8) {
    throw "Python 3.8 or higher is required. Found Python $pythonVersionNumber"
}

# Install glancewatch via pip
Write-Host "Installing GlanceWatch v$version via pip..."
& python -m pip install --upgrade pip
& python -m pip install glancewatch==$version

if ($LASTEXITCODE -ne 0) {
    throw "Failed to install GlanceWatch"
}

Write-Host "GlanceWatch v$version installed successfully!"
Write-Host ""
Write-Host "To start GlanceWatch, run: glancewatch"
Write-Host "Web UI will be available at: http://localhost:8765"
Write-Host ""
Write-Host "For more information, visit: https://github.com/collynes/glancewatch"
