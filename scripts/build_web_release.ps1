# Build web for release and deploy to Firebase Hosting.
# CRITICAL: Always run this script (or flutter clean) before release builds.
# Flutter's incremental build cache can produce stale output when shared across
# projects or after SDK/IDE updates. A clean build ensures fresh output.
#
# Usage: .\scripts\build_web_release.ps1
# Or:    .\scripts\build_web_release.ps1 -Deploy

param(
    [switch]$Deploy
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $projectRoot

Write-Host "=== Cleaning build cache (critical for fresh output) ===" -ForegroundColor Cyan
flutter clean

Write-Host "`n=== Getting dependencies ===" -ForegroundColor Cyan
flutter pub get

Write-Host "`n=== Building web ===" -ForegroundColor Cyan
flutter build web

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed." -ForegroundColor Red
    exit 1
}

if ($Deploy) {
    Write-Host "`n=== Deploying to Firebase Hosting ===" -ForegroundColor Cyan
    firebase deploy --only hosting
} else {
    Write-Host "`n=== Done. Output in build/web/" -ForegroundColor Green
    Write-Host "To deploy: firebase deploy --only hosting" -ForegroundColor Yellow
}
