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
  static const String? facebookUrl = 'https://www.facebook.com/masterelf';
  static const String? instagramUrl = null;
  static const String? tiktokUrl = 'https://www.tiktok.com/@masterelf';
  static const String? youtubeUrl = null;
  static const String? telegramUrl = null;
  static const String? linkedInUrl = null;

  /// Explore Courses / Academy link (e.g. charter.masterelf.vip)
  static const String academyExploreUrl = 'https://charter.masterelf.vip';

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
  static const String assetTestimonialProfile = 'assets/images/profile.jpg';
  static const String assetTestimonialParticipant = 'assets/images/participant2.jpg';
  static const String assetAcademy = 'assets/images/apps.jpg';
}
