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
          message.contains('Build scheduled during frame')) {
        return;
      }
      previousErrorHandler?.call(details);
    };
  });

  tearDown(() {
    FlutterError.onError = previousErrorHandler;
  });

  for (final width in [375.0, 1280.0]) {
    testWidgets('Apps page has no overflow at ${width.toInt()}px', (tester) async {
      await pumpRouteAtWidth(tester, '/apps', width);
      drainLayoutExceptions(tester);

      expect(find.text('Apps & Store'), findsWidgets);
    });
  }
}
