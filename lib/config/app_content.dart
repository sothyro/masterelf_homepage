/// Central content and contact from INFORMATION_NEEDED.md.
/// Update here when client provides final copy.
class AppContent {
  AppContent._();

  // §1 Brand
  static const String companyName = 'Master Elf Feng Shui';
  static const String shortName = 'Master Elf';
  static const String legalEntity = 'Master Elf Feng Shui Co., Ltd.';

  // §3 Contact (from "Current in code" / INFORMATION_NEEDED)
  static const String phonePrimary = '012 222 211';
  static const String phoneSecondary = '090 222 211';
  static const String email = '8@masterelf.vip';
  static const String websiteUrl = 'https://www.masterelf.vip';
  /// WhatsApp: country code + number no spaces (e.g. 85512222211 for Cambodia 12 222 211)
  static const String whatsAppNumber = '85512222211';
  static const String addressLine = '#23-25, Street V07, Victory City, Steung Meanchey';

  // Office 1 (Cambodia / Phnom Penh)
  static const String office1Label = 'Cambodia Office';
  static const String office1Company = companyName;
  static const String office1Address = '#23-25, Street V07, Victory City, Steung Mean Chey, Phnom Penh, Cambodia, 12000';
  static const String office1Phone = '+855-12 222211';
  static const String office1PhoneSecondary = '+855 90 222 211';

  // §4 Social (Facebook, TikTok, Telegram shown in footer)
  static const String facebookUrl = 'https://www.facebook.com/masterelf';
  static const String? instagramUrl = null;
  static const String tiktokUrl = 'https://www.tiktok.com/@masterelf';
  static const String? youtubeUrl = null;
  static const String telegramUrl = 'https://t.me/hongchhayheng';
  static const String? linkedInUrl = null;

  /// Telegram group for Media & Posts dialog (same as telegramUrl)
  static const String telegramGroupUrl = 'https://t.me/hongchhayheng';

  /// Explore Courses / Academy link (e.g. charter.masterelf.vip)
  static const String academyExploreUrl = 'https://charter.masterelf.vip';

  /// Master Elf System (BaZi etc.) – open in browser
  static const String baziSystemUrl = 'https://bazi.masterelf.vip';

  /// Period 9 Mobile App – replace with real store URLs when available
  static const String? period9AppStoreUrl = null;
  static const String? period9PlayStoreUrl = null;

  /// Appointment booking API: POST booking details; backend sends SMS confirmation via Unimatrix.
  /// Leave empty to use demo mode (success UI only, no HTTP call).
  static const String appointmentBookingApiUrl = '';

  // Asset paths (§1, §2, §8, §9 – use images from assets folder)
  /// Logo for header; favicon can use same. Use assets/icons/logo.png when available.
  static const String assetLogo = 'assets/icons/logo.png';
  static const String assetFavicon = 'assets/icons/logo.png';
  static const String assetHeroBackground = 'assets/images/main.jpg';
  static const String assetBackgroundDirection = 'assets/images/backgrounddirection.jpg';
  static const String assetHeroVideo = 'assets/videos/videobackground720.mp4';
  static const String assetEventCard = 'assets/images/event.jpg';
  static const String assetEventMain = 'assets/images/main event.jpg';
  static const String assetAboutHero = 'assets/images/sessions.jpg';
  /// Story section image (portrait).
  static const String assetStoryBackground = 'assets/images/story.PNG';
  static const String assetTestimonialProfile = 'assets/images/profile.jpg';
  static const String assetTestimonialParticipant = 'assets/images/participant2.jpg';
  static const String assetAcademy = 'assets/images/apps.jpg';
  /// Consultation / appointments page (Smart Move cards).
  static const String assetConsultation = 'assets/images/consultation.jpg';
  /// BaZi Harmony card image on main page (Academies section).
  static const String assetBaziHarmony = 'assets/icons/baziharmony.jpg';
  /// QiMen card image on main page (Academies section).
  static const String assetAcademyQiMen = 'assets/icons/qimendunjia.jpg';
  /// Feng Shui card image on main page (Academies section).
  static const String assetAcademyFengShui = 'assets/images/backgrounddirection.jpg';

  // Apps page showcase (assets/images/apps/)
  /// Apps page hero banner
  static const String assetAppsHero = 'assets/images/hero1x.jpg';
  static const String assetAppQiMen = 'assets/images/apps/qimen.jpg';
  static const String assetAppBaziLife = 'assets/images/apps/bazi_life.jpg';
  static const String assetAppBaziReport = 'assets/images/apps/bazi_report.jpg';
  static const String assetAppBaziAge = 'assets/images/apps/bazi_age.jpg';
  static const String assetAppBaziStars = 'assets/images/apps/bazi_stars.jpg';
  static const String assetAppBaziKhmer = 'assets/images/apps/bazi_khmer.jpg';
  static const String assetAppBaziPage2 = 'assets/images/apps/bazi_page2.jpg';
  static const String assetAppDateSelection = 'assets/images/apps/dateselection.jpg';
  static const String assetAppMarriage = 'assets/images/apps/marriage.jpg';
  static const String assetAppBusinessPartner = 'assets/images/apps/business_partner.jpg';
  static const String assetAppAdvancedFeatures = 'assets/images/apps/advancedfeatures.jpg';
  /// Period 9 mobile app screenshots
  static const String assetPeriod9_1 = 'assets/images/apps/period9_1.JPG';
  static const String assetPeriod9_2 = 'assets/images/apps/period9_2.JPG';
}
