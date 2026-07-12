import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/utils/web_hero_video_verify.dart';

void main() {
  test('verifyReleaseVideos passes for optimized local release videos', () {
    const requiredPaths = [
      'web/videos/videobackground720.mp4',
      'web/videos/videobackground480.mp4',
      'assets/videos/videobackground720.mp4',
      'assets/videos/appads.mp4',
    ];
    if (!requiredPaths.every((path) => File(path).existsSync())) {
      return;
    }

    expect(verifyReleaseVideos(), isTrue);
    expect(verifyWebHeroVideos(), isTrue);
  });
}
