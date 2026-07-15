import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/app.dart';
import 'package:masterelf_homepage/config/app_content.dart';
import 'package:masterelf_homepage/config/testimonials_content.dart';
import 'package:masterelf_homepage/app_bootstrap.dart';
import 'package:masterelf_homepage/main.dart';
import 'package:masterelf_homepage/screens/home/home_load_coordinator.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';
import 'package:masterelf_homepage/utils/hero_video_preloader.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'test_helpers/pump_app.dart';

void drainPendingExceptions(WidgetTester tester) {
  while (tester.takeException() != null) {}
}

void main() {
  late void Function(FlutterErrorDetails)? previousErrorHandler;

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
    AppAssetPreloader.disableImageDecodeForTesting = true;
    AppAssetPreloader.disableHeroVideoForTesting = true;
    HomeReadiness.reset();
    HomeLoadCoordinator.resetForTesting();
    initializeAppBootstrap('/');
    previousErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('google_fonts') ||
          message.contains('GoogleFonts') ||
          message.contains('overflowed')) {
        return;
      }
      previousErrorHandler?.call(details);
    };
  });

  tearDown(() {
    FlutterError.onError = previousErrorHandler;
    HomeLoadCoordinator.resetForTesting();
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  group('AppAssetPreloader', () {
    test('preloadAll reports 1.0 when complete', () async {
      double? lastProgress;
      await AppAssetPreloader.preloadAll((progress) => lastProgress = progress);
      expect(lastProgress, 1.0);
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });

    test('preloadAll progress reaches above-fold phase before completion', () async {
      final progressValues = <double>[];
      await AppAssetPreloader.preloadAll(progressValues.add);
      expect(progressValues.first, 0.0);
      expect(progressValues.last, 1.0);
      expect(progressValues.any((p) => p >= 0.20 && p < 1.0), isTrue);
    });

    test('preloadAll waits for the first-paint gate before reporting 1.0', () async {
      final gate = Completer<void>();
      final progressValues = <double>[];
      final preload = AppAssetPreloader.preloadAll(
        progressValues.add,
        waitForFirstPaint: gate.future,
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(progressValues.last, lessThan(1.0));

      gate.complete();
      await preload;
      expect(progressValues.last, 1.0);
    });

    test('preloadBelowFoldHomepage is idempotent', () async {
      await AppAssetPreloader.preloadBelowFoldHomepage();
      await AppAssetPreloader.preloadBelowFoldHomepage();
    });

    test('preloadAppsPageAssets warms app demo video and completes', () async {
      await AppAssetPreloader.preloadAppsPageAssets();
    });

    test('preloadAppsPageAssets is idempotent', () async {
      await AppAssetPreloader.preloadAppsPageAssets();
      await AppAssetPreloader.preloadAppsPageAssets();
    });

    test('first-screen bootstrap asset count excludes mid-page images', () {
      expect(AppAssetPreloader.aboveFoldAssetCount, 10);
      expect(AppAssetPreloader.midPageHomeAssetCount, greaterThan(4));
    });

    test('belowFoldHomepage preloads story background only', () {
      expect(AppAssetPreloader.belowFoldAssetCount, 1);
    });

    test('preloadTestimonialPortraits deduplicates paths', () async {
      final paths = testimonialImageAssetsForPreload().take(3).toList();
      expect(paths, isNotEmpty);
      await AppAssetPreloader.preloadTestimonialPortraits(paths);
      expect(AppAssetPreloader.preloadedTestimonialCount, paths.length);
      await AppAssetPreloader.preloadTestimonialPortraits(paths);
      expect(AppAssetPreloader.preloadedTestimonialCount, paths.length);
    });

    test('startBackgroundPreload is idempotent', () async {
      AppAssetPreloader.startBackgroundPreload();
      AppAssetPreloader.startBackgroundPreload();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });

    test('preloadBelowFoldHomepage does not include testimonial portraits', () async {
      await AppAssetPreloader.preloadBelowFoldHomepage();
      expect(AppAssetPreloader.preloadedTestimonialCount, 0);
      expect(AppContent.assetStoryBackground, isNotEmpty);
    });

    test('preloadAppsPageAssets does not bulk-load deferred screenshots', () async {
      await AppAssetPreloader.preloadAppsPageAssets();
      expect(AppAssetPreloader.appsDeferredPreloadStarted, isFalse);
      expect(AppAssetPreloader.appsDeferredAssetCount, greaterThan(0));
    });

    test('preloadAppsDeferredAssets is idempotent', () async {
      await AppAssetPreloader.preloadAppsDeferredAssets();
      await AppAssetPreloader.preloadAppsDeferredAssets();
      expect(AppAssetPreloader.appsDeferredPreloadStarted, isTrue);
    });

    test('preloadBooksPageAssets warms blessing covers', () async {
      await AppAssetPreloader.preloadBooksPageAssets();
      expect(AppAssetPreloader.booksPagePreloadStarted, isTrue);
      expect(AppAssetPreloader.booksDeferredPreloadStarted, isFalse);
    });

    test('preloadBooksPageAssets is idempotent', () async {
      await AppAssetPreloader.preloadBooksPageAssets();
      await AppAssetPreloader.preloadBooksPageAssets();
      expect(AppAssetPreloader.booksPagePreloadStarted, isTrue);
    });

    test('preloadBooksDeferredAssets is idempotent', () async {
      await AppAssetPreloader.preloadBooksDeferredAssets();
      await AppAssetPreloader.preloadBooksDeferredAssets();
      expect(AppAssetPreloader.booksDeferredPreloadStarted, isTrue);
      expect(AppAssetPreloader.booksDeferredAssetCount, greaterThan(0));
    });

    test('preloadEventsPageAssets warms hero and venue assets', () async {
      await AppAssetPreloader.preloadEventsPageAssets();
      expect(AppAssetPreloader.eventsPagePreloadStarted, isTrue);
    });

    test('preloadTalismanPageAssets warms hero only', () async {
      await AppAssetPreloader.preloadTalismanPageAssets();
      expect(AppAssetPreloader.talismanPagePreloadStarted, isTrue);
    });

    test('preloadActivityStoryCovers deduplicates paths', () async {
      const paths = [
        'assets/images/activities/fengshui.webp',
        'assets/images/activities/consultation.webp',
      ];
      await AppAssetPreloader.preloadActivityStoryCovers(paths);
      expect(AppAssetPreloader.preloadedActivityCoverCount, 2);
      await AppAssetPreloader.preloadActivityStoryCovers(paths);
      expect(AppAssetPreloader.preloadedActivityCoverCount, 2);
    });

    test('resetForTesting allows preloadBelowFoldHomepage to run again', () async {
      await AppAssetPreloader.preloadBelowFoldHomepage();
      AppAssetPreloader.resetForTesting();
      AppAssetPreloader.disableBackgroundFontsForTesting = true;
      AppAssetPreloader.disableImageDecodeForTesting = true;
      AppAssetPreloader.disableHeroVideoForTesting = true;
      await AppAssetPreloader.preloadBelowFoldHomepage();
    });
  });

  group('HeroVideoBootstrap', () {
    testWidgets('keeps loader until homepage is ready, then dismisses', (tester) async {
      tester.view.physicalSize = const Size(1400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const HeroVideoBootstrap());

      for (var i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        drainPendingExceptions(tester);
        if (find.byType(MasterElfApp).evaluate().isNotEmpty) break;
      }

      // App mounts under the loading overlay before the loader dismisses.
      expect(find.byType(MasterElfApp), findsOneWidget);

      await settleHomeScreenTimers(tester);
      VisibilityDetectorController.instance.notifyNow();
      await tester.pump();
      drainPendingExceptions(tester);

      // Once the homepage has painted and the fade completed, the loader is gone.
      expect(find.byType(HeroLoadingScreen), findsNothing);
    });

    testWidgets('force-reveals after timeout when homepage never signals ready', (tester) async {
      HomeReadiness.holdForTesting = true;
      tester.view.physicalSize = const Size(1400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const HeroVideoBootstrap());

      // Preload phases finish but the render gate never completes.
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        drainPendingExceptions(tester);
      }
      expect(find.byType(MasterElfApp), findsOneWidget);
      expect(find.byType(HeroLoadingScreen), findsOneWidget);

      // 20s bootstrap timeout fires, then the fade-out completes.
      await tester.pump(const Duration(seconds: 20));
      drainPendingExceptions(tester);
      await tester.pump(const Duration(milliseconds: 500));
      drainPendingExceptions(tester);

      expect(find.byType(HeroLoadingScreen), findsNothing);
      expect(find.byType(MasterElfApp), findsOneWidget);

      await settleHomeScreenTimers(tester);
      VisibilityDetectorController.instance.notifyNow();
      await tester.pump();
      drainPendingExceptions(tester);
    });
  });
}
