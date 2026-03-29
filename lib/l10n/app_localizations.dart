import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_te.dart';
import 'app_localizations_tn.dart';

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
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
    Locale('pa'),
    Locale('te'),
    Locale('tn')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Ashray (आश्रय)'**
  String get appTitle;

  /// No description provided for @healthCompanion.
  ///
  /// In en, this message translates to:
  /// **'Your Health Companion'**
  String get healthCompanion;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @ashaWorker.
  ///
  /// In en, this message translates to:
  /// **'ASHA Worker'**
  String get ashaWorker;

  /// No description provided for @citizen.
  ///
  /// In en, this message translates to:
  /// **'Citizen'**
  String get citizen;

  /// No description provided for @loginId.
  ///
  /// In en, this message translates to:
  /// **'Login ID'**
  String get loginId;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navReels.
  ///
  /// In en, this message translates to:
  /// **'Reels'**
  String get navReels;

  /// No description provided for @navMissions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get navMissions;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @manualSync.
  ///
  /// In en, this message translates to:
  /// **'Manual Sync'**
  String get manualSync;

  /// No description provided for @syncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push offline data to the server'**
  String get syncSubtitle;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'My Achievements'**
  String get achievements;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guide;

  /// No description provided for @helpline.
  ///
  /// In en, this message translates to:
  /// **'Helpline'**
  String get helpline;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportIssue;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @sosAlert.
  ///
  /// In en, this message translates to:
  /// **'SOS Alert Triggered!'**
  String get sosAlert;

  /// No description provided for @aiCopilot.
  ///
  /// In en, this message translates to:
  /// **'AI Copilot'**
  String get aiCopilot;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'👩‍⚕️ Namaste {userName},'**
  String greeting(String userName);

  /// No description provided for @progressToday.
  ///
  /// In en, this message translates to:
  /// **'Here is your progress for today.'**
  String get progressToday;

  /// No description provided for @aiHealthCopilot.
  ///
  /// In en, this message translates to:
  /// **'AI Health Copilot'**
  String get aiHealthCopilot;

  /// No description provided for @detectIllnessPrompt.
  ///
  /// In en, this message translates to:
  /// **'Take a photo to detect illness'**
  String get detectIllnessPrompt;

  /// No description provided for @myTasks.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get myTasks;

  /// No description provided for @tasksDue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No tasks due} =1{1 task due} other{{count} tasks due}}'**
  String tasksDue(int count);

  /// No description provided for @scanAadhar.
  ///
  /// In en, this message translates to:
  /// **'Scan Aadhar'**
  String get scanAadhar;

  /// No description provided for @myMissions.
  ///
  /// In en, this message translates to:
  /// **'My Missions'**
  String get myMissions;

  /// No description provided for @weeklyAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Weekly Analytics'**
  String get weeklyAnalytics;

  /// No description provided for @familiesVisitedThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Families Visited This Week'**
  String get familiesVisitedThisWeek;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @quote1.
  ///
  /// In en, this message translates to:
  /// **'🌸 Healthy Gaon, Strong Bharat. 🌸'**
  String get quote1;

  /// No description provided for @quote2.
  ///
  /// In en, this message translates to:
  /// **'🌸 Swasth Gaon, Samruddh Bharat. 🌸'**
  String get quote2;

  /// No description provided for @quote3.
  ///
  /// In en, this message translates to:
  /// **'🌸 Aapki Seva, Desh Ki Seva. 🌸'**
  String get quote3;

  /// No description provided for @gamificationHint.
  ///
  /// In en, this message translates to:
  /// **'Level up to be eligible for promotions and stipend bonuses!'**
  String get gamificationHint;

  /// No description provided for @syncingNow.
  ///
  /// In en, this message translates to:
  /// **'Syncing now...'**
  String get syncingNow;

  /// No description provided for @nationalHealthPrograms.
  ///
  /// In en, this message translates to:
  /// **'Health Programs'**
  String get nationalHealthPrograms;

  /// No description provided for @progAyushmanBharat.
  ///
  /// In en, this message translates to:
  /// **'Ayushman Bharat PM-JAY'**
  String get progAyushmanBharat;

  /// No description provided for @descAyushmanBharat.
  ///
  /// In en, this message translates to:
  /// **'Provides health coverage of up to ₹5 lakh per family per year for secondary and tertiary care hospitalization.'**
  String get descAyushmanBharat;

  /// No description provided for @progJSSK.
  ///
  /// In en, this message translates to:
  /// **'Janani Shishu Suraksha Karyakram (JSSK)'**
  String get progJSSK;

  /// No description provided for @descJSSK.
  ///
  /// In en, this message translates to:
  /// **'Entitles pregnant women to free delivery, including caesarean section, in public health institutions.'**
  String get descJSSK;

  /// No description provided for @progRBSK.
  ///
  /// In en, this message translates to:
  /// **'Rashtriya Bal Swasthya Karyakram (RBSK)'**
  String get progRBSK;

  /// No description provided for @descRBSK.
  ///
  /// In en, this message translates to:
  /// **'An initiative for early identification and intervention for children from birth to 18 years to cover defects at birth, deficiencies, diseases, development delays.'**
  String get descRBSK;

  /// No description provided for @progPMNDP.
  ///
  /// In en, this message translates to:
  /// **'Pradhan Mantri National Dialysis Programme'**
  String get progPMNDP;

  /// No description provided for @descPMNDP.
  ///
  /// In en, this message translates to:
  /// **'Supports dialysis facilities in all district hospitals for free or subsidized care to patients with end-stage renal disease.'**
  String get descPMNDP;

  /// No description provided for @voiceAssistant.
  ///
  /// In en, this message translates to:
  /// **'Voice Assistant'**
  String get voiceAssistant;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @trySaying.
  ///
  /// In en, this message translates to:
  /// **'Try saying: \'Open Search\', \'My Tasks\', or \'Health Programs\''**
  String get trySaying;

  /// No description provided for @selectVillage.
  ///
  /// In en, this message translates to:
  /// **'Select Village'**
  String get selectVillage;

  /// No description provided for @selectFamily.
  ///
  /// In en, this message translates to:
  /// **'Select Family'**
  String get selectFamily;

  /// No description provided for @scanAadharQR.
  ///
  /// In en, this message translates to:
  /// **'Scan Aadhar QR'**
  String get scanAadharQR;

  /// No description provided for @noPendingTasks.
  ///
  /// In en, this message translates to:
  /// **'No pending tasks'**
  String get noPendingTasks;

  /// No description provided for @myFamily.
  ///
  /// In en, this message translates to:
  /// **'My Family'**
  String get myFamily;

  /// No description provided for @viewSchedule.
  ///
  /// In en, this message translates to:
  /// **'View Schedule'**
  String get viewSchedule;

  /// No description provided for @viewHealthDetails.
  ///
  /// In en, this message translates to:
  /// **'View Health Details'**
  String get viewHealthDetails;

  /// No description provided for @yourHealthQRCode.
  ///
  /// In en, this message translates to:
  /// **'Your Health QR Code'**
  String get yourHealthQRCode;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'bn',
        'en',
        'hi',
        'mr',
        'pa',
        'te',
        'tn'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
    case 'pa':
      return AppLocalizationsPa();
    case 'te':
      return AppLocalizationsTe();
    case 'tn':
      return AppLocalizationsTn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
