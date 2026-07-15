import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/field_work_content.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/field_work/widgets/activity_stories_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/utils/mobile_web_performance.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  Future<void> pumpActivityStoriesSection(
    WidgetTester tester, {
    required double width,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 2400)),
          child: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SingleChildScrollView(
              child: SizedBox(
                width: width,
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    final pillars = buildFieldWorkCoreActivities(l10n, 'en');
                    return ActivityStoriesSection(
                      l10n: l10n,
                      pillars: pillars,
                      preloadOwnerKey: 'test-activity-stories',
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> disposeActivityStoriesSection(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 7));
  }

  testWidgets('ActivityStoriesSection has no overflow at mobile width', (tester) async {
    await pumpActivityStoriesSection(tester, width: 375);
    expect(find.byType(ActivityStoriesSection), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
    await disposeActivityStoriesSection(tester);
  });

  testWidgets('ActivityStoriesSection has no overflow at desktop width', (tester) async {
    await pumpActivityStoriesSection(tester, width: 1280);
    expect(tester.takeException(), isNull);
    expect(find.byType(ActivityStoriesSection), findsOneWidget);
    await disposeActivityStoriesSection(tester);
  });

  testWidgets('ActivityStoriesSection allows auto-loop at mobile width', (
    tester,
  ) async {
    await pumpActivityStoriesSection(tester, width: 375);
    expect(
      MobileWebPerformance.prefersReducedMotion(
        tester.element(find.byType(ActivityStoriesSection)),
      ),
      isFalse,
    );
    await disposeActivityStoriesSection(tester);
  });

  testWidgets('ActivityStoriesSection does not auto-advance when animations disabled', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(375, 2400),
            disableAnimations: true,
          ),
          child: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SingleChildScrollView(
              child: SizedBox(
                width: 375,
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    final pillars = buildFieldWorkCoreActivities(l10n, 'en');
                    expect(
                      MobileWebPerformance.prefersReducedMotion(context),
                      isTrue,
                    );
                    return ActivityStoriesSection(
                      l10n: l10n,
                      pillars: pillars,
                      preloadOwnerKey: 'test-activity-stories-reduced',
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(ActivityStoriesSection), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);

    await disposeActivityStoriesSection(tester);
  });
}
