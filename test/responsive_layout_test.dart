import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'test_helpers/pump_app.dart';

const _responsiveRoutes = [
  '/about',
  '/journey',
  '/events',
  '/apps',
  '/books',
  '/talisman',
  '/academy',
  '/contact',
  '/consultations',
  '/field-work',
];

const _responsiveWidths = [320.0, 375.0, 768.0, 1024.0, 1280.0];
const _responsiveLocales = ['en', 'km', 'zh'];
const _localeRoutes = ['/about', '/consultations', '/events', '/books'];

Future<void> pumpRouteAndSettle(
  WidgetTester tester,
  String path,
  double width,
) async {
  final height = width < 768 ? 4000.0 : 3200.0;
  await pumpRouteAtWidth(tester, path, width, height: height);
}

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  group('responsive layout matrix', () {
    for (final width in _responsiveWidths) {
      for (final route in _responsiveRoutes) {
        testWidgets('$route has no overflow at ${width.toInt()}px (en)', (tester) async {
          await pumpRouteAndSettle(tester, route, width);
        });
      }
    }

    for (final locale in _responsiveLocales) {
      for (final route in _localeRoutes) {
        testWidgets('$route has no overflow at 375px ($locale)', (tester) async {
          await pumpMasterElfAppWithLocale(
            tester,
            locale,
            surfaceSize: const Size(375, 3200),
          );
          await resetAppToHome(tester);
          if (route != '/') {
            await settleHomeScreenTimers(tester);
            drainLayoutExceptions(tester);
          }
          await navigateTo(tester, route);
          await tester.pump(const Duration(milliseconds: 800));
          assertNoLayoutOverflow(tester);
        });
      }
    }
  });

  testWidgets('home route settles without overflow at 375px', (tester) async {
    await pumpMasterElfApp(tester, surfaceSize: const Size(375, 4000));
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    assertNoLayoutOverflow(tester);
  });

  testWidgets('apps fragment deep link loads on mobile', (tester) async {
    await pumpRouteAndSettle(tester, '/apps#master-elf', 375);
    expect(find.textContaining('Master Elf'), findsWidgets);
  });

  testWidgets('books fragment deep link loads on mobile', (tester) async {
    await pumpRouteAndSettle(tester, '/books#books', 375);
    expect(find.byType(Scrollable), findsWidgets);
  });
}
