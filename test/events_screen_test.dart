import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/events/events_load_coordinator.dart';
import 'package:masterelf_homepage/screens/events/events_screen.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'test_helpers/pump_app.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    EventsLoadCoordinator.resetForTesting();
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableImageDecodeForTesting = true;
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  Future<void> settleEventsTimers(WidgetTester tester) async {
    await tester.pump(EventsLoadCoordinator.idleFallback);
    await tester.pump(const Duration(seconds: 5));
  }

  Future<void> pumpEventsScreen(WidgetTester tester, {required double width}) async {
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
            child: EventsScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 100));
    assertNoLayoutOverflow(tester);
  }

  Future<void> revealDeferredEventsSections(WidgetTester tester) async {
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -2800));
    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('EventsScreen shows persuasive copy and register CTA at 1280px', (tester) async {
    await pumpEventsScreen(tester, width: 1280);
    await revealDeferredEventsSections(tester);

    expect(find.byType(EventsScreen), findsOneWidget);
    expect(find.text('Be in the room when the cycle turns.'), findsOneWidget);
    expect(find.text('Live revelation with Master Elf.'), findsOneWidget);
    expect(find.text('Reserve your seat'), findsWidgets);
    expect(find.text('See what\'s coming'), findsOneWidget);
    expect(find.text('Proof in the room'), findsOneWidget);
    expect(find.text('Why show up in person'), findsOneWidget);
    expect(find.text('Master Elf — The Rise of the Phoenix 2026'), findsOneWidget);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Online'), findsNWidgets(2));
    expect(
      find.text('Master Elf — Strive for the Year of the Blood Goat 2027'),
      findsWidgets,
    );
    expect(find.text('Upcoming'), findsWidgets);
    expect(find.text('Explore the journey'), findsWidgets);
    expect(find.text("Can't make the room?"), findsOneWidget);
    expect(
      find.text('Prefer a private session? Book a consultation'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('events-venue-partners')), findsOneWidget);
    expect(find.text('Where insight becomes experience'), findsNothing);

    final upcomingY = tester.getTopLeft(find.text("What's next")).dy;
    final completedY = tester.getTopLeft(find.text('Proof in the room')).dy;
    expect(upcomingY, lessThan(completedY));
    await settleEventsTimers(tester);
  });

  testWidgets('EventsScreen layout works on mobile without overflow', (tester) async {
    await pumpEventsScreen(tester, width: 375);

    expect(find.text('Be in the room when the cycle turns.'), findsOneWidget);
    expect(find.text('Live revelation with Master Elf.'), findsOneWidget);
    expect(find.text('Reserve your seat'), findsWidgets);
    expect(find.text('Master Elf — The Rise of the Phoenix 2026'), findsOneWidget);
    expect(
      find.text('Master Elf — Strive for the Year of the Blood Goat 2027'),
      findsWidgets,
    );
    await settleEventsTimers(tester);
  });

  testWidgets('EventsScreen has no overflow at tablet width', (tester) async {
    await pumpEventsScreen(tester, width: 768);
    expect(tester.takeException(), isNull);
    await settleEventsTimers(tester);
  });
}
