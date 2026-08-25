import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';

void main() {
  setUp(ScrollActivityGate.resetForTesting);

  test('isUserScrolling is false before any scroll', () {
    expect(ScrollActivityGate.isUserScrolling, isFalse);
    expect(ScrollActivityGate.hasUserScrolled, isFalse);
  });

  test('offset change marks user scrolling and first scroll', () {
    ScrollActivityGate.onScrollOffset(10);
    expect(ScrollActivityGate.isUserScrolling, isTrue);
    expect(ScrollActivityGate.hasUserScrolled, isTrue);
  });

  test('first scroll listener fires once and is sticky', () {
    var count = 0;
    ScrollActivityGate.addFirstScrollListener(() => count++);
    expect(count, 0);

    ScrollActivityGate.onScrollOffset(10);
    expect(count, 1);

    ScrollActivityGate.onScrollOffset(20);
    expect(count, 1);

    var lateCount = 0;
    ScrollActivityGate.addFirstScrollListener(() => lateCount++);
    expect(lateCount, 1);
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
    expect(ScrollActivityGate.hasUserScrolled, isTrue);
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

  test('showHomeEventsInkWash requires past hero and idle', () async {
    ScrollActivityGate.onScrollOffset(100);
    expect(ScrollActivityGate.showHomeEventsInkWash, isFalse);

    await Future<void>.delayed(ScrollActivityGate.idleDelay);
    expect(ScrollActivityGate.showHomeEventsInkWash, isFalse);

    ScrollActivityGate.onScrollOffset(450);
    await Future<void>.delayed(ScrollActivityGate.idleDelay);
    expect(ScrollActivityGate.showHomeEventsInkWash, isTrue);
  });
}
