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
echo "=== Building web ==="
flutter build web

if [[ "$1" == "--deploy" ]]; then
  echo ""
  echo "=== Deploying to Firebase Hosting ==="
  firebase deploy --only hosting
else
  echo ""
  echo "=== Done. Output in build/web/"
  echo "To deploy: firebase deploy --only hosting"
fi
