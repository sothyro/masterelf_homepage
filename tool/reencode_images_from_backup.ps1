# Re-encode WebP assets from tool/image_sources/ backups (fixes profile/size issues).
# Usage: .\tool\reencode_images_from_backup.ps1

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $projectRoot

$assetsDir = Join-Path $projectRoot "assets"
$sourceDir = Join-Path $projectRoot "tool\image_sources"

if (-not (Test-Path $sourceDir)) {
    Write-Error "No backups in tool/image_sources/. Run encode_images.ps1 first."
}

Get-ChildItem -Path $assetsDir -Recurse -Include *.webp -File | Remove-Item -Force
Write-Host "Removed existing WebP files." -ForegroundColor Cyan

$backups = Get-ChildItem -Path $sourceDir -Recurse -Include *.jpg,*.jpeg,*.png,*.JPG,*.JPEG,*.PNG -File
foreach ($backup in $backups) {
    $relative = $backup.FullName.Substring($sourceDir.Length + 1)
    $dest = Join-Path $assetsDir $relative
    $destDir = Split-Path $dest -Parent
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    }
    Copy-Item $backup.FullName $dest -Force
}
Write-Host "Restored $($backups.Count) originals from backup." -ForegroundColor Cyan

& (Join-Path $projectRoot "tool\encode_images.ps1")
