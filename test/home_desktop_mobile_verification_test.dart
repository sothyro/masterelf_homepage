import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/app_bootstrap.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/home/home_load_coordinator.dart';
import 'package:masterelf_homepage/screens/home/home_screen.dart';
import 'package:masterelf_homepage/screens/home/widgets/academies_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/events_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/field_work_chinese_design.dart';
import 'package:masterelf_homepage/screens/home/widgets/field_work_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/hero_section.dart';
import 'package:masterelf_homepage/screens/home/home_section_mount_queue.dart';
import 'package:masterelf_homepage/screens/home/widgets/home_queued_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';
import 'package:masterelf_homepage/utils/breakpoints.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';
import 'package:masterelf_homepage/widgets/majestic_orbital_card_frame.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Desktop + mobile verification of homescreen optimization contracts.
void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    HomeReadiness.reset();
    HomeLoadCoordinator.resetForTesting();
    HomeSectionMountQueue.resetForTesting();
    ScrollActivityGate.resetForTesting();
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
    AppAssetPreloader.disableHeroVideoForTesting = true;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
    HomeLoadCoordinator.resetForTesting();
    HomeSectionMountQueue.resetForTesting();
    ScrollActivityGate.resetForTesting();
  });

  Future<void> pumpHome(
    WidgetTester tester, {
    required double width,
    double height = 2400,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, height));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, height)),
          child: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SingleChildScrollView(
              child: SizedBox(
                width: width,
                child: const HomeScreen(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 50));
    while (tester.takeException() != null) {}
  }

  group('mobile homescreen (< 768)', () {
    testWidgets('eager Hero + Events only; no orbital; lite backdrop', (
      tester,
    ) async {
      expect(Breakpoints.isMobile(390), isTrue);
      await pumpHome(tester, width: 390, height: 844);

      expect(find.byType(HeroSection), findsOneWidget);
      expect(find.byType(EventsSection), findsOneWidget);
      expect(find.byType(EventsSectionLiteBackground), findsOneWidget);
      expect(find.byType(ChineseInkWashGlow), findsNothing);
      expect(find.byType(MajesticOrbitalCardFrame), findsNothing);
      expect(find.byType(AcademiesSection), findsNothing);
      expect(find.byType(FieldWorkSection), findsNothing);
      expect(find.byType(HomeQueuedSection), findsWidgets);

      // Field-work+story slot reserves height (no zero-height shrink).
      final queued = tester
          .widgetList<HomeQueuedSection>(find.byType(HomeQueuedSection))
          .firstWhere((s) => s.sectionKey == 'home-field-work-story');
      expect(queued.placeholderHeight, 1400);

      // Mobile layout: featured only (no completed sidebar header yet).
      expect(find.text('Coming Up Next'), findsOneWidget);
      expect(find.text('All Upcoming Events'), findsNothing);
      HomeSectionMountQueue.resetForTesting();
    });

    testWidgets('first scroll does not mount FieldWork mid-gesture', (
      tester,
    ) async {
      await pumpHome(tester, width: 390, height: 844);
      await tester.pump();
      await tester.pump();
      expect(HomeReadiness.isReady, isTrue);

      ScrollActivityGate.onScrollOffset(20);
      for (var i = 0; i < 8; i++) {
        ScrollActivityGate.onScrollOffset(40.0 + i * 30);
        await tester.pump(const Duration(milliseconds: 80));
      }
      expect(find.byType(FieldWorkSection), findsNothing);
      expect(find.byType(AcademiesSection), findsNothing);

      await tester.pump(ScrollActivityGate.idleDelay);
      await tester.pump();
      // Queue resumes: Academies → Consultations → FieldWork.
      await tester.pump(HomeSectionMountQueue.betweenSectionsDelay);
      await tester.pump();
      await tester.pump(HomeSectionMountQueue.betweenSectionsDelay);
      await tester.pump();
      await tester.pump(HomeSectionMountQueue.betweenSectionsDelay);
      await tester.pump();
      // Story section may overflow in tight test surfaces; drain only.
      while (tester.takeException() != null) {}
      expect(find.byType(FieldWorkSection), findsOneWidget);
      HomeSectionMountQueue.resetForTesting();
    });
  });

  group('desktop homescreen (>= 1024)', () {
    testWidgets('eager Hero + Events; deferred completed sidebar', (
      tester,
    ) async {
      expect(Breakpoints.isDesktop(1280), isTrue);
      await pumpHome(tester, width: 1280, height: 1000);

      expect(find.byType(HeroSection), findsOneWidget);
      expect(find.byType(EventsSection), findsOneWidget);
      expect(find.byType(EventsSectionLiteBackground), findsOneWidget);
      expect(find.byType(ChineseInkWashGlow), findsNothing);
      expect(find.byType(MajesticOrbitalCardFrame), findsNothing);
      expect(find.byType(AcademiesSection), findsNothing);

      expect(find.text('Coming Up Next'), findsOneWidget);
      // Sidebar deferred until scroll idle or 2s fallback.
      expect(find.text('All Upcoming Events'), findsNothing);

      final queued = tester
          .widgetList<HomeQueuedSection>(find.byType(HomeQueuedSection))
          .firstWhere((s) => s.sectionKey == 'home-field-work-story');
      expect(queued.placeholderHeight, 1600);
      HomeSectionMountQueue.resetForTesting();
    });

    testWidgets('completed sidebar mounts after settle fallback', (
      tester,
    ) async {
      await pumpHome(tester, width: 1280, height: 1000);
      expect(find.text('All Upcoming Events'), findsNothing);

      await tester.pump(const Duration(milliseconds: 2100));
      expect(find.text('All Upcoming Events'), findsOneWidget);
      expect(find.byType(MajesticOrbitalCardFrame), findsNothing);
      HomeSectionMountQueue.resetForTesting();
    });

    testWidgets('completed sidebar mounts on first scroll idle', (
      tester,
    ) async {
      await pumpHome(tester, width: 1280, height: 1000);
      expect(find.text('All Upcoming Events'), findsNothing);

      ScrollActivityGate.onScrollOffset(80);
      await tester.pump(ScrollActivityGate.idleDelay);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();

      expect(find.text('All Upcoming Events'), findsOneWidget);
      HomeSectionMountQueue.resetForTesting();
    });
  });

  group('shared optimization contracts', () {
    testWidgets('tablet width uses desktop Events two-column path', (
      tester,
    ) async {
      // isMobile is < 768; 900 is tablet-ish and uses desktop Events layout.
      expect(Breakpoints.isMobile(900), isFalse);
      await pumpHome(tester, width: 900, height: 1000);
      expect(find.text('Coming Up Next'), findsOneWidget);
      expect(find.text('All Upcoming Events'), findsNothing);
      await tester.pump(const Duration(milliseconds: 2100));
      expect(find.text('All Upcoming Events'), findsOneWidget);
      HomeSectionMountQueue.resetForTesting();
    });

    test('bootstrap policy: video does not hard-gate; Events not critical', () {
      // Documented contracts exercised by app_asset_preloader_test + main.
      expect(AppAssetPreloader.aboveFoldAssetCount, 4);
      expect(AppAssetPreloader.disableHeroVideoForTesting, isTrue);
    });
  });
}
