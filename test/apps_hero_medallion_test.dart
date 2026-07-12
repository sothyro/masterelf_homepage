import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_hero_medallion.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_yuk9_metaphysics_orbits.dart';
import 'package:masterelf_homepage/utils/mobile_web_performance.dart';

Widget _medallionApp({bool disableAnimations = false}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(1280, 900),
        disableAnimations: disableAnimations,
      ),
      child: const Scaffold(
        body: Center(child: AppsHeroMedallion()),
      ),
    ),
  );
}

void main() {
  test('heroMedallionAnimationDefer is zero off web', () {
    expect(MobileWebPerformance.heroMedallionAnimationDefer(), Duration.zero);
  });

  testWidgets('desktop width shows orbit animation immediately', (tester) async {
    await tester.pumpWidget(_medallionApp());
    await tester.pump();

    expect(find.byType(Yuk9MetaphysicsOrbits), findsWidgets);
  });

  testWidgets('reduced motion keeps static medallion without orbits', (tester) async {
    await tester.pumpWidget(_medallionApp(disableAnimations: true));
    await tester.pump();

    expect(find.byType(AppsHeroMedallion), findsOneWidget);
    expect(find.byType(Yuk9MetaphysicsOrbits), findsNothing);
  });
}
