import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Elf Feng Shui'**
  String get appTitle;

  /// No description provided for @skipToContent.
  ///
  /// In en, this message translates to:
  /// **'Skip to content'**
  String get skipToContent;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// No description provided for @charteredPractitioner.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get charteredPractitioner;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @appsAndStore.
  ///
  /// In en, this message translates to:
  /// **'Apps & Store'**
  String get appsAndStore;

  /// No description provided for @masterElfSystem.
  ///
  /// In en, this message translates to:
  /// **'Master Elf System'**
  String get masterElfSystem;

  /// No description provided for @period9MobileApp.
  ///
  /// In en, this message translates to:
  /// **'Period 9 Mobile App'**
  String get period9MobileApp;

  /// No description provided for @talismanStore.
  ///
  /// In en, this message translates to:
  /// **'Talisman Store'**
  String get talismanStore;

  /// No description provided for @appsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps & Store'**
  String get appsPageTitle;

  /// No description provided for @appsPageSubline.
  ///
  /// In en, this message translates to:
  /// **'Shop digital tools, books, and talismans—all in one place.'**
  String get appsPageSubline;

  /// No description provided for @appsPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Our marketplace brings together subscriptions, apps, books, and curated talismans. Subscribe, download, or add to cart—we\'ll help you complete your order.'**
  String get appsPageDescription;

  /// No description provided for @appsPageDescriptionHighlight.
  ///
  /// In en, this message translates to:
  /// **'marketplace'**
  String get appsPageDescriptionHighlight;

  /// No description provided for @appsFeatureShowcaseHeading.
  ///
  /// In en, this message translates to:
  /// **'Shop by category'**
  String get appsFeatureShowcaseHeading;

  /// No description provided for @appsFeatureShowcaseMarketingDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse digital subscriptions, one-time purchases, and curated products. Add to cart or subscribe and we\'ll get in touch to complete your order.'**
  String get appsFeatureShowcaseMarketingDesc;

  /// No description provided for @appsFeatureShowcaseMarketingHighlight.
  ///
  /// In en, this message translates to:
  /// **'Add to cart or subscribe'**
  String get appsFeatureShowcaseMarketingHighlight;

  /// No description provided for @marketplaceCategoryDigital.
  ///
  /// In en, this message translates to:
  /// **'Digital'**
  String get marketplaceCategoryDigital;

  /// No description provided for @marketplaceCategoryBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get marketplaceCategoryBooks;

  /// No description provided for @marketplaceCategoryTalismans.
  ///
  /// In en, this message translates to:
  /// **'Talismans'**
  String get marketplaceCategoryTalismans;

  /// No description provided for @masterElfSystemSpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Elf System'**
  String get masterElfSystemSpotlightTitle;

  /// No description provided for @masterElfSystemSpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'The complete BaZi and Chinese metaphysics platform. Plot charts, analyse timing and access Master Elf\'s system online.'**
  String get masterElfSystemSpotlightDesc;

  /// No description provided for @openMasterElfSystem.
  ///
  /// In en, this message translates to:
  /// **'Open Master Elf System'**
  String get openMasterElfSystem;

  /// No description provided for @masterElfSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get masterElfSubscribe;

  /// No description provided for @masterElfSubscriptionPrice.
  ///
  /// In en, this message translates to:
  /// **'9.99'**
  String get masterElfSubscriptionPrice;

  /// No description provided for @masterElfPricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get masterElfPricePerMonth;

  /// No description provided for @period9PriceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get period9PriceFree;

  /// No description provided for @period9PremiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium subscription available'**
  String get period9PremiumLabel;

  /// No description provided for @period9SpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Period 9 Mobile App'**
  String get period9SpotlightTitle;

  /// No description provided for @period9SpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'Carry Period 9 Feng Shui and timing insights in your pocket. Available on iOS and Android.'**
  String get period9SpotlightDesc;

  /// No description provided for @downloadOnAppStore.
  ///
  /// In en, this message translates to:
  /// **'Download on the App Store'**
  String get downloadOnAppStore;

  /// No description provided for @getItOnGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Get it on Google Play'**
  String get getItOnGooglePlay;

  /// No description provided for @talismanStoreSpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Talisman Store'**
  String get talismanStoreSpotlightTitle;

  /// No description provided for @talismanStoreSpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'Curated talismans and remedies. Add to cart and we\'ll contact you to complete your order.'**
  String get talismanStoreSpotlightDesc;

  /// No description provided for @marketplaceAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart. We\'ll contact you to complete your order.'**
  String get marketplaceAddedToCart;

  /// No description provided for @talismanProductPrice.
  ///
  /// In en, this message translates to:
  /// **'29.99'**
  String get talismanProductPrice;

  /// No description provided for @talismanProduct1Title.
  ///
  /// In en, this message translates to:
  /// **'Protection Talisman'**
  String get talismanProduct1Title;

  /// No description provided for @talismanProduct2Title.
  ///
  /// In en, this message translates to:
  /// **'Wealth Charm'**
  String get talismanProduct2Title;

  /// No description provided for @talismanProduct3Title.
  ///
  /// In en, this message translates to:
  /// **'Health Amulet'**
  String get talismanProduct3Title;

  /// No description provided for @talismanProduct4Title.
  ///
  /// In en, this message translates to:
  /// **'Love & Harmony'**
  String get talismanProduct4Title;

  /// No description provided for @talismanProduct5Title.
  ///
  /// In en, this message translates to:
  /// **'Career Success'**
  String get talismanProduct5Title;

  /// No description provided for @talismanProduct6Title.
  ///
  /// In en, this message translates to:
  /// **'Peace & Calm'**
  String get talismanProduct6Title;

  /// No description provided for @talismanProduct7Title.
  ///
  /// In en, this message translates to:
  /// **'Travel Protection'**
  String get talismanProduct7Title;

  /// No description provided for @talismanProduct8Title.
  ///
  /// In en, this message translates to:
  /// **'Home Blessing'**
  String get talismanProduct8Title;

  /// No description provided for @talismanProduct9Title.
  ///
  /// In en, this message translates to:
  /// **'Wisdom Pendant'**
  String get talismanProduct9Title;

  /// No description provided for @masterElfSystemSpotlightTagline.
  ///
  /// In en, this message translates to:
  /// **'Your timing, clarified.'**
  String get masterElfSystemSpotlightTagline;

  /// No description provided for @masterElfSystemSpotlightTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'clarified'**
  String get masterElfSystemSpotlightTaglineHighlight;

  /// No description provided for @period9SpotlightTagline.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui in your pocket.'**
  String get period9SpotlightTagline;

  /// No description provided for @period9SpotlightTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'pocket'**
  String get period9SpotlightTaglineHighlight;

  /// No description provided for @talismanStoreSpotlightTagline.
  ///
  /// In en, this message translates to:
  /// **'Heaven\'s blessings. Protection you can carry.'**
  String get talismanStoreSpotlightTagline;

  /// No description provided for @talismanStoreSpotlightTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'carry'**
  String get talismanStoreSpotlightTaglineHighlight;

  /// No description provided for @talismanStoreIntroHeading.
  ///
  /// In en, this message translates to:
  /// **'Sacred charms, chosen with devotion'**
  String get talismanStoreIntroHeading;

  /// No description provided for @talismanStoreIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Each talisman carries the intention of classical blessing rites—made to guard, attract, and restore balance when life feels unsettled.'**
  String get talismanStoreIntroBody;

  /// No description provided for @talismanStoreIntroHighlight.
  ///
  /// In en, this message translates to:
  /// **'guard, attract, and restore'**
  String get talismanStoreIntroHighlight;

  /// No description provided for @talismanStoreCollectionHeading.
  ///
  /// In en, this message translates to:
  /// **'Nine Sacred Charms'**
  String get talismanStoreCollectionHeading;

  /// No description provided for @talismanStoreCollectionIntro.
  ///
  /// In en, this message translates to:
  /// **'Nine intentions, one calling—to walk under heaven\'s favour when you need a sign most.'**
  String get talismanStoreCollectionIntro;

  /// No description provided for @talismanStoreCollectionIntroHighlight.
  ///
  /// In en, this message translates to:
  /// **'heaven\'s favour'**
  String get talismanStoreCollectionIntroHighlight;

  /// No description provided for @talismanStoreTrustHeading.
  ///
  /// In en, this message translates to:
  /// **'Faith you can hold close'**
  String get talismanStoreTrustHeading;

  /// No description provided for @talismanStoreTrustBody.
  ///
  /// In en, this message translates to:
  /// **'Hand-selected remedies. Time-honoured blessings. Spiritually prepared—not mass-made trinkets.'**
  String get talismanStoreTrustBody;

  /// No description provided for @talismanStoreClosingHeading.
  ///
  /// In en, this message translates to:
  /// **'Seeking a blessing for something specific?'**
  String get talismanStoreClosingHeading;

  /// No description provided for @talismanStoreClosingBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you carry—worries at home, on the road, or in the heart—and we\'ll guide you to the charm that fits.'**
  String get talismanStoreClosingBody;

  /// No description provided for @talismanStoreClosingCta.
  ///
  /// In en, this message translates to:
  /// **'Book a consultation'**
  String get talismanStoreClosingCta;

  /// No description provided for @talismanProduct1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Guardian charm for daily wear'**
  String get talismanProduct1Subtitle;

  /// No description provided for @talismanProduct1Hook.
  ///
  /// In en, this message translates to:
  /// **'Shield against harm—carry heaven\'s guard wherever you go.'**
  String get talismanProduct1Hook;

  /// No description provided for @talismanProduct2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fortune-attracting talisman'**
  String get talismanProduct2Subtitle;

  /// No description provided for @talismanProduct2Hook.
  ///
  /// In en, this message translates to:
  /// **'Open the path to abundance; invite prosperity with every step.'**
  String get talismanProduct2Hook;

  /// No description provided for @talismanProduct3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Vitality and wellbeing blessing'**
  String get talismanProduct3Subtitle;

  /// No description provided for @talismanProduct3Hook.
  ///
  /// In en, this message translates to:
  /// **'Nurture body and spirit—a sacred reminder that wellness is divine.'**
  String get talismanProduct3Hook;

  /// No description provided for @talismanProduct4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Bond-deepening blessing charm'**
  String get talismanProduct4Subtitle;

  /// No description provided for @talismanProduct4Hook.
  ///
  /// In en, this message translates to:
  /// **'Soften conflict, deepen connection—for hearts meant to stay together.'**
  String get talismanProduct4Hook;

  /// No description provided for @talismanProduct5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Path-aligning fortune charm'**
  String get talismanProduct5Subtitle;

  /// No description provided for @talismanProduct5Hook.
  ///
  /// In en, this message translates to:
  /// **'Align effort with opportunity; walk your career under decisive fortune.'**
  String get talismanProduct5Hook;

  /// No description provided for @talismanProduct6Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Rest-for-the-soul amulet'**
  String get talismanProduct6Subtitle;

  /// No description provided for @talismanProduct6Hook.
  ///
  /// In en, this message translates to:
  /// **'Quiet the restless mind; rest in blessings that never leave you.'**
  String get talismanProduct6Hook;

  /// No description provided for @talismanProduct7Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Journey guardian talisman'**
  String get talismanProduct7Subtitle;

  /// No description provided for @talismanProduct7Hook.
  ///
  /// In en, this message translates to:
  /// **'Travel under protection—return home as you departed, safe and whole.'**
  String get talismanProduct7Hook;

  /// No description provided for @talismanProduct8Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Dwelling-sealing prosperity charm'**
  String get talismanProduct8Subtitle;

  /// No description provided for @talismanProduct8Hook.
  ///
  /// In en, this message translates to:
  /// **'Seal your home with peace; let every room welcome good fortune.'**
  String get talismanProduct8Hook;

  /// No description provided for @talismanProduct9Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Clarity for life\'s crossroads'**
  String get talismanProduct9Subtitle;

  /// No description provided for @talismanProduct9Hook.
  ///
  /// In en, this message translates to:
  /// **'Clear sight for hard choices—guidance when the way ahead feels clouded.'**
  String get talismanProduct9Hook;

  /// No description provided for @bookStoreSectionHeading.
  ///
  /// In en, this message translates to:
  /// **'Master Elf Book Store'**
  String get bookStoreSectionHeading;

  /// No description provided for @bookStoreSectionTagline.
  ///
  /// In en, this message translates to:
  /// **'Ancient systems. Clear guidance you can use today.'**
  String get bookStoreSectionTagline;

  /// No description provided for @bookStoreSectionTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'use today'**
  String get bookStoreSectionTaglineHighlight;

  /// No description provided for @bookStoreSectionMarketing.
  ///
  /// In en, this message translates to:
  /// **'Master Elf\'s curated library—written for homes, businesses, and life decisions. Pick one volume or build your full foundation.'**
  String get bookStoreSectionMarketing;

  /// No description provided for @bookStoreSectionMarketingHighlight.
  ///
  /// In en, this message translates to:
  /// **'build your full foundation'**
  String get bookStoreSectionMarketingHighlight;

  /// No description provided for @bookStoreIntroHeading.
  ///
  /// In en, this message translates to:
  /// **'Books that earn a place on your desk'**
  String get bookStoreIntroHeading;

  /// No description provided for @bookStoreIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Classical Chinese metaphysics, explained in plain language. Each volume is practical enough to open tonight and wise enough to revisit for years.'**
  String get bookStoreIntroBody;

  /// No description provided for @bookStoreIntroHighlight.
  ///
  /// In en, this message translates to:
  /// **'revisit for years'**
  String get bookStoreIntroHighlight;

  /// No description provided for @bookStoreBlessingSeriesIntro.
  ///
  /// In en, this message translates to:
  /// **'Five classical disciplines, one complete path—from space and strategy to timing and protection.'**
  String get bookStoreBlessingSeriesIntro;

  /// No description provided for @bookStoreBlessingSeriesIntroHighlight.
  ///
  /// In en, this message translates to:
  /// **'one complete path'**
  String get bookStoreBlessingSeriesIntroHighlight;

  /// No description provided for @bookStorePeriod9SeriesIntro.
  ///
  /// In en, this message translates to:
  /// **'Period 9 changes the map. These volumes show what shifted and how to apply it.'**
  String get bookStorePeriod9SeriesIntro;

  /// No description provided for @bookStorePeriod9SeriesIntroHighlight.
  ///
  /// In en, this message translates to:
  /// **'how to apply it'**
  String get bookStorePeriod9SeriesIntroHighlight;

  /// No description provided for @bookStoreTrustHeading.
  ///
  /// In en, this message translates to:
  /// **'Built for real decisions'**
  String get bookStoreTrustHeading;

  /// No description provided for @bookStoreTrustBody.
  ///
  /// In en, this message translates to:
  /// **'Practical chapters. Real case logic. Wisdom you can trust—not museum theory.'**
  String get bookStoreTrustBody;

  /// No description provided for @bookStoreBundleSaveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save {amount} vs buying separately'**
  String bookStoreBundleSaveLabel(String amount);

  /// No description provided for @bookStoreClosingHeading.
  ///
  /// In en, this message translates to:
  /// **'Not sure where to start?'**
  String get bookStoreClosingHeading;

  /// No description provided for @bookStoreClosingBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us your goal—home, business, or timing—and we\'ll point you to the right volume.'**
  String get bookStoreClosingBody;

  /// No description provided for @bookStoreClosingCta.
  ///
  /// In en, this message translates to:
  /// **'Book a consultation'**
  String get bookStoreClosingCta;

  /// No description provided for @bookStoreBook1Hook.
  ///
  /// In en, this message translates to:
  /// **'Shape your space for flow, wealth, and calm at home.'**
  String get bookStoreBook1Hook;

  /// No description provided for @bookStoreBook2Hook.
  ///
  /// In en, this message translates to:
  /// **'Choose better timing for business, travel, and big decisions.'**
  String get bookStoreBook2Hook;

  /// No description provided for @bookStoreBook3Hook.
  ///
  /// In en, this message translates to:
  /// **'Read change clearly—then act with confidence.'**
  String get bookStoreBook3Hook;

  /// No description provided for @bookStoreBook4Hook.
  ///
  /// In en, this message translates to:
  /// **'Blessings and protection rituals, explained step by step.'**
  String get bookStoreBook4Hook;

  /// No description provided for @bookStoreBook5Hook.
  ///
  /// In en, this message translates to:
  /// **'Pick auspicious dates for moves, weddings, and launches.'**
  String get bookStoreBook5Hook;

  /// No description provided for @bookStoreBlessingBundleHook.
  ///
  /// In en, this message translates to:
  /// **'Five disciplines, one trusted set—the library Master Elf recommends.'**
  String get bookStoreBlessingBundleHook;

  /// No description provided for @bookStorePeriod9Book1Hook.
  ///
  /// In en, this message translates to:
  /// **'Master Period 9 foundations before you renovate or move.'**
  String get bookStorePeriod9Book1Hook;

  /// No description provided for @bookStorePeriod9Book2Hook.
  ///
  /// In en, this message translates to:
  /// **'Advanced flying-star methods for serious students and practitioners.'**
  String get bookStorePeriod9Book2Hook;

  /// No description provided for @bookStoreBook1Title.
  ///
  /// In en, this message translates to:
  /// **'Modern Feng Shui'**
  String get bookStoreBook1Title;

  /// No description provided for @bookStoreBook1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The Living Science of Space, Flow & Prosperity'**
  String get bookStoreBook1Subtitle;

  /// No description provided for @bookStoreBook1Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook1Price;

  /// No description provided for @bookStoreBook2Title.
  ///
  /// In en, this message translates to:
  /// **'Applied Qi Men Dun Jia'**
  String get bookStoreBook2Title;

  /// No description provided for @bookStoreBook2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The Hidden Science of Strategy, Timing & Victory'**
  String get bookStoreBook2Subtitle;

  /// No description provided for @bookStoreBook2Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook2Price;

  /// No description provided for @bookStoreBook3Title.
  ///
  /// In en, this message translates to:
  /// **'Strategic I Ching'**
  String get bookStoreBook3Title;

  /// No description provided for @bookStoreBook3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The Ancient Wisdom of Choice, Change & Clarity'**
  String get bookStoreBook3Subtitle;

  /// No description provided for @bookStoreBook3Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook3Price;

  /// No description provided for @bookStoreBook4Title.
  ///
  /// In en, this message translates to:
  /// **'The Mao Shan Way'**
  String get bookStoreBook4Title;

  /// No description provided for @bookStoreBook4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The Secret Rituals of Blessing, Spirit & Protection'**
  String get bookStoreBook4Subtitle;

  /// No description provided for @bookStoreBook4Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook4Price;

  /// No description provided for @bookStoreBook5Title.
  ///
  /// In en, this message translates to:
  /// **'Ze Ri'**
  String get bookStoreBook5Title;

  /// No description provided for @bookStoreBook5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The Sacred Art of Timing for Power, Hope & Destiny'**
  String get bookStoreBook5Subtitle;

  /// No description provided for @bookStoreBook5Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook5Price;

  /// No description provided for @bookStoreBlessingBundleTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete 5-Blessing Bundle'**
  String get bookStoreBlessingBundleTitle;

  /// No description provided for @bookStoreBlessingBundleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All five volumes — save when you buy the full set'**
  String get bookStoreBlessingBundleSubtitle;

  /// No description provided for @bookStoreBlessingBundlePrice.
  ///
  /// In en, this message translates to:
  /// **'99.99'**
  String get bookStoreBlessingBundlePrice;

  /// No description provided for @bookStoreBlessingBundleOriginalPrice.
  ///
  /// In en, this message translates to:
  /// **'124.95'**
  String get bookStoreBlessingBundleOriginalPrice;

  /// No description provided for @bookStoreBundleBadge.
  ///
  /// In en, this message translates to:
  /// **'Bundle'**
  String get bookStoreBundleBadge;

  /// No description provided for @bookStoreAddBundleToCart.
  ///
  /// In en, this message translates to:
  /// **'Add Bundle to Cart'**
  String get bookStoreAddBundleToCart;

  /// No description provided for @bookStorePeriod9Book1Title.
  ///
  /// In en, this message translates to:
  /// **'Period 9 Feng Shui — Volume 1'**
  String get bookStorePeriod9Book1Title;

  /// No description provided for @bookStorePeriod9Book1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Foundations & Flying Stars'**
  String get bookStorePeriod9Book1Subtitle;

  /// No description provided for @bookStorePeriod9Book1Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStorePeriod9Book1Price;

  /// No description provided for @bookStorePeriod9Book2Title.
  ///
  /// In en, this message translates to:
  /// **'Period 9 Feng Shui — Volume 2'**
  String get bookStorePeriod9Book2Title;

  /// No description provided for @bookStorePeriod9Book2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Applications'**
  String get bookStorePeriod9Book2Subtitle;

  /// No description provided for @bookStorePeriod9Book2Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStorePeriod9Book2Price;

  /// No description provided for @bookStoreBlessingSeriesHeading.
  ///
  /// In en, this message translates to:
  /// **'The 5-Blessing Book Series'**
  String get bookStoreBlessingSeriesHeading;

  /// No description provided for @bookStoreShelfPanoramaTopHeading.
  ///
  /// In en, this message translates to:
  /// **'Introducing The Five Blessings Series'**
  String get bookStoreShelfPanoramaTopHeading;

  /// No description provided for @bookStoreShelfPanoramaTopBody.
  ///
  /// In en, this message translates to:
  /// **'A definitive library from Master Hong Chhay Heng—five volumes that turn classical metaphysics into daily decisions you can trust.'**
  String get bookStoreShelfPanoramaTopBody;

  /// No description provided for @bookStoreShelfPanoramaTopHighlight.
  ///
  /// In en, this message translates to:
  /// **'daily decisions you can trust'**
  String get bookStoreShelfPanoramaTopHighlight;

  /// No description provided for @bookStoreShelfPanoramaBottomHeading.
  ///
  /// In en, this message translates to:
  /// **'Own the complete reference set'**
  String get bookStoreShelfPanoramaBottomHeading;

  /// No description provided for @bookStoreShelfPanoramaBottomBody.
  ///
  /// In en, this message translates to:
  /// **'From Feng Shui and Qi Men to I Ching, Mao Shan, and Ze Ri—each book stands alone, and together they form the library serious practitioners keep on their desk.'**
  String get bookStoreShelfPanoramaBottomBody;

  /// No description provided for @bookStoreShelfPanoramaBottomHighlight.
  ///
  /// In en, this message translates to:
  /// **'library serious practitioners keep'**
  String get bookStoreShelfPanoramaBottomHighlight;

  /// No description provided for @bookStorePeriod9BridgeHeading.
  ///
  /// In en, this message translates to:
  /// **'Continue your library with Period 9'**
  String get bookStorePeriod9BridgeHeading;

  /// No description provided for @bookStorePeriod9BridgeBody.
  ///
  /// In en, this message translates to:
  /// **'The Five Blessings set builds your foundation—these two volumes map the 2024–2043 Fire era with flying-star methods you can apply immediately.'**
  String get bookStorePeriod9BridgeBody;

  /// No description provided for @bookStorePeriod9BridgeHighlight.
  ///
  /// In en, this message translates to:
  /// **'2024–2043 Fire era'**
  String get bookStorePeriod9BridgeHighlight;

  /// No description provided for @bookStorePeriod9EraBadge.
  ///
  /// In en, this message translates to:
  /// **'Period 9 · 2024–2043'**
  String get bookStorePeriod9EraBadge;

  /// No description provided for @bookStorePeriod9SeriesKicker.
  ///
  /// In en, this message translates to:
  /// **'Advanced Feng Shui · Two-Volume Set'**
  String get bookStorePeriod9SeriesKicker;

  /// No description provided for @bookStorePeriod9SeriesHeading.
  ///
  /// In en, this message translates to:
  /// **'Period 9 Feng Shui Collection'**
  String get bookStorePeriod9SeriesHeading;

  /// No description provided for @bookStorePricePrefix.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get bookStorePricePrefix;

  /// No description provided for @bookStoreAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get bookStoreAddToCart;

  /// No description provided for @bookStoreAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart. We\'ll contact you to complete your order.'**
  String get bookStoreAddedToCart;

  /// No description provided for @bookStoreBestsellerBadge.
  ///
  /// In en, this message translates to:
  /// **'Bestseller'**
  String get bookStoreBestsellerBadge;

  /// No description provided for @bookStoreNav.
  ///
  /// In en, this message translates to:
  /// **'Book Store'**
  String get bookStoreNav;

  /// No description provided for @appFeatureQiMen.
  ///
  /// In en, this message translates to:
  /// **'Qi Men Dunjia'**
  String get appFeatureQiMen;

  /// No description provided for @appFeatureBaziLife.
  ///
  /// In en, this message translates to:
  /// **'BaZi Life'**
  String get appFeatureBaziLife;

  /// No description provided for @appFeatureBaziReport.
  ///
  /// In en, this message translates to:
  /// **'BaZi Report'**
  String get appFeatureBaziReport;

  /// No description provided for @appFeatureBaziAge.
  ///
  /// In en, this message translates to:
  /// **'BaZi Age'**
  String get appFeatureBaziAge;

  /// No description provided for @appFeatureBaziStars.
  ///
  /// In en, this message translates to:
  /// **'BaZi Stars'**
  String get appFeatureBaziStars;

  /// No description provided for @appFeatureBaziKhmer.
  ///
  /// In en, this message translates to:
  /// **'BaZi Khmer'**
  String get appFeatureBaziKhmer;

  /// No description provided for @appFeatureBaziChart.
  ///
  /// In en, this message translates to:
  /// **'BaZi Chart'**
  String get appFeatureBaziChart;

  /// No description provided for @appFeatureDateSelection.
  ///
  /// In en, this message translates to:
  /// **'Date Selection'**
  String get appFeatureDateSelection;

  /// No description provided for @appFeatureMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get appFeatureMarriage;

  /// No description provided for @appFeatureBusinessPartner.
  ///
  /// In en, this message translates to:
  /// **'Business Partner'**
  String get appFeatureBusinessPartner;

  /// No description provided for @appFeatureAdvancedFeatures.
  ///
  /// In en, this message translates to:
  /// **'Advanced Features'**
  String get appFeatureAdvancedFeatures;

  /// No description provided for @newsAndEvents.
  ///
  /// In en, this message translates to:
  /// **'News & Events'**
  String get newsAndEvents;

  /// No description provided for @mediaAndPosts.
  ///
  /// In en, this message translates to:
  /// **'Media & Posts'**
  String get mediaAndPosts;

  /// No description provided for @mediaPostsFacebookTitle.
  ///
  /// In en, this message translates to:
  /// **'Posts & updates'**
  String get mediaPostsFacebookTitle;

  /// No description provided for @mediaPostsFacebookBody.
  ///
  /// In en, this message translates to:
  /// **'Our latest posts, event updates and news are on our Facebook page. Follow us for updates.'**
  String get mediaPostsFacebookBody;

  /// No description provided for @mediaPostsFacebookLink.
  ///
  /// In en, this message translates to:
  /// **'facebook.com/masterelf.vip'**
  String get mediaPostsFacebookLink;

  /// No description provided for @mediaPostsTelegramTitle.
  ///
  /// In en, this message translates to:
  /// **'Telegram Group'**
  String get mediaPostsTelegramTitle;

  /// No description provided for @mediaPostsTelegramBody.
  ///
  /// In en, this message translates to:
  /// **'Join our community on Telegram for discussions and updates.'**
  String get mediaPostsTelegramBody;

  /// No description provided for @mediaPostsTelegramLink.
  ///
  /// In en, this message translates to:
  /// **'t.me/hongchhayheng'**
  String get mediaPostsTelegramLink;

  /// No description provided for @mediaPostsCoverageTitle.
  ///
  /// In en, this message translates to:
  /// **'Media coverage'**
  String get mediaPostsCoverageTitle;

  /// No description provided for @mediaPostsCoverageBody.
  ///
  /// In en, this message translates to:
  /// **'Sample links to articles and features (to be updated):'**
  String get mediaPostsCoverageBody;

  /// No description provided for @consultations.
  ///
  /// In en, this message translates to:
  /// **'Consultations'**
  String get consultations;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactUs;

  /// No description provided for @bookConsultation.
  ///
  /// In en, this message translates to:
  /// **'Book Consultation'**
  String get bookConsultation;

  /// No description provided for @aboutMasterElf.
  ///
  /// In en, this message translates to:
  /// **'About Master Elf'**
  String get aboutMasterElf;

  /// No description provided for @heroMasterElfCaption.
  ///
  /// In en, this message translates to:
  /// **'Master Elf'**
  String get heroMasterElfCaption;

  /// No description provided for @journey.
  ///
  /// In en, this message translates to:
  /// **'My Endeavour'**
  String get journey;

  /// No description provided for @ourMethod.
  ///
  /// In en, this message translates to:
  /// **'Our Method'**
  String get ourMethod;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @eventsCalendar.
  ///
  /// In en, this message translates to:
  /// **'Events Calendar'**
  String get eventsCalendar;

  /// No description provided for @blog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blog;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @quickLinks.
  ///
  /// In en, this message translates to:
  /// **'Quick Links'**
  String get quickLinks;

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat with us!'**
  String get chatWithUs;

  /// No description provided for @ourSocialMedia.
  ///
  /// In en, this message translates to:
  /// **'Our Social\'s Media'**
  String get ourSocialMedia;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright © {year} {company}. All rights reserved.'**
  String copyright(int year, String company);

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @backToTop.
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get backToTop;

  /// No description provided for @pageNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFoundTitle;

  /// No description provided for @pageNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The page you\'re looking for doesn\'t exist or has been moved.'**
  String get pageNotFoundMessage;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @heroHeadline1.
  ///
  /// In en, this message translates to:
  /// **'Awareness always comes before outcome.'**
  String get heroHeadline1;

  /// No description provided for @heroHeadline1Prefix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get heroHeadline1Prefix;

  /// No description provided for @heroHeadline1Highlight.
  ///
  /// In en, this message translates to:
  /// **'Awareness'**
  String get heroHeadline1Highlight;

  /// No description provided for @heroHeadline1Suffix.
  ///
  /// In en, this message translates to:
  /// **' always comes before outcome.'**
  String get heroHeadline1Suffix;

  /// No description provided for @heroHeadline2Prefix.
  ///
  /// In en, this message translates to:
  /// **'Its true value lies in guiding better '**
  String get heroHeadline2Prefix;

  /// No description provided for @heroHeadline2Highlight.
  ///
  /// In en, this message translates to:
  /// **'Choices.'**
  String get heroHeadline2Highlight;

  /// No description provided for @heroSubline.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui & Life Planning Services'**
  String get heroSubline;

  /// No description provided for @exploreAllEvents.
  ///
  /// In en, this message translates to:
  /// **'Explore All Events'**
  String get exploreAllEvents;

  /// No description provided for @eventsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsSectionTitle;

  /// No description provided for @eventsSectionHeadline.
  ///
  /// In en, this message translates to:
  /// **'Transform insight into experience.'**
  String get eventsSectionHeadline;

  /// No description provided for @eventsSectionSubline.
  ///
  /// In en, this message translates to:
  /// **'Join Master Elf live — workshops, revelations, and field sessions.'**
  String get eventsSectionSubline;

  /// No description provided for @earlyBirdEnds.
  ///
  /// In en, this message translates to:
  /// **'Early bird'**
  String get earlyBirdEnds;

  /// No description provided for @comingUpNext.
  ///
  /// In en, this message translates to:
  /// **'Coming Up Next'**
  String get comingUpNext;

  /// No description provided for @allUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'All Upcoming Events'**
  String get allUpcomingEvents;

  /// No description provided for @limitedSeats.
  ///
  /// In en, this message translates to:
  /// **'Limited seats'**
  String get limitedSeats;

  /// No description provided for @viewEvent.
  ///
  /// In en, this message translates to:
  /// **'View Event'**
  String get viewEvent;

  /// No description provided for @exploreCourses.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreCourses;

  /// No description provided for @getConsultation.
  ///
  /// In en, this message translates to:
  /// **'Get Consultation'**
  String get getConsultation;

  /// No description provided for @finalCtaHeading.
  ///
  /// In en, this message translates to:
  /// **'Hesitate to Start?'**
  String get finalCtaHeading;

  /// No description provided for @finalCtaBody.
  ///
  /// In en, this message translates to:
  /// **'Just make a phone call. Send a message to our Facebook page. Or visit us.'**
  String get finalCtaBody;

  /// No description provided for @notSureWhereToStart.
  ///
  /// In en, this message translates to:
  /// **'Not Sure Where To Start?'**
  String get notSureWhereToStart;

  /// No description provided for @notSureBody.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help. Just reach out to us and we\'ll guide you to your best next step, whether it\'s a consultation, course or supportive community.'**
  String get notSureBody;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @sectionExperienceHeading.
  ///
  /// In en, this message translates to:
  /// **'Best practice guided, result Transformation.'**
  String get sectionExperienceHeading;

  /// No description provided for @sectionExperienceHeadingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Best practice guided, result '**
  String get sectionExperienceHeadingPrefix;

  /// No description provided for @sectionExperienceHeadingHighlight.
  ///
  /// In en, this message translates to:
  /// **'Transformation.'**
  String get sectionExperienceHeadingHighlight;

  /// No description provided for @sectionKnowledgeHeading.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t just instruction. It\'s a practical framework for Real Change.'**
  String get sectionKnowledgeHeading;

  /// No description provided for @sectionKnowledgeBody.
  ///
  /// In en, this message translates to:
  /// **'Over 51,000 followers have used this system. Success is certain when you align with the right people, right places, and right time.'**
  String get sectionKnowledgeBody;

  /// No description provided for @sectionKnowledgeBody2.
  ///
  /// In en, this message translates to:
  /// **'Success doesn\'t come from working harder. It comes from making the right moves, at the right time, with the right system.'**
  String get sectionKnowledgeBody2;

  /// No description provided for @sectionKnowledgeStat.
  ///
  /// In en, this message translates to:
  /// **'51K+ followers'**
  String get sectionKnowledgeStat;

  /// No description provided for @sectionMapHeading.
  ///
  /// In en, this message translates to:
  /// **'You don\'t need more advice. You need a RoadMap.\nLet heaven guide you to the correct way.'**
  String get sectionMapHeading;

  /// No description provided for @sectionMapIntro.
  ///
  /// In en, this message translates to:
  /// **'On your mark… We know the best way to help you align your timing and create a clear path forward.'**
  String get sectionMapIntro;

  /// No description provided for @sectionStoryHeading.
  ///
  /// In en, this message translates to:
  /// **'The Story of Master Elf.'**
  String get sectionStoryHeading;

  /// No description provided for @sectionStoryPara1.
  ///
  /// In en, this message translates to:
  /// **'Master Elf prepared you for the first 50% of success, then guides you with another 50% to reap the benefit for you.'**
  String get sectionStoryPara1;

  /// No description provided for @sectionStoryPara2.
  ///
  /// In en, this message translates to:
  /// **'Through years of study, testing, and developing a proven method rooted in Chinese Metaphysics.'**
  String get sectionStoryPara2;

  /// No description provided for @sectionStoryPara3.
  ///
  /// In en, this message translates to:
  /// **'Today, that method has helped 51,000 followers create better outcomes for themselves and others.'**
  String get sectionStoryPara3;

  /// No description provided for @sectionStoryCtaButton.
  ///
  /// In en, this message translates to:
  /// **'Master Elf\'s Endeavor'**
  String get sectionStoryCtaButton;

  /// No description provided for @sectionTestimonialsHeading.
  ///
  /// In en, this message translates to:
  /// **'Real Insights. Real Outcomes.'**
  String get sectionTestimonialsHeading;

  /// No description provided for @sectionTestimonialsSub1.
  ///
  /// In en, this message translates to:
  /// **'They didn\'t just join the event. They witnessed the real strategy.'**
  String get sectionTestimonialsSub1;

  /// No description provided for @sectionTestimonialsSub2.
  ///
  /// In en, this message translates to:
  /// **'From business leaders to individuals.'**
  String get sectionTestimonialsSub2;

  /// No description provided for @featuredIn.
  ///
  /// In en, this message translates to:
  /// **'Featured in'**
  String get featuredIn;

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch;

  /// No description provided for @academyQiMen.
  ///
  /// In en, this message translates to:
  /// **'QiMen Dunjia Mastery™'**
  String get academyQiMen;

  /// No description provided for @academyQiMenDesc.
  ///
  /// In en, this message translates to:
  /// **'Gain strategic advantage to maximise your wins. Your road to victory!'**
  String get academyQiMenDesc;

  /// No description provided for @academyBaZi.
  ///
  /// In en, this message translates to:
  /// **'BaZi Harmony™'**
  String get academyBaZi;

  /// No description provided for @academyBaZiDesc.
  ///
  /// In en, this message translates to:
  /// **'Reveal your destiny, and understand your hidden power. Maximise your potentials.'**
  String get academyBaZiDesc;

  /// No description provided for @academyFengShui.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui Charter™'**
  String get academyFengShui;

  /// No description provided for @academyFengShuiDesc.
  ///
  /// In en, this message translates to:
  /// **'Chartered Practitioner of the Qi flow. Assign best Feng Shui for your home and office.'**
  String get academyFengShuiDesc;

  /// No description provided for @academyPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Academy'**
  String get academyPageTitle;

  /// No description provided for @academyQiMenAbout.
  ///
  /// In en, this message translates to:
  /// **'Ancient strategy system based on time and space. Used for decision-making, date selection, and situational advantage.'**
  String get academyQiMenAbout;

  /// No description provided for @academyBaZiAbout.
  ///
  /// In en, this message translates to:
  /// **'Your birth chart in Eight Characters. Reveals strengths, life cycles, and hidden potential for career and relationships.'**
  String get academyBaZiAbout;

  /// No description provided for @academyFengShuiAbout.
  ///
  /// In en, this message translates to:
  /// **'The art of environmental energy. Learn to assess and align spaces for wellbeing and success.'**
  String get academyFengShuiAbout;

  /// No description provided for @academyQiMenTopics.
  ///
  /// In en, this message translates to:
  /// **'Nine Palaces • Strategic timing • Business & personal decisions'**
  String get academyQiMenTopics;

  /// No description provided for @academyBaZiTopics.
  ///
  /// In en, this message translates to:
  /// **'Four Pillars • Five Elements • Life potential & cycles'**
  String get academyBaZiTopics;

  /// No description provided for @academyFengShuiTopics.
  ///
  /// In en, this message translates to:
  /// **'Qi flow • Form & Compass • Space alignment'**
  String get academyFengShuiTopics;

  /// No description provided for @academyDateSelection.
  ///
  /// In en, this message translates to:
  /// **'Date Selection™'**
  String get academyDateSelection;

  /// No description provided for @academyDateSelectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose auspicious timing for key life and business events.'**
  String get academyDateSelectionDesc;

  /// No description provided for @academyDateSelectionAbout.
  ///
  /// In en, this message translates to:
  /// **'Select favourable dates and hours using almanac, BaZi and Qimen. Apply to weddings, openings, travel and major decisions.'**
  String get academyDateSelectionAbout;

  /// No description provided for @academyDateSelectionTopics.
  ///
  /// In en, this message translates to:
  /// **'Tung Shu • Auspicious hours • Events & milestones'**
  String get academyDateSelectionTopics;

  /// No description provided for @academyIChing.
  ///
  /// In en, this message translates to:
  /// **'I Ching™'**
  String get academyIChing;

  /// No description provided for @academyIChingDesc.
  ///
  /// In en, this message translates to:
  /// **'Ancient wisdom of the Book of Changes for clarity and direction.'**
  String get academyIChingDesc;

  /// No description provided for @academyIChingAbout.
  ///
  /// In en, this message translates to:
  /// **'The 64 hexagrams offer insight into change and outcome. Learn to consult the I Ching for decisions, strategy and personal guidance.'**
  String get academyIChingAbout;

  /// No description provided for @academyIChingTopics.
  ///
  /// In en, this message translates to:
  /// **'64 Hexagrams • Divination • Change & strategy'**
  String get academyIChingTopics;

  /// No description provided for @academyMaoShan.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan™'**
  String get academyMaoShan;

  /// No description provided for @academyMaoShanDesc.
  ///
  /// In en, this message translates to:
  /// **'Taoist tradition of ritual and practice for transformation.'**
  String get academyMaoShanDesc;

  /// No description provided for @academyMaoShanAbout.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan (Mount Mao) methods and rituals within Chinese metaphysics. Understand foundations and applications for spiritual and practical use.'**
  String get academyMaoShanAbout;

  /// No description provided for @academyMaoShanTopics.
  ///
  /// In en, this message translates to:
  /// **'Rituals • Tradition • Practice & application'**
  String get academyMaoShanTopics;

  /// No description provided for @academyMoreCoursesNote.
  ///
  /// In en, this message translates to:
  /// **'More courses and schedules will be announced here. Contact us for early access or custom group sessions.'**
  String get academyMoreCoursesNote;

  /// No description provided for @consult1Category.
  ///
  /// In en, this message translates to:
  /// **'Bazi Reading'**
  String get consult1Category;

  /// No description provided for @consult1Method.
  ///
  /// In en, this message translates to:
  /// **'BaZi'**
  String get consult1Method;

  /// No description provided for @consult1Question.
  ///
  /// In en, this message translates to:
  /// **'Become who you are born to be…'**
  String get consult1Question;

  /// No description provided for @consult1Desc.
  ///
  /// In en, this message translates to:
  /// **'Your birth chart holds the key to your strengths, challenges and timing. A BaZi reading reveals your true potential and helps you align your choices with the energies you were born with—so you can make decisions with clarity and confidence.'**
  String get consult1Desc;

  /// No description provided for @consult2Category.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui Services'**
  String get consult2Category;

  /// No description provided for @consult2Method.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui'**
  String get consult2Method;

  /// No description provided for @consult2Question.
  ///
  /// In en, this message translates to:
  /// **'Arrange your place, define your life...'**
  String get consult2Question;

  /// No description provided for @consult2Desc.
  ///
  /// In en, this message translates to:
  /// **'Your environment shapes your wellbeing and success. Learn how to harness the positive energy of your space—at home or at work—so that your surroundings support your goals instead of working against them. A personalised assessment helps you apply these principles where they matter most.'**
  String get consult2Desc;

  /// No description provided for @consult3Category.
  ///
  /// In en, this message translates to:
  /// **'Date Selection'**
  String get consult3Category;

  /// No description provided for @consult3Method.
  ///
  /// In en, this message translates to:
  /// **'Xuan Kong'**
  String get consult3Method;

  /// No description provided for @consult3Question.
  ///
  /// In en, this message translates to:
  /// **'When is the best time to choose things wisely?'**
  String get consult3Question;

  /// No description provided for @consult3Desc.
  ///
  /// In en, this message translates to:
  /// **'Choosing the right date and time can turn an ordinary step into a favourable one. We use traditional methods to help you schedule important events—from openings and signings to personal milestones—for the best possible outcome.'**
  String get consult3Desc;

  /// No description provided for @consult4Category.
  ///
  /// In en, this message translates to:
  /// **'Qimen and Iching'**
  String get consult4Category;

  /// No description provided for @consult4Method.
  ///
  /// In en, this message translates to:
  /// **'QiMen & I Ching'**
  String get consult4Method;

  /// No description provided for @consult4Question.
  ///
  /// In en, this message translates to:
  /// **'Strategise your wise move...'**
  String get consult4Question;

  /// No description provided for @consult4Desc.
  ///
  /// In en, this message translates to:
  /// **'Face complex decisions with ancient wisdom. QiMen Dunjia and I Ching offer strategic insight and clarity—so you can see your options clearly, anticipate outcomes and choose the move that best serves your goals. Ideal for business, competition and pivotal life choices.'**
  String get consult4Desc;

  /// No description provided for @consult5Category.
  ///
  /// In en, this message translates to:
  /// **'Mao San Rituals'**
  String get consult5Category;

  /// No description provided for @consult5Method.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan'**
  String get consult5Method;

  /// No description provided for @consult5Question.
  ///
  /// In en, this message translates to:
  /// **'Taoist tradition of ritual and practice for transformation.'**
  String get consult5Question;

  /// No description provided for @consult5Desc.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan brings together Taoist ritual and Chinese metaphysical practice. Whether for spiritual growth or life transitions, these methods offer a structured path to transformation and a deeper connection to tradition.'**
  String get consult5Desc;

  /// No description provided for @consult6Category.
  ///
  /// In en, this message translates to:
  /// **'Master Elf Publications'**
  String get consult6Category;

  /// No description provided for @consult6Method.
  ///
  /// In en, this message translates to:
  /// **'Publications'**
  String get consult6Method;

  /// No description provided for @consult6Question.
  ///
  /// In en, this message translates to:
  /// **'Books and resources from Master Elf.'**
  String get consult6Question;

  /// No description provided for @consult6Desc.
  ///
  /// In en, this message translates to:
  /// **'Dive deeper with Master Elf’s published works on Feng Shui, BaZi and Chinese metaphysics. Our books and resources are designed to support your learning and practice beyond the consultation room.'**
  String get consult6Desc;

  /// No description provided for @stickyCtaText.
  ///
  /// In en, this message translates to:
  /// **'Free 12 Animal Forecast'**
  String get stickyCtaText;

  /// No description provided for @popupTitle1.
  ///
  /// In en, this message translates to:
  /// **'Master Elf\'s'**
  String get popupTitle1;

  /// No description provided for @popupTitle2.
  ///
  /// In en, this message translates to:
  /// **'12 ZODIACS FORECAST'**
  String get popupTitle2;

  /// No description provided for @popupDescription.
  ///
  /// In en, this message translates to:
  /// **'Year of Fire Horse'**
  String get popupDescription;

  /// No description provided for @readFullArticles.
  ///
  /// In en, this message translates to:
  /// **'Read Full Articles'**
  String get readFullArticles;

  /// No description provided for @popupFormPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Details Below and we\'ll notify you when your sign premieres.'**
  String get popupFormPrompt;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @eventsCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Elf\'s Events Calendar'**
  String get eventsCalendarTitle;

  /// No description provided for @eventsHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'The Event of the Year—Don\'t Miss It'**
  String get eventsHeroHeadline;

  /// No description provided for @eventsHeroSubline.
  ///
  /// In en, this message translates to:
  /// **'Live teachings. Expert masters. A community that transforms.'**
  String get eventsHeroSubline;

  /// No description provided for @eventsSubline.
  ///
  /// In en, this message translates to:
  /// **'Where discussion turns into real knowledge.'**
  String get eventsSubline;

  /// No description provided for @eventsDescription.
  ///
  /// In en, this message translates to:
  /// **'Experience the best event for Feng Shui, Chinese Metaphysics and Astrology in Cambodia—live teachings, expert insights, and a community ready to grow with you.'**
  String get eventsDescription;

  /// No description provided for @eventsDescriptionHighlight.
  ///
  /// In en, this message translates to:
  /// **'best event for Feng Shui, Chinese Metaphysics and Astrology in Cambodia'**
  String get eventsDescriptionHighlight;

  /// No description provided for @eventsUpcomingSubline.
  ///
  /// In en, this message translates to:
  /// **'Choose your event and secure your seat. We can\'t wait to see you there.'**
  String get eventsUpcomingSubline;

  /// No description provided for @eventsPageHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Where insight becomes experience'**
  String get eventsPageHeroHeadline;

  /// No description provided for @eventsPageHeroSubline.
  ///
  /// In en, this message translates to:
  /// **'Live revelations, online archives, and the next chapter of Master Elf\'s teaching journey.'**
  String get eventsPageHeroSubline;

  /// No description provided for @eventsPageHeroHighlight.
  ///
  /// In en, this message translates to:
  /// **'next chapter'**
  String get eventsPageHeroHighlight;

  /// No description provided for @eventsCompletedHeading.
  ///
  /// In en, this message translates to:
  /// **'Recently Completed'**
  String get eventsCompletedHeading;

  /// No description provided for @eventsCompletedSubline.
  ///
  /// In en, this message translates to:
  /// **'Moments that moved our community—captured in person and online.'**
  String get eventsCompletedSubline;

  /// No description provided for @eventsCompletedBadge.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get eventsCompletedBadge;

  /// No description provided for @eventsOnlineBadge.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get eventsOnlineBadge;

  /// No description provided for @eventsUpcomingBadge.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get eventsUpcomingBadge;

  /// No description provided for @eventsUpcomingSpotlightHeading.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Spotlight'**
  String get eventsUpcomingSpotlightHeading;

  /// No description provided for @eventsUpcomingSpotlightSubline.
  ///
  /// In en, this message translates to:
  /// **'The next gathering is already taking shape. Reserve your place early.'**
  String get eventsUpcomingSpotlightSubline;

  /// No description provided for @eventsGoat2027Title.
  ///
  /// In en, this message translates to:
  /// **'Master Elf — Strive for the Year of the Blood Goat 2027'**
  String get eventsGoat2027Title;

  /// No description provided for @eventsGoat2027Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Annual revelation for the new zodiac cycle'**
  String get eventsGoat2027Subtitle;

  /// No description provided for @eventsGoat2027Hook.
  ///
  /// In en, this message translates to:
  /// **'Step into the Blood Goat year with clarity, strategy, and heaven-aligned timing.'**
  String get eventsGoat2027Hook;

  /// No description provided for @eventsGoat2027Description.
  ///
  /// In en, this message translates to:
  /// **'Master Elf\'s signature annual event returns—live teachings, Period 9 strategy, and the roadmap for thriving in the Year of the Blood Goat.'**
  String get eventsGoat2027Description;

  /// No description provided for @eventsGoat2027DescriptionHighlight.
  ///
  /// In en, this message translates to:
  /// **'Year of the Blood Goat'**
  String get eventsGoat2027DescriptionHighlight;

  /// No description provided for @eventsGoat2027Date.
  ///
  /// In en, this message translates to:
  /// **'February 2027 · Phnom Penh'**
  String get eventsGoat2027Date;

  /// No description provided for @eventsGoat2027Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh'**
  String get eventsGoat2027Location;

  /// No description provided for @eventsZodiacStripLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Goat Year begins February 2027'**
  String get eventsZodiacStripLabel;

  /// No description provided for @eventsZodiacStripPhoenix.
  ///
  /// In en, this message translates to:
  /// **'Phoenix 2026'**
  String get eventsZodiacStripPhoenix;

  /// No description provided for @eventsZodiacStripGoat.
  ///
  /// In en, this message translates to:
  /// **'Blood Goat 2027'**
  String get eventsZodiacStripGoat;

  /// No description provided for @eventsPhoenixRecapHook.
  ///
  /// In en, this message translates to:
  /// **'The revelation that launched a new era—witnessed live in Phnom Penh.'**
  String get eventsPhoenixRecapHook;

  /// No description provided for @eventsPhoenixRecapBody.
  ///
  /// In en, this message translates to:
  /// **'Hundreds gathered for Master Elf\'s most anticipated revelation. The Rise of Phoenix marked a turning point—renewal, transformation, and the framework for rising in Period 9.'**
  String get eventsPhoenixRecapBody;

  /// No description provided for @eventsPhoenixRecapHighlight.
  ///
  /// In en, this message translates to:
  /// **'turning point'**
  String get eventsPhoenixRecapHighlight;

  /// No description provided for @eventsExploreJourney.
  ///
  /// In en, this message translates to:
  /// **'Explore the journey'**
  String get eventsExploreJourney;

  /// No description provided for @eventsHomeFeaturedUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Coming Up Next'**
  String get eventsHomeFeaturedUpcoming;

  /// No description provided for @eventsHomeRecentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Recently Completed'**
  String get eventsHomeRecentCompleted;

  /// No description provided for @event1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The Master Revelation — live in Phnom Penh'**
  String get event1Subtitle;

  /// No description provided for @event1Hook.
  ///
  /// In en, this message translates to:
  /// **'The moment insight became action—Master Elf\'s defining revelation of 2026.'**
  String get event1Hook;

  /// No description provided for @event2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Singapore edition — now available online'**
  String get event2Subtitle;

  /// No description provided for @event2Hook.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui and astrology mastery, captured for replay at your pace.'**
  String get event2Hook;

  /// No description provided for @event3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fire Horse year strategy — online archive'**
  String get event3Subtitle;

  /// No description provided for @event3Hook.
  ///
  /// In en, this message translates to:
  /// **'The art of war in the Year of the Fire Horse—strategy you can revisit anytime.'**
  String get event3Hook;

  /// No description provided for @eventsWhyAttendTitle.
  ///
  /// In en, this message translates to:
  /// **'Why Master Elf events matter'**
  String get eventsWhyAttendTitle;

  /// No description provided for @eventsWhyAttendLead.
  ///
  /// In en, this message translates to:
  /// **'Whether you joined us in Phnom Penh or online, or you\'re preparing for the Blood Goat year ahead—these gatherings turn classical wisdom into decisions you can act on.'**
  String get eventsWhyAttendLead;

  /// No description provided for @eventsWhyAttend1.
  ///
  /// In en, this message translates to:
  /// **'Learn directly from Master Elf—live revelations and depth you won\'t find in books alone.'**
  String get eventsWhyAttend1;

  /// No description provided for @eventsWhyAttend2.
  ///
  /// In en, this message translates to:
  /// **'Join a community of practitioners ready to rise with each zodiac cycle.'**
  String get eventsWhyAttend2;

  /// No description provided for @eventsWhyAttend3.
  ///
  /// In en, this message translates to:
  /// **'Upcoming seats are limited. Register early for the Blood Goat 2027 gathering.'**
  String get eventsWhyAttend3;

  /// No description provided for @secureYourSeat.
  ///
  /// In en, this message translates to:
  /// **'Book your seat'**
  String get secureYourSeat;

  /// No description provided for @searchEvent.
  ///
  /// In en, this message translates to:
  /// **'Search event…'**
  String get searchEvent;

  /// No description provided for @registerForEvent.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerForEvent;

  /// No description provided for @eventColumn.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventColumn;

  /// No description provided for @eventRegTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Registration'**
  String get eventRegTitle;

  /// No description provided for @eventRegFor.
  ///
  /// In en, this message translates to:
  /// **'Registering for'**
  String get eventRegFor;

  /// No description provided for @eventRegName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get eventRegName;

  /// No description provided for @eventRegEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get eventRegEmail;

  /// No description provided for @eventRegPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get eventRegPhone;

  /// No description provided for @eventRegSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit registration'**
  String get eventRegSubmit;

  /// No description provided for @eventRegSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration received'**
  String get eventRegSuccess;

  /// No description provided for @eventRegSuccessNote.
  ///
  /// In en, this message translates to:
  /// **'We will confirm your seat by email or phone. See you at the event!'**
  String get eventRegSuccessNote;

  /// No description provided for @noEventsMatch.
  ///
  /// In en, this message translates to:
  /// **'No events match your search.'**
  String get noEventsMatch;

  /// No description provided for @dateColumn.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateColumn;

  /// No description provided for @locationColumn.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationColumn;

  /// No description provided for @aboutPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Elf | The Rise of Phoenix'**
  String get aboutPageTitle;

  /// No description provided for @aboutBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'About Master Elf.'**
  String get aboutBreadcrumb;

  /// No description provided for @aboutHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Enrich Lives Through Heavenly Knowledge'**
  String get aboutHeroHeadline;

  /// No description provided for @aboutBullet1.
  ///
  /// In en, this message translates to:
  /// **'It started with believe.'**
  String get aboutBullet1;

  /// No description provided for @aboutBullet2.
  ///
  /// In en, this message translates to:
  /// **'A mission delegated by the heaven.'**
  String get aboutBullet2;

  /// No description provided for @aboutBullet3.
  ///
  /// In en, this message translates to:
  /// **'Guiding you with metaphysics into reapable outcome.'**
  String get aboutBullet3;

  /// No description provided for @aboutBullet4.
  ///
  /// In en, this message translates to:
  /// **'Real achievement. Real outputs.'**
  String get aboutBullet4;

  /// No description provided for @journeyPageHeadline.
  ///
  /// In en, this message translates to:
  /// **'My Endeavour'**
  String get journeyPageHeadline;

  /// No description provided for @journeyHeroSubline.
  ///
  /// In en, this message translates to:
  /// **'From a calling to clarity—Feng Shui and Chinese Metaphysics in practice.'**
  String get journeyHeroSubline;

  /// No description provided for @journeySectionTheStory.
  ///
  /// In en, this message translates to:
  /// **'The Story'**
  String get journeySectionTheStory;

  /// No description provided for @journeyHeroSpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'The Path'**
  String get journeyHeroSpotlightTitle;

  /// No description provided for @journeyHeroSpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'From a calling to a system that brings clarity and results. Discover the story below.'**
  String get journeyHeroSpotlightDesc;

  /// No description provided for @journeyHeroSpotlightCta.
  ///
  /// In en, this message translates to:
  /// **'Read the story'**
  String get journeyHeroSpotlightCta;

  /// No description provided for @journeyStory1.
  ///
  /// In en, this message translates to:
  /// **'Master Elf is a recognised practitioner of Feng Shui and Chinese Metaphysics, with a following of over 51,000 and a track record of guiding individuals and businesses toward clarity and results. His path did not begin by chance—it began with a calling.'**
  String get journeyStory1;

  /// No description provided for @journeyStory2.
  ///
  /// In en, this message translates to:
  /// **'What started as a deep belief in the wisdom of the heavens grew into a mission: to bring ancient systems of timing, space and destiny into everyday life. Through years of study, practice and refinement, he built a method that turns metaphysics into actionable insight.'**
  String get journeyStory2;

  /// No description provided for @journeyStory3.
  ///
  /// In en, this message translates to:
  /// **'Today, that method helps clients make better decisions, choose auspicious dates, understand their strengths and align their environments. From destiny readings to strategic date selection and Feng Shui audits, Master Elf\'s system is designed for real-world impact.'**
  String get journeyStory3;

  /// No description provided for @journeyPeriod9Title.
  ///
  /// In en, this message translates to:
  /// **'Period 9 and the New Era'**
  String get journeyPeriod9Title;

  /// No description provided for @journeyPeriod9Body.
  ///
  /// In en, this message translates to:
  /// **'We are now in Period 9 (2024–2043), the Li Fire era in the Xuan Kong Nine Periods cycle. This 20-year phase emphasises fire element energy, the south direction, and themes of visibility, progress and inner clarity. Master Elf\'s practice is aligned with this shift, helping you navigate the new era with timing and placement that match the cosmic cycle.'**
  String get journeyPeriod9Body;

  /// No description provided for @journeyPhoenixTitle.
  ///
  /// In en, this message translates to:
  /// **'The Rise of the Phoenix'**
  String get journeyPhoenixTitle;

  /// No description provided for @journeyPhoenixBody.
  ///
  /// In en, this message translates to:
  /// **'The Rise of the Phoenix is Master Elf\'s revelation and the name of his system. It symbolises renewal, transformation and the moment when insight leads to action. In Period 9, the phoenix rises—and with the right knowledge, so can you. His framework integrates BaZi, Qimen Dunjia, I Ching, Date Selection, Feng Shui and Mao Shan into one coherent approach for those ready to rise.'**
  String get journeyPhoenixBody;

  /// No description provided for @methodPageHeadline.
  ///
  /// In en, this message translates to:
  /// **'Our Method'**
  String get methodPageHeadline;

  /// No description provided for @methodIntro.
  ///
  /// In en, this message translates to:
  /// **'Master Elf\'s system is built on classical Chinese metaphysics. Each discipline is applied with clear formulas and standards so that consultations and training are consistent, explainable and effective. Below is how the main pillars are practiced, calculated and used.'**
  String get methodIntro;

  /// No description provided for @methodBaZiTitle.
  ///
  /// In en, this message translates to:
  /// **'BaZi (Four Pillars of Destiny)'**
  String get methodBaZiTitle;

  /// No description provided for @methodBaZiBody.
  ///
  /// In en, this message translates to:
  /// **'BaZi uses your exact birth date and time to build four pillars—Year, Month, Day, Hour—each with a Heavenly Stem and Earthly Branch (eight characters in total). The chart is calculated in true solar time where applicable. We analyse the Five Elements, strengths and clashes, and life cycles to reveal your potential, favourable directions and timing for key decisions.'**
  String get methodBaZiBody;

  /// No description provided for @methodQimenTitle.
  ///
  /// In en, this message translates to:
  /// **'Qimen Dunjia'**
  String get methodQimenTitle;

  /// No description provided for @methodQimenBody.
  ///
  /// In en, this message translates to:
  /// **'Qimen is built on a 3×3 Nine Palaces grid that changes with date and double-hour. We set the chart for the time of the question or event, place the Three Odd Stars (Yi, Bing, Ding), Eight Gates and Eight Deities, and interpret using Yin or Yang Dun. The formula is time-sensitive and used for strategy, date selection and situational analysis.'**
  String get methodQimenBody;

  /// No description provided for @methodIChingTitle.
  ///
  /// In en, this message translates to:
  /// **'I Ching (Book of Changes)'**
  String get methodIChingTitle;

  /// No description provided for @methodIChingBody.
  ///
  /// In en, this message translates to:
  /// **'The I Ching is consulted to obtain a hexagram (six lines) that reflects the situation. We use the classical three-coin or yarrow-stalk method: each line is built from bottom to top (6 = transforming yin, 7 = stable yang, 8 = stable yin, 9 = transforming yang). The resulting hexagram and any changing lines are interpreted using the classic text and Master Elf\'s framework for decisions and direction.'**
  String get methodIChingBody;

  /// No description provided for @methodDateSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Date Selection'**
  String get methodDateSelectionTitle;

  /// No description provided for @methodDateSelectionBody.
  ///
  /// In en, this message translates to:
  /// **'Auspicious dates and hours are chosen using the Chinese almanac (Tung Shu), BaZi compatibility with the event and principal, and Qimen Dunjia for strategic timing. We avoid inauspicious days (e.g. conflicting stems and branches) and align with favourable energies for openings, weddings, travel and major commitments.'**
  String get methodDateSelectionBody;

  /// No description provided for @methodFengShuiTitle.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui (Xuan Kong Flying Star)'**
  String get methodFengShuiTitle;

  /// No description provided for @methodFengShuiBody.
  ///
  /// In en, this message translates to:
  /// **'We use Xuan Kong Fei Xing (Flying Star) Feng Shui. The building\'s period (based on completion year; the Feng Shui year starts 4 February) and facing direction (24 Mountains) determine the Flying Star chart. The nine palaces receive stars that combine with the Lo Shu layout. We assess mountain and water stars, element balance and Period 9 adjustments to recommend placement and remedies.'**
  String get methodFengShuiBody;

  /// No description provided for @methodMaoShanTitle.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan'**
  String get methodMaoShanTitle;

  /// No description provided for @methodMaoShanBody.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan (Mount Mao) traditions are integrated where appropriate for ritual and practice within Master Elf\'s system. The methods are applied with respect to classical form and purpose, supporting both spiritual and practical dimensions of Chinese metaphysics as used in his framework.'**
  String get methodMaoShanBody;

  /// No description provided for @appointmentIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose your consultation type, pick a time, and receive an SMS confirmation to your phone.'**
  String get appointmentIntro;

  /// No description provided for @stepChooseService.
  ///
  /// In en, this message translates to:
  /// **'Selection'**
  String get stepChooseService;

  /// No description provided for @stepDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get stepDateAndTime;

  /// No description provided for @stepYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get stepYourDetails;

  /// No description provided for @stepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get stepConfirm;

  /// No description provided for @stepGuideChooseService.
  ///
  /// In en, this message translates to:
  /// **'Pick the consultation type and how you\'d like to meet.'**
  String get stepGuideChooseService;

  /// No description provided for @stepGuideDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Choose a date and time that work for you.'**
  String get stepGuideDateAndTime;

  /// No description provided for @stepGuideYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Share your name and phone so we can confirm your booking.'**
  String get stepGuideYourDetails;

  /// No description provided for @stepGuideConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review your booking and confirm to receive an SMS.'**
  String get stepGuideConfirm;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @yourPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get yourPhone;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send your confirmation via SMS'**
  String get phoneHint;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred time'**
  String get selectTime;

  /// No description provided for @confirmAndBook.
  ///
  /// In en, this message translates to:
  /// **'Confirm & book'**
  String get confirmAndBook;

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get bookingSuccessTitle;

  /// No description provided for @bookingSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your consultation has been reserved.'**
  String get bookingSuccessMessage;

  /// No description provided for @smsConfirmationNote.
  ///
  /// In en, this message translates to:
  /// **'An SMS confirmation has been sent to your phone.'**
  String get smsConfirmationNote;

  /// No description provided for @smsPoweredByPlasGate.
  ///
  /// In en, this message translates to:
  /// **'SMS confirmation sent via PlasGate.'**
  String get smsPoweredByPlasGate;

  /// No description provided for @smsStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'SMS status'**
  String get smsStatusLabel;

  /// No description provided for @sessionDurationNote.
  ///
  /// In en, this message translates to:
  /// **'Sessions from 1 hour. Open daily 8 AM–10 PM (Cambodia time).'**
  String get sessionDurationNote;

  /// No description provided for @selectDuration.
  ///
  /// In en, this message translates to:
  /// **'Session duration'**
  String get selectDuration;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String durationHours(int hours);

  /// No description provided for @confirmSessionDuration.
  ///
  /// In en, this message translates to:
  /// **'{hours}-hour session'**
  String confirmSessionDuration(int hours);

  /// No description provided for @bookingUntilTime.
  ///
  /// In en, this message translates to:
  /// **'until {time}'**
  String bookingUntilTime(String time);

  /// No description provided for @bookingContinued.
  ///
  /// In en, this message translates to:
  /// **'Continued'**
  String get bookingContinued;

  /// No description provided for @sessionType.
  ///
  /// In en, this message translates to:
  /// **'Session type'**
  String get sessionType;

  /// No description provided for @sessionTypeOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get sessionTypeOnline;

  /// No description provided for @sessionTypeVisit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get sessionTypeVisit;

  /// No description provided for @bookAnother.
  ///
  /// In en, this message translates to:
  /// **'Book another'**
  String get bookAnother;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @viewYourBookings.
  ///
  /// In en, this message translates to:
  /// **'View your bookings'**
  String get viewYourBookings;

  /// No description provided for @viewYourBookingsIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to see your upcoming and past bookings.'**
  String get viewYourBookingsIntro;

  /// No description provided for @findMyBookings.
  ///
  /// In en, this message translates to:
  /// **'Find my bookings'**
  String get findMyBookings;

  /// No description provided for @bookingReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get bookingReference;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found for this number.'**
  String get noBookingsFound;

  /// No description provided for @cancelBookingButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBookingButton;

  /// No description provided for @cancelBookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking?'**
  String get cancelBookingConfirm;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled.'**
  String get bookingCancelled;

  /// No description provided for @loadingSlots.
  ///
  /// In en, this message translates to:
  /// **'Loading available times…'**
  String get loadingSlots;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get markAsCompleted;

  /// No description provided for @customTime.
  ///
  /// In en, this message translates to:
  /// **'Custom time…'**
  String get customTime;

  /// No description provided for @editTime.
  ///
  /// In en, this message translates to:
  /// **'Edit time'**
  String get editTime;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @smartMoveHeading.
  ///
  /// In en, this message translates to:
  /// **'Every Move Can Be A Smart Move'**
  String get smartMoveHeading;

  /// No description provided for @smartMoveIntro.
  ///
  /// In en, this message translates to:
  /// **'Behind every breakthrough is a moment of clarity. When you see the full picture, opportunities arise, decisions become easier, and progress flows naturally. That\'s what we help you with: seeing clearly turns your next step into the right one. A consultation with our team gives you more than insight. It gives you structure to move forward with confidence.'**
  String get smartMoveIntro;

  /// No description provided for @smartMoveCard1Title.
  ///
  /// In en, this message translates to:
  /// **'Reach Your Personal Goals'**
  String get smartMoveCard1Title;

  /// No description provided for @smartMoveCard1Desc.
  ///
  /// In en, this message translates to:
  /// **'Turn ambitions into achievable milestones with clear guidance.'**
  String get smartMoveCard1Desc;

  /// No description provided for @smartMoveCard2Title.
  ///
  /// In en, this message translates to:
  /// **'Create a Roadmap That Fits'**
  String get smartMoveCard2Title;

  /// No description provided for @smartMoveCard2Desc.
  ///
  /// In en, this message translates to:
  /// **'Get a structured plan tailored to your life, career, or business.'**
  String get smartMoveCard2Desc;

  /// No description provided for @smartMoveCard3Title.
  ///
  /// In en, this message translates to:
  /// **'Remove Hidden Roadblocks'**
  String get smartMoveCard3Title;

  /// No description provided for @smartMoveCard3Desc.
  ///
  /// In en, this message translates to:
  /// **'Identify obstacles you didn\'t see and learn how to move past them.'**
  String get smartMoveCard3Desc;

  /// No description provided for @smartMoveCard4Title.
  ///
  /// In en, this message translates to:
  /// **'Gain Situational Awareness'**
  String get smartMoveCard4Title;

  /// No description provided for @smartMoveCard4Desc.
  ///
  /// In en, this message translates to:
  /// **'See your situation as it is so decisions feel lighter and easier.'**
  String get smartMoveCard4Desc;

  /// No description provided for @smartMoveCard5Title.
  ///
  /// In en, this message translates to:
  /// **'Unlock Better Options'**
  String get smartMoveCard5Title;

  /// No description provided for @smartMoveCard5Desc.
  ///
  /// In en, this message translates to:
  /// **'Discover choices you didn\'t know you had and select the one that serves you best.'**
  String get smartMoveCard5Desc;

  /// No description provided for @smartMoveCard6Title.
  ///
  /// In en, this message translates to:
  /// **'Move in the Right Direction'**
  String get smartMoveCard6Title;

  /// No description provided for @smartMoveCard6Desc.
  ///
  /// In en, this message translates to:
  /// **'Act with timing and alignment so progress feels natural and sustainable.'**
  String get smartMoveCard6Desc;

  /// No description provided for @contactLetsConnect.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Connect!'**
  String get contactLetsConnect;

  /// No description provided for @contactIntro.
  ///
  /// In en, this message translates to:
  /// **'Whether you are seeking clarity through a consultation, exploring our programs, or reaching out for collaborations, our team is here to guide you. Simply choose your subject, leave your message, and we will connect with you shortly.'**
  String get contactIntro;

  /// No description provided for @contactFormName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get contactFormName;

  /// No description provided for @contactFormEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactFormEmail;

  /// No description provided for @contactFormPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactFormPhone;

  /// No description provided for @contactFormSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get contactFormSubject;

  /// No description provided for @contactFormMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactFormMessage;

  /// No description provided for @contactSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get contactSending;

  /// No description provided for @contactSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get contactSuccessTitle;

  /// No description provided for @contactSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent successfully. Our team will get back to you soon.'**
  String get contactSuccess;

  /// No description provided for @contactErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send your message'**
  String get contactErrorTitle;

  /// No description provided for @contactError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again or email us directly.'**
  String get contactError;

  /// No description provided for @contactSubjectDestiny.
  ///
  /// In en, this message translates to:
  /// **'Destiny / Personal Reading (Bazi)'**
  String get contactSubjectDestiny;

  /// No description provided for @contactSubjectBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business & Strategy Planning (Qi Men / Business Date Selection)'**
  String get contactSubjectBusiness;

  /// No description provided for @contactSubjectFengShui.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui (Home / Office Alignment)'**
  String get contactSubjectFengShui;

  /// No description provided for @contactSubjectDateSelection.
  ///
  /// In en, this message translates to:
  /// **'Date Selection (Training Specifics)'**
  String get contactSubjectDateSelection;

  /// No description provided for @contactSubjectUnsure.
  ///
  /// In en, this message translates to:
  /// **'Unsure - I need your recommendation'**
  String get contactSubjectUnsure;

  /// No description provided for @forecastAuspiciousStars.
  ///
  /// In en, this message translates to:
  /// **'Auspicious Stars'**
  String get forecastAuspiciousStars;

  /// No description provided for @forecastInauspiciousStars.
  ///
  /// In en, this message translates to:
  /// **'Inauspicious Stars'**
  String get forecastInauspiciousStars;

  /// No description provided for @zodiacRat.
  ///
  /// In en, this message translates to:
  /// **'Rat'**
  String get zodiacRat;

  /// No description provided for @zodiacOx.
  ///
  /// In en, this message translates to:
  /// **'Ox'**
  String get zodiacOx;

  /// No description provided for @zodiacTiger.
  ///
  /// In en, this message translates to:
  /// **'Tiger'**
  String get zodiacTiger;

  /// No description provided for @zodiacRabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get zodiacRabbit;

  /// No description provided for @zodiacDragon.
  ///
  /// In en, this message translates to:
  /// **'Dragon'**
  String get zodiacDragon;

  /// No description provided for @zodiacSnake.
  ///
  /// In en, this message translates to:
  /// **'Snake'**
  String get zodiacSnake;

  /// No description provided for @zodiacHorse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get zodiacHorse;

  /// No description provided for @zodiacGoat.
  ///
  /// In en, this message translates to:
  /// **'Goat'**
  String get zodiacGoat;

  /// No description provided for @zodiacMonkey.
  ///
  /// In en, this message translates to:
  /// **'Monkey'**
  String get zodiacMonkey;

  /// No description provided for @zodiacRooster.
  ///
  /// In en, this message translates to:
  /// **'Rooster'**
  String get zodiacRooster;

  /// No description provided for @zodiacDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get zodiacDog;

  /// No description provided for @zodiacPig.
  ///
  /// In en, this message translates to:
  /// **'Pig'**
  String get zodiacPig;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @forecastYearBingWu.
  ///
  /// In en, this message translates to:
  /// **'2026 Bing Wu, Year of Fire Horse'**
  String get forecastYearBingWu;

  /// No description provided for @forecastYearSubtitle.
  ///
  /// In en, this message translates to:
  /// **'2026: New Beginnings & Transformation'**
  String get forecastYearSubtitle;

  /// No description provided for @logoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Logo {number}'**
  String logoPlaceholder(int number);

  /// No description provided for @sampleArticle1.
  ///
  /// In en, this message translates to:
  /// **'Sample article 1'**
  String get sampleArticle1;

  /// No description provided for @sampleArticle2.
  ///
  /// In en, this message translates to:
  /// **'Sample article 2'**
  String get sampleArticle2;

  /// No description provided for @sampleFeature.
  ///
  /// In en, this message translates to:
  /// **'Sample feature'**
  String get sampleFeature;

  /// No description provided for @event1Title.
  ///
  /// In en, this message translates to:
  /// **'Master Elf - The Rise of Phoenix 2026'**
  String get event1Title;

  /// No description provided for @event1Description.
  ///
  /// In en, this message translates to:
  /// **'The Master Revelation.'**
  String get event1Description;

  /// No description provided for @event1Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh'**
  String get event1Location;

  /// No description provided for @event2Title.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui & Astrology 2026'**
  String get event2Title;

  /// No description provided for @event2Description.
  ///
  /// In en, this message translates to:
  /// **'The Singapore Edition of Feng Shui & Astrology 2026—now available as an online replay.'**
  String get event2Description;

  /// No description provided for @event2Location.
  ///
  /// In en, this message translates to:
  /// **'Resorts World Sentosa, Singapore'**
  String get event2Location;

  /// No description provided for @event3Title.
  ///
  /// In en, this message translates to:
  /// **'Crimson Horse QiMen'**
  String get event3Title;

  /// No description provided for @event3Description.
  ///
  /// In en, this message translates to:
  /// **'The Art of War in the Year of the Fire Horse—completed online event, available for replay.'**
  String get event3Description;

  /// No description provided for @event3Location.
  ///
  /// In en, this message translates to:
  /// **'Resorts World Singapore'**
  String get event3Location;

  /// No description provided for @event4Title.
  ///
  /// In en, this message translates to:
  /// **'Date Selection Masterclass'**
  String get event4Title;

  /// No description provided for @event4Description.
  ///
  /// In en, this message translates to:
  /// **'Choose auspicious timing for key life decisions.'**
  String get event4Description;

  /// No description provided for @event4Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh'**
  String get event4Location;

  /// No description provided for @loginSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff / Admin Login'**
  String get loginSectionTitle;

  /// No description provided for @loginSectionIntro.
  ///
  /// In en, this message translates to:
  /// **'Log in to access the appointment dashboard and manage bookings.'**
  String get loginSectionIntro;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutButton;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @siteInspection.
  ///
  /// In en, this message translates to:
  /// **'Site Inspection'**
  String get siteInspection;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage all bookings'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardStatsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get dashboardStatsTotal;

  /// No description provided for @dashboardStatsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get dashboardStatsPending;

  /// No description provided for @dashboardStatsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get dashboardStatsConfirmed;

  /// No description provided for @dashboardStatsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get dashboardStatsCancelled;

  /// No description provided for @dashboardStatsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get dashboardStatsCompleted;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// No description provided for @statusColumn.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusColumn;

  /// No description provided for @actionsColumn.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actionsColumn;

  /// No description provided for @appointmentsListRange.
  ///
  /// In en, this message translates to:
  /// **'Showing {start}–{end} of {total}'**
  String appointmentsListRange(int start, int end, int total);

  /// No description provided for @appointmentsListPage.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String appointmentsListPage(int current, int total);

  /// No description provided for @searchAppointments.
  ///
  /// In en, this message translates to:
  /// **'Search appointments…'**
  String get searchAppointments;

  /// No description provided for @exportAppointmentsList.
  ///
  /// In en, this message translates to:
  /// **'Export List'**
  String get exportAppointmentsList;

  /// No description provided for @noAppointmentsMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No appointments match your search.'**
  String get noAppointmentsMatchSearch;

  /// No description provided for @appointmentsListPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments List'**
  String get appointmentsListPdfTitle;

  /// No description provided for @appointmentsPdfExportStarted.
  ///
  /// In en, this message translates to:
  /// **'Appointments list PDF download started.'**
  String get appointmentsPdfExportStarted;

  /// No description provided for @appointmentsPdfExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export appointments list.'**
  String get appointmentsPdfExportFailed;

  /// No description provided for @dashboardStatsFilteredTotal.
  ///
  /// In en, this message translates to:
  /// **'Filtered total'**
  String get dashboardStatsFilteredTotal;

  /// No description provided for @switchToListToSearchExport.
  ///
  /// In en, this message translates to:
  /// **'Switch to List view to search or export.'**
  String get switchToListToSearchExport;

  /// No description provided for @slotTimeNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Selected time is not available. Please choose another slot.'**
  String get slotTimeNotAvailable;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @appointmentName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get appointmentName;

  /// No description provided for @appointmentPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get appointmentPhone;

  /// No description provided for @confirmAppointment.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAppointment;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments found.'**
  String get noAppointments;

  /// No description provided for @loadingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Loading appointments…'**
  String get loadingAppointments;

  /// No description provided for @errorLoadingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Failed to load appointments.'**
  String get errorLoadingAppointments;

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated.'**
  String get statusUpdated;

  /// No description provided for @errorUpdatingStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status.'**
  String get errorUpdatingStatus;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get loginError;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access the dashboard.'**
  String get loginRequired;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @calendarView.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listView;

  /// No description provided for @createBooking.
  ///
  /// In en, this message translates to:
  /// **'Create booking'**
  String get createBooking;

  /// No description provided for @createBookingFor.
  ///
  /// In en, this message translates to:
  /// **'Create booking for client'**
  String get createBookingFor;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Select date & time'**
  String get selectDateAndTime;

  /// No description provided for @bookingCreated.
  ///
  /// In en, this message translates to:
  /// **'Booking created successfully.'**
  String get bookingCreated;

  /// No description provided for @errorCreatingBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to create booking.'**
  String get errorCreatingBooking;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @availableSlots.
  ///
  /// In en, this message translates to:
  /// **'Available slots'**
  String get availableSlots;

  /// No description provided for @addBooking.
  ///
  /// In en, this message translates to:
  /// **'Add booking'**
  String get addBooking;

  /// No description provided for @pleaseEnterNameAndPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter name and phone.'**
  String get pleaseEnterNameAndPhone;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Optional notes about this booking…'**
  String get noteHint;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network connection failed. Please check your internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get errorNetworkTitle;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please check your connection and try again.'**
  String get errorTimeout;

  /// No description provided for @errorServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable. Please try again.'**
  String get errorServerUnavailable;

  /// No description provided for @errorServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred. Please try again later.'**
  String get errorServerError;

  /// No description provided for @errorDatabaseError.
  ///
  /// In en, this message translates to:
  /// **'Database error occurred. Please try again.'**
  String get errorDatabaseError;

  /// No description provided for @errorAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get errorAuthFailed;

  /// No description provided for @errorAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication Error'**
  String get errorAuthTitle;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get errorWrongPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get errorEmailInUse;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get errorInvalidEmail;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get errorTooManyRequests;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get errorPermissionDenied;

  /// No description provided for @errorPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get errorPermissionTitle;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get errorNotFound;

  /// No description provided for @errorNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get errorNotFoundTitle;

  /// No description provided for @errorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input. Please check your information.'**
  String get errorInvalidInput;

  /// No description provided for @errorValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get errorValidationTitle;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @errorRateLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Too Many Requests'**
  String get errorRateLimitTitle;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEmailInvalid;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too short'**
  String get validationPhoneTooShort;

  /// No description provided for @validationPhoneTooLong.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too long'**
  String get validationPhoneTooLong;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get validationPhoneInvalid;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;

  /// No description provided for @validationNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get validationNameTooShort;

  /// No description provided for @validationNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get validationNameTooLong;

  /// No description provided for @validationMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get validationMessageRequired;

  /// No description provided for @validationMessageTooShort.
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters'**
  String get validationMessageTooShort;

  /// No description provided for @validationMessageTooLong.
  ///
  /// In en, this message translates to:
  /// **'Message is too long (maximum 2000 characters)'**
  String get validationMessageTooLong;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String validationRequired(String field);

  /// No description provided for @validationDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Date is required'**
  String get validationDateRequired;

  /// No description provided for @validationDateNotPast.
  ///
  /// In en, this message translates to:
  /// **'Please select a date in the future'**
  String get validationDateNotPast;

  /// No description provided for @validationTimeRequired.
  ///
  /// In en, this message translates to:
  /// **'Time slot is required'**
  String get validationTimeRequired;

  /// No description provided for @validationTimeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid time slot'**
  String get validationTimeInvalid;

  /// No description provided for @validationFormErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors below'**
  String get validationFormErrors;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password is too long (maximum 128 characters)'**
  String get validationPasswordTooLong;

  /// No description provided for @validationPasswordNoUpperCase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get validationPasswordNoUpperCase;

  /// No description provided for @validationPasswordNoLowerCase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get validationPasswordNoLowerCase;

  /// No description provided for @validationPasswordNoNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get validationPasswordNoNumber;

  /// No description provided for @validationUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'URL is required'**
  String get validationUrlRequired;

  /// No description provided for @validationUrlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL (must start with http:// or https://)'**
  String get validationUrlInvalid;

  /// No description provided for @semanticsNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get semanticsNavigation;

  /// No description provided for @semanticsMainContent.
  ///
  /// In en, this message translates to:
  /// **'Main content'**
  String get semanticsMainContent;

  /// No description provided for @semanticsFooter.
  ///
  /// In en, this message translates to:
  /// **'Footer'**
  String get semanticsFooter;

  /// No description provided for @drawerNavigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get drawerNavigate;

  /// No description provided for @drawerGetInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get drawerGetInTouch;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get buttonOk;

  /// No description provided for @buttonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get buttonAdd;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @validationPleaseSelectService.
  ///
  /// In en, this message translates to:
  /// **'Please select a service'**
  String get validationPleaseSelectService;

  /// No description provided for @noSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No slots available for this date.'**
  String get noSlotsAvailable;

  /// No description provided for @slotsEstimateWarning.
  ///
  /// In en, this message translates to:
  /// **'Showing estimated times — live availability could not be loaded. Please confirm with us after booking.'**
  String get slotsEstimateWarning;

  /// No description provided for @slotsFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the booking server. Times shown are estimates only — please confirm with us after booking.'**
  String get slotsFetchFailed;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by Stonechat Communications'**
  String get poweredBy;

  /// No description provided for @tooltipWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get tooltipWhatsApp;

  /// No description provided for @tooltipFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get tooltipFacebook;

  /// No description provided for @tooltipInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get tooltipInstagram;

  /// No description provided for @tooltipTikTok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get tooltipTikTok;

  /// No description provided for @tooltipTelegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get tooltipTelegram;

  /// No description provided for @tooltipEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get tooltipEmail;

  /// No description provided for @loadingExperience.
  ///
  /// In en, this message translates to:
  /// **'Loading your experience…'**
  String get loadingExperience;

  /// No description provided for @loadingOptimising.
  ///
  /// In en, this message translates to:
  /// **'Optimising view…'**
  String get loadingOptimising;

  /// No description provided for @loadingAlmostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there…'**
  String get loadingAlmostThere;

  /// No description provided for @loadingJustAMoment.
  ///
  /// In en, this message translates to:
  /// **'Just a moment…'**
  String get loadingJustAMoment;

  /// No description provided for @eventRegEmailSubjectPrefix.
  ///
  /// In en, this message translates to:
  /// **'Event Registration: '**
  String get eventRegEmailSubjectPrefix;

  /// No description provided for @eventRegEmailBodyRegistrant.
  ///
  /// In en, this message translates to:
  /// **'Registrant'**
  String get eventRegEmailBodyRegistrant;

  /// No description provided for @sectionTestimonialsPart1.
  ///
  /// In en, this message translates to:
  /// **'Real '**
  String get sectionTestimonialsPart1;

  /// No description provided for @sectionTestimonialsPart2.
  ///
  /// In en, this message translates to:
  /// **'Insights.\n'**
  String get sectionTestimonialsPart2;

  /// No description provided for @sectionTestimonialsPart3.
  ///
  /// In en, this message translates to:
  /// **'Real '**
  String get sectionTestimonialsPart3;

  /// No description provided for @sectionTestimonialsPart4.
  ///
  /// In en, this message translates to:
  /// **'Outcomes.'**
  String get sectionTestimonialsPart4;

  /// No description provided for @inspectionFormTitle.
  ///
  /// In en, this message translates to:
  /// **'FENG SHUI GEOMANCY SITE INSPECTION FORM'**
  String get inspectionFormTitle;

  /// No description provided for @inspectionFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Commercial Housing Complex Assessment'**
  String get inspectionFormSubtitle;

  /// No description provided for @inspectionStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String inspectionStepOf(int current, int total);

  /// No description provided for @inspectionDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection Dashboard'**
  String get inspectionDashboardTitle;

  /// No description provided for @inspectionDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View, edit or continue your inspections'**
  String get inspectionDashboardSubtitle;

  /// No description provided for @inspectionContinue.
  ///
  /// In en, this message translates to:
  /// **'Edit / Continue'**
  String get inspectionContinue;

  /// No description provided for @inspectionNoInspections.
  ///
  /// In en, this message translates to:
  /// **'No inspections yet'**
  String get inspectionNoInspections;

  /// No description provided for @inspectionStartFirst.
  ///
  /// In en, this message translates to:
  /// **'Start your first inspection'**
  String get inspectionStartFirst;

  /// No description provided for @inspectionSave.
  ///
  /// In en, this message translates to:
  /// **'Save Inspection'**
  String get inspectionSave;

  /// No description provided for @inspectionSaveProgress.
  ///
  /// In en, this message translates to:
  /// **'Save progress'**
  String get inspectionSaveProgress;

  /// No description provided for @inspectionSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get inspectionSaving;

  /// No description provided for @inspectionNewInspection.
  ///
  /// In en, this message translates to:
  /// **'New Inspection'**
  String get inspectionNewInspection;

  /// No description provided for @inspectionDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get inspectionDownloadPdf;

  /// No description provided for @inspectionSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection Saved'**
  String get inspectionSavedTitle;

  /// No description provided for @inspectionSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Feng Shui site inspection has been saved successfully.'**
  String get inspectionSavedMessage;

  /// No description provided for @inspectionPdfDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'PDF download started.'**
  String get inspectionPdfDownloadStarted;

  /// No description provided for @inspectionPdfExportFailed.
  ///
  /// In en, this message translates to:
  /// **'PDF export failed'**
  String get inspectionPdfExportFailed;

  /// No description provided for @inspectionSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save inspection'**
  String get inspectionSaveFailed;

  /// No description provided for @inspectionSection0.
  ///
  /// In en, this message translates to:
  /// **'Header & Inspection Info'**
  String get inspectionSection0;

  /// No description provided for @inspectionSection1.
  ///
  /// In en, this message translates to:
  /// **'Section 1: Basic Project Information'**
  String get inspectionSection1;

  /// No description provided for @inspectionSection2.
  ///
  /// In en, this message translates to:
  /// **'Section 2: Site Measurements'**
  String get inspectionSection2;

  /// No description provided for @inspectionSection3.
  ///
  /// In en, this message translates to:
  /// **'Section 3: External Landform (Four Celestial Animals)'**
  String get inspectionSection3;

  /// No description provided for @inspectionSection4.
  ///
  /// In en, this message translates to:
  /// **'Section 4: Macro Landform and Environment'**
  String get inspectionSection4;

  /// No description provided for @inspectionSection5.
  ///
  /// In en, this message translates to:
  /// **'Section 5: Road and Traffic Analysis'**
  String get inspectionSection5;

  /// No description provided for @inspectionSection6.
  ///
  /// In en, this message translates to:
  /// **'Section 6: Water Features'**
  String get inspectionSection6;

  /// No description provided for @inspectionSection7.
  ///
  /// In en, this message translates to:
  /// **'Section 7: Sha Qi - Negative Influences'**
  String get inspectionSection7;

  /// No description provided for @inspectionSection8.
  ///
  /// In en, this message translates to:
  /// **'Section 8: Comprehensive Compass Readings'**
  String get inspectionSection8;

  /// No description provided for @inspectionSection9.
  ///
  /// In en, this message translates to:
  /// **'Section 9: Xuan Kong Flying Star'**
  String get inspectionSection9;

  /// No description provided for @inspectionSection10.
  ///
  /// In en, this message translates to:
  /// **'Section 10: Eight Mansions Analysis'**
  String get inspectionSection10;

  /// No description provided for @inspectionSection11.
  ///
  /// In en, this message translates to:
  /// **'Section 11: Client and Occupant Bazi'**
  String get inspectionSection11;

  /// No description provided for @inspectionSection12.
  ///
  /// In en, this message translates to:
  /// **'Section 12: Qi Men Dun Jia Date Selection'**
  String get inspectionSection12;

  /// No description provided for @inspectionSection13.
  ///
  /// In en, this message translates to:
  /// **'Section 13: Internal Layout Inspection'**
  String get inspectionSection13;

  /// No description provided for @inspectionSection14.
  ///
  /// In en, this message translates to:
  /// **'Section 14: Safety, Practical and Legal'**
  String get inspectionSection14;

  /// No description provided for @inspectionSection15.
  ///
  /// In en, this message translates to:
  /// **'Section 15: Documentation and Evidence'**
  String get inspectionSection15;

  /// No description provided for @inspectionSection16.
  ///
  /// In en, this message translates to:
  /// **'Section 16: Preliminary Assessment Summary'**
  String get inspectionSection16;

  /// No description provided for @inspectionSection17.
  ///
  /// In en, this message translates to:
  /// **'Section 17: Follow-up Actions'**
  String get inspectionSection17;

  /// No description provided for @inspectionNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Inspection Name'**
  String get inspectionNameLabel;

  /// No description provided for @inspectionNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Riverside Shophouse, Tower A Site Visit'**
  String get inspectionNameHint;

  /// No description provided for @inspectionInspectorName.
  ///
  /// In en, this message translates to:
  /// **'Inspector Name'**
  String get inspectionInspectorName;

  /// No description provided for @inspectionDate.
  ///
  /// In en, this message translates to:
  /// **'Date of Inspection'**
  String get inspectionDate;

  /// No description provided for @inspectionTimeOfArrival.
  ///
  /// In en, this message translates to:
  /// **'Time of Arrival'**
  String get inspectionTimeOfArrival;

  /// No description provided for @inspectionWeatherConditions.
  ///
  /// In en, this message translates to:
  /// **'Weather Conditions'**
  String get inspectionWeatherConditions;

  /// No description provided for @inspectionProjectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get inspectionProjectName;

  /// No description provided for @inspectionAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get inspectionAddress;

  /// No description provided for @inspectionDistrictSangkat.
  ///
  /// In en, this message translates to:
  /// **'District/Sangkat'**
  String get inspectionDistrictSangkat;

  /// No description provided for @inspectionGoogleMapsLink.
  ///
  /// In en, this message translates to:
  /// **'Google Maps Link'**
  String get inspectionGoogleMapsLink;

  /// No description provided for @inspectionProjectType.
  ///
  /// In en, this message translates to:
  /// **'Project Type'**
  String get inspectionProjectType;

  /// No description provided for @inspectionProjectTypeShophouse.
  ///
  /// In en, this message translates to:
  /// **'Shophouse'**
  String get inspectionProjectTypeShophouse;

  /// No description provided for @inspectionProjectTypeCommercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial Building'**
  String get inspectionProjectTypeCommercial;

  /// No description provided for @inspectionProjectTypeMixedUse.
  ///
  /// In en, this message translates to:
  /// **'Mixed-Use Development'**
  String get inspectionProjectTypeMixedUse;

  /// No description provided for @inspectionProjectTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get inspectionProjectTypeOther;

  /// No description provided for @inspectionOtherSpecify.
  ///
  /// In en, this message translates to:
  /// **'Other (if selected)'**
  String get inspectionOtherSpecify;

  /// No description provided for @inspectionHintSpecify.
  ///
  /// In en, this message translates to:
  /// **'Specify'**
  String get inspectionHintSpecify;

  /// No description provided for @inspectionConstructionStatus.
  ///
  /// In en, this message translates to:
  /// **'Construction Status'**
  String get inspectionConstructionStatus;

  /// No description provided for @inspectionConstructionUnder.
  ///
  /// In en, this message translates to:
  /// **'Under Construction'**
  String get inspectionConstructionUnder;

  /// No description provided for @inspectionConstructionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get inspectionConstructionCompleted;

  /// No description provided for @inspectionConstructionPartially.
  ///
  /// In en, this message translates to:
  /// **'Partially Occupied'**
  String get inspectionConstructionPartially;

  /// No description provided for @inspectionConstructionFully.
  ///
  /// In en, this message translates to:
  /// **'Fully Occupied'**
  String get inspectionConstructionFully;

  /// No description provided for @inspectionEstimatedCompletionYear.
  ///
  /// In en, this message translates to:
  /// **'Estimated Completion Year'**
  String get inspectionEstimatedCompletionYear;

  /// No description provided for @inspectionNumberOfFloors.
  ///
  /// In en, this message translates to:
  /// **'Number of Floors'**
  String get inspectionNumberOfFloors;

  /// No description provided for @inspectionNumberOfUnits.
  ///
  /// In en, this message translates to:
  /// **'Number of Units'**
  String get inspectionNumberOfUnits;

  /// No description provided for @inspectionRenovationDates.
  ///
  /// In en, this message translates to:
  /// **'Previous renovation date(s)'**
  String get inspectionRenovationDates;

  /// No description provided for @inspectionStructuralChanges.
  ///
  /// In en, this message translates to:
  /// **'Structural changes made'**
  String get inspectionStructuralChanges;

  /// No description provided for @inspectionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get inspectionYes;

  /// No description provided for @inspectionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get inspectionNo;

  /// No description provided for @inspectionRenovationDetails.
  ///
  /// In en, this message translates to:
  /// **'Renovation details'**
  String get inspectionRenovationDetails;

  /// No description provided for @inspectionConstructionPhase.
  ///
  /// In en, this message translates to:
  /// **'Current Construction Phase'**
  String get inspectionConstructionPhase;

  /// No description provided for @inspectionPhaseAllBlocks.
  ///
  /// In en, this message translates to:
  /// **'All blocks completed simultaneously'**
  String get inspectionPhaseAllBlocks;

  /// No description provided for @inspectionPhasePhased.
  ///
  /// In en, this message translates to:
  /// **'Phased completion (different blocks/different years)'**
  String get inspectionPhasePhased;

  /// No description provided for @inspectionPhaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Phase details'**
  String get inspectionPhaseDetails;

  /// No description provided for @inspectionDimensions.
  ///
  /// In en, this message translates to:
  /// **'2.1 Dimensions'**
  String get inspectionDimensions;

  /// No description provided for @inspectionFrontageWidth.
  ///
  /// In en, this message translates to:
  /// **'Frontage Width (m)'**
  String get inspectionFrontageWidth;

  /// No description provided for @inspectionDepthLength.
  ///
  /// In en, this message translates to:
  /// **'Depth/Length (m)'**
  String get inspectionDepthLength;

  /// No description provided for @inspectionTotalSiteArea.
  ///
  /// In en, this message translates to:
  /// **'Total Site Area (m²)'**
  String get inspectionTotalSiteArea;

  /// No description provided for @inspectionUnitWidth.
  ///
  /// In en, this message translates to:
  /// **'Unit Width (m)'**
  String get inspectionUnitWidth;

  /// No description provided for @inspectionUnitDepth.
  ///
  /// In en, this message translates to:
  /// **'Unit Depth (m)'**
  String get inspectionUnitDepth;

  /// No description provided for @inspectionUnitArea.
  ///
  /// In en, this message translates to:
  /// **'Unit Area (m²)'**
  String get inspectionUnitArea;

  /// No description provided for @inspectionFloorToCeilingHeight.
  ///
  /// In en, this message translates to:
  /// **'Floor-to-ceiling Height (m)'**
  String get inspectionFloorToCeilingHeight;

  /// No description provided for @inspectionOrientationCompass.
  ///
  /// In en, this message translates to:
  /// **'2.2 Orientation and Compass Readings'**
  String get inspectionOrientationCompass;

  /// No description provided for @inspectionEquipmentUsed.
  ///
  /// In en, this message translates to:
  /// **'Equipment Used'**
  String get inspectionEquipmentUsed;

  /// No description provided for @inspectionEquipmentLuoPan.
  ///
  /// In en, this message translates to:
  /// **'Traditional Luo Pan Compass'**
  String get inspectionEquipmentLuoPan;

  /// No description provided for @inspectionEquipmentDigital.
  ///
  /// In en, this message translates to:
  /// **'Digital Compass'**
  String get inspectionEquipmentDigital;

  /// No description provided for @inspectionEquipmentSmartphone.
  ///
  /// In en, this message translates to:
  /// **'Smartphone Compass App'**
  String get inspectionEquipmentSmartphone;

  /// No description provided for @inspectionEquipmentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get inspectionEquipmentOther;

  /// No description provided for @inspectionOtherEquipment.
  ///
  /// In en, this message translates to:
  /// **'Other equipment'**
  String get inspectionOtherEquipment;

  /// No description provided for @inspectionFacingReading1.
  ///
  /// In en, this message translates to:
  /// **'Facing Direction - Reading 1 (degrees)'**
  String get inspectionFacingReading1;

  /// No description provided for @inspectionFacingReading2.
  ///
  /// In en, this message translates to:
  /// **'Facing Direction - Reading 2 (degrees)'**
  String get inspectionFacingReading2;

  /// No description provided for @inspectionFacingReading3.
  ///
  /// In en, this message translates to:
  /// **'Facing Direction - Reading 3 (degrees)'**
  String get inspectionFacingReading3;

  /// No description provided for @inspectionAverageFacing.
  ///
  /// In en, this message translates to:
  /// **'Average Facing (degrees)'**
  String get inspectionAverageFacing;

  /// No description provided for @inspectionConverted24Mountains.
  ///
  /// In en, this message translates to:
  /// **'Converted to 24 Mountains'**
  String get inspectionConverted24Mountains;

  /// No description provided for @inspectionFacingCardinal.
  ///
  /// In en, this message translates to:
  /// **'Facing Direction (Cardinal)'**
  String get inspectionFacingCardinal;

  /// No description provided for @inspectionSittingDirection.
  ///
  /// In en, this message translates to:
  /// **'Sitting Direction (opposite)'**
  String get inspectionSittingDirection;

  /// No description provided for @inspectionMagneticInterferenceNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes on Magnetic Interference'**
  String get inspectionMagneticInterferenceNotes;

  /// No description provided for @inspectionTortoiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Black Tortoise (玄武) - BACK Support'**
  String get inspectionTortoiseTitle;

  /// No description provided for @inspectionDragonTitle.
  ///
  /// In en, this message translates to:
  /// **'Green Dragon (青龍) - LEFT Side'**
  String get inspectionDragonTitle;

  /// No description provided for @inspectionTigerTitle.
  ///
  /// In en, this message translates to:
  /// **'White Tiger (白虎) - RIGHT Side'**
  String get inspectionTigerTitle;

  /// No description provided for @inspectionPhoenixTitle.
  ///
  /// In en, this message translates to:
  /// **'Red Phoenix (朱雀) - FRONT Bright Hall'**
  String get inspectionPhoenixTitle;

  /// No description provided for @inspectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get inspectionDescription;

  /// No description provided for @inspectionAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get inspectionAssessment;

  /// No description provided for @inspectionNotesSketch.
  ///
  /// In en, this message translates to:
  /// **'Notes/Sketch'**
  String get inspectionNotesSketch;

  /// No description provided for @inspectionTortoiseDesc1.
  ///
  /// In en, this message translates to:
  /// **'Higher ground/hill'**
  String get inspectionTortoiseDesc1;

  /// No description provided for @inspectionTortoiseDesc2.
  ///
  /// In en, this message translates to:
  /// **'Taller buildings'**
  String get inspectionTortoiseDesc2;

  /// No description provided for @inspectionTortoiseDesc3.
  ///
  /// In en, this message translates to:
  /// **'Solid structures'**
  String get inspectionTortoiseDesc3;

  /// No description provided for @inspectionTortoiseDesc4.
  ///
  /// In en, this message translates to:
  /// **'Empty land/void'**
  String get inspectionTortoiseDesc4;

  /// No description provided for @inspectionTortoiseDesc5.
  ///
  /// In en, this message translates to:
  /// **'Lower ground'**
  String get inspectionTortoiseDesc5;

  /// No description provided for @inspectionTortoiseDesc6.
  ///
  /// In en, this message translates to:
  /// **'Water body'**
  String get inspectionTortoiseDesc6;

  /// No description provided for @inspectionTortoiseDesc7.
  ///
  /// In en, this message translates to:
  /// **'Road'**
  String get inspectionTortoiseDesc7;

  /// No description provided for @inspectionTortoiseAssess1.
  ///
  /// In en, this message translates to:
  /// **'Strong support (favorable)'**
  String get inspectionTortoiseAssess1;

  /// No description provided for @inspectionTortoiseAssess2.
  ///
  /// In en, this message translates to:
  /// **'Moderate support'**
  String get inspectionTortoiseAssess2;

  /// No description provided for @inspectionTortoiseAssess3.
  ///
  /// In en, this message translates to:
  /// **'Weak support (unfavorable)'**
  String get inspectionTortoiseAssess3;

  /// No description provided for @inspectionDragonDesc1.
  ///
  /// In en, this message translates to:
  /// **'Higher than Tiger side'**
  String get inspectionDragonDesc1;

  /// No description provided for @inspectionDragonDesc2.
  ///
  /// In en, this message translates to:
  /// **'Active (traffic, buildings)'**
  String get inspectionDragonDesc2;

  /// No description provided for @inspectionDragonDesc3.
  ///
  /// In en, this message translates to:
  /// **'Gentle slope'**
  String get inspectionDragonDesc3;

  /// No description provided for @inspectionDragonDesc4.
  ///
  /// In en, this message translates to:
  /// **'Water feature'**
  String get inspectionDragonDesc4;

  /// No description provided for @inspectionDragonDesc5.
  ///
  /// In en, this message translates to:
  /// **'Lower than Tiger side'**
  String get inspectionDragonDesc5;

  /// No description provided for @inspectionDragonDesc6.
  ///
  /// In en, this message translates to:
  /// **'Sharp structures/corners'**
  String get inspectionDragonDesc6;

  /// No description provided for @inspectionDragonDesc7.
  ///
  /// In en, this message translates to:
  /// **'Aggressive forms'**
  String get inspectionDragonDesc7;

  /// No description provided for @inspectionDragonAssess1.
  ///
  /// In en, this message translates to:
  /// **'Dominant and favorable'**
  String get inspectionDragonAssess1;

  /// No description provided for @inspectionDragonAssess2.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get inspectionDragonAssess2;

  /// No description provided for @inspectionDragonAssess3.
  ///
  /// In en, this message translates to:
  /// **'Too weak'**
  String get inspectionDragonAssess3;

  /// No description provided for @inspectionDragonAssess4.
  ///
  /// In en, this message translates to:
  /// **'Too aggressive'**
  String get inspectionDragonAssess4;

  /// No description provided for @inspectionTigerDesc1.
  ///
  /// In en, this message translates to:
  /// **'Lower than Dragon side'**
  String get inspectionTigerDesc1;

  /// No description provided for @inspectionTigerDesc2.
  ///
  /// In en, this message translates to:
  /// **'Calm/passive features'**
  String get inspectionTigerDesc2;

  /// No description provided for @inspectionTigerDesc3.
  ///
  /// In en, this message translates to:
  /// **'Gentle structures'**
  String get inspectionTigerDesc3;

  /// No description provided for @inspectionTigerDesc4.
  ///
  /// In en, this message translates to:
  /// **'Higher than Dragon side'**
  String get inspectionTigerDesc4;

  /// No description provided for @inspectionTigerDesc5.
  ///
  /// In en, this message translates to:
  /// **'Aggressive structures (towers, poles)'**
  String get inspectionTigerDesc5;

  /// No description provided for @inspectionTigerDesc6.
  ///
  /// In en, this message translates to:
  /// **'Very busy road'**
  String get inspectionTigerDesc6;

  /// No description provided for @inspectionTigerAssess1.
  ///
  /// In en, this message translates to:
  /// **'Appropriately subdued (favorable)'**
  String get inspectionTigerAssess1;

  /// No description provided for @inspectionTigerAssess2.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get inspectionTigerAssess2;

  /// No description provided for @inspectionTigerAssess3.
  ///
  /// In en, this message translates to:
  /// **'Too dominant (unfavorable)'**
  String get inspectionTigerAssess3;

  /// No description provided for @inspectionTigerAssess4.
  ///
  /// In en, this message translates to:
  /// **'Too aggressive (inauspicious)'**
  String get inspectionTigerAssess4;

  /// No description provided for @inspectionPhoenixDesc1.
  ///
  /// In en, this message translates to:
  /// **'Open space/plaza'**
  String get inspectionPhoenixDesc1;

  /// No description provided for @inspectionPhoenixDesc2.
  ///
  /// In en, this message translates to:
  /// **'Broad road'**
  String get inspectionPhoenixDesc2;

  /// No description provided for @inspectionPhoenixDesc3.
  ///
  /// In en, this message translates to:
  /// **'Water feature (pond, canal)'**
  String get inspectionPhoenixDesc3;

  /// No description provided for @inspectionPhoenixDesc4.
  ///
  /// In en, this message translates to:
  /// **'Park/garden'**
  String get inspectionPhoenixDesc4;

  /// No description provided for @inspectionPhoenixDesc5.
  ///
  /// In en, this message translates to:
  /// **'Oppressive tall building directly in front'**
  String get inspectionPhoenixDesc5;

  /// No description provided for @inspectionPhoenixDesc6.
  ///
  /// In en, this message translates to:
  /// **'Narrow/cramped space'**
  String get inspectionPhoenixDesc6;

  /// No description provided for @inspectionPhoenixAssess1.
  ///
  /// In en, this message translates to:
  /// **'Excellent bright hall (spacious, gathering Qi)'**
  String get inspectionPhoenixAssess1;

  /// No description provided for @inspectionPhoenixAssess2.
  ///
  /// In en, this message translates to:
  /// **'Moderate bright hall'**
  String get inspectionPhoenixAssess2;

  /// No description provided for @inspectionPhoenixAssess3.
  ///
  /// In en, this message translates to:
  /// **'Poor bright hall (blocked, oppressive)'**
  String get inspectionPhoenixAssess3;

  /// No description provided for @inspectionWiderAreaContext.
  ///
  /// In en, this message translates to:
  /// **'4.1 Wider Area Context'**
  String get inspectionWiderAreaContext;

  /// No description provided for @inspectionDistanceToCityCenter.
  ///
  /// In en, this message translates to:
  /// **'Distance to City Center (km)'**
  String get inspectionDistanceToCityCenter;

  /// No description provided for @inspectionMajorHighways.
  ///
  /// In en, this message translates to:
  /// **'Major highways'**
  String get inspectionMajorHighways;

  /// No description provided for @inspectionRiversWaterBodies.
  ///
  /// In en, this message translates to:
  /// **'Rivers/major water bodies'**
  String get inspectionRiversWaterBodies;

  /// No description provided for @inspectionMountainsTerrain.
  ///
  /// In en, this message translates to:
  /// **'Mountains/elevated terrain'**
  String get inspectionMountainsTerrain;

  /// No description provided for @inspectionDirectionOfMountains.
  ///
  /// In en, this message translates to:
  /// **'Direction of mountains'**
  String get inspectionDirectionOfMountains;

  /// No description provided for @inspectionSurroundingDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Surrounding Development'**
  String get inspectionSurroundingDevelopment;

  /// No description provided for @inspectionMicroEnvironment.
  ///
  /// In en, this message translates to:
  /// **'4.2 Micro Environment Quality'**
  String get inspectionMicroEnvironment;

  /// No description provided for @inspectionPowerLinesDirection.
  ///
  /// In en, this message translates to:
  /// **'Power lines/transmission towers - Direction'**
  String get inspectionPowerLinesDirection;

  /// No description provided for @inspectionBridgesDirection.
  ///
  /// In en, this message translates to:
  /// **'Bridges/flyovers - Direction'**
  String get inspectionBridgesDirection;

  /// No description provided for @inspectionLargeTreesLocation.
  ///
  /// In en, this message translates to:
  /// **'Large trees (height > 3 floors) - Location'**
  String get inspectionLargeTreesLocation;

  /// No description provided for @inspectionReligiousBuildingsDirection.
  ///
  /// In en, this message translates to:
  /// **'Religious buildings - Direction'**
  String get inspectionReligiousBuildingsDirection;

  /// No description provided for @inspectionHospitalDirection.
  ///
  /// In en, this message translates to:
  /// **'Hospital/clinic - Direction'**
  String get inspectionHospitalDirection;

  /// No description provided for @inspectionSchoolDirection.
  ///
  /// In en, this message translates to:
  /// **'School - Direction'**
  String get inspectionSchoolDirection;

  /// No description provided for @inspectionMarketDirection.
  ///
  /// In en, this message translates to:
  /// **'Market - Direction'**
  String get inspectionMarketDirection;

  /// No description provided for @inspectionFactoryDirection.
  ///
  /// In en, this message translates to:
  /// **'Factory/industrial - Direction'**
  String get inspectionFactoryDirection;

  /// No description provided for @inspectionTrafficNoise.
  ///
  /// In en, this message translates to:
  /// **'Traffic noise'**
  String get inspectionTrafficNoise;

  /// No description provided for @inspectionNoiseSources.
  ///
  /// In en, this message translates to:
  /// **'Noise Sources'**
  String get inspectionNoiseSources;

  /// No description provided for @inspectionAirQuality.
  ///
  /// In en, this message translates to:
  /// **'Air Quality and Pollution'**
  String get inspectionAirQuality;

  /// No description provided for @inspectionFoulOdorsFrom.
  ///
  /// In en, this message translates to:
  /// **'Foul odors from'**
  String get inspectionFoulOdorsFrom;

  /// No description provided for @inspectionHeavy.
  ///
  /// In en, this message translates to:
  /// **'Heavy'**
  String get inspectionHeavy;

  /// No description provided for @inspectionModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get inspectionModerate;

  /// No description provided for @inspectionLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get inspectionLight;

  /// No description provided for @inspectionMainRoadName.
  ///
  /// In en, this message translates to:
  /// **'Main Road Name'**
  String get inspectionMainRoadName;

  /// No description provided for @inspectionRoadWidth.
  ///
  /// In en, this message translates to:
  /// **'Road Width (estimated)'**
  String get inspectionRoadWidth;

  /// No description provided for @inspectionRoadPosition.
  ///
  /// In en, this message translates to:
  /// **'Road Position'**
  String get inspectionRoadPosition;

  /// No description provided for @inspectionTrafficFlowDirection.
  ///
  /// In en, this message translates to:
  /// **'Traffic Flow Direction'**
  String get inspectionTrafficFlowDirection;

  /// No description provided for @inspectionTrafficVolume.
  ///
  /// In en, this message translates to:
  /// **'Traffic Volume'**
  String get inspectionTrafficVolume;

  /// No description provided for @inspectionNearbyJunctions.
  ///
  /// In en, this message translates to:
  /// **'Nearby Junctions'**
  String get inspectionNearbyJunctions;

  /// No description provided for @inspectionJunctionDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance from building (m) - if T-junction'**
  String get inspectionJunctionDistance;

  /// No description provided for @inspectionDeflectionBuffer.
  ///
  /// In en, this message translates to:
  /// **'Any deflection/buffer (trees, walls)'**
  String get inspectionDeflectionBuffer;

  /// No description provided for @inspectionRoadAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get inspectionRoadAssessment;

  /// No description provided for @inspectionRoadNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get inspectionRoadNotes;

  /// No description provided for @inspectionServiceRoad.
  ///
  /// In en, this message translates to:
  /// **'Service road'**
  String get inspectionServiceRoad;

  /// No description provided for @inspectionServiceRoadLocation.
  ///
  /// In en, this message translates to:
  /// **'Service road location'**
  String get inspectionServiceRoadLocation;

  /// No description provided for @inspectionBackAlley.
  ///
  /// In en, this message translates to:
  /// **'Back alley'**
  String get inspectionBackAlley;

  /// No description provided for @inspectionBackAlleyWidth.
  ///
  /// In en, this message translates to:
  /// **'Back alley width'**
  String get inspectionBackAlleyWidth;

  /// No description provided for @inspectionCarParkEntrance.
  ///
  /// In en, this message translates to:
  /// **'Car park entrance'**
  String get inspectionCarParkEntrance;

  /// No description provided for @inspectionLoadingBay.
  ///
  /// In en, this message translates to:
  /// **'Loading bay'**
  String get inspectionLoadingBay;

  /// No description provided for @inspectionLoadingBayLocation.
  ///
  /// In en, this message translates to:
  /// **'Loading bay location'**
  String get inspectionLoadingBayLocation;

  /// No description provided for @inspectionFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get inspectionFront;

  /// No description provided for @inspectionSide.
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get inspectionSide;

  /// No description provided for @inspectionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get inspectionBack;

  /// No description provided for @inspectionWaterBodiesPresent.
  ///
  /// In en, this message translates to:
  /// **'Water Bodies Present'**
  String get inspectionWaterBodiesPresent;

  /// No description provided for @inspectionWaterLocation.
  ///
  /// In en, this message translates to:
  /// **'Water Location (relative to building)'**
  String get inspectionWaterLocation;

  /// No description provided for @inspectionWaterFlowDirection.
  ///
  /// In en, this message translates to:
  /// **'Water Flow Direction'**
  String get inspectionWaterFlowDirection;

  /// No description provided for @inspectionWaterQuality.
  ///
  /// In en, this message translates to:
  /// **'Water Quality'**
  String get inspectionWaterQuality;

  /// No description provided for @inspectionWaterAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get inspectionWaterAssessment;

  /// No description provided for @inspectionWaterNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get inspectionWaterNotes;

  /// No description provided for @inspectionShaQiChecklist.
  ///
  /// In en, this message translates to:
  /// **'External Sha Qi Checklist'**
  String get inspectionShaQiChecklist;

  /// No description provided for @inspectionShaQiSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity Assessment'**
  String get inspectionShaQiSeverity;

  /// No description provided for @inspectionShaQiDetailedNotes.
  ///
  /// In en, this message translates to:
  /// **'Detailed Notes'**
  String get inspectionShaQiDetailedNotes;

  /// No description provided for @inspectionLeftCornerReading.
  ///
  /// In en, this message translates to:
  /// **'Main Façade - Left corner (degrees)'**
  String get inspectionLeftCornerReading;

  /// No description provided for @inspectionCenterReading.
  ///
  /// In en, this message translates to:
  /// **'Main Façade - Center (degrees)'**
  String get inspectionCenterReading;

  /// No description provided for @inspectionRightCornerReading.
  ///
  /// In en, this message translates to:
  /// **'Main Façade - Right corner (degrees)'**
  String get inspectionRightCornerReading;

  /// No description provided for @inspectionMainFacadeAverage.
  ///
  /// In en, this message translates to:
  /// **'Main Façade - Average (degrees)'**
  String get inspectionMainFacadeAverage;

  /// No description provided for @inspectionMainDoorReading1.
  ///
  /// In en, this message translates to:
  /// **'Main Entrance Door - Reading 1'**
  String get inspectionMainDoorReading1;

  /// No description provided for @inspectionMainDoorReading2.
  ///
  /// In en, this message translates to:
  /// **'Main Entrance Door - Reading 2'**
  String get inspectionMainDoorReading2;

  /// No description provided for @inspectionMainDoorAverage.
  ///
  /// In en, this message translates to:
  /// **'Main Entrance Door - Average'**
  String get inspectionMainDoorAverage;

  /// No description provided for @inspectionMainDoor24Mountains.
  ///
  /// In en, this message translates to:
  /// **'Main Entrance Door - 24 Mountains'**
  String get inspectionMainDoor24Mountains;

  /// No description provided for @inspectionBackEntranceReading.
  ///
  /// In en, this message translates to:
  /// **'Service/Back Entrance Reading'**
  String get inspectionBackEntranceReading;

  /// No description provided for @inspectionBackEntrance24Mountains.
  ///
  /// In en, this message translates to:
  /// **'Service/Back Entrance - 24 Mountains'**
  String get inspectionBackEntrance24Mountains;

  /// No description provided for @inspectionCarParkEntranceReading.
  ///
  /// In en, this message translates to:
  /// **'Car Park Entrance Reading'**
  String get inspectionCarParkEntranceReading;

  /// No description provided for @inspectionCarPark24Mountains.
  ///
  /// In en, this message translates to:
  /// **'Car Park Entrance - 24 Mountains'**
  String get inspectionCarPark24Mountains;

  /// No description provided for @inspectionMetalDoorFrames.
  ///
  /// In en, this message translates to:
  /// **'Metal door frames'**
  String get inspectionMetalDoorFrames;

  /// No description provided for @inspectionElectricalPanelsNearby.
  ///
  /// In en, this message translates to:
  /// **'Electrical panels nearby'**
  String get inspectionElectricalPanelsNearby;

  /// No description provided for @inspectionSteelReinforcement.
  ///
  /// In en, this message translates to:
  /// **'Steel reinforcement'**
  String get inspectionSteelReinforcement;

  /// No description provided for @inspectionAdjustmentsMade.
  ///
  /// In en, this message translates to:
  /// **'Adjustments made'**
  String get inspectionAdjustmentsMade;

  /// No description provided for @inspectionGroundFloorFunction.
  ///
  /// In en, this message translates to:
  /// **'Ground Floor - Function'**
  String get inspectionGroundFloorFunction;

  /// No description provided for @inspectionGroundFloorHeight.
  ///
  /// In en, this message translates to:
  /// **'Ground Floor - Ceiling height (m)'**
  String get inspectionGroundFloorHeight;

  /// No description provided for @inspectionGroundFloorFeatures.
  ///
  /// In en, this message translates to:
  /// **'Ground Floor - Main features'**
  String get inspectionGroundFloorFeatures;

  /// No description provided for @inspectionStaircaseLocation.
  ///
  /// In en, this message translates to:
  /// **'Staircase location (sector)'**
  String get inspectionStaircaseLocation;

  /// No description provided for @inspectionLiftLocation.
  ///
  /// In en, this message translates to:
  /// **'Lift location (sector)'**
  String get inspectionLiftLocation;

  /// No description provided for @inspectionFireEscapeLocation.
  ///
  /// In en, this message translates to:
  /// **'Fire escape location'**
  String get inspectionFireEscapeLocation;

  /// No description provided for @inspectionFavorable.
  ///
  /// In en, this message translates to:
  /// **'Favorable'**
  String get inspectionFavorable;

  /// No description provided for @inspectionUnfavorable.
  ///
  /// In en, this message translates to:
  /// **'Unfavorable'**
  String get inspectionUnfavorable;

  /// No description provided for @inspectionNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get inspectionNeutral;

  /// No description provided for @inspectionNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get inspectionNotes;

  /// No description provided for @inspectionDirN.
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get inspectionDirN;

  /// No description provided for @inspectionDirS.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get inspectionDirS;

  /// No description provided for @inspectionDirE.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get inspectionDirE;

  /// No description provided for @inspectionDirW.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get inspectionDirW;

  /// No description provided for @inspectionDirNE.
  ///
  /// In en, this message translates to:
  /// **'NE'**
  String get inspectionDirNE;

  /// No description provided for @inspectionDirNW.
  ///
  /// In en, this message translates to:
  /// **'NW'**
  String get inspectionDirNW;

  /// No description provided for @inspectionDirSE.
  ///
  /// In en, this message translates to:
  /// **'SE'**
  String get inspectionDirSE;

  /// No description provided for @inspectionDirSW.
  ///
  /// In en, this message translates to:
  /// **'SW'**
  String get inspectionDirSW;

  /// No description provided for @inspectionSurroundEstablished.
  ///
  /// In en, this message translates to:
  /// **'Established commercial district'**
  String get inspectionSurroundEstablished;

  /// No description provided for @inspectionSurroundDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Developing area'**
  String get inspectionSurroundDeveloping;

  /// No description provided for @inspectionSurroundMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed residential-commercial'**
  String get inspectionSurroundMixed;

  /// No description provided for @inspectionSurroundIndustrial.
  ///
  /// In en, this message translates to:
  /// **'Industrial zone'**
  String get inspectionSurroundIndustrial;

  /// No description provided for @inspectionSurroundSuburban.
  ///
  /// In en, this message translates to:
  /// **'Suburban/rural'**
  String get inspectionSurroundSuburban;

  /// No description provided for @inspectionNoiseConstruction.
  ///
  /// In en, this message translates to:
  /// **'Construction noise nearby'**
  String get inspectionNoiseConstruction;

  /// No description provided for @inspectionNoiseNightclub.
  ///
  /// In en, this message translates to:
  /// **'Nightclub/entertainment venues'**
  String get inspectionNoiseNightclub;

  /// No description provided for @inspectionNoiseMarket.
  ///
  /// In en, this message translates to:
  /// **'Market/commercial activity'**
  String get inspectionNoiseMarket;

  /// No description provided for @inspectionNoiseAirport.
  ///
  /// In en, this message translates to:
  /// **'Airport/railway'**
  String get inspectionNoiseAirport;

  /// No description provided for @inspectionAirClean.
  ///
  /// In en, this message translates to:
  /// **'Clean air, green surroundings'**
  String get inspectionAirClean;

  /// No description provided for @inspectionAirModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate (urban environment)'**
  String get inspectionAirModerate;

  /// No description provided for @inspectionAirIndustrial.
  ///
  /// In en, this message translates to:
  /// **'Industrial pollution present'**
  String get inspectionAirIndustrial;

  /// No description provided for @inspectionAirDust.
  ///
  /// In en, this message translates to:
  /// **'Dust from construction'**
  String get inspectionAirDust;

  /// No description provided for @inspectionAirFoul.
  ///
  /// In en, this message translates to:
  /// **'Foul odors'**
  String get inspectionAirFoul;

  /// No description provided for @inspectionRoadParallel.
  ///
  /// In en, this message translates to:
  /// **'Runs parallel to front façade'**
  String get inspectionRoadParallel;

  /// No description provided for @inspectionRoadCurvesToward.
  ///
  /// In en, this message translates to:
  /// **'Curves toward building (embracing)'**
  String get inspectionRoadCurvesToward;

  /// No description provided for @inspectionRoadCurvesAway.
  ///
  /// In en, this message translates to:
  /// **'Curves away from building'**
  String get inspectionRoadCurvesAway;

  /// No description provided for @inspectionRoadStraight.
  ///
  /// In en, this message translates to:
  /// **'Straight alignment'**
  String get inspectionRoadStraight;

  /// No description provided for @inspectionFlowDragonToTiger.
  ///
  /// In en, this message translates to:
  /// **'Left to right (Dragon to Tiger)'**
  String get inspectionFlowDragonToTiger;

  /// No description provided for @inspectionFlowTigerToDragon.
  ///
  /// In en, this message translates to:
  /// **'Right to left (Tiger to Dragon)'**
  String get inspectionFlowTigerToDragon;

  /// No description provided for @inspectionFlowBoth.
  ///
  /// In en, this message translates to:
  /// **'Both directions (two-way)'**
  String get inspectionFlowBoth;

  /// No description provided for @inspectionJunctionT.
  ///
  /// In en, this message translates to:
  /// **'T-junction (road points at building)'**
  String get inspectionJunctionT;

  /// No description provided for @inspectionJunctionY.
  ///
  /// In en, this message translates to:
  /// **'Y-junction'**
  String get inspectionJunctionY;

  /// No description provided for @inspectionJunctionCross.
  ///
  /// In en, this message translates to:
  /// **'Cross junction'**
  String get inspectionJunctionCross;

  /// No description provided for @inspectionJunctionRoundabout.
  ///
  /// In en, this message translates to:
  /// **'Roundabout'**
  String get inspectionJunctionRoundabout;

  /// No description provided for @inspectionJunctionNone.
  ///
  /// In en, this message translates to:
  /// **'No direct junction'**
  String get inspectionJunctionNone;

  /// No description provided for @inspectionRoadConfigFavorable.
  ///
  /// In en, this message translates to:
  /// **'Favorable road configuration'**
  String get inspectionRoadConfigFavorable;

  /// No description provided for @inspectionRoadConfigShaQi.
  ///
  /// In en, this message translates to:
  /// **'Sha Qi from junction (needs remedy)'**
  String get inspectionRoadConfigShaQi;

  /// No description provided for @inspectionWaterRiver.
  ///
  /// In en, this message translates to:
  /// **'River'**
  String get inspectionWaterRiver;

  /// No description provided for @inspectionWaterCanal.
  ///
  /// In en, this message translates to:
  /// **'Canal'**
  String get inspectionWaterCanal;

  /// No description provided for @inspectionWaterPond.
  ///
  /// In en, this message translates to:
  /// **'Pond'**
  String get inspectionWaterPond;

  /// No description provided for @inspectionWaterLake.
  ///
  /// In en, this message translates to:
  /// **'Lake'**
  String get inspectionWaterLake;

  /// No description provided for @inspectionWaterDitch.
  ///
  /// In en, this message translates to:
  /// **'Drainage ditch'**
  String get inspectionWaterDitch;

  /// No description provided for @inspectionWaterPool.
  ///
  /// In en, this message translates to:
  /// **'Swimming pool'**
  String get inspectionWaterPool;

  /// No description provided for @inspectionWaterFountain.
  ///
  /// In en, this message translates to:
  /// **'Fountain'**
  String get inspectionWaterFountain;

  /// No description provided for @inspectionWaterNone.
  ///
  /// In en, this message translates to:
  /// **'None visible'**
  String get inspectionWaterNone;

  /// No description provided for @inspectionWaterLeftDragon.
  ///
  /// In en, this message translates to:
  /// **'Left (Dragon side)'**
  String get inspectionWaterLeftDragon;

  /// No description provided for @inspectionWaterRightTiger.
  ///
  /// In en, this message translates to:
  /// **'Right (Tiger side)'**
  String get inspectionWaterRightTiger;

  /// No description provided for @inspectionFlowToward.
  ///
  /// In en, this message translates to:
  /// **'Toward the building (gathering wealth)'**
  String get inspectionFlowToward;

  /// No description provided for @inspectionFlowAway.
  ///
  /// In en, this message translates to:
  /// **'Away from building (draining wealth)'**
  String get inspectionFlowAway;

  /// No description provided for @inspectionFlowEmbracing.
  ///
  /// In en, this message translates to:
  /// **'Embracing/curving around'**
  String get inspectionFlowEmbracing;

  /// No description provided for @inspectionFlowStagnant.
  ///
  /// In en, this message translates to:
  /// **'Stagnant (no visible flow)'**
  String get inspectionFlowStagnant;

  /// No description provided for @inspectionQualityClean.
  ///
  /// In en, this message translates to:
  /// **'Clean and clear'**
  String get inspectionQualityClean;

  /// No description provided for @inspectionQualityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate (some sediment)'**
  String get inspectionQualityModerate;

  /// No description provided for @inspectionQualityPolluted.
  ///
  /// In en, this message translates to:
  /// **'Polluted/murky'**
  String get inspectionQualityPolluted;

  /// No description provided for @inspectionQualityFoul.
  ///
  /// In en, this message translates to:
  /// **'Foul smell'**
  String get inspectionQualityFoul;

  /// No description provided for @inspectionWaterConfigFavorable.
  ///
  /// In en, this message translates to:
  /// **'Favorable water configuration'**
  String get inspectionWaterConfigFavorable;

  /// No description provided for @inspectionWaterConfigUnfavorable.
  ///
  /// In en, this message translates to:
  /// **'Unfavorable (sha qi or draining)'**
  String get inspectionWaterConfigUnfavorable;

  /// No description provided for @inspectionShaLamppost.
  ///
  /// In en, this message translates to:
  /// **'Lamppost/pole directly in front of main door'**
  String get inspectionShaLamppost;

  /// No description provided for @inspectionShaSharpCorners.
  ///
  /// In en, this message translates to:
  /// **'Sharp building corners pointing at site'**
  String get inspectionShaSharpCorners;

  /// No description provided for @inspectionShaTransmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission towers or high-voltage lines nearby'**
  String get inspectionShaTransmission;

  /// No description provided for @inspectionShaBridge.
  ///
  /// In en, this message translates to:
  /// **'Bridge or flyover cutting across view'**
  String get inspectionShaBridge;

  /// No description provided for @inspectionShaDeadEnd.
  ///
  /// In en, this message translates to:
  /// **'Dead-end road (knife-cutting qi)'**
  String get inspectionShaDeadEnd;

  /// No description provided for @inspectionShaChurch.
  ///
  /// In en, this message translates to:
  /// **'Church, temple, hospital, cemetery directly opposite'**
  String get inspectionShaChurch;

  /// No description provided for @inspectionShaTree.
  ///
  /// In en, this message translates to:
  /// **'Large tree blocking main entrance'**
  String get inspectionShaTree;

  /// No description provided for @inspectionShaTriangular.
  ///
  /// In en, this message translates to:
  /// **'Triangular or irregular plot shape'**
  String get inspectionShaTriangular;

  /// No description provided for @inspectionShaHighway.
  ///
  /// In en, this message translates to:
  /// **'Elevated highway or MRT creating noise/pressure'**
  String get inspectionShaHighway;

  /// No description provided for @inspectionShaConstruction.
  ///
  /// In en, this message translates to:
  /// **'Construction site with ongoing work nearby'**
  String get inspectionShaConstruction;

  /// No description provided for @inspectionShaSeverityNone.
  ///
  /// In en, this message translates to:
  /// **'No significant sha qi'**
  String get inspectionShaSeverityNone;

  /// No description provided for @inspectionShaSeverityMinor.
  ///
  /// In en, this message translates to:
  /// **'Minor sha qi (can be remedied)'**
  String get inspectionShaSeverityMinor;

  /// No description provided for @inspectionShaSeverityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate sha qi (needs cures)'**
  String get inspectionShaSeverityModerate;

  /// No description provided for @inspectionShaSeveritySevere.
  ///
  /// In en, this message translates to:
  /// **'Severe sha qi (major remedial work required)'**
  String get inspectionShaSeveritySevere;

  /// No description provided for @inspectionSelectPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'— Select —'**
  String get inspectionSelectPlaceholder;

  /// No description provided for @weatherSunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get weatherSunny;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherOvercast.
  ///
  /// In en, this message translates to:
  /// **'Overcast'**
  String get weatherOvercast;

  /// No description provided for @weatherRainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get weatherRainy;

  /// No description provided for @weatherStormy.
  ///
  /// In en, this message translates to:
  /// **'Stormy'**
  String get weatherStormy;

  /// No description provided for @weatherFoggy.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get weatherFoggy;

  /// No description provided for @weatherPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get weatherPartlyCloudy;

  /// No description provided for @dirNorth.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get dirNorth;

  /// No description provided for @dirSouth.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get dirSouth;

  /// No description provided for @dirEast.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get dirEast;

  /// No description provided for @dirWest.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get dirWest;

  /// No description provided for @dirNortheast.
  ///
  /// In en, this message translates to:
  /// **'Northeast'**
  String get dirNortheast;

  /// No description provided for @dirNorthwest.
  ///
  /// In en, this message translates to:
  /// **'Northwest'**
  String get dirNorthwest;

  /// No description provided for @dirSoutheast.
  ///
  /// In en, this message translates to:
  /// **'Southeast'**
  String get dirSoutheast;

  /// No description provided for @dirSouthwest.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get dirSouthwest;

  /// No description provided for @zodRat.
  ///
  /// In en, this message translates to:
  /// **'Rat (鼠)'**
  String get zodRat;

  /// No description provided for @zodOx.
  ///
  /// In en, this message translates to:
  /// **'Ox (牛)'**
  String get zodOx;

  /// No description provided for @zodTiger.
  ///
  /// In en, this message translates to:
  /// **'Tiger (虎)'**
  String get zodTiger;

  /// No description provided for @zodRabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit (兔)'**
  String get zodRabbit;

  /// No description provided for @zodDragon.
  ///
  /// In en, this message translates to:
  /// **'Dragon (龙)'**
  String get zodDragon;

  /// No description provided for @zodSnake.
  ///
  /// In en, this message translates to:
  /// **'Snake (蛇)'**
  String get zodSnake;

  /// No description provided for @zodHorse.
  ///
  /// In en, this message translates to:
  /// **'Horse (马)'**
  String get zodHorse;

  /// No description provided for @zodGoat.
  ///
  /// In en, this message translates to:
  /// **'Goat (羊)'**
  String get zodGoat;

  /// No description provided for @zodMonkey.
  ///
  /// In en, this message translates to:
  /// **'Monkey (猴)'**
  String get zodMonkey;

  /// No description provided for @zodRooster.
  ///
  /// In en, this message translates to:
  /// **'Rooster (鸡)'**
  String get zodRooster;

  /// No description provided for @zodDog.
  ///
  /// In en, this message translates to:
  /// **'Dog (狗)'**
  String get zodDog;

  /// No description provided for @zodPig.
  ///
  /// In en, this message translates to:
  /// **'Pig (猪)'**
  String get zodPig;

  /// No description provided for @personalGuaKan.
  ///
  /// In en, this message translates to:
  /// **'Kan (坎) - Water'**
  String get personalGuaKan;

  /// No description provided for @personalGuaKun.
  ///
  /// In en, this message translates to:
  /// **'Kun (坤) - Earth'**
  String get personalGuaKun;

  /// No description provided for @personalGuaZhen.
  ///
  /// In en, this message translates to:
  /// **'Zhen (震) - Wood'**
  String get personalGuaZhen;

  /// No description provided for @personalGuaXun.
  ///
  /// In en, this message translates to:
  /// **'Xun (巽) - Wood'**
  String get personalGuaXun;

  /// No description provided for @personalGuaQian.
  ///
  /// In en, this message translates to:
  /// **'Qian (乾) - Metal'**
  String get personalGuaQian;

  /// No description provided for @personalGuaDui.
  ///
  /// In en, this message translates to:
  /// **'Dui (兌) - Metal'**
  String get personalGuaDui;

  /// No description provided for @personalGuaGen.
  ///
  /// In en, this message translates to:
  /// **'Gen (艮) - Earth'**
  String get personalGuaGen;

  /// No description provided for @personalGuaLi.
  ///
  /// In en, this message translates to:
  /// **'Li (離) - Fire'**
  String get personalGuaLi;

  /// No description provided for @sectorKanNorth.
  ///
  /// In en, this message translates to:
  /// **'Kan (坎) - North'**
  String get sectorKanNorth;

  /// No description provided for @sectorKunSouthwest.
  ///
  /// In en, this message translates to:
  /// **'Kun (坤) - Southwest'**
  String get sectorKunSouthwest;

  /// No description provided for @sectorZhenEast.
  ///
  /// In en, this message translates to:
  /// **'Zhen (震) - East'**
  String get sectorZhenEast;

  /// No description provided for @sectorXunSoutheast.
  ///
  /// In en, this message translates to:
  /// **'Xun (巽) - Southeast'**
  String get sectorXunSoutheast;

  /// No description provided for @sectorQianNorthwest.
  ///
  /// In en, this message translates to:
  /// **'Qian (乾) - Northwest'**
  String get sectorQianNorthwest;

  /// No description provided for @sectorDuiWest.
  ///
  /// In en, this message translates to:
  /// **'Dui (兌) - West'**
  String get sectorDuiWest;

  /// No description provided for @sectorGenNortheast.
  ///
  /// In en, this message translates to:
  /// **'Gen (艮) - Northeast'**
  String get sectorGenNortheast;

  /// No description provided for @sectorLiSouth.
  ///
  /// In en, this message translates to:
  /// **'Li (離) - South'**
  String get sectorLiSouth;

  /// No description provided for @trigramQian.
  ///
  /// In en, this message translates to:
  /// **'Qian (乾) - Heaven'**
  String get trigramQian;

  /// No description provided for @trigramKun.
  ///
  /// In en, this message translates to:
  /// **'Kun (坤) - Earth'**
  String get trigramKun;

  /// No description provided for @trigramZhen.
  ///
  /// In en, this message translates to:
  /// **'Zhen (震) - Thunder'**
  String get trigramZhen;

  /// No description provided for @trigramXun.
  ///
  /// In en, this message translates to:
  /// **'Xun (巽) - Wind'**
  String get trigramXun;

  /// No description provided for @trigramKan.
  ///
  /// In en, this message translates to:
  /// **'Kan (坎) - Water'**
  String get trigramKan;

  /// No description provided for @trigramLi.
  ///
  /// In en, this message translates to:
  /// **'Li (離) - Fire'**
  String get trigramLi;

  /// No description provided for @trigramGen.
  ///
  /// In en, this message translates to:
  /// **'Gen (艮) - Mountain'**
  String get trigramGen;

  /// No description provided for @trigramDui.
  ///
  /// In en, this message translates to:
  /// **'Dui (兌) - Lake'**
  String get trigramDui;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDec;

  /// No description provided for @inspectionBuildingCompletionYear.
  ///
  /// In en, this message translates to:
  /// **'Building Completion Year'**
  String get inspectionBuildingCompletionYear;

  /// No description provided for @inspectionMonthOfVisit.
  ///
  /// In en, this message translates to:
  /// **'Month of Visit'**
  String get inspectionMonthOfVisit;

  /// No description provided for @inspectionFacingDirectionDegrees.
  ///
  /// In en, this message translates to:
  /// **'Facing Direction (degrees)'**
  String get inspectionFacingDirectionDegrees;

  /// No description provided for @inspection24MountainPosition.
  ///
  /// In en, this message translates to:
  /// **'24 Mountain Position'**
  String get inspection24MountainPosition;

  /// No description provided for @inspectionStar9Location.
  ///
  /// In en, this message translates to:
  /// **'Star 9 (Future Prosperity) location'**
  String get inspectionStar9Location;

  /// No description provided for @inspectionStar1Location.
  ///
  /// In en, this message translates to:
  /// **'Star 1 (Noble/Water Wealth) location'**
  String get inspectionStar1Location;

  /// No description provided for @inspectionStar8Location.
  ///
  /// In en, this message translates to:
  /// **'Star 8 (Current Wealth) location'**
  String get inspectionStar8Location;

  /// No description provided for @inspectionStar5Location.
  ///
  /// In en, this message translates to:
  /// **'Star 5 (Five Yellow - Misfortune) location'**
  String get inspectionStar5Location;

  /// No description provided for @inspectionStar2Location.
  ///
  /// In en, this message translates to:
  /// **'Star 2 (Illness Star) location'**
  String get inspectionStar2Location;

  /// No description provided for @inspectionStar3Location.
  ///
  /// In en, this message translates to:
  /// **'Star 3 (Quarrel Star) location'**
  String get inspectionStar3Location;

  /// No description provided for @inspectionCriticalCombinations.
  ///
  /// In en, this message translates to:
  /// **'Critical Combinations to Note'**
  String get inspectionCriticalCombinations;

  /// No description provided for @inspectionAvoidOwnerZodiac.
  ///
  /// In en, this message translates to:
  /// **'Avoid clash with owner\'s zodiac'**
  String get inspectionAvoidOwnerZodiac;

  /// No description provided for @inspectionAvoidPartnerZodiac.
  ///
  /// In en, this message translates to:
  /// **'Avoid clash with partner\'s zodiac'**
  String get inspectionAvoidPartnerZodiac;

  /// No description provided for @inspectionRoom1DoorDirection.
  ///
  /// In en, this message translates to:
  /// **'Room 1 - Door direction'**
  String get inspectionRoom1DoorDirection;

  /// No description provided for @inspectionRoom1WindowDirection.
  ///
  /// In en, this message translates to:
  /// **'Room 1 - Window direction'**
  String get inspectionRoom1WindowDirection;

  /// No description provided for @inspectionKitchenLocation.
  ///
  /// In en, this message translates to:
  /// **'Kitchen/pantry location'**
  String get inspectionKitchenLocation;

  /// No description provided for @inspectionBathroomLocation.
  ///
  /// In en, this message translates to:
  /// **'Bathroom/toilet location'**
  String get inspectionBathroomLocation;

  /// No description provided for @inspectionDrainageDirection.
  ///
  /// In en, this message translates to:
  /// **'Drainage direction'**
  String get inspectionDrainageDirection;

  /// No description provided for @inspectionEstimatedReportDeliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Estimated Report Delivery Date'**
  String get inspectionEstimatedReportDeliveryDate;

  /// No description provided for @fieldWorkSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Real Work in Action'**
  String get fieldWorkSectionTitle;

  /// No description provided for @fieldWorkSectionHeadline.
  ///
  /// In en, this message translates to:
  /// **'Real work. Real places. Real outcomes.'**
  String get fieldWorkSectionHeadline;

  /// No description provided for @fieldWorkSectionSubline.
  ///
  /// In en, this message translates to:
  /// **'Office consultations, Mao Shan rituals, and on-site Feng Shui—documented as it happens.'**
  String get fieldWorkSectionSubline;

  /// No description provided for @fieldWorkRealmAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get fieldWorkRealmAll;

  /// No description provided for @fieldWorkRealmOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get fieldWorkRealmOffice;

  /// No description provided for @fieldWorkRealmRitual.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan Ritual'**
  String get fieldWorkRealmRitual;

  /// No description provided for @fieldWorkRealmSite.
  ///
  /// In en, this message translates to:
  /// **'Site Visit'**
  String get fieldWorkRealmSite;

  /// No description provided for @fieldWorkFilterVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get fieldWorkFilterVideos;

  /// No description provided for @fieldWorkViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all activities'**
  String get fieldWorkViewAll;

  /// No description provided for @fieldWorkBookConsultation.
  ///
  /// In en, this message translates to:
  /// **'Book a consultation'**
  String get fieldWorkBookConsultation;

  /// No description provided for @fieldWorkNav.
  ///
  /// In en, this message translates to:
  /// **'Field Work'**
  String get fieldWorkNav;

  /// No description provided for @fieldWorkPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Elf in Action'**
  String get fieldWorkPageTitle;

  /// No description provided for @fieldWorkPageSubline.
  ///
  /// In en, this message translates to:
  /// **'Documented consultations, rituals, and Feng Shui site visits across Cambodia.'**
  String get fieldWorkPageSubline;

  /// No description provided for @fieldWorkFeaturedLabel.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get fieldWorkFeaturedLabel;

  /// No description provided for @fieldWorkSeeRealSessions.
  ///
  /// In en, this message translates to:
  /// **'See real sessions and site visits'**
  String get fieldWorkSeeRealSessions;

  /// No description provided for @fieldWorkSeeRealSessionsLink.
  ///
  /// In en, this message translates to:
  /// **'Browse field work'**
  String get fieldWorkSeeRealSessionsLink;

  /// No description provided for @fieldWorkJourneyTeaser.
  ///
  /// In en, this message translates to:
  /// **'Beyond the classroom—see how we work in the field.'**
  String get fieldWorkJourneyTeaser;

  /// No description provided for @fieldWorkJourneyCta.
  ///
  /// In en, this message translates to:
  /// **'Explore field work'**
  String get fieldWorkJourneyCta;

  /// No description provided for @fieldWorkRelatedService.
  ///
  /// In en, this message translates to:
  /// **'Book this type of service'**
  String get fieldWorkRelatedService;

  /// No description provided for @fieldWorkShareFacebook.
  ///
  /// In en, this message translates to:
  /// **'Share on Facebook'**
  String get fieldWorkShareFacebook;

  /// No description provided for @fieldWorkBackToJournal.
  ///
  /// In en, this message translates to:
  /// **'Back to field work'**
  String get fieldWorkBackToJournal;

  /// No description provided for @fieldWorkEmptyFilter.
  ///
  /// In en, this message translates to:
  /// **'No activities match this filter yet.'**
  String get fieldWorkEmptyFilter;

  /// No description provided for @fieldWorkGalleryHeading.
  ///
  /// In en, this message translates to:
  /// **'Photo gallery'**
  String get fieldWorkGalleryHeading;

  /// No description provided for @fieldWorkPillarFengShuiTitle.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui site visit'**
  String get fieldWorkPillarFengShuiTitle;

  /// No description provided for @fieldWorkPillarFengShuiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compass readings and landform assessment on real properties.'**
  String get fieldWorkPillarFengShuiSubtitle;

  /// No description provided for @fieldWorkPillarConsultTitle.
  ///
  /// In en, this message translates to:
  /// **'BaZi, Qi Men & I Ching consultations'**
  String get fieldWorkPillarConsultTitle;

  /// No description provided for @fieldWorkPillarConsultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Office sessions—charts, strategy, and practical next steps.'**
  String get fieldWorkPillarConsultSubtitle;

  /// No description provided for @fieldWorkPillarMaoShanTitle.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan home blessing'**
  String get fieldWorkPillarMaoShanTitle;

  /// No description provided for @fieldWorkPillarMaoShanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ritual support for peace, protection, and harmony at home.'**
  String get fieldWorkPillarMaoShanSubtitle;

  /// No description provided for @fieldWorkPillarDateSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Date Selection (择日)'**
  String get fieldWorkPillarDateSelectionTitle;

  /// No description provided for @fieldWorkPillarDateSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auspicious timing for openings, signings, and milestones.'**
  String get fieldWorkPillarDateSelectionSubtitle;

  /// No description provided for @fieldWorkPillarBooksTitle.
  ///
  /// In en, this message translates to:
  /// **'The 5-Blessing Book Series'**
  String get fieldWorkPillarBooksTitle;

  /// No description provided for @fieldWorkPillarBooksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wisdom you can hold—Master Elf publications for deeper study.'**
  String get fieldWorkPillarBooksSubtitle;

  /// No description provided for @homePublicationsHeading.
  ///
  /// In en, this message translates to:
  /// **'The 5-Blessing Book Series'**
  String get homePublicationsHeading;

  /// No description provided for @homePublicationsSubline.
  ///
  /// In en, this message translates to:
  /// **'Master Elf publications — wisdom you can hold.'**
  String get homePublicationsSubline;

  /// No description provided for @homePublicationsViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all books'**
  String get homePublicationsViewAll;

  /// No description provided for @homeCoreActivitiesHeading.
  ///
  /// In en, this message translates to:
  /// **'Real Work. Real Outcomes.'**
  String get homeCoreActivitiesHeading;

  /// No description provided for @homeCoreActivitiesSubline.
  ///
  /// In en, this message translates to:
  /// **'Every photo below is from an actual session—not stock imagery. See how Master Elf turns classical Chinese metaphysics into clarity, protection, and prosperity for clients on site, in office, and at the altar. Your next chapter could start here.'**
  String get homeCoreActivitiesSubline;

  /// No description provided for @fieldWorkFromEventsLink.
  ///
  /// In en, this message translates to:
  /// **'See real field work'**
  String get fieldWorkFromEventsLink;

  /// No description provided for @fieldWorkVideosHeading.
  ///
  /// In en, this message translates to:
  /// **'Watch real work in action'**
  String get fieldWorkVideosHeading;

  /// No description provided for @fieldWorkVideosSubline.
  ///
  /// In en, this message translates to:
  /// **'Six moments from the field—consultations, rituals, and site visits as they happen.'**
  String get fieldWorkVideosSubline;

  /// No description provided for @fieldWorkStoriesHeading.
  ///
  /// In en, this message translates to:
  /// **'Our core activities'**
  String get fieldWorkStoriesHeading;

  /// No description provided for @fieldWorkStoriesSubline.
  ///
  /// In en, this message translates to:
  /// **'Real site visits, office consultations, Mao Shan rituals, and date selection—documented in photos from the field.'**
  String get fieldWorkStoriesSubline;

  /// No description provided for @fieldWorkWatchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get fieldWorkWatchVideo;

  /// No description provided for @fieldWorkBackToActivities.
  ///
  /// In en, this message translates to:
  /// **'Back to activities'**
  String get fieldWorkBackToActivities;

  /// No description provided for @fieldWorkVideoSpotlight1Title.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui site visit — compass on site'**
  String get fieldWorkVideoSpotlight1Title;

  /// No description provided for @fieldWorkVideoSpotlight1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'On-location readings and landform assessment for a commercial property.'**
  String get fieldWorkVideoSpotlight1Subtitle;

  /// No description provided for @fieldWorkVideoSpotlight2Title.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui audit — facing and sitting directions'**
  String get fieldWorkVideoSpotlight2Title;

  /// No description provided for @fieldWorkVideoSpotlight2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Recording accurate directions for Flying Star analysis before interior work.'**
  String get fieldWorkVideoSpotlight2Subtitle;

  /// No description provided for @fieldWorkVideoSpotlight3Title.
  ///
  /// In en, this message translates to:
  /// **'BaZi consultation at the office'**
  String get fieldWorkVideoSpotlight3Title;

  /// No description provided for @fieldWorkVideoSpotlight3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'A one-to-one session—charts, timing, and practical next steps.'**
  String get fieldWorkVideoSpotlight3Subtitle;

  /// No description provided for @fieldWorkVideoSpotlight4Title.
  ///
  /// In en, this message translates to:
  /// **'Qi Men strategy session'**
  String get fieldWorkVideoSpotlight4Title;

  /// No description provided for @fieldWorkVideoSpotlight4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ancient timing tools applied to modern business decisions.'**
  String get fieldWorkVideoSpotlight4Subtitle;

  /// No description provided for @fieldWorkVideoSpotlight5Title.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan ritual — office blessing'**
  String get fieldWorkVideoSpotlight5Title;

  /// No description provided for @fieldWorkVideoSpotlight5Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ceremony to clear and align a workspace for a new business cycle.'**
  String get fieldWorkVideoSpotlight5Subtitle;

  /// No description provided for @fieldWorkVideoSpotlight6Title.
  ///
  /// In en, this message translates to:
  /// **'Date Selection in practice'**
  String get fieldWorkVideoSpotlight6Title;

  /// No description provided for @fieldWorkVideoSpotlight6Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choosing auspicious timing for openings, signings, and milestones.'**
  String get fieldWorkVideoSpotlight6Subtitle;

  /// No description provided for @inspectionXuanKongPeriod.
  ///
  /// In en, this message translates to:
  /// **'Xuan Kong Period'**
  String get inspectionXuanKongPeriod;

  /// No description provided for @inspectionPeriod7.
  ///
  /// In en, this message translates to:
  /// **'Period 7 (1984–2003)'**
  String get inspectionPeriod7;

  /// No description provided for @inspectionPeriod8.
  ///
  /// In en, this message translates to:
  /// **'Period 8 (2004–2023)'**
  String get inspectionPeriod8;

  /// No description provided for @inspectionPeriod9Option.
  ///
  /// In en, this message translates to:
  /// **'Period 9 (2024–2043)'**
  String get inspectionPeriod9Option;

  /// No description provided for @inspectionConvertedToTrigram.
  ///
  /// In en, this message translates to:
  /// **'Converted to Trigram'**
  String get inspectionConvertedToTrigram;

  /// No description provided for @inspectionHouseGua.
  ///
  /// In en, this message translates to:
  /// **'House Gua'**
  String get inspectionHouseGua;

  /// No description provided for @inspectionHouseKan.
  ///
  /// In en, this message translates to:
  /// **'Kan House (坎) - Sitting North'**
  String get inspectionHouseKan;

  /// No description provided for @inspectionHouseKun.
  ///
  /// In en, this message translates to:
  /// **'Kun House (坤) - Sitting Southwest'**
  String get inspectionHouseKun;

  /// No description provided for @inspectionHouseZhen.
  ///
  /// In en, this message translates to:
  /// **'Zhen House (震) - Sitting East'**
  String get inspectionHouseZhen;

  /// No description provided for @inspectionHouseXun.
  ///
  /// In en, this message translates to:
  /// **'Xun House (巽) - Sitting Southeast'**
  String get inspectionHouseXun;

  /// No description provided for @inspectionHouseQian.
  ///
  /// In en, this message translates to:
  /// **'Qian House (乾) - Sitting Northwest'**
  String get inspectionHouseQian;

  /// No description provided for @inspectionHouseDui.
  ///
  /// In en, this message translates to:
  /// **'Dui House (兌) - Sitting West'**
  String get inspectionHouseDui;

  /// No description provided for @inspectionHouseGen.
  ///
  /// In en, this message translates to:
  /// **'Gen House (艮) - Sitting Northeast'**
  String get inspectionHouseGen;

  /// No description provided for @inspectionHouseLi.
  ///
  /// In en, this message translates to:
  /// **'Li House (離) - Sitting South'**
  String get inspectionHouseLi;

  /// No description provided for @inspectionHouseGroup.
  ///
  /// In en, this message translates to:
  /// **'House Group'**
  String get inspectionHouseGroup;

  /// No description provided for @inspectionHouseGroupEast.
  ///
  /// In en, this message translates to:
  /// **'East Group (Kan, Zhen, Xun, Li)'**
  String get inspectionHouseGroupEast;

  /// No description provided for @inspectionHouseGroupWest.
  ///
  /// In en, this message translates to:
  /// **'West Group (Qian, Kun, Gen, Dui)'**
  String get inspectionHouseGroupWest;

  /// No description provided for @inspectionMainEntranceSector.
  ///
  /// In en, this message translates to:
  /// **'Main Entrance - Eight Mansions sector'**
  String get inspectionMainEntranceSector;

  /// No description provided for @inspectionMainEntranceQuality.
  ///
  /// In en, this message translates to:
  /// **'Main Entrance - Quality'**
  String get inspectionMainEntranceQuality;

  /// No description provided for @inspectionManagerOfficeSector.
  ///
  /// In en, this message translates to:
  /// **'Manager/Owner Office - Sector'**
  String get inspectionManagerOfficeSector;

  /// No description provided for @inspectionManagerOfficeQuality.
  ///
  /// In en, this message translates to:
  /// **'Manager/Owner Office - Quality'**
  String get inspectionManagerOfficeQuality;

  /// No description provided for @inspectionCashierSector.
  ///
  /// In en, this message translates to:
  /// **'Cashier/Safe - Sector'**
  String get inspectionCashierSector;

  /// No description provided for @inspectionCashierQuality.
  ///
  /// In en, this message translates to:
  /// **'Cashier/Safe - Quality'**
  String get inspectionCashierQuality;

  /// No description provided for @inspectionToiletSector.
  ///
  /// In en, this message translates to:
  /// **'Toilet Location - Sector'**
  String get inspectionToiletSector;

  /// No description provided for @inspectionToiletImpact.
  ///
  /// In en, this message translates to:
  /// **'Toilet Impact'**
  String get inspectionToiletImpact;

  /// No description provided for @inspectionToiletAcceptable.
  ///
  /// In en, this message translates to:
  /// **'Acceptable (at unfavorable sector)'**
  String get inspectionToiletAcceptable;

  /// No description provided for @inspectionToiletPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor (at favorable sector)'**
  String get inspectionToiletPoor;

  /// No description provided for @inspectionClientFullName.
  ///
  /// In en, this message translates to:
  /// **'Primary Client/Owner - Full Name'**
  String get inspectionClientFullName;

  /// No description provided for @inspectionClientRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get inspectionClientRole;

  /// No description provided for @inspectionRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get inspectionRoleOwner;

  /// No description provided for @inspectionRoleMainTenant.
  ///
  /// In en, this message translates to:
  /// **'Main Tenant'**
  String get inspectionRoleMainTenant;

  /// No description provided for @inspectionRoleCeo.
  ///
  /// In en, this message translates to:
  /// **'CEO'**
  String get inspectionRoleCeo;

  /// No description provided for @inspectionRoleManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get inspectionRoleManager;

  /// No description provided for @inspectionBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get inspectionBirthDate;

  /// No description provided for @inspectionBirthTime.
  ///
  /// In en, this message translates to:
  /// **'Birth Time'**
  String get inspectionBirthTime;

  /// No description provided for @inspectionPlaceOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Place of Birth'**
  String get inspectionPlaceOfBirth;

  /// No description provided for @inspectionDayMaster.
  ///
  /// In en, this message translates to:
  /// **'Day Master'**
  String get inspectionDayMaster;

  /// No description provided for @inspectionFavorableElements.
  ///
  /// In en, this message translates to:
  /// **'Favorable Elements'**
  String get inspectionFavorableElements;

  /// No description provided for @inspectionUnfavorableElements.
  ///
  /// In en, this message translates to:
  /// **'Unfavorable Elements'**
  String get inspectionUnfavorableElements;

  /// No description provided for @inspectionElementWood.
  ///
  /// In en, this message translates to:
  /// **'Wood (木)'**
  String get inspectionElementWood;

  /// No description provided for @inspectionElementFire.
  ///
  /// In en, this message translates to:
  /// **'Fire (火)'**
  String get inspectionElementFire;

  /// No description provided for @inspectionElementEarth.
  ///
  /// In en, this message translates to:
  /// **'Earth (土)'**
  String get inspectionElementEarth;

  /// No description provided for @inspectionElementMetal.
  ///
  /// In en, this message translates to:
  /// **'Metal (金)'**
  String get inspectionElementMetal;

  /// No description provided for @inspectionElementWater.
  ///
  /// In en, this message translates to:
  /// **'Water (水)'**
  String get inspectionElementWater;

  /// No description provided for @inspectionPersonalGuaLabel.
  ///
  /// In en, this message translates to:
  /// **'Personal Gua (Ming Gua)'**
  String get inspectionPersonalGuaLabel;

  /// No description provided for @inspectionPersonalGroup.
  ///
  /// In en, this message translates to:
  /// **'Personal Group'**
  String get inspectionPersonalGroup;

  /// No description provided for @inspectionPersonalGroupEast.
  ///
  /// In en, this message translates to:
  /// **'East Group'**
  String get inspectionPersonalGroupEast;

  /// No description provided for @inspectionPersonalGroupWest.
  ///
  /// In en, this message translates to:
  /// **'West Group'**
  String get inspectionPersonalGroupWest;

  /// No description provided for @inspectionShengQiDirection.
  ///
  /// In en, this message translates to:
  /// **'Sheng Qi (Best) direction'**
  String get inspectionShengQiDirection;

  /// No description provided for @inspectionTianYiDirection.
  ///
  /// In en, this message translates to:
  /// **'Tian Yi (Health) direction'**
  String get inspectionTianYiDirection;

  /// No description provided for @inspectionYanNianDirection.
  ///
  /// In en, this message translates to:
  /// **'Yan Nian (Relationship) direction'**
  String get inspectionYanNianDirection;

  /// No description provided for @inspectionFuWeiDirection.
  ///
  /// In en, this message translates to:
  /// **'Fu Wei (Stability) direction'**
  String get inspectionFuWeiDirection;

  /// No description provided for @inspectionPerson2Name.
  ///
  /// In en, this message translates to:
  /// **'Person 2 - Name'**
  String get inspectionPerson2Name;

  /// No description provided for @inspectionPerson2Role.
  ///
  /// In en, this message translates to:
  /// **'Person 2 - Role'**
  String get inspectionPerson2Role;

  /// No description provided for @inspectionPerson2BirthDate.
  ///
  /// In en, this message translates to:
  /// **'Person 2 - Birth Date'**
  String get inspectionPerson2BirthDate;

  /// No description provided for @inspectionPerson2BirthTime.
  ///
  /// In en, this message translates to:
  /// **'Person 2 - Birth Time'**
  String get inspectionPerson2BirthTime;

  /// No description provided for @inspectionPerson2Gua.
  ///
  /// In en, this message translates to:
  /// **'Person 2 - Personal Gua'**
  String get inspectionPerson2Gua;

  /// No description provided for @inspectionPerson3Name.
  ///
  /// In en, this message translates to:
  /// **'Person 3 - Name'**
  String get inspectionPerson3Name;

  /// No description provided for @inspectionPerson3Role.
  ///
  /// In en, this message translates to:
  /// **'Person 3 - Role'**
  String get inspectionPerson3Role;

  /// No description provided for @inspectionPerson3BirthDate.
  ///
  /// In en, this message translates to:
  /// **'Person 3 - Birth Date'**
  String get inspectionPerson3BirthDate;

  /// No description provided for @inspectionPerson3BirthTime.
  ///
  /// In en, this message translates to:
  /// **'Person 3 - Birth Time'**
  String get inspectionPerson3BirthTime;

  /// No description provided for @inspectionPerson3Gua.
  ///
  /// In en, this message translates to:
  /// **'Person 3 - Personal Gua'**
  String get inspectionPerson3Gua;

  /// No description provided for @inspectionBusinessGoals.
  ///
  /// In en, this message translates to:
  /// **'Primary Business Goals'**
  String get inspectionBusinessGoals;

  /// No description provided for @inspectionGoalWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth/profit maximization'**
  String get inspectionGoalWealth;

  /// No description provided for @inspectionGoalCustomerFlow.
  ///
  /// In en, this message translates to:
  /// **'Customer flow'**
  String get inspectionGoalCustomerFlow;

  /// No description provided for @inspectionGoalStability.
  ///
  /// In en, this message translates to:
  /// **'Business stability'**
  String get inspectionGoalStability;

  /// No description provided for @inspectionGoalStaffHarmony.
  ///
  /// In en, this message translates to:
  /// **'Staff harmony'**
  String get inspectionGoalStaffHarmony;

  /// No description provided for @inspectionGoalHealth.
  ///
  /// In en, this message translates to:
  /// **'Health and wellbeing'**
  String get inspectionGoalHealth;

  /// No description provided for @inspectionGoalOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get inspectionGoalOther;

  /// No description provided for @inspectionSpecificConcerns.
  ///
  /// In en, this message translates to:
  /// **'Specific Concerns Raised'**
  String get inspectionSpecificConcerns;

  /// No description provided for @inspectionCurrentChallenges.
  ///
  /// In en, this message translates to:
  /// **'Current Challenges'**
  String get inspectionCurrentChallenges;

  /// No description provided for @inspectionChallengeFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial difficulties'**
  String get inspectionChallengeFinancial;

  /// No description provided for @inspectionChallengeHealth.
  ///
  /// In en, this message translates to:
  /// **'Health issues'**
  String get inspectionChallengeHealth;

  /// No description provided for @inspectionChallengeStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff conflicts'**
  String get inspectionChallengeStaff;

  /// No description provided for @inspectionChallengeLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal problems'**
  String get inspectionChallengeLegal;

  /// No description provided for @inspectionChallengeRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship issues'**
  String get inspectionChallengeRelationship;

  /// No description provided for @inspectionChallengeCustomerFlow.
  ///
  /// In en, this message translates to:
  /// **'Poor customer flow'**
  String get inspectionChallengeCustomerFlow;

  /// No description provided for @inspectionHealthIssuesSpecify.
  ///
  /// In en, this message translates to:
  /// **'Health issues (specify)'**
  String get inspectionHealthIssuesSpecify;

  /// No description provided for @inspectionPlannedOpeningDate.
  ///
  /// In en, this message translates to:
  /// **'Planned Opening Date'**
  String get inspectionPlannedOpeningDate;

  /// No description provided for @inspectionPreferredDateFrom.
  ///
  /// In en, this message translates to:
  /// **'Preferred Date Range - From'**
  String get inspectionPreferredDateFrom;

  /// No description provided for @inspectionPreferredDateTo.
  ///
  /// In en, this message translates to:
  /// **'Preferred Date Range - To'**
  String get inspectionPreferredDateTo;

  /// No description provided for @inspectionActivitiesDateSelection.
  ///
  /// In en, this message translates to:
  /// **'Important Activities Requiring Date Selection'**
  String get inspectionActivitiesDateSelection;

  /// No description provided for @inspectionActivityGrandOpening.
  ///
  /// In en, this message translates to:
  /// **'Grand opening ceremony'**
  String get inspectionActivityGrandOpening;

  /// No description provided for @inspectionActivityRenovation.
  ///
  /// In en, this message translates to:
  /// **'Renovation commencement'**
  String get inspectionActivityRenovation;

  /// No description provided for @inspectionActivityMovingIn.
  ///
  /// In en, this message translates to:
  /// **'Moving in/occupation'**
  String get inspectionActivityMovingIn;

  /// No description provided for @inspectionActivitySignInstall.
  ///
  /// In en, this message translates to:
  /// **'Sign installation'**
  String get inspectionActivitySignInstall;

  /// No description provided for @inspectionActivityContract.
  ///
  /// In en, this message translates to:
  /// **'Contract signing'**
  String get inspectionActivityContract;

  /// No description provided for @inspectionActivityPurchases.
  ///
  /// In en, this message translates to:
  /// **'Major purchases'**
  String get inspectionActivityPurchases;

  /// No description provided for @inspectionSolarTerm.
  ///
  /// In en, this message translates to:
  /// **'Solar Term'**
  String get inspectionSolarTerm;

  /// No description provided for @inspectionLunarDate.
  ///
  /// In en, this message translates to:
  /// **'Lunar Date'**
  String get inspectionLunarDate;

  /// No description provided for @inspectionFavorablePalaces.
  ///
  /// In en, this message translates to:
  /// **'Favorable Palaces for This Date/Time'**
  String get inspectionFavorablePalaces;

  /// No description provided for @inspectionUnfavorablePalaces.
  ///
  /// In en, this message translates to:
  /// **'Unfavorable Palaces for This Date/Time'**
  String get inspectionUnfavorablePalaces;

  /// No description provided for @inspectionGrandOpeningDate1.
  ///
  /// In en, this message translates to:
  /// **'For Grand Opening - Date option 1'**
  String get inspectionGrandOpeningDate1;

  /// No description provided for @inspectionGrandOpeningDate2.
  ///
  /// In en, this message translates to:
  /// **'For Grand Opening - Date option 2'**
  String get inspectionGrandOpeningDate2;

  /// No description provided for @inspectionGrandOpeningDate3.
  ///
  /// In en, this message translates to:
  /// **'For Grand Opening - Date option 3'**
  String get inspectionGrandOpeningDate3;

  /// No description provided for @inspectionRenovationDate1.
  ///
  /// In en, this message translates to:
  /// **'For Renovation Start - Date option 1'**
  String get inspectionRenovationDate1;

  /// No description provided for @inspectionRenovationDate2.
  ///
  /// In en, this message translates to:
  /// **'For Renovation Start - Date option 2'**
  String get inspectionRenovationDate2;

  /// No description provided for @inspectionMustAvoid.
  ///
  /// In en, this message translates to:
  /// **'Must avoid'**
  String get inspectionMustAvoid;

  /// No description provided for @inspectionNumberOfMainEntrances.
  ///
  /// In en, this message translates to:
  /// **'Number of Main Entrances'**
  String get inspectionNumberOfMainEntrances;

  /// No description provided for @inspectionMainDoorPosition.
  ///
  /// In en, this message translates to:
  /// **'Main Door Position (which palace/sector)'**
  String get inspectionMainDoorPosition;

  /// No description provided for @inspectionDoorConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Door Configuration'**
  String get inspectionDoorConfiguration;

  /// No description provided for @inspectionDoorOpensInward.
  ///
  /// In en, this message translates to:
  /// **'Opens inward'**
  String get inspectionDoorOpensInward;

  /// No description provided for @inspectionDoorOpensOutward.
  ///
  /// In en, this message translates to:
  /// **'Opens outward'**
  String get inspectionDoorOpensOutward;

  /// No description provided for @inspectionDoorSliding.
  ///
  /// In en, this message translates to:
  /// **'Sliding door'**
  String get inspectionDoorSliding;

  /// No description provided for @inspectionDoorAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic door'**
  String get inspectionDoorAutomatic;

  /// No description provided for @inspectionEntranceIssues.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get inspectionEntranceIssues;

  /// No description provided for @inspectionIssueBeamAboveDoor.
  ///
  /// In en, this message translates to:
  /// **'Beam directly above door'**
  String get inspectionIssueBeamAboveDoor;

  /// No description provided for @inspectionIssueThroughFlow.
  ///
  /// In en, this message translates to:
  /// **'Door opens to back door (through-flow)'**
  String get inspectionIssueThroughFlow;

  /// No description provided for @inspectionIssueToStaircase.
  ///
  /// In en, this message translates to:
  /// **'Door opens to staircase'**
  String get inspectionIssueToStaircase;

  /// No description provided for @inspectionIssueToToilet.
  ///
  /// In en, this message translates to:
  /// **'Door opens to toilet'**
  String get inspectionIssueToToilet;

  /// No description provided for @inspectionIssueNarrowEntrance.
  ///
  /// In en, this message translates to:
  /// **'Narrow entrance/cramped'**
  String get inspectionIssueNarrowEntrance;

  /// No description provided for @inspectionIssueNone.
  ///
  /// In en, this message translates to:
  /// **'No issues observed'**
  String get inspectionIssueNone;

  /// No description provided for @inspectionEntranceAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get inspectionEntranceAssessment;

  /// No description provided for @inspectionEntranceFavorable.
  ///
  /// In en, this message translates to:
  /// **'Favorable entrance'**
  String get inspectionEntranceFavorable;

  /// No description provided for @inspectionEntranceAcceptable.
  ///
  /// In en, this message translates to:
  /// **'Acceptable with minor adjustments'**
  String get inspectionEntranceAcceptable;

  /// No description provided for @inspectionEntranceRemedial.
  ///
  /// In en, this message translates to:
  /// **'Requires remedial work'**
  String get inspectionEntranceRemedial;

  /// No description provided for @inspectionCeilingHeight.
  ///
  /// In en, this message translates to:
  /// **'Ceiling Height (m)'**
  String get inspectionCeilingHeight;

  /// No description provided for @inspectionNaturalLight.
  ///
  /// In en, this message translates to:
  /// **'Natural Light'**
  String get inspectionNaturalLight;

  /// No description provided for @inspectionLightAbundant.
  ///
  /// In en, this message translates to:
  /// **'Abundant (large windows)'**
  String get inspectionLightAbundant;

  /// No description provided for @inspectionLightModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get inspectionLightModerate;

  /// No description provided for @inspectionLightDim.
  ///
  /// In en, this message translates to:
  /// **'Dim/insufficient'**
  String get inspectionLightDim;

  /// No description provided for @inspectionAirCirculation.
  ///
  /// In en, this message translates to:
  /// **'Air Circulation'**
  String get inspectionAirCirculation;

  /// No description provided for @inspectionAirGood.
  ///
  /// In en, this message translates to:
  /// **'Good ventilation'**
  String get inspectionAirGood;

  /// No description provided for @inspectionAirPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor/stagnant'**
  String get inspectionAirPoor;

  /// No description provided for @inspectionFloorPlanShape.
  ///
  /// In en, this message translates to:
  /// **'Floor Plan Shape'**
  String get inspectionFloorPlanShape;

  /// No description provided for @inspectionShapeSquare.
  ///
  /// In en, this message translates to:
  /// **'Square/rectangular (ideal)'**
  String get inspectionShapeSquare;

  /// No description provided for @inspectionShapeL.
  ///
  /// In en, this message translates to:
  /// **'L-shaped'**
  String get inspectionShapeL;

  /// No description provided for @inspectionShapeIrregular.
  ///
  /// In en, this message translates to:
  /// **'Irregular'**
  String get inspectionShapeIrregular;

  /// No description provided for @inspectionShapeTriangular.
  ///
  /// In en, this message translates to:
  /// **'Triangular sections'**
  String get inspectionShapeTriangular;

  /// No description provided for @inspectionReceptionSector.
  ///
  /// In en, this message translates to:
  /// **'Reception/Cashier - Sector'**
  String get inspectionReceptionSector;

  /// No description provided for @inspectionReceptionFlyingStar.
  ///
  /// In en, this message translates to:
  /// **'Reception - Flying Star'**
  String get inspectionReceptionFlyingStar;

  /// No description provided for @inspectionReception8Mansions.
  ///
  /// In en, this message translates to:
  /// **'Reception - Eight Mansions'**
  String get inspectionReception8Mansions;

  /// No description provided for @inspectionReceptionAssessment.
  ///
  /// In en, this message translates to:
  /// **'Reception - Assessment'**
  String get inspectionReceptionAssessment;

  /// No description provided for @inspectionOfficeSector.
  ///
  /// In en, this message translates to:
  /// **'Office/Manager - Sector'**
  String get inspectionOfficeSector;

  /// No description provided for @inspectionOfficeFlyingStar.
  ///
  /// In en, this message translates to:
  /// **'Office - Flying Star'**
  String get inspectionOfficeFlyingStar;

  /// No description provided for @inspectionOffice8Mansions.
  ///
  /// In en, this message translates to:
  /// **'Office - Eight Mansions'**
  String get inspectionOffice8Mansions;

  /// No description provided for @inspectionOfficeAssessment.
  ///
  /// In en, this message translates to:
  /// **'Office - Assessment'**
  String get inspectionOfficeAssessment;

  /// No description provided for @inspectionToiletSectorInternal.
  ///
  /// In en, this message translates to:
  /// **'Toilet/Bathroom - Sector'**
  String get inspectionToiletSectorInternal;

  /// No description provided for @inspectionToiletFlyingStar.
  ///
  /// In en, this message translates to:
  /// **'Toilet - Flying Star'**
  String get inspectionToiletFlyingStar;

  /// No description provided for @inspectionToilet8Mansions.
  ///
  /// In en, this message translates to:
  /// **'Toilet - Eight Mansions'**
  String get inspectionToilet8Mansions;

  /// No description provided for @inspectionToiletIssues.
  ///
  /// In en, this message translates to:
  /// **'Toilet Issues'**
  String get inspectionToiletIssues;

  /// No description provided for @inspectionToiletAtCenter.
  ///
  /// In en, this message translates to:
  /// **'At center palace'**
  String get inspectionToiletAtCenter;

  /// No description provided for @inspectionToiletAtWealth.
  ///
  /// In en, this message translates to:
  /// **'At wealth sector'**
  String get inspectionToiletAtWealth;

  /// No description provided for @inspectionToiletNoIssues.
  ///
  /// In en, this message translates to:
  /// **'No issues'**
  String get inspectionToiletNoIssues;

  /// No description provided for @inspectionStaircaseSector.
  ///
  /// In en, this message translates to:
  /// **'Staircase/Elevator - Sector'**
  String get inspectionStaircaseSector;

  /// No description provided for @inspectionStaircaseFlyingStar.
  ///
  /// In en, this message translates to:
  /// **'Staircase - Flying Star'**
  String get inspectionStaircaseFlyingStar;

  /// No description provided for @inspectionStaircase8Mansions.
  ///
  /// In en, this message translates to:
  /// **'Staircase - Eight Mansions'**
  String get inspectionStaircase8Mansions;

  /// No description provided for @inspectionStaircaseAssessment.
  ///
  /// In en, this message translates to:
  /// **'Staircase - Assessment'**
  String get inspectionStaircaseAssessment;

  /// No description provided for @inspectionRoom1Sector.
  ///
  /// In en, this message translates to:
  /// **'Room 1 - Sector'**
  String get inspectionRoom1Sector;

  /// No description provided for @inspectionRoom1FlyingStar.
  ///
  /// In en, this message translates to:
  /// **'Room 1 - Flying Star'**
  String get inspectionRoom1FlyingStar;

  /// No description provided for @inspectionRoom1EightMansions.
  ///
  /// In en, this message translates to:
  /// **'Room 1 - Eight Mansions'**
  String get inspectionRoom1EightMansions;

  /// No description provided for @inspectionRoom2Sector.
  ///
  /// In en, this message translates to:
  /// **'Room 2 - Sector'**
  String get inspectionRoom2Sector;

  /// No description provided for @inspectionRoom3Sector.
  ///
  /// In en, this message translates to:
  /// **'Room 3 - Sector'**
  String get inspectionRoom3Sector;

  /// No description provided for @inspectionBestSectorMainEntrance.
  ///
  /// In en, this message translates to:
  /// **'Sectors Best for - Main entrance'**
  String get inspectionBestSectorMainEntrance;

  /// No description provided for @inspectionBestSectorCashier.
  ///
  /// In en, this message translates to:
  /// **'Sectors Best for - Cashier/finance'**
  String get inspectionBestSectorCashier;

  /// No description provided for @inspectionBestSectorManager.
  ///
  /// In en, this message translates to:
  /// **'Sectors Best for - Manager office'**
  String get inspectionBestSectorManager;

  /// No description provided for @inspectionBestSectorStorage.
  ///
  /// In en, this message translates to:
  /// **'Sectors Best for - Storage'**
  String get inspectionBestSectorStorage;

  /// No description provided for @inspectionQualityStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get inspectionQualityStrong;

  /// No description provided for @inspectionQualityWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get inspectionQualityWeak;

  /// No description provided for @inspectionQualityConflicting.
  ///
  /// In en, this message translates to:
  /// **'Conflicting'**
  String get inspectionQualityConflicting;

  /// No description provided for @inspectionPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Site Inspection Report'**
  String get inspectionPdfTitle;

  /// No description provided for @solarTerm01.
  ///
  /// In en, this message translates to:
  /// **'Lichun (立春)'**
  String get solarTerm01;

  /// No description provided for @solarTerm02.
  ///
  /// In en, this message translates to:
  /// **'Yushui (雨水)'**
  String get solarTerm02;

  /// No description provided for @solarTerm03.
  ///
  /// In en, this message translates to:
  /// **'Jingzhe (惊蛰)'**
  String get solarTerm03;

  /// No description provided for @solarTerm04.
  ///
  /// In en, this message translates to:
  /// **'Chunfen (春分)'**
  String get solarTerm04;

  /// No description provided for @solarTerm05.
  ///
  /// In en, this message translates to:
  /// **'Qingming (清明)'**
  String get solarTerm05;

  /// No description provided for @solarTerm06.
  ///
  /// In en, this message translates to:
  /// **'Guyu (谷雨)'**
  String get solarTerm06;

  /// No description provided for @solarTerm07.
  ///
  /// In en, this message translates to:
  /// **'Lixia (立夏)'**
  String get solarTerm07;

  /// No description provided for @solarTerm08.
  ///
  /// In en, this message translates to:
  /// **'Xiaoman (小满)'**
  String get solarTerm08;

  /// No description provided for @solarTerm09.
  ///
  /// In en, this message translates to:
  /// **'Mangzhong (芒种)'**
  String get solarTerm09;

  /// No description provided for @solarTerm10.
  ///
  /// In en, this message translates to:
  /// **'Xiazhi (夏至)'**
  String get solarTerm10;

  /// No description provided for @solarTerm11.
  ///
  /// In en, this message translates to:
  /// **'Xiaoshu (小暑)'**
  String get solarTerm11;

  /// No description provided for @solarTerm12.
  ///
  /// In en, this message translates to:
  /// **'Dashu (大暑)'**
  String get solarTerm12;

  /// No description provided for @solarTerm13.
  ///
  /// In en, this message translates to:
  /// **'Liqiu (立秋)'**
  String get solarTerm13;

  /// No description provided for @solarTerm14.
  ///
  /// In en, this message translates to:
  /// **'Chushu (处暑)'**
  String get solarTerm14;

  /// No description provided for @solarTerm15.
  ///
  /// In en, this message translates to:
  /// **'Bailu (白露)'**
  String get solarTerm15;

  /// No description provided for @solarTerm16.
  ///
  /// In en, this message translates to:
  /// **'Qiufen (秋分)'**
  String get solarTerm16;

  /// No description provided for @solarTerm17.
  ///
  /// In en, this message translates to:
  /// **'Hanlu (寒露)'**
  String get solarTerm17;

  /// No description provided for @solarTerm18.
  ///
  /// In en, this message translates to:
  /// **'Shuangjiang (霜降)'**
  String get solarTerm18;

  /// No description provided for @solarTerm19.
  ///
  /// In en, this message translates to:
  /// **'Lidong (立冬)'**
  String get solarTerm19;

  /// No description provided for @solarTerm20.
  ///
  /// In en, this message translates to:
  /// **'Xiaoxue (小雪)'**
  String get solarTerm20;

  /// No description provided for @solarTerm21.
  ///
  /// In en, this message translates to:
  /// **'Daxue (大雪)'**
  String get solarTerm21;

  /// No description provided for @solarTerm22.
  ///
  /// In en, this message translates to:
  /// **'Dongzhi (冬至)'**
  String get solarTerm22;

  /// No description provided for @solarTerm23.
  ///
  /// In en, this message translates to:
  /// **'Xiaohan (小寒)'**
  String get solarTerm23;

  /// No description provided for @solarTerm24.
  ///
  /// In en, this message translates to:
  /// **'Dahan (大寒)'**
  String get solarTerm24;

  /// No description provided for @lunarDay01.
  ///
  /// In en, this message translates to:
  /// **'1st'**
  String get lunarDay01;

  /// No description provided for @lunarDay02.
  ///
  /// In en, this message translates to:
  /// **'2nd'**
  String get lunarDay02;

  /// No description provided for @lunarDay03.
  ///
  /// In en, this message translates to:
  /// **'3rd'**
  String get lunarDay03;

  /// No description provided for @lunarDay04.
  ///
  /// In en, this message translates to:
  /// **'4th'**
  String get lunarDay04;

  /// No description provided for @lunarDay05.
  ///
  /// In en, this message translates to:
  /// **'5th'**
  String get lunarDay05;

  /// No description provided for @lunarDay06.
  ///
  /// In en, this message translates to:
  /// **'6th'**
  String get lunarDay06;

  /// No description provided for @lunarDay07.
  ///
  /// In en, this message translates to:
  /// **'7th'**
  String get lunarDay07;

  /// No description provided for @lunarDay08.
  ///
  /// In en, this message translates to:
  /// **'8th'**
  String get lunarDay08;

  /// No description provided for @lunarDay09.
  ///
  /// In en, this message translates to:
  /// **'9th'**
  String get lunarDay09;

  /// No description provided for @lunarDay10.
  ///
  /// In en, this message translates to:
  /// **'10th'**
  String get lunarDay10;

  /// No description provided for @lunarDay11.
  ///
  /// In en, this message translates to:
  /// **'11th'**
  String get lunarDay11;

  /// No description provided for @lunarDay12.
  ///
  /// In en, this message translates to:
  /// **'12th'**
  String get lunarDay12;

  /// No description provided for @lunarDay13.
  ///
  /// In en, this message translates to:
  /// **'13th'**
  String get lunarDay13;

  /// No description provided for @lunarDay14.
  ///
  /// In en, this message translates to:
  /// **'14th'**
  String get lunarDay14;

  /// No description provided for @lunarDay15.
  ///
  /// In en, this message translates to:
  /// **'15th'**
  String get lunarDay15;

  /// No description provided for @lunarDay16.
  ///
  /// In en, this message translates to:
  /// **'16th'**
  String get lunarDay16;

  /// No description provided for @lunarDay17.
  ///
  /// In en, this message translates to:
  /// **'17th'**
  String get lunarDay17;

  /// No description provided for @lunarDay18.
  ///
  /// In en, this message translates to:
  /// **'18th'**
  String get lunarDay18;

  /// No description provided for @lunarDay19.
  ///
  /// In en, this message translates to:
  /// **'19th'**
  String get lunarDay19;

  /// No description provided for @lunarDay20.
  ///
  /// In en, this message translates to:
  /// **'20th'**
  String get lunarDay20;

  /// No description provided for @lunarDay21.
  ///
  /// In en, this message translates to:
  /// **'21st'**
  String get lunarDay21;

  /// No description provided for @lunarDay22.
  ///
  /// In en, this message translates to:
  /// **'22nd'**
  String get lunarDay22;

  /// No description provided for @lunarDay23.
  ///
  /// In en, this message translates to:
  /// **'23rd'**
  String get lunarDay23;

  /// No description provided for @lunarDay24.
  ///
  /// In en, this message translates to:
  /// **'24th'**
  String get lunarDay24;

  /// No description provided for @lunarDay25.
  ///
  /// In en, this message translates to:
  /// **'25th'**
  String get lunarDay25;

  /// No description provided for @lunarDay26.
  ///
  /// In en, this message translates to:
  /// **'26th'**
  String get lunarDay26;

  /// No description provided for @lunarDay27.
  ///
  /// In en, this message translates to:
  /// **'27th'**
  String get lunarDay27;

  /// No description provided for @lunarDay28.
  ///
  /// In en, this message translates to:
  /// **'28th'**
  String get lunarDay28;

  /// No description provided for @lunarDay29.
  ///
  /// In en, this message translates to:
  /// **'29th'**
  String get lunarDay29;

  /// No description provided for @lunarDay30.
  ///
  /// In en, this message translates to:
  /// **'30th'**
  String get lunarDay30;

  /// No description provided for @flyingStar1.
  ///
  /// In en, this message translates to:
  /// **'Star 1'**
  String get flyingStar1;

  /// No description provided for @flyingStar2.
  ///
  /// In en, this message translates to:
  /// **'Star 2'**
  String get flyingStar2;

  /// No description provided for @flyingStar3.
  ///
  /// In en, this message translates to:
  /// **'Star 3'**
  String get flyingStar3;

  /// No description provided for @flyingStar4.
  ///
  /// In en, this message translates to:
  /// **'Star 4'**
  String get flyingStar4;

  /// No description provided for @flyingStar5.
  ///
  /// In en, this message translates to:
  /// **'Star 5'**
  String get flyingStar5;

  /// No description provided for @flyingStar6.
  ///
  /// In en, this message translates to:
  /// **'Star 6'**
  String get flyingStar6;

  /// No description provided for @flyingStar7.
  ///
  /// In en, this message translates to:
  /// **'Star 7'**
  String get flyingStar7;

  /// No description provided for @flyingStar8.
  ///
  /// In en, this message translates to:
  /// **'Star 8'**
  String get flyingStar8;

  /// No description provided for @flyingStar9.
  ///
  /// In en, this message translates to:
  /// **'Star 9'**
  String get flyingStar9;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
