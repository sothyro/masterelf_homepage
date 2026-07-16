import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/screens/field_work/widgets/activity_video_playback_hub.dart';
import 'package:masterelf_homepage/utils/web_hero_video_verify.dart';

class _FakeDelegate implements ActivityVideoPlaybackDelegate {
  _FakeDelegate(this.id);

  final String id;
  int playCount = 0;
  int pauseCount = 0;

  @override
  Future<void> playMuted({bool retryAfterFailure = false}) async {
    playCount++;
  }

  @override
  Future<void> pause() async {
    pauseCount++;
  }
}

void main() {
  test('verifyReleaseVideos passes for optimized local release videos', () {
    const corePaths = [
      'web/videos/videobackground720.mp4',
      'web/videos/videobackground480.mp4',
      'assets/videos/videobackground720.mp4',
      'assets/videos/appads.mp4',
    ];
    if (!corePaths.every((path) => File(path).existsSync())) {
      return;
    }
    for (var n = 1; n <= 6; n++) {
      if (!File('assets/videos/activities/$n.mp4').existsSync()) return;
      if (!File('web/videos/activities/$n.mp4').existsSync()) return;
      if (!File('web/videos/activities/$n-720.mp4').existsSync()) return;
    }

    expect(verifyReleaseVideos(), isTrue);
    expect(verifyWebHeroVideos(), isTrue);
    expect(releaseVideoFiles.length, greaterThanOrEqualTo(22));
  });

  test('autoplays the most visible video only', () async {
    final hub = ActivityVideoPlaybackHub();
    final a = _FakeDelegate('a');
    final b = _FakeDelegate('b');
    hub.register('a', a);
    hub.register('b', b);

    hub.reportVisibility('a', 0.6);
    await Future<void>.delayed(ActivityVideoPlaybackHub.playDebounce);
    expect(a.playCount, 1);
    expect(b.playCount, 0);

    hub.reportVisibility('b', 0.8);
    await Future<void>.delayed(ActivityVideoPlaybackHub.playDebounce);
    expect(a.pauseCount, 1);
    expect(b.playCount, 1);

    hub.reportVisibility('b', 0.2);
    expect(b.pauseCount, 1);
  });

  test('requestUserPlay pauses the active video', () async {
    final hub = ActivityVideoPlaybackHub();
    final a = _FakeDelegate('a');
    final b = _FakeDelegate('b');
    hub.register('a', a);
    hub.register('b', b);

    hub.reportVisibility('a', 0.7);
    await Future<void>.delayed(ActivityVideoPlaybackHub.playDebounce);
    await Future<void>.delayed(Duration.zero);
    hub.requestUserPlay('b');
    await Future<void>.delayed(Duration.zero);

    expect(a.pauseCount, 1);
    expect(b.playCount, 1);
  });

  test('re-entering autoplay zone retries the same video', () async {
    final hub = ActivityVideoPlaybackHub();
    final a = _FakeDelegate('a');
    hub.register('a', a);

    hub.reportVisibility('a', 0.7);
    await Future<void>.delayed(ActivityVideoPlaybackHub.playDebounce);
    expect(a.playCount, 1);

    hub.reportVisibility('a', 0.2);
    hub.reportVisibility('a', 0.7);
    await Future<void>.delayed(ActivityVideoPlaybackHub.playDebounce);
    expect(a.playCount, 2);
  });
}
