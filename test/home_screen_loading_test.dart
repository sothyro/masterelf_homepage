import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/app_bootstrap.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/home/home_load_coordinator.dart';
import 'package:masterelf_homepage/screens/home/home_screen.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';
import 'package:masterelf_homepage/screens/home/widgets/academies_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/consultations_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/events_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/field_work_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/hero_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/story_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/testimonials_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';
import 'package:masterelf_homepage/widgets/viewport_deferred_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    HomeReadiness.reset();
    HomeLoadCoordinator.resetForTesting();
    ScrollActivityGate.resetForTesting();
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
    HomeLoadCoordinator.resetForTesting();
    ScrollActivityGate.resetForTesting();
  });

  void drainExceptions(WidgetTester tester) {
    while (tester.takeException() != null) {}
  }

  Future<void> settleHomeTimers(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 1600));
    drainExceptions(tester);
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 3));
    drainExceptions(tester);
    HomeLoadCoordinator.resetForTesting();
    ScrollActivityGate.resetForTesting();
  }

  Future<void> pumpHomeScreen(
    WidgetTester tester, {
    required double width,
    double height = 3200,
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
    await tester.pump(const Duration(milliseconds: 100));
    drainExceptions(tester);
  }

  void expectCriticalSectionsPresent() {
    expect(find.byType(HeroSection), findsOneWidget);
    expect(find.byType(EventsSection), findsOneWidget);
  }

  testWidgets('HomeScreen mounts critical sections first at mobile width', (
    tester,
  ) async {
    await pumpHomeScreen(tester, width: 375, height: 700);

    expectCriticalSectionsPresent();
    expect(find.byType(AcademiesSection), findsNothing);
    expect(find.byType(ConsultationsSection), findsNothing);
    expect(find.byType(TestimonialsSection), findsNothing);
    expect(find.byType(ViewportDeferredSection), findsWidgets);
    expect(
      find.byKey(const ValueKey<String>('viewport-deferred-home-academies')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('viewport-deferred-home-consultations')),
      findsOneWidget,
    );

    await settleHomeTimers(tester);
  });

  testWidgets('HomeScreen keeps deferred placeholders before scroll', (
    tester,
  ) async {
    await pumpHomeScreen(tester, width: 1280, height: 800);

    expectCriticalSectionsPresent();
    expect(find.byType(AcademiesSection), findsNothing);
    expect(find.byType(ConsultationsSection), findsNothing);
    expect(
      find.byKey(const ValueKey<String>('viewport-deferred-home-academies')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('viewport-deferred-home-testimonials')),
      findsOneWidget,
    );
    expect(find.byType(TestimonialsSection), findsNothing);

    await settleHomeTimers(tester);
  });

  testWidgets('HomeReadiness completes after critical sections only', (
    tester,
  ) async {
    await pumpHomeScreen(tester, width: 1280, height: 1000);

    await tester.pump();
    await tester.pump();
    drainExceptions(tester);

    expect(HomeReadiness.isReady, isTrue);
    expect(find.byType(FieldWorkSection), findsNothing);

    await settleHomeTimers(tester);
  });

  testWidgets('HomeIdleMount does not mount mid-page sections during active scroll', (
    tester,
  ) async {
    await pumpHomeScreen(tester, width: 1280, height: 4000);

    await tester.pump();
    await tester.pump();
    expect(HomeReadiness.isReady, isTrue);
    expect(find.byType(FieldWorkSection), findsNothing);

    ScrollActivityGate.onScrollOffset(10);
    for (var i = 0; i < 10; i++) {
      ScrollActivityGate.onScrollOffset(20.0 + i * 10);
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.byType(FieldWorkSection), findsNothing);
    expect(find.byType(StorySection), findsNothing);

    await tester.pump(ScrollActivityGate.idleDelay);
    await tester.pump();
    expect(find.byType(FieldWorkSection), findsNothing);

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(find.byType(FieldWorkSection), findsOneWidget);
    expect(find.byType(StorySection), findsOneWidget);
    HomeLoadCoordinator.resetForTesting();
  });

  testWidgets('HomeScreen unmount during settle completes HomeReadiness', (
    tester,
  ) async {
    HomeReadiness.reset();
    await pumpHomeScreen(tester, width: 1280, height: 1000);
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();
    expect(HomeReadiness.isReady, isTrue);
    HomeLoadCoordinator.resetForTesting();
  });
}
