import 'package:flutter/foundation.dart';

import '../../utils/app_asset_preloader.dart';
import '../../utils/deferred_page_load_coordinator.dart';

/// Defers non-critical background loading on `/apps` until scroll or idle.
class AppsLoadCoordinator {
  AppsLoadCoordinator._();

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

  static void onAppsScroll({
    required double pixels,
    required double maxScrollExtent,
  }) {
    _delegate.onScroll(pixels: pixels, maxScrollExtent: maxScrollExtent);
  }
}
