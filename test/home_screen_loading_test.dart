import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/home/home_screen.dart';
import 'package:masterelf_homepage/screens/home/widgets/academies_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/consultations_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/cta_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/events_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/field_work_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/featured_in_consultation_band.dart';
import 'package:masterelf_homepage/screens/home/widgets/hero_section.dart';
import 'package:masterelf_homepage/screens/home/widgets/story_section.dart';
import 'package:masterelf_homepage/screens/field_work/widgets/activity_stories_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  void drainExceptions(WidgetTester tester) {
    while (tester.takeException() != null) {}
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

  /// Progressive reveal: 100ms start + 220ms per section (8 total).
  Future<void> pumpUntilAllSectionsLoaded(WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump();
    drainExceptions(tester);
  }

  void expectAllBelowFoldSectionsPresent() {
    expect(find.byType(EventsSection), findsOneWidget);
    expect(find.byType(AcademiesSection), findsOneWidget);
    expect(find.byType(ConsultationsSection), findsOneWidget);
    expect(find.byType(FieldWorkSection), findsOneWidget);
    expect(find.byType(StorySection), findsOneWidget);
    expect(find.byType(FeaturedInConsultationBand), findsOneWidget);
    expect(find.byType(ActivityStoriesSection), findsOneWidget);
    expect(find.byType(CtaSection), findsOneWidget);
  }

  testWidgets('HomeScreen has no Optimising view overlay at mobile width', (tester) async {
    await pumpHomeScreen(tester, width: 375);
    await pumpUntilAllSectionsLoaded(tester);

    expect(find.textContaining('Optimising view'), findsNothing);
    expect(find.byType(HeroSection), findsOneWidget);
    expect(find.byType(EventsSection), findsOneWidget);
  });

  testWidgets('HomeScreen has no Optimising view overlay at desktop width', (tester) async {
    await pumpHomeScreen(tester, width: 1280);
    await pumpUntilAllSectionsLoaded(tester);

    expect(find.textContaining('Optimising view'), findsNothing);
    expect(find.byType(HeroSection), findsOneWidget);
    expect(find.byType(EventsSection), findsOneWidget);
  });

  testWidgets('HomeScreen mounts above-fold sections immediately', (tester) async {
    await pumpHomeScreen(tester, width: 1280, height: 900);

    expect(find.byType(EventsSection), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    drainExceptions(tester);
    expect(find.byType(AcademiesSection), findsOneWidget);
    expect(find.byType(ConsultationsSection), findsOneWidget);

    await pumpUntilAllSectionsLoaded(tester);
  });

  testWidgets('HomeScreen prefetch chain mounts consultations without scroll', (tester) async {
    await pumpHomeScreen(tester, width: 1280, height: 3200);

    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump();
    drainExceptions(tester);

    expect(find.byType(ConsultationsSection), findsOneWidget);

    await pumpUntilAllSectionsLoaded(tester);
  });

  testWidgets('HomeScreen mounts all sections after fallback timer', (tester) async {
    await pumpHomeScreen(tester, width: 1280, height: 1000);

    await pumpUntilAllSectionsLoaded(tester);

    expect(find.textContaining('Optimising view'), findsNothing);
    expectAllBelowFoldSectionsPresent();
  });

  testWidgets('HomeScreen mounts remaining sections on scroll', (tester) async {
    await pumpHomeScreen(tester, width: 1280, height: 1000);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -4000));
    await pumpUntilAllSectionsLoaded(tester);

    expect(find.textContaining('Optimising view'), findsNothing);
    expectAllBelowFoldSectionsPresent();
  });
}
