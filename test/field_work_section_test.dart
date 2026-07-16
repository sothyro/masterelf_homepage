import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/home/widgets/field_work_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';

void main() {
  Future<void> pumpFieldWorkSection(
    WidgetTester tester, {
    required double width,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 1600)),
          child: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SingleChildScrollView(
              child: SizedBox(
                width: width,
                child: const FieldWorkSection(),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('FieldWorkSection shows all four pillars at mobile width', (tester) async {
    await pumpFieldWorkSection(tester, width: 375);
    expect(tester.takeException(), isNull);
    expect(find.text("Unlock Your Property's Qi"), findsOneWidget);
    expect(find.text("Clarity for Life's Biggest Calls"), findsOneWidget);
    expect(find.text('Protection You Can Feel at Home'), findsOneWidget);
    expect(find.text('Choose the Day Destiny Favours'), findsOneWidget);
  });

  testWidgets('FieldWorkSection has no overflow at tablet width', (tester) async {
    await pumpFieldWorkSection(tester, width: 768);
    expect(tester.takeException(), isNull);
    expect(find.byType(FieldWorkSection), findsOneWidget);
    expect(find.text('Choose the Day Destiny Favours'), findsOneWidget);
  });

  testWidgets('FieldWorkSection has no overflow at desktop width', (tester) async {
    await pumpFieldWorkSection(tester, width: 1280);
    expect(tester.takeException(), isNull);
    expect(find.byType(FieldWorkSection), findsOneWidget);
    expect(find.text("Unlock Your Property's Qi"), findsOneWidget);
  });
}
