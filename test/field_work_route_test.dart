import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:masterelf_homepage/screens/field_work/field_work_load_coordinator.dart';
import 'test_helpers/pump_app.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
    FieldWorkLoadCoordinator.resetForTesting();
  });

  testWidgets('Field work route loads journal page', (tester) async {
    await pumpRouteAtWidth(tester, '/field-work', 1280);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(seconds: 6));
    FieldWorkLoadCoordinator.resetForTesting();

    expect(find.text('FIELD WORK'), findsOneWidget);
    expect(find.text('Real work. Real places. Real outcomes.'), findsOneWidget);
    expect(find.text('Book a face-to-face consultation'), findsWidgets);
  });

  testWidgets('Field work detail route loads post', (tester) async {
    await pumpRouteAtWidth(
      tester,
      '/field-work/feng-shui-shophouse-audit-phnom-penh',
      1280,
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(seconds: 6));
    FieldWorkLoadCoordinator.resetForTesting();

    expect(find.textContaining('Feng Shui site visit'), findsWidgets);
  });
}
