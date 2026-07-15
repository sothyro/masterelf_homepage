import 'package:flutter/foundation.dart';

import '../../utils/app_asset_preloader.dart';
import '../../utils/deferred_page_load_coordinator.dart';

/// Defers spotlight video prewarm and background assets on `/field-work`.
class FieldWorkLoadCoordinator {
  FieldWorkLoadCoordinator._();

  static double? _layoutWidth;

  static final _delegate = DeferredPageLoadCoordinator(
    onTrigger: _triggerDeferredLoads,
  );

  static const double scrollFractionThreshold =
      DeferredPageLoadCoordinator.scrollFractionThreshold;
  static const Duration idleFallback =
      DeferredPageLoadCoordinator.idleFallback;

  @visibleForTesting
  static void resetForTesting() {
    _layoutWidth = null;
    _delegate.resetForTesting();
  }

  static void armAfterReveal({required double layoutWidth}) {
    _layoutWidth = layoutWidth;
    _delegate.arm();
  }

  static void onFieldWorkScroll({
    required double pixels,
    required double maxScrollExtent,
  }) {
    _delegate.onScroll(pixels: pixels, maxScrollExtent: maxScrollExtent);
  }

  static void _triggerDeferredLoads() {
    AppAssetPreloader.startBackgroundPreload();
    final width = _layoutWidth;
    if (width != null) {
      AppAssetPreloader.preloadFieldWorkSpotlightVideos(width);
    }
  }
}
