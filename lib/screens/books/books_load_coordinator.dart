import 'package:flutter/foundation.dart';

import '../../utils/app_asset_preloader.dart';
import '../../utils/deferred_page_load_coordinator.dart';

/// Defers shelf panorama and period9 cover preload on `/books` until scroll or idle.
class BooksLoadCoordinator {
  BooksLoadCoordinator._();

  static final _delegate = DeferredPageLoadCoordinator(
    onTrigger: _triggerDeferredLoads,
  );

  static const double scrollFractionThreshold =
      DeferredPageLoadCoordinator.scrollFractionThreshold;
  static const Duration idleFallback =
      DeferredPageLoadCoordinator.idleFallback;

  @visibleForTesting
  static void resetForTesting() => _delegate.resetForTesting();

  static void armAfterReveal() => _delegate.arm();

  static void onBooksScroll({
    required double pixels,
    required double maxScrollExtent,
  }) {
    _delegate.onScroll(pixels: pixels, maxScrollExtent: maxScrollExtent);
  }

  static void _triggerDeferredLoads() {
    AppAssetPreloader.startBackgroundPreload();
    AppAssetPreloader.preloadBooksDeferredAssets();
  }
}
