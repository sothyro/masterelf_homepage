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
  static const String addressLine =
      '#23-25, Street V07, Victory City, Steung Meanchey';

  // Office 1 (Cambodia / Phnom Penh)
  static const String office1Label = 'Cambodia Office';
  static const String office1Company = companyName;
  static const String office1Address =
      '#23-25, Street V07, Victory City, Steung Mean Chey, Phnom Penh, Cambodia, 12000';
  static const String office1Phone = '+855-12 222211';
  static const String office1PhoneSecondary = '+855 90 222 211';

  // §4 Social (Facebook, TikTok, Telegram shown in footer)
  static const String facebookUrl = 'https://www.facebook.com/masterelf.vip';
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
  /// Logo for header; favicon can use same. Monochrome logo for tinting (e.g. accent).
  static const String assetLogo = 'assets/icons/logomono.png';
  static const String assetFavicon = 'assets/icons/logomono.png';

  /// Apps page hero medallion (Period 9 / phoenix emblem).
  static const String assetYuk9Icon = 'assets/icons/yuk9icon.png';
  static const String assetHeroBackground = 'assets/images/main.jpg';
  static const String assetBackgroundDirection =
      'assets/images/backgrounddirection.jpg';
  static const String assetHeroVideo = 'assets/videos/videobackground720.mp4';

  /// Static web hero videos (served from [web/videos/], not the asset bundle).
  static const String webHeroVideo720 = 'videos/videobackground720.mp4';
  static const String webHeroVideo480 = 'videos/videobackground480.mp4';

  /// Apps page: Master Elf System section video.
  static const String assetAppPageVideo = 'assets/videos/appads.mp4';
  static const String assetEventCard = 'assets/images/event.jpg';
  static const String assetEventMain = 'assets/images/event2026.jpg';
  static const String assetEvent2027 =
      'assets/images/events/comingsoon2027.jpg';
  static const String assetEvent2026FengShui =
      'assets/images/events/event2026_1.jpg';
  static const String assetEvent2026CrimsonHorse =
      'assets/images/events/event2026_2.jpg';

  /// Events page hero background.
  static const String assetEventHero = 'assets/images/eventbg.jpg';

  /// Activities page hero background.
  static const String assetActivitiesHero = 'assets/images/activitiesbg.jpg';

  /// Phoenix 2026 venue partners (Chipmong, Legend Cinema).
  static const String assetVenueChipmong = 'assets/CL/CL (2).jpg';
  static const String assetVenueLegendCinema = 'assets/CL/CL (3).jpg';
  static const String assetAboutHero = 'assets/images/sessions.jpg';
  static const String assetSessions = 'assets/images/sessions.jpg';
  static const String assetParticipants = 'assets/images/participants.jpg';
  static const String assetRegistration = 'assets/images/registration.jpg';
  static const String assetDirection = 'assets/images/direction.jpg';

  /// Contact page hero background.
  static const String assetContactHero = 'assets/images/herobackground.jpg';

  /// Journey page hero background.
  static const String assetJourneyHero = 'assets/images/endeavour.jpg';

  /// Story section image (portrait).
  static const String assetStoryBackground = 'assets/images/story.PNG';
  static const String assetTestimonialProfile = 'assets/images/profile.jpg';
  static const String assetTestimonialParticipant =
      'assets/images/participant2.jpg';
  static const String assetTestimonialPanhaLeakhena =
      'assets/images/testimonials/panhaleakhena.jpg';
  static const String assetTestimonialMoon =
      'assets/images/testimonials/moon.jpg';
  static const String assetTestimonialRithy =
      'assets/images/testimonials/rithy.jpg';
  static const String assetTestimonialVanna =
      'assets/images/testimonials/vanna.jpg';
  static const String assetTestimonialThida =
      'assets/images/testimonials/thida.jpg';
  static const String assetTestimonialZeiitey =
      'assets/images/testimonials/zeiitey.jpg';
  static const String assetTestimonial7 = 'assets/images/testimonials/7.jpg';
  static const String assetTestimonial8 = 'assets/images/testimonials/8.jpg';
  static const String assetTestimonial9 = 'assets/images/testimonials/9.jpg';
  static const String assetTestimonial10 = 'assets/images/testimonials/10.jpg';
  static const String assetTestimonial11 = 'assets/images/testimonials/11.jpg';
  static const String assetTestimonial12 = 'assets/images/testimonials/12.jpg';
  static const String assetTestimonial13 = 'assets/images/testimonials/13.jpg';
  static const String assetTestimonial14 = 'assets/images/testimonials/14.jpg';
  static const String assetTestimonial15 = 'assets/images/testimonials/15.jpg';
  static const String assetTestimonial16 = 'assets/images/testimonials/16.jpg';
  static const String assetTestimonial17 = 'assets/images/testimonials/17.jpg';
  static const String assetTestimonial18 = 'assets/images/testimonials/18.jpg';
  static const String assetTestimonialHena =
      'assets/images/testimonials/hena.png';
  static const String assetTestimonialSokha =
      'assets/images/testimonials/sokha.png';
  static const String assetTestimonialPisey =
      'assets/images/testimonials/pisey.png';
  static const String assetTestimonialAiichen =
      'assets/images/testimonials/aiichen.png';
  static const String assetTestimonialHengyang =
      'assets/images/testimonials/hengyang.png';
  static const String assetTestimonialChanra =
      'assets/images/testimonials/chanra.png';
  static const String assetTestimonialDeth =
      'assets/images/testimonials/deth.png';
  static const String assetTestimonialLinger =
      'assets/images/testimonials/linger.png';
  static const String assetTestimonialOunnpovv =
      'assets/images/testimonials/ounnpovv.png';
  static const String assetTestimonialMuysorng =
      'assets/images/testimonials/muysorng.png';
  static const String assetTestimonialSokunna =
      'assets/images/testimonials/sokunna.png';
  static const String assetTestimonialSaly =
      'assets/images/testimonials/saly.png';
  static const String assetTestimonialRina =
      'assets/images/testimonials/rina.png';
  static const String assetTestimonialChung =
      'assets/images/testimonials/chung.png';
  static const String assetAcademy = 'assets/images/apps.jpg';

  /// Consultation / appointments page (Smart Move cards).
  static const String assetConsultation = 'assets/images/consultation.jpg';

  /// Field Work homepage showcase pillars (assets/images/activities/).
  static const String assetActivityFengShui =
      'assets/images/activities/fengshui.jpg';
  static const String assetActivityConsultation =
      'assets/images/activities/consultation.jpg';
  static const String assetActivityMaoShan =
      'assets/images/activities/maosan.jpg';
  static const String assetActivityDateSelection =
      'assets/images/activities/dateselection.jpg';

  /// Field Work photo carousel image (activity_01.jpg … activity_29.jpg).
  static String assetActivityPhoto(int n) =>
      'assets/images/activities/activity_${n.toString().padLeft(2, '0')}.jpg';

  /// Activity spotlight videos (9:16) under assets/videos/activities/.
  static const String assetActivityVideo01 = 'assets/videos/activities/1.mp4';
  static const String assetActivityVideo02 = 'assets/videos/activities/2.mp4';
  static const String assetActivityVideo03 = 'assets/videos/activities/3.mp4';
  static const String assetActivityVideo04 = 'assets/videos/activities/4.mp4';
  static const String assetActivityVideo05 = 'assets/videos/activities/5.mp4';
  static const String assetActivityVideo06 = 'assets/videos/activities/6.mp4';

  /// Web static path for mobile activity video [n] (480p portrait).
  static String webActivityVideo480(int n) => 'videos/activities/$n.mp4';

  /// Web static path for desktop/tablet activity video [n] (720p portrait).
  static String webActivityVideo720(int n) => 'videos/activities/$n-720.mp4';

  /// Parses `assets/videos/activities/N.mp4` → N.
  static int? activityIndexFromAsset(String assetPath) {
    final match = RegExp(r'activities/(\d+)\.mp4$').firstMatch(assetPath);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  /// All six field-work spotlight video asset paths.
  static List<String> get activityVideoAssets => [
    assetActivityVideo01,
    assetActivityVideo02,
    assetActivityVideo03,
    assetActivityVideo04,
    assetActivityVideo05,
    assetActivityVideo06,
  ];
  static const String assetBetterOption = 'assets/images/betteroption.jpg';

  /// BaZi Harmony card image on main page (Academies section).
  static const String assetBaziHarmony = 'assets/icons/baziharmony.jpg';

  /// QiMen card image on main page (Academies section).
  static const String assetAcademyQiMen = 'assets/icons/qimendunjia.jpg';

  /// Feng Shui Charter card image (home Academies, Journey, Academy page).
  static const String assetAcademyFengShui = 'assets/images/fengshuicard.jpg';

  // Apps page showcase (assets/images/apps/)
  /// Apps page hero banner
  static const String assetAppsHero = 'assets/images/hero1x.jpg';
  static const String assetAppMainMenu = 'assets/images/apps/mainmenu.png';
  static const String assetAppBazi01 = 'assets/images/apps/bazi_01.png';
  static const String assetAppBazi02 = 'assets/images/apps/bazi_02.png';
  static const String assetAppBazi03 = 'assets/images/apps/bazi_03.png';
  static const String assetAppBazi04 = 'assets/images/apps/bazi_04.png';
  static const String assetAppBazi05 = 'assets/images/apps/bazi_05.png';
  static const String assetAppBazi06 = 'assets/images/apps/bazi_06.png';
  static const String assetAppBazi07 = 'assets/images/apps/bazi_07.png';
  static const String assetAppQiMen = 'assets/images/apps/qimendunjia.png';
  static const String assetAppDateSelection =
      'assets/images/apps/dateselection.png';
  static const String assetAppCoupleCompatibility01 =
      'assets/images/apps/couple_compatibility_01.png';
  static const String assetAppCoupleCompatibility02 =
      'assets/images/apps/couple_compatibility_02.png';
  static const String assetAppCoupleCompatibility03 =
      'assets/images/apps/couple_compatibility_03.png';
  static const String assetAppBusinessPartnership01 =
      'assets/images/apps/business_partnership_01.png';
  static const String assetAppBusinessPartnership02 =
      'assets/images/apps/business_partnership_02.png';
  static const String assetAppBusinessPartnership03 =
      'assets/images/apps/business_partnership_03.png';
  static const String assetAppFengShuiTools =
      'assets/images/apps/fengshuitools.png';
  static const String assetAppIChing = 'assets/images/apps/iching.png';

  /// Period 9 mobile app screenshots
  static const String assetPeriod9_1 = 'assets/images/apps/period9_1.jpg';
  static const String assetPeriod9_2 = 'assets/images/apps/period9_2.jpg';

  /// All Master Elf app showcase images (for preloader).
  static List<String> get appShowcaseImageAssets => [
    ...appShowcaseAboveFoldAssets,
    ...appShowcaseDeferredAssets,
  ];

  /// Above-fold apps page screenshots (overview ecosystem poster).
  static List<String> get appShowcaseAboveFoldAssets => [
    assetAppMainMenu,
  ];

  /// Below-fold / carousel apps page screenshots — deferred preload.
  static List<String> get appShowcaseDeferredAssets => [
    assetAppBazi01,
    assetAppBazi02,
    assetAppBazi03,
    assetAppBazi04,
    assetAppBazi05,
    assetAppBazi06,
    assetAppBazi07,
    assetAppQiMen,
    assetAppDateSelection,
    assetAppCoupleCompatibility01,
    assetAppCoupleCompatibility02,
    assetAppCoupleCompatibility03,
    assetAppBusinessPartnership01,
    assetAppBusinessPartnership02,
    assetAppBusinessPartnership03,
    assetAppFengShuiTools,
    assetAppIChing,
    assetPeriod9_1,
    assetPeriod9_2,
  ];

  /// Book store — 5-Blessing series (1080×1350, 4:5 covers)
  static const String assetBook1 = 'assets/images/books/book1.jpg';
  static const String assetBook2 = 'assets/images/books/book2.jpg';
  static const String assetBook3 = 'assets/images/books/book3.jpg';
  static const String assetBook4 = 'assets/images/books/book4.jpg';
  static const String assetBook5 = 'assets/images/books/book5.jpg';

  /// Full-width shelf mockup panorama for the 5-Blessing series band.
  static const String assetShelfMockupFiveBlessings =
      'assets/images/books/shelf_mockup_five_blessings.jpg';

  /// Period 9 Feng Shui book store volumes (legacy covers).
  static const String assetPeriod9Book1 =
      'assets/stores/books/period9book1.jpg';
  static const String assetPeriod9Book2 =
      'assets/stores/books/period9book2.jpg';

  /// Press / media logos shown in the home page Featured In section.
  static const List<String> featuredPressLogos = [
    'assets/CL/CL (1).jpg',
    'assets/CL/CL (2).jpg',
    'assets/CL/CL (3).jpg',
    'assets/CL/CL (4).jpg',
    'assets/CL/CL (5).jpg',
    'assets/CL/CL (6).jpg',
    'assets/CL/CL (7).jpg',
    'assets/CL/CL (8).jpg',
  ];
}
