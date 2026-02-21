import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_content.dart';

// ---------------------------------------------------------------------------
// Critical path: logo + hero image only. Video loads in the hero section
// after the app is visible (standard practice; avoids web asset URL issues).
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

  /// Critical path: logo + hero image. Hero video loads in the hero section.
  static Future<void> preloadAll(void Function(double progress) onProgress) async {
    onProgress(0.0);

    await _loadImageList(_criticalImageAssets, (completed, total) {
      onProgress(total > 0 ? completed / total : 1.0);
    });
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
