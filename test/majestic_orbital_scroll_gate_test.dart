import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/app_content.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';
import 'package:masterelf_homepage/widgets/majestic_orbital_card_frame.dart';
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

  Future<MajesticOrbitalCardFrameState> pumpOrbital(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: MajesticOrbitalCardFrame(
                aspectRatio: 16 / 9,
                imageAsset: AppContent.assetEvent2027,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump();
    // Initial soft-start: allow frame-delayed ticker resume.
    await tester.pump();
    await tester.pump();

    return tester.state<MajesticOrbitalCardFrameState>(
      find.byType(MajesticOrbitalCardFrame),
    );
  }

  testWidgets('MajesticOrbitalCardFrame stops ticker while user is scrolling', (
    tester,
  ) async {
    final state = await pumpOrbital(tester);
    expect(state.isCycleAnimating, isTrue);

    ScrollActivityGate.onScrollOffset(40);
    await tester.pump();
    expect(ScrollActivityGate.isUserScrolling, isTrue);
    expect(state.isCycleAnimating, isFalse);

    await tester.pump(ScrollActivityGate.idleDelay);
    expect(ScrollActivityGate.isUserScrolling, isFalse);
    expect(state.isResumeSettling, isTrue);

    // Soft resume: a couple of frames before/while ticker restarts.
    await tester.pump();
    await tester.pump();
    expect(state.isCycleAnimating, isTrue);
    expect(state.isResumeSettling, isTrue);

    await tester.pump(const Duration(milliseconds: 320));
    await tester.pump();
    expect(state.isResumeSettling, isFalse);
    expect(state.isCycleAnimating, isTrue);
  });
}
