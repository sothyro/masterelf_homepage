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
// Tier 2 — above-fold homepage (blocks bootstrap).
// Tier 3 — below-fold homepage (background after reveal).
// Tier 4 — other pages (background only).
// The hero video is pre-warmed during bootstrap (phase 5) on web; native uses
// the same asset via [HeroVideoController].
// ---------------------------------------------------------------------------

/// Critical for first paint: logo (header) and hero background (fallback/static).
List<String> get _criticalImageAssets => [
  AppContent.assetLogo,
  AppContent.assetHeroBackground,
];

/// Above-the-fold homepage images (events, academies, consultations, featured-in).
List<String> get _aboveFoldHomepageAssets => [
  AppContent.assetEventMain,
  AppContent.assetEvent2027,
  AppContent.assetEvent2026FengShui,
  AppContent.assetEvent2026CrimsonHorse,
  AppContent.assetBackgroundDirection,
  AppContent.assetAcademy,
  AppContent.assetBaziHarmony,
  AppContent.assetAcademyQiMen,
  AppContent.assetPeriod9Book1,
  AppContent.assetPeriod9Book2,
  AppContent.assetActivityFengShui,
  AppContent.assetActivityConsultation,
  AppContent.assetActivityMaoShan,
  AppContent.assetActivityDateSelection,
  ...AppContent.featuredPressLogos,
];

/// Subset decoded to GPU on desktop web before reveal (hero poster + first
/// sections) to avoid first-paint decode jank without risking mobile tab OOM.
List<String> get _webCriticalDecodeAssets => [
  AppContent.assetHeroBackground,
  AppContent.assetEventMain,
  AppContent.assetEvent2027,
  AppContent.assetEvent2026FengShui,
  AppContent.assetEvent2026CrimsonHorse,
  AppContent.assetAcademy,
  AppContent.assetBaziHarmony,
  AppContent.assetAcademyQiMen,
];

/// Below-fold homepage images — preload after bootstrap (story only; no testimonials on home).
List<String> get _belowFoldHomepageAssets => [
  AppContent.assetStoryBackground,
];

/// Testimonial portraits — deferred to background tier (not home below-fold).
List<String> get _testimonialImageAssets => [
  AppContent.assetTestimonialProfile,
  AppContent.assetTestimonialParticipant,
  AppContent.assetTestimonialPanhaLeakhena,
  AppContent.assetTestimonialMoon,
  AppContent.assetTestimonialRithy,
  AppContent.assetTestimonialVanna,
  AppContent.assetTestimonialThida,
  AppContent.assetTestimonialZeiitey,
  AppContent.assetTestimonial7,
  AppContent.assetTestimonial8,
  AppContent.assetTestimonial9,
  AppContent.assetTestimonial10,
  AppContent.assetTestimonial11,
  AppContent.assetTestimonial12,
  AppContent.assetTestimonial13,
  AppContent.assetTestimonial14,
  AppContent.assetTestimonial15,
  AppContent.assetTestimonial16,
  AppContent.assetTestimonial17,
  AppContent.assetTestimonial18,
];

/// App screenshots — above-fold subset for first paint on /apps.
List<String> get _appsPageAboveFoldAssets => [
  AppContent.assetYuk9Icon,
  ...AppContent.appShowcaseAboveFoldAssets,
];

/// Remaining apps page screenshots — deferred after first paint.
List<String> get _appsPageDeferredAssets => AppContent.appShowcaseDeferredAssets;

/// Remaining images for other pages; loaded in background after homepage tiers.
List<String> get _restImageAssets => [
  AppContent.assetAboutHero,
  AppContent.assetEventHero,
  AppContent.assetActivitiesHero,
  AppContent.assetAppsHero,
  AppContent.assetPeriod9_1,
  AppContent.assetPeriod9_2,
  for (var i = 1; i <= 8; i++) AppContent.assetActivityPhoto(i),
  AppContent.assetActivityPhoto(15),
  AppContent.assetActivityPhoto(27),
  ..._testimonialImageAssets,
];

/// Preloads above-fold homepage assets before reveal; below-fold + rest in background.
class AppAssetPreloader {
  AppAssetPreloader._();

  static bool _belowFoldStarted = false;
  static bool _appsPageStarted = false;
  static bool _fieldWorkVideosStarted = false;

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
  static int get aboveFoldAssetCount => _aboveFoldHomepageAssets.length;

  @visibleForTesting
  static int get belowFoldAssetCount => _belowFoldHomepageAssets.length;

  /// Phased bootstrap preload: critical → above-fold → decode → fonts →
  /// hero video prewarm → homepage render gate → reveal.
  ///
  /// [waitForFirstPaint] (usually `HomeReadiness.ready`) keeps the final
  /// progress step pending until the homepage has fully mounted and painted;
  /// pass null when the initial route is not the homepage.
  static Future<void> preloadAll(
    void Function(double progress) onProgress, {
    Future<void>? waitForFirstPaint,
  }) async {
    onProgress(0.0);

    // Start hero video load in parallel (web: native HTML video; does not block
    // loader dismiss — poster stays until canplaythrough).
    if (!disableHeroVideoForTesting &&
        MobileWebPerformance.shouldPrewarmHeroVideo()) {
      unawaited(HeroVideoPlatform.prewarm());
    }

    // Phase 1 — critical (0 → 20%)
    await _loadImageList(_criticalImageAssets, (completed, total) {
      onProgress(0.20 * (total > 0 ? completed / total : 1.0));
    });
    // Phase 2 — above-fold bundle (20 → 55%)
    final webBatchSize = kIsWeb ? 3 : 6;
    await _loadImageListBatchedWithProgress(
      _aboveFoldHomepageAssets,
      (completed, total) {
        onProgress(0.20 + 0.35 * (total > 0 ? completed / total : 1.0));
      },
      batchSize: webBatchSize,
    );

    // Phase 3 — GPU decode (55 → 65%). Native decodes all above-fold assets;
    // desktop web decodes the critical subset; mobile web skips (tab OOM risk).
    if (!disableImageDecodeForTesting) {
      final decodeAssets = kIsWeb
          ? (MobileWebPerformance.isMobileWebViewport()
              ? const <String>[]
              : _webCriticalDecodeAssets)
          : _aboveFoldHomepageAssets;
      if (decodeAssets.isNotEmpty) {
        await _decodeImageListBatchedWithProgress(
          decodeAssets,
          (completed, total) {
            onProgress(0.55 + 0.10 * (total > 0 ? completed / total : 1.0));
          },
        );
      }
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
    _belowFoldStarted = false;
    _appsPageStarted = false;
    _fieldWorkVideosStarted = false;
    disableBackgroundFontsForTesting = false;
    disableImageDecodeForTesting = false;
    disableHeroVideoForTesting = false;
  }

  /// Warm first two field-work spotlight videos — call when [FieldWorkScreen] mounts.
  static void preloadFieldWorkSpotlightVideos(double layoutWidth) {
    if (_fieldWorkVideosStarted) return;
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

  /// App demo video + screenshot PNGs — call when [AppsScreen] mounts.
  static Future<void> preloadAppsPageAssets() async {
    if (_appsPageStarted) return;
    _appsPageStarted = true;

    // Tier A — above-fold icons/posters (small, awaited).
    await _loadImageList(_appsPageAboveFoldAssets, (_, __) {});

    // Tier C — app demo video bytes (non-blocking).
    unawaited(rootBundle.load(AppContent.assetAppPageVideo));

    // Tier D — remaining showcase PNGs (non-blocking batched warm).
    unawaited(
      _loadImageListBatched(
        _appsPageDeferredAssets,
        batchSize: kIsWeb ? 2 : 4,
      ),
    );
  }

  /// Below-fold homepage assets — call from [HomeScreen] on first mount.
  static Future<void> preloadBelowFoldHomepage() async {
    if (_belowFoldStarted) return;
    _belowFoldStarted = true;
    await _loadImageListBatched(_belowFoldHomepageAssets);
  }

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
