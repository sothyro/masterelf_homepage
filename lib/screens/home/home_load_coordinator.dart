import 'package:flutter/foundation.dart';

import '../../utils/app_asset_preloader.dart';
import '../../utils/deferred_page_load_coordinator.dart';

/// Defers non-critical background asset loading on the homepage until the user
/// scrolls or a post-reveal idle timeout elapses.
class HomeLoadCoordinator {
  HomeLoadCoordinator._();

  static final _delegate = DeferredPageLoadCoordinator(
    onTrigger: AppAssetPreloader.startBackgroundPreload,
  );

  static const double scrollFractionThreshold =
      DeferredPageLoadCoordinator.scrollFractionThreshold;
  static const Duration idleFallback =
      DeferredPageLoadCoordinator.idleFallback;

  @visibleForTesting
  static void resetForTesting() => _delegate.reset();

  /// Call once when the bootstrap overlay has dismissed on the homepage.
  static void armAfterReveal() => _delegate.arm();

  /// Call from shell scroll listener when on `/`.
  static void onHomeScroll({
    required double pixels,
    required double maxScrollExtent,
  }) {
    _delegate.onScroll(pixels: pixels, maxScrollExtent: maxScrollExtent);
  }
}
