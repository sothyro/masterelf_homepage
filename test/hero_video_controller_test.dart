import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/services/hero_video_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HeroVideoController.resetForTesting();
    HeroVideoController.prewarmOverrideForTesting = Future.value(false);
  });

  tearDown(HeroVideoController.resetForTesting);

  test('prewarm is idempotent: repeat calls share one future', () {
    final first = HeroVideoController.prewarm();
    final second = HeroVideoController.prewarm();
    expect(identical(first, second), isTrue);
  });

  test('prewarm reports failure when override returns false', () async {
    expect(await HeroVideoController.prewarm(), isFalse);
    expect(HeroVideoController.isReady, isFalse);
    expect(HeroVideoController.controller, isNull);
  });

  test('pause and resume are safe with no controller', () async {
    await HeroVideoController.pause();
    await HeroVideoController.resume();
  });

  test('resetPrewarmAttempt allows a fresh prewarm attempt after failure', () async {
    await HeroVideoController.prewarm();
    HeroVideoController.resetPrewarmAttempt();
    final first = HeroVideoController.prewarm();
    final second = HeroVideoController.prewarm();
    expect(identical(first, second), isTrue);
  });

  test('resetForTesting clears state for a fresh prewarm attempt', () async {
    await HeroVideoController.prewarm();
    HeroVideoController.resetForTesting();
    HeroVideoController.prewarmOverrideForTesting = Future.value(false);
    expect(await HeroVideoController.prewarm(), isFalse);
  });
}
