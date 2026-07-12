# Re-encode field-work activity spotlight videos (H.264 + AAC, faststart).
# Usage: .\tool\encode_activity_videos.ps1
#
# Outputs:
#   assets/videos/activities/{1..6}.mp4       - 720p native bundle
#   web/videos/activities/{1..6}.mp4          - 480p mobile web
#   web/videos/activities/{1..6}-720.mp4      - 720p desktop/tablet web
#
# Originals are backed up to tool/activity_video_sources/ on first run.

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $projectRoot

$ffmpeg = Get-Command ffmpeg -ErrorAction SilentlyContinue
if (-not $ffmpeg) {
    $wingetFfmpeg = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Links\ffmpeg.exe"
    if (Test-Path $wingetFfmpeg) {
        $ffmpeg = Get-Command $wingetFfmpeg
    }
}
if (-not $ffmpeg) {
    Write-Error "ffmpeg not found in PATH. Install via winget install ffmpeg"
}
$ffmpegExe = $ffmpeg.Source

$activitiesDir = Join-Path $projectRoot "assets\videos\activities"
$sourceDir = Join-Path $projectRoot "tool\activity_video_sources"
$webDir = Join-Path $projectRoot "web\videos\activities"

New-Item -ItemType Directory -Force -Path $sourceDir, $webDir | Out-Null

function Format-Mb([long]$bytes) {
    return "{0:N2} MB" -f ($bytes / 1MB)
}

foreach ($n in 1..6) {
    $name = "$n.mp4"
    $assetPath = Join-Path $activitiesDir $name
    $sourcePath = Join-Path $sourceDir $name

    if (-not (Test-Path $assetPath)) {
        Write-Warning "Missing $assetPath - skip"
        continue
    }

    if (-not (Test-Path $sourcePath)) {
        Copy-Item $assetPath $sourcePath -Force
        Write-Host "Backed up $name to source/" -ForegroundColor Cyan
    }

    $inputPath = $sourcePath
    $tmp720 = Join-Path $activitiesDir "$n.tmp720.mp4"
    $tmp480 = Join-Path $webDir "$n.tmp480.mp4"
    $out720Asset = Join-Path $activitiesDir $name
    $out480Web = Join-Path $webDir $name
    $out720Web = Join-Path $webDir "$n-720.mp4"

    Write-Host "`n=== Encoding activity video $n ===" -ForegroundColor Yellow

    & $ffmpegExe -y -i $inputPath -vf "scale=-2:720" `
        -c:v libx264 -preset slow -crf 28 `
        -c:a aac -b:a 128k -ac 2 `
        -movflags +faststart $tmp720

    & $ffmpegExe -y -i $inputPath -vf "scale=-2:480" `
        -c:v libx264 -preset slow -crf 28 `
        -c:a aac -b:a 96k -ac 2 `
        -movflags +faststart $tmp480

    Move-Item -Force $tmp720 $out720Asset
    Copy-Item -Force $out720Asset $out720Web
    Move-Item -Force $tmp480 $out480Web

    Write-Host "  native 720: $(Format-Mb (Get-Item $out720Asset).Length)" -ForegroundColor Green
    Write-Host "  web 720:    $(Format-Mb (Get-Item $out720Web).Length)" -ForegroundColor Green
    Write-Host "  web 480:    $(Format-Mb (Get-Item $out480Web).Length)" -ForegroundColor Green
}

Write-Host "`nDone. Run: dart run tool/verify_web_videos.dart" -ForegroundColor Cyan
