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

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @newsAndEvents.
  ///
  /// In en, this message translates to:
  /// **'News & Events'**
  String get newsAndEvents;

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

  /// No description provided for @journey.
  ///
  /// In en, this message translates to:
  /// **'Master Elf\'s Journey'**
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
  /// **'Explore Courses'**
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
  /// **'You don\'t need more advice. You need a RoadMap. Let heaven guide you to the correct way.'**
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
  /// **'Gain strategic advantage to maximise your wins.'**
  String get academyQiMenDesc;

  /// No description provided for @academyBaZi.
  ///
  /// In en, this message translates to:
  /// **'BaZi Revelation™'**
  String get academyBaZi;

  /// No description provided for @academyBaZiDesc.
  ///
  /// In en, this message translates to:
  /// **'Understand your destiny, and hidden power.'**
  String get academyBaZiDesc;

  /// No description provided for @academyFengShui.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui Charter™'**
  String get academyFengShui;

  /// No description provided for @academyFengShuiDesc.
  ///
  /// In en, this message translates to:
  /// **'Charter Practitioner of the Qi flow.'**
  String get academyFengShuiDesc;

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
  /// **'12 ANIMALS FORECAST'**
  String get popupTitle2;

  /// No description provided for @popupDescription.
  ///
  /// In en, this message translates to:
  /// **'Get Your Personal 2026 Animal Sign Forecast…'**
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

  /// No description provided for @eventColumn.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventColumn;

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

  /// No description provided for @appointmentIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose your consultation type, pick a time, and receive an SMS confirmation to your phone.'**
  String get appointmentIntro;

  /// No description provided for @stepChooseService.
  ///
  /// In en, this message translates to:
  /// **'Choose service'**
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
