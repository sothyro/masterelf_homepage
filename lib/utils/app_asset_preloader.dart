import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_content.dart';
import 'hero_video_preloader.dart';

/// Best practice: critical assets first; only block on main fonts (Exo 2 + Condiment).
/// Weights: critical (logo + hero image + video) 50%, rest images 30%, main fonts 20%.
const double _criticalWeight = 0.50;
const double _restImagesWeight = 0.30;

/// Critical for first paint: logo and hero background (video loads right after).
List<String> get _criticalImageAssets => [
  AppContent.assetLogo,
  AppContent.assetHeroBackground,
];

/// Rest of images (below-the-fold); loaded after critical.
List<String> get _restImageAssets => [
  AppContent.assetBackgroundDirection,
  AppContent.assetEventCard,
  AppContent.assetEventMain,
  AppContent.assetAboutHero,
  AppContent.assetStoryBackground,
  AppContent.assetTestimonialProfile,
  AppContent.assetTestimonialParticipant,
  AppContent.assetAcademy,
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

  /// Critical path first (logo, hero image, video), then rest of images, then main fonts (Exo 2 + Condiment).
  /// Dangrek, Siemreap, Noto Sans SC are triggered in background for locale switch.
  static Future<void> preloadAll(void Function(double progress) onProgress) async {
    onProgress(0.0);

    // 1) Critical images then video — 0% → 50%
    await _loadImageList(_criticalImageAssets, (completed, total) {
      final fraction = total > 0 ? completed / total : 1.0;
      onProgress(_criticalWeight * 0.6 * fraction);
    });
    onProgress(_criticalWeight * 0.6);
    await _loadVideo();
    onProgress(_criticalWeight);

    // 2) Rest of images — 50% → 80%
    await _loadImageList(_restImageAssets, (completed, total) {
      final fraction = total > 0 ? completed / total : 1.0;
      onProgress(_criticalWeight + _restImagesWeight * fraction);
    });

    // 3) Main fonts only (Exo 2 + Condiment). Other locales load in background.
    await _loadMainFonts();
    _triggerOtherLocaleFontsInBackground();
    onProgress(1.0);
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

  /// Trigger KH/ZH fonts in background so they're ready if user switches locale.
  static void _triggerOtherLocaleFontsInBackground() {
    GoogleFonts.dangrek(fontSize: 14);
    GoogleFonts.siemreap(fontSize: 14);
    GoogleFonts.notoSansSc(fontSize: 14);
  }
}
