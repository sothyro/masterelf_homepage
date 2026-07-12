import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/app_content.dart';
import 'package:masterelf_homepage/services/hero_video_platform.dart';
import 'package:masterelf_homepage/utils/breakpoints.dart';

void main() {
  setUp(HeroVideoPlatform.resetForTesting);

  tearDown(HeroVideoPlatform.resetForTesting);

  test('prewarm override returns configured result', () async {
    HeroVideoPlatform.prewarmOverrideForTesting = Future.value(false);
    expect(await HeroVideoPlatform.prewarm(), isFalse);
    expect(HeroVideoPlatform.isReady, isFalse);
  });

  test('mobile breakpoint selects 480p web path constant', () {
    expect(
      AppContent.webHeroVideo480,
      'videos/videobackground480.mp4',
    );
    expect(Breakpoints.isMobile(390), isTrue);
    expect(Breakpoints.isMobile(Breakpoints.mobile), isFalse);
  });
}
