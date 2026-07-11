import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/app.dart';
import 'package:masterelf_homepage/app_bootstrap.dart';
import 'package:masterelf_homepage/main.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';
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
      expect(progressValues.any((p) => p >= 0.25 && p < 1.0), isTrue);
    });

    test('preloadBelowFoldHomepage is idempotent', () async {
      await AppAssetPreloader.preloadBelowFoldHomepage();
      await AppAssetPreloader.preloadBelowFoldHomepage();
    });

    test('resetForTesting allows preloadBelowFoldHomepage to run again', () async {
      await AppAssetPreloader.preloadBelowFoldHomepage();
      AppAssetPreloader.resetForTesting();
      AppAssetPreloader.disableBackgroundFontsForTesting = true;
      AppAssetPreloader.disableImageDecodeForTesting = true;
      await AppAssetPreloader.preloadBelowFoldHomepage();
    });
  });

  group('HeroVideoBootstrap', () {
    testWidgets('transitions to MasterElfApp after preload', (tester) async {
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

      expect(find.byType(MasterElfApp), findsOneWidget);

      await settleHomeScreenTimers(tester);
      VisibilityDetectorController.instance.notifyNow();
      await tester.pump();
      drainPendingExceptions(tester);
    });
  });
}
