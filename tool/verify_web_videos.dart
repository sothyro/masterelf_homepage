// Verifies release video files exist and are optimized before a web release build.
//
// Usage: dart run tool/verify_web_videos.dart

import 'dart:io';

import 'package:masterelf_homepage/utils/web_hero_video_verify.dart';

void main() {
  if (!verifyReleaseVideos(logError: stderr.writeln)) {
    stderr.writeln(
      'Encode optimized release videos with ffmpeg (see README.md), then re-run '
      'dart run tool/verify_web_videos.dart',
    );
    exit(1);
  }

  stdout.writeln('Release video files OK.');
}
