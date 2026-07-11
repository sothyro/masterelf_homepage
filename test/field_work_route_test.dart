import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'test_helpers/pump_app.dart';

void main() {
  late void Function(FlutterErrorDetails)? previousErrorHandler;

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
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
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
    FlutterError.onError = previousErrorHandler;
  });

  testWidgets('Field work route loads journal page', (tester) async {
    await pumpRouteAtWidth(tester, '/field-work', 1280);
    await tester.pump(const Duration(milliseconds: 500));
    drainLayoutExceptions(tester);

    expect(find.text('Master Elf in Action'), findsOneWidget);
  });

  testWidgets('Field work detail route loads post', (tester) async {
    await pumpRouteAtWidth(tester, '/field-work/feng-shui-shophouse-audit-phnom-penh', 1280);
    await tester.pump(const Duration(milliseconds: 500));
    drainLayoutExceptions(tester);

    expect(find.textContaining('Feng Shui site visit'), findsWidgets);
  });
}
