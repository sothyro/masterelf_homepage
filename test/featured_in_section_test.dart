import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/home/widgets/featured_in_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  Future<void> pumpFeaturedIn(
    WidgetTester tester, {
    required double width,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 900)),
          child: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(
              child: SizedBox(
                width: width,
                child: Builder(
                  builder: (context) {
                    return FeaturedInSection(
                      l10n: AppLocalizations.of(context)!,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> disposeFeaturedIn(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump();
  }

  testWidgets('FeaturedInSection has no overflow at mobile width', (tester) async {
    await pumpFeaturedIn(tester, width: 375);
    expect(tester.takeException(), isNull);
    expect(find.byType(FeaturedInSection), findsOneWidget);
    await disposeFeaturedIn(tester);
  });

  testWidgets('FeaturedInSection has no overflow at tablet width', (tester) async {
    await pumpFeaturedIn(tester, width: 768);
    expect(tester.takeException(), isNull);
    expect(find.byType(FeaturedInSection), findsOneWidget);
    await disposeFeaturedIn(tester);
  });

  testWidgets('FeaturedInSection has no overflow at desktop width', (tester) async {
    await pumpFeaturedIn(tester, width: 1280);
    expect(tester.takeException(), isNull);
    expect(find.byType(FeaturedInSection), findsOneWidget);
    await disposeFeaturedIn(tester);
  });

  testWidgets('FeaturedInSection uses marquee on mobile width', (tester) async {
    await pumpFeaturedIn(tester, width: 375);
    expect(
      find.byKey(const ValueKey<String>('featured-in-marquee')),
      findsOneWidget,
    );
    await disposeFeaturedIn(tester);
  });

  testWidgets('FeaturedInSection uses static row when animations disabled', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(375, 900),
            disableAnimations: true,
          ),
          child: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(
              child: SizedBox(
                width: 375,
                child: Builder(
                  builder: (context) {
                    return FeaturedInSection(
                      l10n: AppLocalizations.of(context)!,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('featured-in-marquee')),
      findsNothing,
    );
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    await disposeFeaturedIn(tester);
  });

  testWidgets('featuredLogoSize scales responsively', (tester) async {
    expect(featuredLogoSize(1280), 256);
    expect(featuredLogoSize(900), 200);
    expect(featuredLogoSize(500), 160);
    expect(featuredLogoSize(360), 128);
  });
}
