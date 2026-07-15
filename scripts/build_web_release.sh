#!/usr/bin/env bash
# Build web for release and optionally deploy to Firebase Hosting.
# CRITICAL: Always run this script (or flutter clean) before release builds.
# Flutter's incremental build cache can produce stale output when shared across
# projects or after SDK/IDE updates. A clean build ensures fresh output.
#
# Usage: ./scripts/build_web_release.sh
# Or:    ./scripts/build_web_release.sh --deploy

set -e
cd "$(dirname "$0")/.."

echo "=== Cleaning build cache (critical for fresh output) ==="
flutter clean

echo ""
echo "=== Getting dependencies ==="
flutter pub get

echo ""
echo "=== Verifying web hero videos ==="
dart run tool/verify_web_videos.dart

echo ""
echo "=== Verifying release images ==="
dart run tool/verify_web_images.dart

echo ""
echo "=== Building web ==="
flutter build web

# Web uses static files under web/videos/; strip duplicate Flutter asset bundle copies.
bundled_hero_video="build/web/assets/assets/videos/videobackground720.mp4"
if [[ -f "$bundled_hero_video" ]]; then
  rm -f "$bundled_hero_video"
  echo "Removed duplicate bundled hero video from build/web/assets/"
fi

bundled_activities="build/web/assets/assets/videos/activities"
if [[ -d "$bundled_activities" ]]; then
  rm -rf "$bundled_activities"
  echo "Removed duplicate bundled activity videos from build/web/assets/"
fi

# Copy .htaccess to build output (required for Apache/LiteSpeed hosting - SPA routing + www redirect)
if [[ -f web/.htaccess ]]; then
  cp web/.htaccess build/web/.htaccess
  echo "Copied .htaccess to build/web/"
fi

if [[ "$1" == "--deploy" ]]; then
  echo ""
  echo "=== Deploying to Firebase Hosting ==="
  firebase deploy --only hosting
else
  echo ""
  echo "=== Done. Output in build/web/"
  echo "To deploy: firebase deploy --only hosting"
fi
