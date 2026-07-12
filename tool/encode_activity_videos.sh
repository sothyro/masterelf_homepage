#!/usr/bin/env bash
# Re-encode field-work activity spotlight videos (H.264 + AAC, faststart).
# Usage: ./tool/encode_activity_videos.sh

set -euo pipefail
cd "$(dirname "$0")/.."

command -v ffmpeg >/dev/null 2>&1 || { echo "ffmpeg not found"; exit 1; }

activities_dir="assets/videos/activities"
source_dir="tool/activity_video_sources"
web_dir="web/videos/activities"
mkdir -p "$source_dir" "$web_dir"

format_mb() {
  local bytes=$1
  awk "BEGIN {printf \"%.2f MB\", $bytes/1048576}"
}

for n in 1 2 3 4 5 6; do
  name="${n}.mp4"
  asset_path="$activities_dir/$name"
  source_path="$source_dir/$name"

  if [[ ! -f "$asset_path" ]]; then
    echo "Missing $asset_path — skip"
    continue
  fi

  if [[ ! -f "$source_path" ]]; then
    cp "$asset_path" "$source_path"
    echo "Backed up $name to source/"
  fi

  input_path="$source_path"
  tmp720="$activities_dir/${n}.tmp720.mp4"
  tmp480="$web_dir/${n}.tmp480.mp4"
  out720_asset="$activities_dir/$name"
  out480_web="$web_dir/$name"
  out720_web="$web_dir/${n}-720.mp4"

  echo ""
  echo "=== Encoding activity video $n ==="

  ffmpeg -y -i "$input_path" -vf "scale=-2:720" \
    -c:v libx264 -preset slow -crf 28 \
    -c:a aac -b:a 128k -ac 2 \
    -movflags +faststart "$tmp720"

  ffmpeg -y -i "$input_path" -vf "scale=-2:480" \
    -c:v libx264 -preset slow -crf 28 \
    -c:a aac -b:a 96k -ac 2 \
    -movflags +faststart "$tmp480"

  mv -f "$tmp720" "$out720_asset"
  cp -f "$out720_asset" "$out720_web"
  mv -f "$tmp480" "$out480_web"

  echo "  native 720: $(format_mb "$(stat -c%s "$out720_asset" 2>/dev/null || stat -f%z "$out720_asset")")"
  echo "  web 720:    $(format_mb "$(stat -c%s "$out720_web" 2>/dev/null || stat -f%z "$out720_web")")"
  echo "  web 480:    $(format_mb "$(stat -c%s "$out480_web" 2>/dev/null || stat -f%z "$out480_web")")"
done

echo ""
echo "Done. Run: dart run tool/verify_web_videos.dart"
