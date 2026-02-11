import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_content.dart';
import 'hero_video_preloader.dart';

// ---------------------------------------------------------------------------
// ROOT CAUSE OF SLOW FIRST LOAD (critical inspection):
// - App blocked on preloadAll() until 100%: hero video (~10 MB), 28 images,
//   and 5 font families with long waits. FIX: Show app after critical path
//   only (logo + hero image). Fonts, video, and rest images load in background.
// ---------------------------------------------------------------------------

/// Critical for first paint: logo (header) and hero background (fallback/static).
List<String> get _criticalImageAssets => [
  AppContent.assetLogo,
  AppContent.assetHeroBackground,
];

/// Images for home below-the-fold and other pages; loaded in background after app is visible.
List<String> get _restImageAssets => [
  AppContent.assetBackgroundDirection,
  AppContent.assetEventCard,
  AppContent.assetEventMain,
  AppContent.assetAboutHero,
  AppContent.assetStoryBackground,
  AppContent.assetTestimonialProfile,
  AppContent.assetTestimonialParticipant,
  AppContent.assetTestimonialPanhaLeakhena,
  AppContent.assetTestimonialMoon,
  AppContent.assetTestimonialRithy,
  AppContent.assetTestimonialVanna,
  AppContent.assetTestimonialThida,
  AppContent.assetTestimonialZeiitey,
  AppContent.assetAcademy,
  AppContent.assetBaziHarmony,
  AppContent.assetAcademyQiMen,
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
];

/// Preloads only what's needed for first paint; reports progress 0.0 → 1.0.
/// Call [preloadAll] at startup. When it reaches 1.0, the app is shown. Video,
/// rest images, and other-locale fonts continue loading in background.
class AppAssetPreloader {
  AppAssetPreloader._();

  /// Critical path only: logo + hero image. Reaches 1.0 as soon as those are
  /// loaded so the app can show. Fonts, video, and rest images load in background
  /// (brief FOUT possible until main fonts finish).
  static Future<void> preloadAll(void Function(double progress) onProgress) async {
    onProgress(0.0);

    // 1) Critical images only (logo + hero background) — then show app
    await _loadImageList(_criticalImageAssets, (completed, total) {
      final fraction = total > 0 ? completed / total : 1.0;
      onProgress(fraction);
    });
    onProgress(1.0);

    // 2) Background: main fonts first (minimize FOUT), then video, rest images, other-locale fonts
    unawaited(_backgroundPreload());
  }

  static Future<void> _backgroundPreload() async {
    _triggerOtherLocaleFontsInBackground();
    await _loadMainFonts();
    try {
      await HeroVideoPreloader.preload();
    } catch (_) {}
    await _loadImageList(_restImageAssets, (_, __) {});
    await GoogleFonts.pendingFonts().timeout(
      const Duration(seconds: 30),
      onTimeout: () => <void>[],
    );
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

  static Future<void> _loadMainFonts() async {
    GoogleFonts.exo2(fontSize: 14);
    GoogleFonts.condiment(fontSize: 14);
    await GoogleFonts.pendingFonts().timeout(
      const Duration(milliseconds: 1500),
      onTimeout: () => <void>[],
    );
  }

  static void _triggerOtherLocaleFontsInBackground() {
    GoogleFonts.dangrek(fontSize: 14);
    GoogleFonts.siemreap(fontSize: 14);
    GoogleFonts.notoSansSc(fontSize: 14);
  }
}
