import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/utils/deferred_page_load_coordinator.dart';

void main() {
  test('does not trigger before arm', () {
    var count = 0;
    final coordinator = DeferredPageLoadCoordinator(onTrigger: () => count++);
    coordinator.onScroll(pixels: 500, maxScrollExtent: 1000);
    expect(count, 0);
  });

  test('triggers once on scroll threshold', () {
    var count = 0;
    final coordinator = DeferredPageLoadCoordinator(onTrigger: () => count++);
    coordinator.arm();
    coordinator.onScroll(pixels: 300, maxScrollExtent: 1000);
    coordinator.onScroll(pixels: 900, maxScrollExtent: 1000);
    expect(count, 1);
  });

  test('idle fallback triggers once', () async {
    var count = 0;
    final coordinator = DeferredPageLoadCoordinator(onTrigger: () => count++);
    coordinator.arm();
    await Future<void>.delayed(DeferredPageLoadCoordinator.idleFallback);
    expect(count, 1);
  });
}
