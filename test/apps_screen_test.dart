import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_chapter_header.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_hero_medallion.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_master_elf_system_intro.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_yuk9_brand.dart';
import 'package:masterelf_homepage/utils/breakpoints.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'test_helpers/pump_app.dart';

Future<void> revealAppsDeferredSections(WidgetTester tester) async {
  final scrollable = find.byType(Scrollable);
  if (scrollable.evaluate().isEmpty) return;
  await tester.drag(scrollable.first, const Offset(0, -2400));
  await tester.pump();
  await tester.pump(ScrollActivityGate.idleDelay);
  VisibilityDetectorController.instance.notifyNow();
  await tester.pump(const Duration(milliseconds: 100));
  ScrollActivityGate.resetForTesting();
}

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
    ScrollActivityGate.resetForTesting();
  });

  for (final width in [375.0, 768.0, 1280.0]) {
    testWidgets('Apps page has no overflow at ${width.toInt()}px', (
      tester,
    ) async {
      await pumpRouteAtWidth(tester, '/apps', width);

      expect(find.byType(AppsHeroMedallion), findsOneWidget);
      expect(find.byType(AppsMasterElfSystemIntro), findsOneWidget);
      expect(find.byType(MasterElfYuk9ProBrandTitle), findsNWidgets(2));
      expect(find.text('Master Elf Chinese Metaphysics System'), findsOneWidget);
      expect(
        find.text(
          'Plot charts. Read the moment. Act with certainty.',
        ),
        findsOneWidget,
      );
      expect(find.text('Feature Atlas'), findsOneWidget);
      expect(find.text('Period 9 Mobile'), findsOneWidget);
      expect(find.text('Overview'), findsNothing);

      await revealAppsDeferredSections(tester);
      // Band switches on content width (< 768); desktop content is capped at 1100.
      if (width < Breakpoints.tablet) {
        expect(find.byIcon(LucideIcons.monitor), findsOneWidget);
        expect(find.byIcon(LucideIcons.tablet), findsOneWidget);
        expect(find.byIcon(LucideIcons.globe), findsOneWidget);
      } else {
        expect(find.text('Desktop · Tablet · Web'), findsOneWidget);
      }
      expect(find.text('BaZi Destiny'), findsWidgets);
      expect(find.text('Digital Platform'), findsNothing);
    });
  }

  testWidgets('Period 9 appears before module atlas on page', (tester) async {
    await pumpRouteAtWidth(tester, '/apps', 1280);
    await revealAppsDeferredSections(tester);

    final period9Title = find.text('Period 9 Mobile');
    final featureAtlasTitle = find.text('Feature Atlas');
    final baziTitle = find.text('BaZi Destiny').first;

    expect(tester.getTopLeft(period9Title).dy, lessThan(tester.getTopLeft(featureAtlasTitle).dy));
    expect(tester.getTopLeft(featureAtlasTitle).dy, lessThan(tester.getTopLeft(baziTitle).dy));
  });

  testWidgets('Apps page deep link scrolls to master-elf section', (
    tester,
  ) async {
    await pumpRouteAtWidth(tester, '/apps#master-elf', 375);
    expect(find.byType(AppsMasterElfSystemIntro), findsOneWidget);
  });

  testWidgets('Apps page deep link scrolls to period9 section', (tester) async {
    await pumpRouteAtWidth(tester, '/apps#period9', 375);
    expect(find.text('Period 9 Mobile'), findsOneWidget);
    expect(find.byType(AppsChapterHeader), findsWidgets);
  });
}
