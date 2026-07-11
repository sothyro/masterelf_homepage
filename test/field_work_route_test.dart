import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'test_helpers/pump_app.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  testWidgets('Field work route loads journal page', (tester) async {
    await pumpRouteAtWidth(tester, '/field-work', 1280);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Master Elf in Action'), findsOneWidget);
  });

  testWidgets('Field work detail route loads post', (tester) async {
    await pumpRouteAtWidth(
      tester,
      '/field-work/feng-shui-shophouse-audit-phnom-penh',
      1280,
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Feng Shui site visit'), findsWidgets);
  });
}
