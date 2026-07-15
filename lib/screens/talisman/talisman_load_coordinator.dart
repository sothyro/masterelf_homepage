import 'package:flutter/foundation.dart';

import '../../utils/app_asset_preloader.dart';
import '../../utils/deferred_page_load_coordinator.dart';

/// Arms background preload on `/talisman` after first paint.
class TalismanLoadCoordinator {
  TalismanLoadCoordinator._();

  static final _delegate = DeferredPageLoadCoordinator(
    onTrigger: AppAssetPreloader.startBackgroundPreload,
  );

  static const double scrollFractionThreshold =
      DeferredPageLoadCoordinator.scrollFractionThreshold;
  static const Duration idleFallback =
      DeferredPageLoadCoordinator.idleFallback;

  @visibleForTesting
  static void resetForTesting() => _delegate.resetForTesting();

  static void armAfterReveal() => _delegate.arm();

  static void onTalismanScroll({
    required double pixels,
    required double maxScrollExtent,
  }) {
    _delegate.onScroll(pixels: pixels, maxScrollExtent: maxScrollExtent);
  }
}
