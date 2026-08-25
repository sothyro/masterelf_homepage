import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/home/widgets/events_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/widgets/majestic_orbital_card_frame.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpEventsSection(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 1800)),
          child: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SingleChildScrollView(
              child: SizedBox(
                width: width,
                child: const EventsSection(),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('EventsSection shows lite featured card on mobile', (tester) async {
    await pumpEventsSection(tester, width: 375);
    expect(tester.takeException(), isNull);
    expect(find.text('Coming Up Next'), findsOneWidget);
    expect(
      find.text('Master Elf — Strive for the Year of the Blood Goat 2027'),
      findsOneWidget,
    );
    expect(find.byType(MajesticOrbitalCardFrame), findsNothing);
    expect(find.byType(Image), findsWidgets);
    expect(find.text('Explore All Events'), findsOneWidget);
    expect(find.text('All Upcoming Events'), findsNothing);
  });

  testWidgets('EventsSection has no overflow at narrow width', (tester) async {
    await pumpEventsSection(tester, width: 700);
    expect(tester.takeException(), isNull);
    expect(find.byType(EventsSection), findsOneWidget);
  });

  testWidgets('EventsSection shows lite featured and completed sidebar on desktop', (
    tester,
  ) async {
    await pumpEventsSection(tester, width: 1280);
    // Desktop sidebar mounts after settle fallback (2s) or scroll idle.
    await tester.pump(const Duration(milliseconds: 2100));
    expect(tester.takeException(), isNull);
    expect(find.text('Coming Up Next'), findsOneWidget);
    expect(find.text('All Upcoming Events'), findsOneWidget);
    expect(
      find.text('Master Elf — Strive for the Year of the Blood Goat 2027'),
      findsOneWidget,
    );
    expect(find.text('Master Elf — The Rise of the Phoenix 2026'), findsOneWidget);
    expect(find.byType(MajesticOrbitalCardFrame), findsNothing);
  });
}
