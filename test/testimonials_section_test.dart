import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/home/widgets/testimonials_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';

void main() {
  Future<void> pumpTestimonialsSection(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 1200)),
          child: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SingleChildScrollView(
              child: SizedBox(
                width: width,
                child: const TestimonialsSection(),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> disposeTestimonialsSection(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 7));
  }

  testWidgets('TestimonialsSection has no overflow at mobile width', (tester) async {
    await pumpTestimonialsSection(tester, width: 375);
    expect(tester.takeException(), isNull);
    expect(find.byType(TestimonialsSection), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);

    // Cycle through pages to catch overflow on long quotes.
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 7));
      expect(tester.takeException(), isNull);
    }

    await disposeTestimonialsSection(tester);
  });

  testWidgets('TestimonialsSection has no overflow at desktop width', (tester) async {
    await pumpTestimonialsSection(tester, width: 1280);
    expect(tester.takeException(), isNull);
    expect(find.byType(TestimonialsSection), findsOneWidget);
    await disposeTestimonialsSection(tester);
  });
}
