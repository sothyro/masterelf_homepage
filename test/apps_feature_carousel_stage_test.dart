import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/apps_showcase_content.dart';
import 'package:masterelf_homepage/l10n/app_localizations_en.dart';
import 'package:masterelf_homepage/screens/apps/widgets/apps_feature_carousel_stage.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('carousel shows first module and all feature pills', (tester) async {
    final l10n = AppLocalizationsEn();
    final modules = buildAppsShowcaseGroups(l10n)
        .where((g) => g.layout != AppsGroupLayout.ecosystem)
        .toList();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 800,
              child: AppsFeatureCarouselStage(modules: modules),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BaZi Destiny'), findsWidgets);
    expect(find.byKey(const ValueKey<String>('qimen')), findsOneWidget);
    expect(find.byType(AppsFeatureCarouselStage), findsOneWidget);
  });

  testWidgets('tapping pill switches active feature copy', (tester) async {
    final l10n = AppLocalizationsEn();
    final modules = buildAppsShowcaseGroups(l10n)
        .where((g) => g.layout != AppsGroupLayout.ecosystem)
        .toList();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 800,
              child: AppsFeatureCarouselStage(modules: modules),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey<String>('qimen')));
    await tester.tap(find.byKey(const ValueKey<String>('qimen')));
    await tester.pumpAndSettle();

    expect(
      find.text('Strategic formations for decisions when timing is everything.'),
      findsOneWidget,
    );
  });

  testWidgets('reduced motion disables auto-advance', (tester) async {
    final l10n = AppLocalizationsEn();
    final modules = buildAppsShowcaseGroups(l10n)
        .where((g) => g.layout != AppsGroupLayout.ecosystem)
        .toList();

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 800,
                height: 1200,
                child: AppsFeatureCarouselStage(modules: modules),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BaZi Destiny'), findsWidgets);

    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    expect(
      find.text('Strategic formations for decisions when timing is everything.'),
      findsNothing,
    );
  });

  testWidgets('mobile width renders carousel stage', (tester) async {
    final l10n = AppLocalizationsEn();
    final modules = buildAppsShowcaseGroups(l10n)
        .where((g) => g.layout != AppsGroupLayout.ecosystem)
        .toList();

    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 390,
              child: AppsFeatureCarouselStage(modules: modules),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppsFeatureCarouselStage), findsOneWidget);
    expect(find.text('BaZi Destiny'), findsWidgets);
  });
}
