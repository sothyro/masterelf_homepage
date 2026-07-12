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

Write-Host "`n=== Verifying web hero videos ===" -ForegroundColor Cyan
dart run tool/verify_web_videos.dart
if ($LASTEXITCODE -ne 0) {
    Write-Host "Web hero video verification failed." -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Building web ===" -ForegroundColor Cyan
flutter build web

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed." -ForegroundColor Red
    exit 1
}

# Web uses static files under web/videos/; strip duplicate Flutter asset bundle copies.
$bundledHeroVideo = Join-Path $projectRoot "build\web\assets\assets\videos\videobackground720.mp4"
if (Test-Path $bundledHeroVideo) {
    Remove-Item $bundledHeroVideo -Force
    Write-Host "Removed duplicate bundled hero video from build/web/assets/" -ForegroundColor Green
}

$bundledActivities = Join-Path $projectRoot "build\web\assets\assets\videos\activities"
if (Test-Path $bundledActivities) {
    Remove-Item $bundledActivities -Recurse -Force
    Write-Host "Removed duplicate bundled activity videos from build/web/assets/" -ForegroundColor Green
}

# Copy .htaccess to build output (required for Apache/LiteSpeed hosting - SPA routing + www redirect)
$htaccessSrc = Join-Path $projectRoot "web\.htaccess"
$htaccessDst = Join-Path $projectRoot "build\web\.htaccess"
if (Test-Path $htaccessSrc) {
    Copy-Item $htaccessSrc $htaccessDst -Force
    Write-Host "Copied .htaccess to build/web/" -ForegroundColor Green
}

if ($Deploy) {
    Write-Host "`n=== Deploying to Firebase Hosting ===" -ForegroundColor Cyan
    firebase deploy --only hosting
} else {
    Write-Host "`n=== Done. Output in build/web/" -ForegroundColor Green
    Write-Host "To deploy: firebase deploy --only hosting" -ForegroundColor Yellow
}
