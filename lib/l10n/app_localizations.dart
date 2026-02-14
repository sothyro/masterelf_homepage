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
  /// **'Chartered Practitioner'**
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
  /// **'Curated talismans and remedies. More items coming soon.'**
  String get talismanStoreSpotlightDesc;

  /// No description provided for @appsFeatureShowcaseHeading.
  ///
  /// In en, this message translates to:
  /// **'See the system in action'**
  String get appsFeatureShowcaseHeading;

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
  /// **'Contact Us'**
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
  /// **'Over 44,000 followers have used this system. Success is certain when you align with the right people, right places, and right time.'**
  String get sectionKnowledgeBody;

  /// No description provided for @sectionKnowledgeBody2.
  ///
  /// In en, this message translates to:
  /// **'Success doesn\'t come from working harder. It comes from making the right moves, at the right time, with the right system.'**
  String get sectionKnowledgeBody2;

  /// No description provided for @sectionKnowledgeStat.
  ///
  /// In en, this message translates to:
  /// **'44,000+ followers'**
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
  /// **'Today, that method has helped 44,000 followers create better outcomes for themselves and others.'**
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
  /// **'Learning & Training'**
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
  /// **'Destiny Reveal'**
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
  /// **'Reveal your true power within.'**
  String get consult1Desc;

  /// No description provided for @consult2Category.
  ///
  /// In en, this message translates to:
  /// **'Special Event Date Selection'**
  String get consult2Category;

  /// No description provided for @consult2Method.
  ///
  /// In en, this message translates to:
  /// **'QiMen DunJia'**
  String get consult2Method;

  /// No description provided for @consult2Question.
  ///
  /// In en, this message translates to:
  /// **'Strategise your wise move...'**
  String get consult2Question;

  /// No description provided for @consult2Desc.
  ///
  /// In en, this message translates to:
  /// **'Defeat your enemy and maximise your benefits.'**
  String get consult2Desc;

  /// No description provided for @consult3Category.
  ///
  /// In en, this message translates to:
  /// **'Mediation of Space'**
  String get consult3Category;

  /// No description provided for @consult3Method.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui'**
  String get consult3Method;

  /// No description provided for @consult3Question.
  ///
  /// In en, this message translates to:
  /// **'Arrange your place, define your life...'**
  String get consult3Question;

  /// No description provided for @consult3Desc.
  ///
  /// In en, this message translates to:
  /// **'Understand how to harness the positive energy of your environment.'**
  String get consult3Desc;

  /// No description provided for @consult4Category.
  ///
  /// In en, this message translates to:
  /// **'Auspicious Timing'**
  String get consult4Category;

  /// No description provided for @consult4Method.
  ///
  /// In en, this message translates to:
  /// **'Date Selection'**
  String get consult4Method;

  /// No description provided for @consult4Question.
  ///
  /// In en, this message translates to:
  /// **'When is the best time to choose things wisely?'**
  String get consult4Question;

  /// No description provided for @consult4Desc.
  ///
  /// In en, this message translates to:
  /// **'Select your time and date for the best possible outcome.'**
  String get consult4Desc;

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

  /// No description provided for @journeyStory1.
  ///
  /// In en, this message translates to:
  /// **'Master Elf is a recognised practitioner of Feng Shui and Chinese Metaphysics, with a following of over 44,000 and a track record of guiding individuals and businesses toward clarity and results. His path did not begin by chance—it began with a calling.'**
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

  /// No description provided for @sessionDurationNote.
  ///
  /// In en, this message translates to:
  /// **'Each session is 2 hours with a 1-hour break between sessions.'**
  String get sessionDurationNote;

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
  /// **'Cancel booking'**
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
  /// **'Mark completed'**
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
  /// **'The Singapore Edition of Feng Shui & Astrology 2026 live event.'**
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
  /// **'The Art of War In The Year of the Fire Horse'**
  String get event3Description;

  /// No description provided for @event3Location.
  ///
  /// In en, this message translates to:
  /// **'Resorts World Singapore'**
  String get event3Location;

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
