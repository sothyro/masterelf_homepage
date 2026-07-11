import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_content.dart';

// ---------------------------------------------------------------------------
// Tier 1 — critical first paint (logo + hero static background).
// Tier 2 — above-fold homepage (blocks bootstrap).
// Tier 3 — below-fold homepage (background after reveal).
// Tier 4 — other pages (background only).
// Hero video loads in the hero section after reveal.
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

/// Below-fold homepage images — preload after bootstrap, before lazy sections mount.
List<String> get _belowFoldHomepageAssets => [
  AppContent.assetStoryBackground,
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

/// Remaining images for other pages; loaded in background after homepage tiers.
List<String> get _restImageAssets => [
  AppContent.assetAboutHero,
  AppContent.assetEventHero,
  AppContent.assetActivitiesHero,
  AppContent.assetAppsHero,
  AppContent.assetAppQiMen,
  AppContent.assetAppBaziLife,
  AppContent.assetAppBaziReport,
  AppContent.assetAppBaziAge,
  AppContent.assetAppBaziStars,
  AppContent.assetAppBaziKhmer,
  AppContent.assetAppBaziPage2,
  AppContent.assetAppDateSelection,
  AppContent.assetAppMarriage,
  AppContent.assetAppBusinessPartner,
  AppContent.assetAppAdvancedFeatures,
  AppContent.assetPeriod9_1,
  AppContent.assetPeriod9_2,
  for (var i = 1; i <= 8; i++) AppContent.assetActivityPhoto(i),
  AppContent.assetActivityPhoto(15),
  AppContent.assetActivityPhoto(27),
];

/// Preloads above-fold homepage assets before reveal; below-fold + rest in background.
class AppAssetPreloader {
  AppAssetPreloader._();

  static bool _belowFoldStarted = false;

  /// When true, skips network font work during bootstrap (tests only).
  @visibleForTesting
  static bool disableBackgroundFontsForTesting = false;

  /// When true, skips GPU decode during bootstrap (tests only).
  @visibleForTesting
  static bool disableImageDecodeForTesting = false;

  @visibleForTesting
  static int get aboveFoldAssetCount => _aboveFoldHomepageAssets.length;

  @visibleForTesting
  static int get belowFoldAssetCount => _belowFoldHomepageAssets.length;

  /// Phased bootstrap preload: critical → above-fold → decode → fonts → reveal.
  static Future<void> preloadAll(void Function(double progress) onProgress) async {
    onProgress(0.0);

    // Phase 1 — critical (0 → 25%)
    await _loadImageList(_criticalImageAssets, (completed, total) {
      onProgress(0.25 * (total > 0 ? completed / total : 1.0));
    });
    // Phase 2 — above-fold bundle (25 → 85%)
    await _loadImageListBatchedWithProgress(
      _aboveFoldHomepageAssets,
      (completed, total) {
        onProgress(0.25 + 0.60 * (total > 0 ? completed / total : 1.0));
      },
    );

    // Phase 3 — decode above-fold (85 → 92%)
    if (!disableImageDecodeForTesting) {
      await _decodeImageListBatchedWithProgress(
        _aboveFoldHomepageAssets,
        (completed, total) {
          onProgress(0.85 + 0.07 * (total > 0 ? completed / total : 1.0));
        },
      );
    } else {
      onProgress(0.92);
    }

    // Phase 4 — main fonts (92 → 100%)
    onProgress(0.92);
    if (!disableBackgroundFontsForTesting) {
      await _loadMainFonts();
    }
    onProgress(1.0);

    unawaited(_runBackgroundPreloadSafely());
  }

  static Future<void> _runBackgroundPreloadSafely() async {
    await runZonedGuarded(() async {
      try {
        await _backgroundPreload();
      } catch (_) {}
    }, (_, __) {});
  }

  @visibleForTesting
  static void resetForTesting() {
    _belowFoldStarted = false;
    disableBackgroundFontsForTesting = false;
    disableImageDecodeForTesting = false;
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
