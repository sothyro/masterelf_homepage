import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/field_work/field_work_screen.dart';
import 'package:masterelf_homepage/screens/field_work/widgets/activity_spotlight_section.dart';
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
  }

  testWidgets('FieldWorkScreen shows video spotlights and stories at desktop width', (tester) async {
    await pumpFieldWorkHub(tester, width: 1280);
    expect(tester.takeException(), isNull);
    expect(find.byType(ActivitySpotlightSection), findsOneWidget);
    expect(find.text('Watch real work in action'), findsOneWidget);
    expect(find.byType(ActivityStoriesSection), findsOneWidget);
    expect(find.text('Our core activities'), findsOneWidget);
    expect(find.text('Feng Shui site visit'), findsOneWidget);
    expect(find.text('BaZi, Qi Men & I Ching consultations'), findsOneWidget);
    expect(find.text('Mao Shan home blessing'), findsOneWidget);
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
