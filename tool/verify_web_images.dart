// Verifies release image assets exist as optimized WebP before a web release build.
//
// Usage: dart run tool/verify_web_images.dart

import 'dart:io';

import 'package:masterelf_homepage/utils/web_image_verify.dart';

void main() {
  if (!verifyReleaseImages(logError: stderr.writeln)) {
    stderr.writeln(
      'Encode optimized release images with ffmpeg (see README.md), then re-run '
      'dart run tool/verify_web_images.dart',
    );
    exit(1);
  }

  stdout.writeln('Release image assets OK (${releaseImageAssets.length} files).');
}
