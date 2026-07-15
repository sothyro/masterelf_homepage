import 'dart:io';

import 'package:masterelf_homepage/config/app_content.dart';

/// Max allowed file size for app UI mockup screenshots.
const int maxAppMockupImageBytes = 400 * 1024;

/// Max allowed file size for testimonial / activity card photos.
const int maxCardPhotoImageBytes = 240 * 1024;

/// Max allowed file size for hero / section backgrounds.
const int maxHeroImageBytes = 400 * 1024;

/// Max allowed file size for icons and press logos.
const int maxIconImageBytes = 300 * 1024;

int _maxBytesForAsset(String path) {
  final normalized = path.replaceAll('\\', '/').toLowerCase();
  if (normalized.contains('/images/apps/')) {
    return maxAppMockupImageBytes;
  }
  if (normalized.contains('/testimonials/') ||
      normalized.contains('/images/activities/')) {
    return maxCardPhotoImageBytes;
  }
  if (normalized.contains('/icons/') || normalized.contains('/cl/')) {
    return maxIconImageBytes;
  }
  return maxHeroImageBytes;
}

/// All raster image asset paths shipped in release builds.
List<String> get releaseImageAssets {
  final assets = <String>{
    AppContent.assetLogo,
    AppContent.assetFavicon,
    AppContent.assetYuk9Icon,
    AppContent.assetHeroBackground,
    AppContent.assetBackgroundDirection,
    AppContent.assetEventCard,
    AppContent.assetEventMain,
    AppContent.assetEvent2027,
    AppContent.assetEvent2026FengShui,
    AppContent.assetEvent2026CrimsonHorse,
    AppContent.assetEventHero,
    AppContent.assetActivitiesHero,
    AppContent.assetVenueChipmong,
    AppContent.assetVenueLegendCinema,
    AppContent.assetAboutHero,
    AppContent.assetSessions,
    AppContent.assetParticipants,
    AppContent.assetRegistration,
    AppContent.assetDirection,
    AppContent.assetContactHero,
    AppContent.assetJourneyHero,
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
    AppContent.assetTestimonialHena,
    AppContent.assetTestimonialSokha,
    AppContent.assetTestimonialPisey,
    AppContent.assetTestimonialAiichen,
    AppContent.assetTestimonialHengyang,
    AppContent.assetTestimonialChanra,
    AppContent.assetTestimonialDeth,
    AppContent.assetTestimonialLinger,
    AppContent.assetTestimonialOunnpovv,
    AppContent.assetTestimonialMuysorng,
    AppContent.assetTestimonialSokunna,
    AppContent.assetTestimonialSaly,
    AppContent.assetTestimonialRina,
    AppContent.assetTestimonialChung,
    AppContent.assetAcademy,
    AppContent.assetConsultation,
    AppContent.assetActivityFengShui,
    AppContent.assetActivityConsultation,
    AppContent.assetActivityMaoShan,
    AppContent.assetActivityDateSelection,
    AppContent.assetBetterOption,
    AppContent.assetBaziHarmony,
    AppContent.assetAcademyQiMen,
    AppContent.assetAcademyFengShui,
    AppContent.assetAppsHero,
    ...AppContent.appShowcaseImageAssets,
    AppContent.assetBook1,
    AppContent.assetBook2,
    AppContent.assetBook3,
    AppContent.assetBook4,
    AppContent.assetBook5,
    AppContent.assetShelfMockupFiveBlessings,
    AppContent.assetPeriod9Book1,
    AppContent.assetPeriod9Book2,
    ...AppContent.featuredPressLogos,
    for (var n = 1; n <= 29; n++) AppContent.assetActivityPhoto(n),
  };
  return assets.toList()..sort();
}

/// Returns false when any required release image is missing, not WebP, or too large.
bool verifyReleaseImages({void Function(String message)? logError}) {
  var ok = true;
  void fail(String message) {
    ok = false;
    logError?.call(message);
  }

  for (final path in releaseImageAssets) {
    if (!path.endsWith('.webp')) {
      fail('Release image must be WebP: $path');
      continue;
    }

    final file = File(path);
    if (!file.existsSync()) {
      fail('Missing required release image: $path');
      continue;
    }

    final size = file.lengthSync();
    final maxBytes = _maxBytesForAsset(path);
    if (size > maxBytes) {
      final sizeKb = (size / 1024).toStringAsFixed(1);
      final maxKb = (maxBytes / 1024).toStringAsFixed(0);
      fail(
        'Release image too large: $path (${sizeKb} KB; max ${maxKb} KB). '
        'Re-encode with .\\tool\\encode_images.ps1 (see README.md).',
      );
    }
  }

  return ok;
}
