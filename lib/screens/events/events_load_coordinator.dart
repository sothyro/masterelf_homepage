import 'package:flutter/foundation.dart';

import '../../utils/app_asset_preloader.dart';
import '../../utils/deferred_page_load_coordinator.dart';

/// Defers background asset loading on `/events` until scroll or idle.
class EventsLoadCoordinator {
  EventsLoadCoordinator._();

  static final _delegate = DeferredPageLoadCoordinator(
    onTrigger: AppAssetPreloader.startBackgroundPreload,
  );

  static const double scrollFractionThreshold =
      DeferredPageLoadCoordinator.scrollFractionThreshold;
  static const Duration idleFallback =
      DeferredPageLoadCoordinator.idleFallback;

  @visibleForTesting
  static void resetForTesting() => _delegate.reset();

  static void armAfterReveal() => _delegate.arm();

  static void onEventsScroll({
    required double pixels,
    required double maxScrollExtent,
  }) {
    _delegate.onScroll(pixels: pixels, maxScrollExtent: maxScrollExtent);
  }
}
