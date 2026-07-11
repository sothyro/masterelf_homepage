import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/events/events_screen.dart';
import 'package:masterelf_homepage/screens/store/widgets/store_page_hero.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';

void main() {
  Future<void> pumpEventsScreen(WidgetTester tester, {required double width}) async {
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
            child: EventsScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('EventsScreen shows Phoenix completed and Goat 2027 register', (tester) async {
    await pumpEventsScreen(tester, width: 1280);

    expect(find.byType(EventsScreen), findsOneWidget);
    expect(find.byType(StorePageHero), findsOneWidget);
    expect(find.text('Where insight becomes experience'), findsOneWidget);
    expect(find.text('Recently Completed'), findsWidgets);
    expect(find.text('Master Elf - The Rise of Phoenix 2026'), findsOneWidget);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Online'), findsNWidgets(2));
    expect(
      find.text('Master Elf — Strive for the Year of the Blood Goat 2027'),
      findsWidgets,
    );
    expect(find.text('Upcoming'), findsWidgets);
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Explore the journey'), findsOneWidget);
    expect(find.byKey(const Key('events-venue-partners')), findsOneWidget);

    final upcomingY = tester.getTopLeft(find.text('Upcoming Spotlight')).dy;
    final completedY = tester.getTopLeft(find.text('Recently Completed')).dy;
    expect(upcomingY, lessThan(completedY));
  });

  testWidgets('EventsScreen layout works on mobile without overflow', (tester) async {
    await pumpEventsScreen(tester, width: 375);

    expect(tester.takeException(), isNull);
    expect(find.text('Where insight becomes experience'), findsOneWidget);
    expect(find.text('Master Elf - The Rise of Phoenix 2026'), findsOneWidget);
    expect(
      find.text('Master Elf — Strive for the Year of the Blood Goat 2027'),
      findsWidgets,
    );
    expect(find.text('Register'), findsOneWidget);
  });
}
