import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_chapter_header.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_hero_medallion.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_master_elf_system_intro.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_yuk9_brand.dart';

import 'test_helpers/pump_app.dart';

void main() {
  for (final width in [375.0, 768.0, 1280.0]) {
    testWidgets('Apps page has no overflow at ${width.toInt()}px', (
      tester,
    ) async {
      await pumpRouteAtWidth(tester, '/apps', width);

      expect(find.byType(AppsHeroMedallion), findsOneWidget);
      expect(find.byType(AppsMasterElfSystemIntro), findsOneWidget);
      expect(find.byType(MasterElfYuk9ProBrandTitle), findsNWidgets(2));
      expect(find.text('Master Elf Chinese Metaphysic System'), findsOneWidget);
      expect(
        find.text(
          'Plot charts. Read the moment. Act with certainty — on every screen.',
        ),
        findsOneWidget,
      );
      expect(find.text('Feature Atlas'), findsOneWidget);
      expect(find.text('Period 9 Mobile'), findsOneWidget);
      expect(find.text('Overview'), findsNothing);
      expect(find.text('Desktop · Tablet · Web'), findsOneWidget);
      expect(find.text('BaZi Destiny'), findsOneWidget);
      expect(find.text('Digital Platform'), findsNothing);
    });
  }

  testWidgets('Period 9 appears before module atlas on page', (tester) async {
    await pumpRouteAtWidth(tester, '/apps', 1280);

    final period9Title = find.text('Period 9 Mobile');
    final featureAtlasTitle = find.text('Feature Atlas');
    final baziTitle = find.text('BaZi Destiny');

    expect(tester.getTopLeft(period9Title).dy, lessThan(tester.getTopLeft(featureAtlasTitle).dy));
    expect(tester.getTopLeft(featureAtlasTitle).dy, lessThan(tester.getTopLeft(baziTitle).dy));
  });

  testWidgets('Apps page deep link scrolls to master-elf section', (
    tester,
  ) async {
    await pumpRouteAtWidth(tester, '/apps#master-elf', 375);
    expect(find.byType(AppsMasterElfSystemIntro), findsOneWidget);
    expect(find.text('Desktop · Tablet · Web'), findsOneWidget);
  });

  testWidgets('Apps page deep link scrolls to period9 section', (tester) async {
    await pumpRouteAtWidth(tester, '/apps#period9', 375);
    expect(find.text('Period 9 Mobile'), findsOneWidget);
    expect(find.byType(AppsChapterHeader), findsWidgets);
  });
}
