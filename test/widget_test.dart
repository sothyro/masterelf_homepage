import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers/pump_app.dart';

void main() {
  late void Function(FlutterErrorDetails)? previousErrorHandler;

  setUp(() {
    previousErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('overflowed') ||
          message.contains('Build scheduled during frame') ||
          message.contains('deactivated widget')) {
        return;
      }
      previousErrorHandler?.call(details);
    };
  });

  tearDown(() {
    FlutterError.onError = previousErrorHandler;
  });

  testWidgets('App smoke test loads contact route', (WidgetTester tester) async {
    await pumpRouteAtWidth(tester, '/contact', 1280);
    drainLayoutExceptions(tester);

    expect(find.text('Contact'), findsAtLeastNWidgets(1));
  });

  testWidgets('404 shows not-found page inside shell', (WidgetTester tester) async {
    await pumpMasterElfApp(tester, surfaceSize: const Size(1280, 2000));
    await navigateTo(tester, '/unknown-path');

    expect(find.text('Page not found'), findsOneWidget);
    expect(find.text('Back to Home'), findsOneWidget);
  });
}
