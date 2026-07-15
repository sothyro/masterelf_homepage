import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/journey/journey_screen.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';

import 'test_helpers/pump_app.dart';

void main() {
  Future<void> pumpJourneyScreen(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 3600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 3600)),
          child: const SingleChildScrollView(
            child: JourneyScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    assertNoLayoutOverflow(tester);
  }

  testWidgets('JourneyScreen shows editorial hero and consultation flow at 1280px', (tester) async {
    await pumpJourneyScreen(tester, width: 1280);

    expect(find.byType(JourneyScreen), findsOneWidget);
    expect(find.text('MY ENDEAVOUR'), findsOneWidget);
    expect(
      find.text('From a calling to clarity—Feng Shui and Chinese Metaphysics in practice.'),
      findsOneWidget,
    );
    expect(find.text('Read the story'), findsOneWidget);
    expect(find.text('Explore the method'), findsOneWidget);
    expect(find.text('The Story'), findsOneWidget);
    expect(find.text('The Method'), findsWidgets);
    expect(find.text('Explore The Method'), findsOneWidget);
    expect(find.text('Trusted by thousands'), findsOneWidget);
    expect(find.text('Ready to begin?'), findsOneWidget);
    expect(find.text('Book a face-to-face consultation'), findsOneWidget);
    expect(find.text('View all six consultations'), findsOneWidget);
    expect(
      find.text('See the method in practice — real site visits, rituals, and readings in the field.'),
      findsOneWidget,
    );
  });

  testWidgets('JourneyScreen layout works on mobile without overflow', (tester) async {
    await pumpJourneyScreen(tester, width: 375);

    expect(find.text('MY ENDEAVOUR'), findsOneWidget);
    expect(find.text('Read the story'), findsOneWidget);
    expect(find.text('Ready to begin?'), findsOneWidget);
  });
}
