#!/usr/bin/env bash
# Encode raster images under assets/ to optimized WebP (libwebp via ffmpeg).
# Usage: ./tool/encode_images.sh
#
# Originals are backed up to tool/image_sources/ on first run.

set -euo pipefail
cd "$(dirname "$0")/.."
project_root="$PWD"

command -v ffmpeg >/dev/null 2>&1 || { echo "ffmpeg not found"; exit 1; }

assets_dir="$project_root/assets"
source_dir="$project_root/tool/image_sources"
mkdir -p "$source_dir"

format_kb() {
  local bytes=$1
  awk -v b="$bytes" 'BEGIN { printf "%.1f KB", b / 1024 }'
}

get_profile() {
  local rel
  rel=$(echo "$1" | tr '\\' '/' | tr '[:upper:]' '[:lower:]')
  if [[ "$rel" == *"/images/apps/"* ]]; then
    echo "2048 92 0 app-mockup"
  elif [[ "$rel" == *"/testimonials/"* || "$rel" == *"/images/activities/"* ]]; then
    echo "1200 89 0 card-photo"
  elif [[ "$rel" == *"/icons/logomono.png" || "$rel" == *"/icons/yuk9icon.png" || "$rel" == *"/icons/icon.png" ]]; then
    echo "0 0 1 icon-alpha"
  elif [[ "$rel" == *"/icons/"* || "$rel" == *"/cl/"* ]]; then
    echo "512 90 0 icon-logo"
  else
    echo "1920 84 0 hero-default"
  fi
}

encode_image() {
  local input=$1
  local output=$2
  local max_edge=$3
  local quality=$4
  local lossless=$5

  local -a args=(-hide_banner -loglevel error -y -i "$input")
  if [[ "$max_edge" -gt 0 ]]; then
    args+=(-vf "scale=${max_edge}:${max_edge}:force_original_aspect_ratio=decrease")
  fi
  if [[ "$lossless" -eq 1 ]]; then
    args+=(-c:v libwebp -lossless 1)
  else
    args+=(-c:v libwebp -quality "$quality")
  fi
  args+=("$output")
  ffmpeg "${args[@]}"
}

total_before=0
total_after=0
count=0

while IFS= read -r -d '' file; do
  rel="${file#"$assets_dir"/}"
  rel="${rel//\\//}"
  output="${file%.*}.webp"

  if [[ -f "$output" ]]; then
    echo "Skip (webp exists): $rel"
    continue
  fi

  backup="$source_dir/$rel"
  mkdir -p "$(dirname "$backup")"
  if [[ ! -f "$backup" ]]; then
    cp "$file" "$backup"
  fi

  read -r max_edge quality lossless label <<< "$(get_profile "$rel")"
  before=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")
  echo "Encoding [$label] $rel"

  encode_image "$file" "$output" "$max_edge" "$quality" "$lossless"

  after=$(stat -c%s "$output" 2>/dev/null || stat -f%z "$output")
  if [[ "$after" -le 0 ]]; then
    rm -f "$output"
    echo "Encoded file is empty: $rel" >&2
    exit 1
  fi

  rm -f "$file"
  total_before=$((total_before + before))
  total_after=$((total_after + after))
  count=$((count + 1))
  saved=$(awk -v b="$before" -v a="$after" 'BEGIN { if (b > 0) printf "%.1f", (1 - a / b) * 100; else print "0" }')
  printf "  %s -> %s (%s%% saved)\n" "$(format_kb "$before")" "$(format_kb "$after")" "$saved"
done < <(find "$assets_dir" \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -type f -print0)

echo ""
echo "=== Encode summary ==="
if [[ "$count" -eq 0 ]]; then
  echo "No new images encoded."
else
  saved_total=$(awk -v b="$total_before" -v a="$total_after" 'BEGIN { if (b > 0) printf "%.1f", (1 - a / b) * 100; else print "0" }')
  echo "Encoded $count files: $(format_kb "$total_before") -> $(format_kb "$total_after") (${saved_total}% saved)"
fi

echo ""
echo "Done. Update lib/config/app_content.dart paths to .webp, then run:"
echo "  dart run tool/verify_web_images.dart"
