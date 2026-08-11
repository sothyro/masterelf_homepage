import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/theme/brand_icons.dart';
import 'package:masterelf_homepage/widgets/media_posts_popup.dart';
import 'package:masterelf_homepage/widgets/social_orbital_medallion.dart';
import 'package:masterelf_homepage/widgets/social_popup_yuk9_orbits.dart';

void main() {
  Future<void> pumpPopup(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showMediaPostsPopup(context),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('MediaPostsPopup shows orbital icons only at 1280px', (tester) async {
    await pumpPopup(tester, width: 1280);

    expect(find.byType(MediaPostsPopup), findsOneWidget);
    expect(find.byType(SocialPopupYuk9Orbits), findsOneWidget);
    expect(find.byKey(const Key('social-orbital-facebook')), findsOneWidget);
    expect(find.byKey(const Key('social-orbital-telegram')), findsOneWidget);
    expect(find.byIcon(BrandIcons.facebook), findsOneWidget);
    expect(find.byIcon(LucideIcons.send), findsOneWidget);
    expect(find.text('Media & Posts'), findsNothing);
    expect(find.text('Media coverage'), findsNothing);
    expect(find.text('Close'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('MediaPostsPopup has no overflow at mobile width', (tester) async {
    await pumpPopup(tester, width: 375);

    expect(find.byType(SocialOrbitalPair), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('MediaPostsPopup dismisses on barrier tap', (tester) async {
    await pumpPopup(tester, width: 1280);

    expect(find.byType(MediaPostsPopup), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(MediaPostsPopup), findsNothing);
  });

  testWidgets('MediaPostsPopup orbit animation pumps without errors', (tester) async {
    await pumpPopup(tester, width: 1280);

    expect(find.byType(SocialPopupYuk9Orbits), findsOneWidget);

    for (var i = 0; i < 32; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    expect(tester.takeException(), isNull);
    expect(find.byType(MediaPostsPopup), findsOneWidget);
  });

  testWidgets('MediaPostsPopup orbit stage has non-zero paint bounds', (tester) async {
    await pumpPopup(tester, width: 1280);

    final orbitBox = tester.renderObject<RenderBox>(
      find.byType(SocialPopupYuk9Orbits),
    );
    expect(orbitBox.size.width, greaterThan(200));
    expect(orbitBox.size.height, greaterThan(100));
    expect(orbitBox.hasSize, isTrue);
  });

  testWidgets('MediaPostsPopup orbit progress advances every frame', (tester) async {
    await pumpPopup(tester, width: 1280);

    double readProgress() {
      final widget = tester.widget<SocialPopupYuk9Orbits>(
        find.byType(SocialPopupYuk9Orbits),
      );
      return widget.progress;
    }

    final samples = <double>[];
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      samples.add(readProgress());
    }

    expect(samples.first, isNot(samples.last));
    expect(samples.toSet().length, greaterThan(20));
    expect(tester.takeException(), isNull);
  });

  testWidgets('MediaPostsPopup sustains 120 frames under budget on mobile width', (tester) async {
    await pumpPopup(tester, width: 375);

    final frameTimes = <int>[];
    for (var i = 0; i < 120; i++) {
      final sw = Stopwatch()..start();
      await tester.pump(const Duration(milliseconds: 16));
      sw.stop();
      frameTimes.add(sw.elapsedMicroseconds);
    }

    final avgMicros = frameTimes.reduce((a, b) => a + b) / frameTimes.length;
    final maxMicros = frameTimes.reduce(math.max);

    expect(tester.takeException(), isNull);
    expect(avgMicros, lessThan(12 * 1000));
    expect(maxMicros, lessThan(40 * 1000));
  });
}
