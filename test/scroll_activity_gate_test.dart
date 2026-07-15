import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';

void main() {
  setUp(ScrollActivityGate.resetForTesting);

  test('isUserScrolling is false before any scroll', () {
    expect(ScrollActivityGate.isUserScrolling, isFalse);
  });

  test('offset change marks user scrolling', () {
    ScrollActivityGate.onScrollOffset(10);
    expect(ScrollActivityGate.isUserScrolling, isTrue);
  });

  test('idle fires after delay with no further offset changes', () async {
    var idleCount = 0;
    ScrollActivityGate.addIdleListener(() => idleCount++);

    ScrollActivityGate.onScrollOffset(10);
    expect(ScrollActivityGate.isUserScrolling, isTrue);
    expect(idleCount, 0);

    await Future<void>.delayed(ScrollActivityGate.idleDelay);
    expect(ScrollActivityGate.isUserScrolling, isFalse);
    expect(idleCount, 1);
  });

  test('activity listener fires when scrolling starts and when idle', () async {
    var activityCount = 0;
    ScrollActivityGate.addActivityListener(() => activityCount++);

    ScrollActivityGate.onScrollOffset(5);
    expect(activityCount, 1);

    await Future<void>.delayed(ScrollActivityGate.idleDelay);
    expect(activityCount, 2);
  });

  test('continuous scroll resets idle timer', () async {
    var idleCount = 0;
    ScrollActivityGate.addIdleListener(() => idleCount++);

    ScrollActivityGate.onScrollOffset(10);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    ScrollActivityGate.onScrollOffset(20);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(idleCount, 0);

    await Future<void>.delayed(ScrollActivityGate.idleDelay);
    expect(idleCount, 1);
  });
}
