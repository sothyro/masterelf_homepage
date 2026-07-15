import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/screens/home/home_load_coordinator.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';

void main() {
  setUp(() {
    HomeLoadCoordinator.resetForTesting();
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
  });

  test('does not start background preload before arm', () {
    HomeLoadCoordinator.onHomeScroll(pixels: 500, maxScrollExtent: 1000);
    expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
  });

  test('starts background preload after scroll threshold when armed', () {
    HomeLoadCoordinator.armAfterReveal();
    HomeLoadCoordinator.onHomeScroll(pixels: 300, maxScrollExtent: 1000);
    expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
  });

  test('idle fallback triggers after arm', () async {
    HomeLoadCoordinator.armAfterReveal();
    expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
    await Future<void>.delayed(HomeLoadCoordinator.idleFallback);
    expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
  });
}
