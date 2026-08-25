import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';
import 'package:masterelf_homepage/widgets/viewport_deferred_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    ScrollActivityGate.resetForTesting();
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
    ScrollActivityGate.resetForTesting();
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

  testWidgets('shows placeholder until visible then idle settle', (tester) async {
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
                  postIdleSettleDelay: Duration(milliseconds: 250),
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

    // Near viewport while idle → wait for post-idle settle before mount.
    expect(find.text('loaded'), findsNothing);
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump();

    expect(find.text('loaded'), findsOneWidget);
  });

  testWidgets('defers mount while user is actively scrolling', (tester) async {
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
                  sectionKey: 'test-idle-gate',
                  placeholderHeight: 200,
                  postIdleSettleDelay: Duration(milliseconds: 100),
                  child: Text('loaded'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    ScrollActivityGate.onScrollOffset(10);
    await tester.drag(find.byType(Scrollable), const Offset(0, -400));
    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('loaded'), findsNothing);

    await tester.pump(ScrollActivityGate.idleDelay);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.text('loaded'), findsOneWidget);
  });
}
