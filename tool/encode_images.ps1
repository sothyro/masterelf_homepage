# Encode raster images under assets/ to optimized WebP (libwebp via ffmpeg).
# Usage: .\tool\encode_images.ps1
#
# Originals are backed up to tool/image_sources/ on first run.
# Tiered quality profiles match display budgets in mobile_web_performance.dart.

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

$assetsDir = Join-Path $projectRoot "assets"
$sourceDir = Join-Path $projectRoot "tool\image_sources"
New-Item -ItemType Directory -Force -Path $sourceDir | Out-Null

function Format-Kb([long]$bytes) {
    return "{0:N1} KB" -f ($bytes / 1KB)
}

function Get-ImageProfile([string]$relativePath) {
    $path = ($relativePath -replace '\\', '/').ToLowerInvariant()
    if ($path -match '(^|/)images/apps/') {
        return @{ MaxEdge = 2048; Quality = 92; Lossless = $false; Label = 'app-mockup' }
    }
    if ($path -match '(^|/)testimonials/' -or $path -match '(^|/)images/activities/') {
        return @{ MaxEdge = 1200; Quality = 89; Lossless = $false; Label = 'card-photo' }
    }
    if ($path -match '(^|/)icons/(logomono|yuk9icon|icon)\.png$') {
        return @{ MaxEdge = 0; Quality = 0; Lossless = $true; Label = 'icon-alpha' }
    }
    if ($path -match '(^|/)icons/' -or $path -match '(^|/)cl/') {
        return @{ MaxEdge = 512; Quality = 90; Lossless = $false; Label = 'icon-logo' }
    }
    return @{ MaxEdge = 1920; Quality = 84; Lossless = $false; Label = 'hero-default' }
}

function Invoke-FfmpegEncode([string]$inputPath, [string]$outputPath, $profile, [int]$qualityOverride = -1) {
    $args = @('-hide_banner', '-loglevel', 'error', '-y', '-i', $inputPath)
    if ($profile.MaxEdge -gt 0) {
        $edge = $profile.MaxEdge
        $args += @('-vf', "scale=${edge}:${edge}:force_original_aspect_ratio=decrease")
    }
    if ($profile.Lossless) {
        $args += @('-c:v', 'libwebp', '-lossless', '1')
    } else {
        $quality = if ($qualityOverride -ge 0) { $qualityOverride } else { $profile.Quality }
        $args += @('-c:v', 'libwebp', '-quality', "$quality")
    }
    if ($outputPath -notmatch '\.webp$') {
        $args = @('-f', 'webp') + $args
    }
    $args += $outputPath
    & $ffmpegExe @args
    if ($LASTEXITCODE -ne 0) {
        throw "ffmpeg failed for $inputPath"
    }
}

function Encode-Image([string]$inputPath, [string]$outputPath, $profile) {
    $before = (Get-Item $inputPath).Length
    $ext = [System.IO.Path]::GetExtension($inputPath).ToLowerInvariant()
    $qualities = @($profile.Quality)
    if (-not $profile.Lossless -and $ext -in @('.jpg', '.jpeg')) {
        $qualities = @($profile.Quality, 80, 72)
    }

    $bestPath = $outputPath
    $tmpPath = [System.IO.Path]::ChangeExtension([System.IO.Path]::GetTempFileName(), '.webp')
    $bestSize = [long]::MaxValue
    $bestQuality = $profile.Quality

    foreach ($q in $qualities) {
        if ($profile.Lossless) {
            Invoke-FfmpegEncode -inputPath $inputPath -outputPath $tmpPath -profile $profile
            $size = (Get-Item $tmpPath).Length
            $bestSize = $size
            break
        }
        Invoke-FfmpegEncode -inputPath $inputPath -outputPath $tmpPath -profile $profile -qualityOverride $q
        $size = (Get-Item $tmpPath).Length
        if ($size -lt $bestSize) {
            $bestSize = $size
            $bestQuality = $q
        }
        if ($size -le $before) { break }
    }

    if ($profile.Lossless) {
        Move-Item -Force $tmpPath $bestPath
        return $bestSize
    }

    if ($bestSize -gt $before) {
        Invoke-FfmpegEncode -inputPath $inputPath -outputPath $tmpPath -profile $profile -qualityOverride 72
        $bestSize = (Get-Item $tmpPath).Length
        $bestQuality = 72
    }

    Move-Item -Force $tmpPath $bestPath
    return $bestSize
}

$extensions = @('*.jpg', '*.jpeg', '*.png', '*.JPG', '*.JPEG', '*.PNG')
$files = Get-ChildItem -Path $assetsDir -Recurse -Include $extensions -File |
    Where-Object { $_.FullName -notmatch '\\videos\\.*\.(jpg|jpeg|png)$' -or $_.Name -eq 'activitiesbg.jpg' }

$totalBefore = 0L
$totalAfter = 0L
$rows = @()

foreach ($file in $files) {
    $relative = $file.FullName.Substring($assetsDir.Length + 1)
    $sourceBackup = Join-Path $sourceDir $relative
    $outputPath = [System.IO.Path]::ChangeExtension($file.FullName, '.webp')

    if (Test-Path $outputPath) {
        Write-Host "Skip (webp exists): $relative" -ForegroundColor DarkGray
        continue
    }

    $sourceDirForFile = Split-Path $sourceBackup -Parent
    if (-not (Test-Path $sourceDirForFile)) {
        New-Item -ItemType Directory -Force -Path $sourceDirForFile | Out-Null
    }
    if (-not (Test-Path $sourceBackup)) {
        Copy-Item $file.FullName $sourceBackup -Force
    }

    $inputPath = if (Test-Path $sourceBackup) { $sourceBackup } else { $file.FullName }
    $profile = Get-ImageProfile $relative
    $before = (Get-Item $inputPath).Length
    Write-Host "Encoding [$($profile.Label)] $relative" -ForegroundColor Yellow

    $after = Encode-Image -inputPath $inputPath -outputPath $outputPath -profile $profile

    if ($after -le 0) {
        Remove-Item $outputPath -Force -ErrorAction SilentlyContinue
        throw "Encoded file is empty: $relative"
    }

    Remove-Item $file.FullName -Force
    $totalBefore += $before
    $totalAfter += $after
    $pct = if ($before -gt 0) { [math]::Round((1 - ($after / $before)) * 100, 1) } else { 0 }
    $rows += [PSCustomObject]@{
        File = $relative
        Profile = $profile.Label
        Before = Format-Kb $before
        After = Format-Kb $after
        Saved = "${pct}%"
    }
}

Write-Host "`n=== Encode summary ===" -ForegroundColor Cyan
if ($rows.Count -eq 0) {
    Write-Host "No new images encoded (all already WebP or none found)."
} else {
    $rows | Format-Table -AutoSize
    $savedPct = if ($totalBefore -gt 0) {
        [math]::Round((1 - ($totalAfter / $totalBefore)) * 100, 1)
    } else { 0 }
    Write-Host "Total: $(Format-Kb $totalBefore) -> $(Format-Kb $totalAfter) (${savedPct}% saved)" -ForegroundColor Green
}

Write-Host "`nDone. Update lib/config/app_content.dart paths to .webp, then run:" -ForegroundColor Cyan
Write-Host "  dart run tool/verify_web_images.dart"
