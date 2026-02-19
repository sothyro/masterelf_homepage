import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_content.dart';
import 'hero_video_preloader.dart';

// ---------------------------------------------------------------------------
// Critical path: logo + hero image + hero video. Page is revealed only when
// all are ready so the video is fully buffered and plays smoothly. Progress
// bar reflects real loading: ~20% images, ~80% video (by weight).
// ---------------------------------------------------------------------------

/// Weight of critical images in the 0–100% progress (video gets the rest).
const double _criticalImagesWeight = 0.2;

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

/// Preloads critical path (logo + hero image + hero video); reports progress 0.0 → 1.0.
/// Page is revealed only when progress reaches 1.0 so the video is buffered and ready.
/// Rest images and other-locale fonts load in background after reveal.
class AppAssetPreloader {
  AppAssetPreloader._();

  /// Critical path: logo + hero image + hero video. Progress is accurate:
  /// images contribute [_criticalImagesWeight], video contributes the rest (buffered %).
  /// Reaches 1.0 only when all are ready so the page can show with smooth video.
  static Future<void> preloadAll(void Function(double progress) onProgress) async {
    onProgress(0.0);

    double imageProgress = 0.0;
    double videoProgress = 0.0;

    void reportCombined() {
      final combined = (imageProgress * _criticalImagesWeight) +
          (videoProgress * (1.0 - _criticalImagesWeight));
      onProgress(combined.clamp(0.0, 1.0));
    }

    // Load critical images and hero video in parallel; both must complete before reveal.
    await Future.wait([
      _loadImageList(_criticalImageAssets, (completed, total) {
        imageProgress = total > 0 ? completed / total : 1.0;
        reportCombined();
      }).then((_) {
        imageProgress = 1.0;
        reportCombined();
      }),
      HeroVideoPreloader.preload((v) {
        videoProgress = v;
        reportCombined();
      }).then((_) {
        videoProgress = 1.0;
        reportCombined();
      }).catchError((_) {
        videoProgress = 1.0;
        reportCombined();
      }),
    ]);

    onProgress(1.0);

    // Background: fonts and rest images (no blocking)
    unawaited(_backgroundPreload());
  }

  static Future<void> _backgroundPreload() async {
    _triggerOtherLocaleFontsInBackground();
    await _loadMainFonts();
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
