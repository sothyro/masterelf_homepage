import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/academy/academy_screen.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'test_helpers/pump_app.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  Future<void> pumpMethodPage(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 3200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 3200)),
          child: const SingleChildScrollView(
            child: AcademyScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    assertNoLayoutOverflow(tester);
  }

  Future<void> disposeMethodPage(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 7));
  }

  for (final width in [375.0, 768.0, 1280.0]) {
    testWidgets('The Method page has no overflow at ${width.toInt()}px', (tester) async {
      await pumpMethodPage(tester, width: width);

      expect(find.text('The Method'), findsWidgets);
      expect(find.text('Why consultation comes first'), findsOneWidget);
      expect(find.text('Six pillars of consultation'), findsOneWidget);
      expect(find.text('What happens in a session'), findsOneWidget);
      expect(find.text('Book this consultation'), findsWidgets);
      expect(find.text('Academy'), findsNothing);
      expect(find.textContaining('More courses'), findsNothing);
      expect(find.textContaining('Mastery'), findsNothing);

      await disposeMethodPage(tester);
    });
  }
}
