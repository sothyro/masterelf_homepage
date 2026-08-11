import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/field_work/field_work_screen.dart';
import 'package:masterelf_homepage/screens/field_work/widgets/activity_spotlight_section.dart';
import 'package:masterelf_homepage/screens/field_work/widgets/activity_stories_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/screens/field_work/field_work_load_coordinator.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
    FieldWorkLoadCoordinator.resetForTesting();
    ScrollActivityGate.resetForTesting();
  });

  Future<void> revealFieldWorkDeferredSections(WidgetTester tester) async {
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isEmpty) return;

    await tester.dragUntilVisible(
      find.byType(ActivitySpotlightSection),
      scrollable.first,
      const Offset(0, -120),
    );
    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump();

    await tester.dragUntilVisible(
      find.byType(ActivityStoriesSection),
      scrollable.first,
      const Offset(0, -120),
    );
    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(ScrollActivityGate.idleDelay);
    await tester.pump(const Duration(seconds: 7));
    ScrollActivityGate.resetForTesting();
  }

  Future<void> pumpFieldWorkHub(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 2400)),
          child: const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SingleChildScrollView(
              child: FieldWorkScreen(),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    FieldWorkLoadCoordinator.resetForTesting();
  }

  testWidgets('FieldWorkScreen shows video spotlights and stories at desktop width', (tester) async {
    await pumpFieldWorkHub(tester, width: 1280);
    await revealFieldWorkDeferredSections(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(ActivitySpotlightSection), findsOneWidget);
    expect(find.text('Watch real work in action'), findsOneWidget);
    expect(
      find.text(
        'Six moments from the field—consultations, rituals, and site visits as they happen.',
      ),
      findsOneWidget,
    );
    expect(find.text('Book a face-to-face consultation'), findsWidgets);
    expect(find.text('Ready for your own session?'), findsOneWidget);
    expect(find.byType(ActivityStoriesSection), findsOneWidget);
    expect(find.text('Our core activities'), findsOneWidget);
    expect(find.text('Unlock Your Property\'s Qi'), findsOneWidget);
    expect(find.text('Clarity for Life\'s Biggest Calls'), findsOneWidget);
    expect(find.text('Protection You Can Feel at Home'), findsOneWidget);
    expect(find.byIcon(LucideIcons.chevronLeft), findsWidgets);
    expect(find.byIcon(LucideIcons.chevronRight), findsWidgets);
    expect(find.textContaining('documented in photos'), findsOneWidget);
  });

  testWidgets('FieldWorkScreen has no overflow at mobile width', (tester) async {
    await pumpFieldWorkHub(tester, width: 375);
    expect(tester.takeException(), isNull);
    expect(find.byType(FieldWorkScreen), findsOneWidget);
  });
}
