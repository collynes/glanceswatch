$ErrorActionPreference = 'Stop'

$packageName = 'glancewatch'

Write-Host "Uninstalling GlanceWatch..."
& python -m pip uninstall -y glancewatch

if ($LASTEXITCODE -ne 0) {
    Write-Warning "Failed to uninstall GlanceWatch via pip"
} else {
    Write-Host "GlanceWatch uninstalled successfully!"
}
