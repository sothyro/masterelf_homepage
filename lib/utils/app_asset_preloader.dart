import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_content.dart';
import '../services/activity_video_platform.dart';
import '../services/hero_video_platform.dart';
import 'mobile_web_performance.dart';

// ---------------------------------------------------------------------------
// Tier 1 — critical first paint (logo + hero static background).
// Tier 2 — eager homepage (Events) — blocks bootstrap.
// Tier 3 — near-fold homepage (Academies / Consultations) — onNearViewport.
// Tier 4 — mid/below-fold + other pages (background after reveal).
// Hero video prewarms in parallel on desktop/tablet web and does not block
// overlay dismiss; poster stays until ready.
// ---------------------------------------------------------------------------

/// Critical for first paint: logo (header) and hero background (fallback/static).
List<String> get _criticalImageAssets => [
  AppContent.assetLogo,
  AppContent.assetHeroBackground,
];

/// Eager homepage images (Events / orbital) — blocks bootstrap reveal.
List<String> get _firstScreenHomepageAssets => [
  AppContent.assetEventMain,
  AppContent.assetEvent2027,
  AppContent.assetEvent2026FengShui,
  AppContent.assetEvent2026CrimsonHorse,
];

/// Near-fold homepage images — warmed when Academies/Consultations approach.
List<String> get _homeNearFoldAssets => [
  AppContent.assetBackgroundDirection,
  AppContent.assetBaziHarmony,
  AppContent.assetAcademyFengShui,
  AppContent.assetAcademyQiMen,
];

/// Mid-page homepage images — loaded after critical gate / section mount.
List<String> get _midPageHomepageAssets => [
  AppContent.assetStoryBackground,
  AppContent.assetActivityFengShui,
  AppContent.assetActivityConsultation,
  AppContent.assetActivityMaoShan,
  AppContent.assetActivityDateSelection,
  ...AppContent.featuredPressLogos,
];

/// Below-fold homepage images — story background only (also in mid-page tier).
List<String> get _belowFoldHomepageAssets => [
  AppContent.assetStoryBackground,
];

/// App screenshots — above-fold subset for first paint on /apps.
List<String> get _appsPageAboveFoldAssets => [
  AppContent.assetYuk9Icon,
  ...AppContent.appShowcaseAboveFoldAssets,
];

/// Remaining apps page screenshots — deferred after first paint.
List<String> get _appsPageDeferredAssets => AppContent.appShowcaseDeferredAssets;

/// Above-fold book store assets — hero uses shared contact hero; blessing covers on mount.
List<String> get _booksPageAboveFoldAssets => [
  AppContent.assetContactHero,
  AppContent.assetBook1,
  AppContent.assetBook2,
  AppContent.assetBook3,
  AppContent.assetBook4,
  AppContent.assetBook5,
];

/// Below-fold book store assets — shelf panorama and period9 covers.
List<String> get _booksPageDeferredAssets => [
  AppContent.assetShelfMockupFiveBlessings,
  AppContent.assetPeriod9Book1,
  AppContent.assetPeriod9Book2,
];

/// Above-fold events page assets — hero, upcoming image, venue logos.
List<String> get _eventsPageAboveFoldAssets => [
  AppContent.assetEventHero,
  AppContent.assetEvent2027,
  AppContent.assetVenueChipmong,
  AppContent.assetVenueLegendCinema,
];

/// Talisman page — hero background only (product images added when available).
List<String> get _talismanPageAboveFoldAssets => [
  AppContent.assetContactHero,
];

/// Remaining images for other pages; loaded in background after homepage tiers.
List<String> get _restImageAssets => [
  AppContent.assetAboutHero,
  AppContent.assetEventHero,
  AppContent.assetActivitiesHero,
  AppContent.assetAppsHero,
  AppContent.assetAcademy,
  AppContent.assetPeriod9Book1,
  AppContent.assetPeriod9Book2,
  AppContent.assetPeriod9_1,
  AppContent.assetPeriod9_2,
  for (var i = 1; i <= 8; i++) AppContent.assetActivityPhoto(i),
  AppContent.assetActivityPhoto(15),
  AppContent.assetActivityPhoto(27),
];

/// Preloads above-fold homepage assets before reveal; below-fold + rest in background.
class AppAssetPreloader {
  AppAssetPreloader._();

  static bool _midPageHomeStarted = false;
  static bool _nearFoldHomeStarted = false;
  static bool _belowFoldStarted = false;
  static bool _appsPageStarted = false;
  static bool _appsDeferredStarted = false;
  static bool _booksPageStarted = false;
  static bool _booksDeferredStarted = false;
  static bool _eventsPageStarted = false;
  static bool _talismanPageStarted = false;
  static bool _fieldWorkVideosStarted = false;
  static bool _backgroundPreloadStarted = false;
  static final Set<String> _preloadedTestimonialPaths = {};
  static final Set<String> _preloadedActivityCoverPaths = {};

  /// When true, skips network font work during bootstrap (tests only).
  @visibleForTesting
  static bool disableBackgroundFontsForTesting = false;

  /// When true, skips GPU decode during bootstrap (tests only).
  @visibleForTesting
  static bool disableImageDecodeForTesting = false;

  /// When true, skips hero video prewarm during bootstrap (tests only).
  @visibleForTesting
  static bool disableHeroVideoForTesting = false;

  @visibleForTesting
  static int get aboveFoldAssetCount => _firstScreenHomepageAssets.length;

  @visibleForTesting
  static int get nearFoldHomeAssetCount => _homeNearFoldAssets.length;

  @visibleForTesting
  static int get midPageHomeAssetCount => _midPageHomepageAssets.length;

  @visibleForTesting
  static bool get nearFoldHomePreloadStarted => _nearFoldHomeStarted;

  @visibleForTesting
  static int get belowFoldAssetCount => _belowFoldHomepageAssets.length;

  @visibleForTesting
  static int get appsDeferredAssetCount => _appsPageDeferredAssets.length;

  @visibleForTesting
  static int get booksDeferredAssetCount => _booksPageDeferredAssets.length;

  @visibleForTesting
  static bool get booksDeferredPreloadStarted => _booksDeferredStarted;

  @visibleForTesting
  static bool get booksPagePreloadStarted => _booksPageStarted;

  @visibleForTesting
  static bool get eventsPagePreloadStarted => _eventsPageStarted;

  @visibleForTesting
  static bool get talismanPagePreloadStarted => _talismanPageStarted;

  @visibleForTesting
  static bool get appsDeferredPreloadStarted => _appsDeferredStarted;

  @visibleForTesting
  static bool get backgroundPreloadStarted => _backgroundPreloadStarted;

  /// Phased bootstrap preload: critical → eager Events images → decode → fonts
  /// → homepage paint gate → reveal. Hero video prewarms in parallel and does
  /// not block dismiss.
  ///
  /// [waitForFirstPaint] (usually `HomeReadiness.ready`) keeps the final
  /// progress step pending until the eager homepage has painted;
  /// pass null when the initial route is not the homepage.
  static Future<void> preloadAll(
    void Function(double progress) onProgress, {
    Future<void>? waitForFirstPaint,
  }) async {
    onProgress(0.0);

    // Start hero video load in parallel (web: native HTML video; does not block
    // loader dismiss — poster stays until canplaythrough).
    if (!disableHeroVideoForTesting &&
        MobileWebPerformance.shouldPrewarmHeroVideoDuringBootstrap()) {
      unawaited(HeroVideoPlatform.prewarm());
    }

    // Phase 1 — critical (0 → 20%), parallel.
    await _loadImageListBatchedWithProgress(
      _criticalImageAssets,
      (completed, total) {
        onProgress(0.20 * (total > 0 ? completed / total : 1.0));
      },
      batchSize: _criticalImageAssets.length.clamp(1, 4),
    );
    // Phase 2 — eager Events images (20 → 55%)
    final webBatchSize = kIsWeb ? 3 : 6;
    await _loadImageListBatchedWithProgress(
      _firstScreenHomepageAssets,
      (completed, total) {
        onProgress(0.20 + 0.35 * (total > 0 ? completed / total : 1.0));
      },
      batchSize: webBatchSize,
    );

    // Phase 3 — GPU decode (55 → 65%). Native only; web relies on widget
    // cacheWidth decode to avoid double-decoding at full resolution (OOM risk).
    if (!disableImageDecodeForTesting && !kIsWeb) {
      await _decodeImageListBatchedWithProgress(
        _firstScreenHomepageAssets,
        (completed, total) {
          onProgress(0.55 + 0.10 * (total > 0 ? completed / total : 1.0));
        },
      );
    }
    onProgress(0.65);

    // Phase 4 — main fonts (65 → 75%)
    if (!disableBackgroundFontsForTesting) {
      await _loadMainFonts();
    }
    onProgress(0.75);

    // Phase 5 — hero video continues loading in background (75 → 88%).
    onProgress(0.88);

    // Phase 6 — homepage render gate (88 → 100%).
    if (waitForFirstPaint != null) {
      await waitForFirstPaint;
    }
    onProgress(1.0);
  }

  /// Kicks off deferred below-fold and other-page preloading. Called by the
  /// bootstrap once the loading overlay has dismissed so it never competes
  /// with hero video init or first paint.
  static void startBackgroundPreload() {
    if (_backgroundPreloadStarted) return;
    _backgroundPreloadStarted = true;
    unawaited(_runBackgroundPreloadSafely());
  }

  static Future<void> _runBackgroundPreloadSafely() async {
    final defer = MobileWebPerformance.backgroundPreloadDefer();
    if (defer > Duration.zero) {
      await Future<void>.delayed(defer);
    }
    await runZonedGuarded(() async {
      try {
        await _backgroundPreload();
      } catch (_) {}
    }, (_, __) {});
  }

  @visibleForTesting
  static void resetForTesting() {
    _midPageHomeStarted = false;
    _nearFoldHomeStarted = false;
    _belowFoldStarted = false;
    _appsPageStarted = false;
    _appsDeferredStarted = false;
    _booksPageStarted = false;
    _booksDeferredStarted = false;
    _eventsPageStarted = false;
    _talismanPageStarted = false;
    _fieldWorkVideosStarted = false;
    _backgroundPreloadStarted = false;
    _preloadedTestimonialPaths.clear();
    _preloadedActivityCoverPaths.clear();
    disableBackgroundFontsForTesting = false;
    disableImageDecodeForTesting = false;
    disableHeroVideoForTesting = false;
  }

  /// Warm first two field-work spotlight videos — call when [FieldWorkScreen] mounts.
  static void preloadFieldWorkSpotlightVideos(double layoutWidth) {
    if (_fieldWorkVideosStarted) return;
    if (MobileWebPerformance.isMobileWebWidth(layoutWidth)) return;
    _fieldWorkVideosStarted = true;
    unawaited(_preloadFieldWorkSpotlightVideos(layoutWidth));
  }

  static Future<void> _preloadFieldWorkSpotlightVideos(double layoutWidth) async {
    if (kIsWeb) {
      await ActivityVideoPlatform.prewarmSpotlightVideos(
        videoAssets: AppContent.activityVideoAssets,
        layoutWidth: layoutWidth,
      );
      return;
    }
    for (final path in AppContent.activityVideoAssets.take(2)) {
      try {
        await rootBundle.load(path);
      } catch (_) {}
    }
  }

  /// Above-fold apps assets — call when [AppsScreen] mounts.
  static Future<void> preloadAppsPageAssets() async {
    if (_appsPageStarted) return;
    _appsPageStarted = true;

    // Tier A — above-fold icons/posters (small, awaited).
    await _loadImageList(_appsPageAboveFoldAssets, (_, __) {});

    // Tier C — app demo video bytes (desktop/tablet web only; device player
    // lazy-loads on mobile web).
    if (!MobileWebPerformance.isMobileWebViewport()) {
      unawaited(rootBundle.load(AppContent.assetAppPageVideo));
    }
  }

  /// Deferred apps screenshots — call when a deferred section nears viewport.
  static Future<void> preloadAppsDeferredAssets() async {
    if (_appsDeferredStarted) return;
    if (MobileWebPerformance.isMobileWebViewport()) return;
    _appsDeferredStarted = true;
    await _loadImageListBatched(
      _appsPageDeferredAssets,
      batchSize: kIsWeb ? 2 : 4,
    );
  }

  /// Above-fold book assets — call when [BookStoreScreen] mounts.
  static Future<void> preloadBooksPageAssets() async {
    if (_booksPageStarted) return;
    _booksPageStarted = true;
    await _loadImageList(_booksPageAboveFoldAssets, (_, __) {});
  }

  /// Deferred book assets — shelf panorama and period9 covers.
  static Future<void> preloadBooksDeferredAssets() async {
    if (_booksDeferredStarted) return;
    if (MobileWebPerformance.isMobileWebViewport()) return;
    _booksDeferredStarted = true;
    await _loadImageListBatched(
      _booksPageDeferredAssets,
      batchSize: kIsWeb ? 2 : 4,
    );
  }

  /// Above-fold events assets — call when [EventsScreen] mounts.
  static Future<void> preloadEventsPageAssets() async {
    if (_eventsPageStarted) return;
    _eventsPageStarted = true;
    await _loadImageList(_eventsPageAboveFoldAssets, (_, __) {});
  }

  /// Talisman hero — call when [TalismanStoreScreen] mounts.
  static Future<void> preloadTalismanPageAssets() async {
    if (_talismanPageStarted) return;
    _talismanPageStarted = true;
    await _loadImageList(_talismanPageAboveFoldAssets, (_, __) {});
  }

  /// Mid-page homepage assets — story, field-work thumbs, press logos.
  static Future<void> preloadMidPageHomeAssets() async {
    if (_midPageHomeStarted) return;
    _midPageHomeStarted = true;
    await _loadImageListBatched(
      _midPageHomepageAssets,
      batchSize: kIsWeb ? 2 : 4,
    );
  }

  /// Near-fold Academies / Consultations images — call from viewport approach.
  static Future<void> preloadHomeNearFoldAssets() async {
    if (_nearFoldHomeStarted) return;
    _nearFoldHomeStarted = true;
    await _loadImageListBatched(
      _homeNearFoldAssets,
      batchSize: kIsWeb ? 2 : 4,
    );
  }

  /// Below-fold homepage assets — call from [HomeScreen] on first mount.
  static Future<void> preloadBelowFoldHomepage() async {
    if (_belowFoldStarted) return;
    _belowFoldStarted = true;
    await _loadImageListBatched(
      _belowFoldHomepageAssets,
      batchSize: kIsWeb ? 2 : 4,
    );
  }

  /// Lazily warm testimonial portrait assets for visible carousel pages.
  static Future<void> preloadTestimonialPortraits(List<String> paths) async {
    if (paths.isEmpty) return;
    final pending = paths
        .where((path) => !_preloadedTestimonialPaths.contains(path))
        .toList();
    if (pending.isEmpty) return;
    for (final path in pending) {
      _preloadedTestimonialPaths.add(path);
    }
    await _loadImageListBatched(
      pending,
      batchSize: kIsWeb ? 2 : 4,
    );
  }

  @visibleForTesting
  static int get preloadedTestimonialCount => _preloadedTestimonialPaths.length;

  /// Lazily warm activity story cover images for visible carousel pages.
  static Future<void> preloadActivityStoryCovers(List<String> paths) async {
    if (paths.isEmpty) return;
    final pending = paths
        .where((path) => !_preloadedActivityCoverPaths.contains(path))
        .toList();
    if (pending.isEmpty) return;
    for (final path in pending) {
      _preloadedActivityCoverPaths.add(path);
    }
    await _loadImageListBatched(
      pending,
      batchSize: kIsWeb ? 2 : 4,
    );
  }

  @visibleForTesting
  static int get preloadedActivityCoverCount => _preloadedActivityCoverPaths.length;

  static Future<void> _backgroundPreload() async {
    if (!_belowFoldStarted) {
      await _loadImageListBatched(_belowFoldHomepageAssets);
      _belowFoldStarted = true;
    }
    await _loadImageListBatched(_restImageAssets);
    if (!disableBackgroundFontsForTesting) {
      _triggerOtherLocaleFontsInBackground();
      try {
        await GoogleFonts.pendingFonts().timeout(
          const Duration(seconds: 2),
          onTimeout: () => <void>[],
        );
      } catch (_) {}
    }
  }

  static Future<void> _loadImageList(
    List<String> paths,
    void Function(int completed, int total) onProgress,
  ) async {
    final total = paths.length;
    var completed = 0;
    for (final path in paths) {
      try {
        await rootBundle.load(path);
      } catch (_) {}
      completed++;
      onProgress(completed, total);
    }
  }

  static Future<void> _loadImageListBatchedWithProgress(
    List<String> paths,
    void Function(int completed, int total) onProgress, {
    int batchSize = 6,
  }) async {
    final total = paths.length;
    if (total == 0) {
      onProgress(0, 0);
      return;
    }
    var completed = 0;
    for (var i = 0; i < paths.length; i += batchSize) {
      final batch = paths.skip(i).take(batchSize);
      await Future.wait(
        batch.map((path) async {
          try {
            await rootBundle.load(path);
          } catch (_) {}
        }),
      );
      completed += batch.length;
      onProgress(completed.clamp(0, total), total);
    }
  }

  /// Loads images in parallel batches to warm the asset bundle without blocking long.
  static Future<void> _loadImageListBatched(List<String> paths, {int batchSize = 6}) async {
    await _loadImageListBatchedWithProgress(
      paths,
      (_, __) {},
      batchSize: batchSize,
    );
  }

  static Future<void> _decodeImageListBatchedWithProgress(
    List<String> paths,
    void Function(int completed, int total) onProgress, {
    int batchSize = 4,
  }) async {
    final total = paths.length;
    if (total == 0) {
      onProgress(0, 0);
      return;
    }
    var completed = 0;
    for (var i = 0; i < paths.length; i += batchSize) {
      final batch = paths.skip(i).take(batchSize);
      await Future.wait(batch.map(_decodeImageAtPath));
      completed += batch.length;
      onProgress(completed.clamp(0, total), total);
    }
  }

  static Future<void> _decodeImageAtPath(String path) async {
    try {
      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List();
      final completer = Completer<void>();
      ui.decodeImageFromList(bytes, (_) {
        if (!completer.isCompleted) completer.complete();
      });
      await completer.future;
    } catch (_) {}
  }

  static Future<void> _loadMainFonts() async {
    try {
      GoogleFonts.exo2(fontSize: 14);
      GoogleFonts.condiment(fontSize: 14);
      GoogleFonts.siemreap(fontSize: 14);
      GoogleFonts.notoSansSc(fontSize: 14);
      await GoogleFonts.pendingFonts().timeout(
        const Duration(milliseconds: 1500),
        onTimeout: () => <void>[],
      );
    } catch (_) {}
  }

  static void _triggerOtherLocaleFontsInBackground() {
    try {
      GoogleFonts.dangrek(fontSize: 14);
    } catch (_) {}
  }
}
