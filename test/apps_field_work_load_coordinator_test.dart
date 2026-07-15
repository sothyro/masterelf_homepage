import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/screens/apps/apps_load_coordinator.dart';
import 'package:masterelf_homepage/screens/field_work/field_work_load_coordinator.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';

void main() {
  setUp(() {
    AppsLoadCoordinator.resetForTesting();
    FieldWorkLoadCoordinator.resetForTesting();
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
  });

  group('AppsLoadCoordinator', () {
    test('does not start background preload before arm', () {
      AppsLoadCoordinator.onAppsScroll(pixels: 500, maxScrollExtent: 1000);
      expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
    });

    test('starts background preload after scroll threshold when armed', () {
      AppsLoadCoordinator.armAfterReveal();
      AppsLoadCoordinator.onAppsScroll(pixels: 300, maxScrollExtent: 1000);
      expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
    });

    test('idle fallback triggers after arm', () async {
      AppsLoadCoordinator.armAfterReveal();
      expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
      await Future<void>.delayed(AppsLoadCoordinator.idleFallback);
      expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
    });
  });

  group('FieldWorkLoadCoordinator', () {
    test('does not start background preload before arm', () {
      FieldWorkLoadCoordinator.onFieldWorkScroll(
        pixels: 500,
        maxScrollExtent: 1000,
      );
      expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
    });

    test('starts background preload after scroll threshold when armed', () {
      FieldWorkLoadCoordinator.armAfterReveal(layoutWidth: 1280);
      FieldWorkLoadCoordinator.onFieldWorkScroll(
        pixels: 300,
        maxScrollExtent: 1000,
      );
      expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
    });

    test('idle fallback triggers after arm', () async {
      FieldWorkLoadCoordinator.armAfterReveal(layoutWidth: 1280);
      expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
      await Future<void>.delayed(FieldWorkLoadCoordinator.idleFallback);
      expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
    });
  });
}
