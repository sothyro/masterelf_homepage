import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/screens/field_work/widgets/activity_video_playback_hub.dart';

class _FakeDelegate implements ActivityVideoPlaybackDelegate {
  _FakeDelegate(this.id);

  final String id;
  int playCount = 0;
  int pauseCount = 0;

  @override
  Future<void> playMuted() async {
    playCount++;
  }

  @override
  Future<void> pause() async {
    pauseCount++;
  }
}

void main() {
  test('autoplays the most visible video only', () {
    final hub = ActivityVideoPlaybackHub();
    final a = _FakeDelegate('a');
    final b = _FakeDelegate('b');
    hub.register('a', a);
    hub.register('b', b);

    hub.reportVisibility('a', 0.6);
    expect(a.playCount, 1);
    expect(b.playCount, 0);

    hub.reportVisibility('b', 0.8);
    expect(a.pauseCount, 1);
    expect(b.playCount, 1);

    hub.reportVisibility('b', 0.2);
    expect(b.pauseCount, 1);
  });

  test('requestUserPlay pauses the active video', () {
    final hub = ActivityVideoPlaybackHub();
    final a = _FakeDelegate('a');
    final b = _FakeDelegate('b');
    hub.register('a', a);
    hub.register('b', b);

    hub.reportVisibility('a', 0.7);
    hub.requestUserPlay('b');

    expect(a.pauseCount, 1);
    expect(b.playCount, 1);
  });
}
