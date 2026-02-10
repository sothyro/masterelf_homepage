import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_content.dart';
import 'hero_video_preloader.dart';

/// Load critical assets before showing the main page so video plays smoothly,
/// images display correctly, and all fonts are fully loaded and rendered.
/// Weights: critical (logo + hero image + video) 50%, rest images 30%, fonts 20%.
const double _criticalWeight = 0.50;
const double _restImagesWeight = 0.30;

/// Critical for first paint: logo and hero background (video loads right after).
List<String> get _criticalImageAssets => [
  AppContent.assetLogo,
  AppContent.assetHeroBackground,
];

/// All other images (home and other screens); loaded after critical so nothing pops in.
List<String> get _restImageAssets => [
  AppContent.assetBackgroundDirection,
  AppContent.assetEventCard,
  AppContent.assetEventMain,
  AppContent.assetAboutHero,
  AppContent.assetStoryBackground,
  AppContent.assetTestimonialProfile,
  AppContent.assetTestimonialParticipant,
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

/// Preloads hero video, images, and Google Fonts; reports progress 0.0 → 1.0.
/// Call [preloadAll] at startup and use [onProgress] to drive a determinate progress bar.
class AppAssetPreloader {
  AppAssetPreloader._();

  /// Critical path first: logo + hero image, then video, then all images, then all fonts.
  /// Main page is shown only when everything is ready so video plays smoothly, images display correctly, and fonts render without FOUT.
  static Future<void> preloadAll(void Function(double progress) onProgress) async {
    onProgress(0.0);

    // 1) Critical images (logo + hero background)
    await _loadImageList(_criticalImageAssets, (completed, total) {
      final fraction = total > 0 ? completed / total : 1.0;
      onProgress(_criticalWeight * 0.6 * fraction);
    });
    onProgress(_criticalWeight * 0.6);

    // 2) Hero video — must finish so video plays smoothly when hero is shown
    await _loadVideo();
    onProgress(_criticalWeight);

    // 3) Rest of images — so all images display correctly with no pop-in
    await _loadImageList(_restImageAssets, (completed, total) {
      final fraction = total > 0 ? completed / total : 1.0;
      onProgress(_criticalWeight + _restImagesWeight * fraction);
    });

    // 4) All fonts: trigger main + other locales, then wait for all so text renders correctly.
    // Report progress during this phase so the bar doesn't sit at 80% (0.8) while fonts load.
    _triggerOtherLocaleFontsInBackground();
    onProgress(0.82);
    await _loadMainFonts();
    onProgress(0.90);
    // While waiting for other-locale fonts, inch progress toward 99% so the UI keeps moving.
    final fontWait = _awaitOtherLocaleFonts();
    const step = Duration(milliseconds: 400);
    const stepsUntil99 = 24; // ~9.6s of 0.9 -> 0.99
    for (int i = 0; i <= stepsUntil99; i++) {
      // Update progress at start of each step so 90%, 91%, ... are always shown.
      onProgress((0.90 + (0.09 * (i / stepsUntil99).clamp(0.0, 1.0))).clamp(0.0, 0.99));
      final done = await Future.any<bool>([
        fontWait.then((_) => true),
        Future<void>.delayed(step).then((_) => false),
      ]);
      if (done) break;
    }
    await fontWait;
    // Always ramp visibly to 100% so the user sees the bar complete before the page is shown.
    onProgress(0.95);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    onProgress(0.98);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    onProgress(1.0);
  }

  /// Awaits KH/ZH fonts so all locale fonts are ready before showing the app.
  static Future<void> _awaitOtherLocaleFonts() async {
    await GoogleFonts.pendingFonts().timeout(
      const Duration(seconds: 20),
      onTimeout: () => <void>[],
    );
  }

  static Future<void> _loadVideo() async {
    try {
      await HeroVideoPreloader.preload();
    } catch (_) {
      // Continue so app still shows; hero can fallback.
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

  /// Wait only for main fonts (Exo 2 + Condiment) used for default locale.
  static Future<void> _loadMainFonts() async {
    GoogleFonts.exo2(fontSize: 14);
    GoogleFonts.condiment(fontSize: 14);
    await GoogleFonts.pendingFonts().timeout(
      const Duration(seconds: 5),
      onTimeout: () => <void>[],
    );
  }

  /// Trigger KH/ZH fonts and ensure they load in background so switching to Chinese/Khmer is fast.
  static void _triggerOtherLocaleFontsInBackground() {
    GoogleFonts.dangrek(fontSize: 14);
    GoogleFonts.siemreap(fontSize: 14);
    GoogleFonts.notoSansSc(fontSize: 14);
  }
}
