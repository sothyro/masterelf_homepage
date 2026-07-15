import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/widgets/viewport_deferred_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  testWidgets('eager mounts child immediately', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ViewportDeferredSection(
            sectionKey: 'test-eager',
            placeholderHeight: 400,
            eager: true,
            child: Text('loaded'),
          ),
        ),
      ),
    );

    expect(find.text('loaded'), findsOneWidget);
  });

  testWidgets('shows placeholder until visible', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 700),
                const ViewportDeferredSection(
                  sectionKey: 'test-lazy',
                  placeholderHeight: 200,
                  child: Text('loaded'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('loaded'), findsNothing);

    await tester.drag(find.byType(Scrollable), const Offset(0, -400));
    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump();

    expect(find.text('loaded'), findsOneWidget);
  });
}
