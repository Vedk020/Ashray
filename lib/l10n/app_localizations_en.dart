// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ashray (आश्रय)';

  @override
  String get healthCompanion => 'Your Health Companion';

  @override
  String get loginTitle => 'Login';

  @override
  String get ashaWorker => 'ASHA Worker';

  @override
  String get citizen => 'Citizen';

  @override
  String get loginId => 'Login ID';

  @override
  String get password => 'Password';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navReels => 'Reels';

  @override
  String get navMissions => 'Missions';

  @override
  String get navProfile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get manualSync => 'Manual Sync';

  @override
  String get syncSubtitle => 'Push offline data to the server';

  @override
  String get achievements => 'My Achievements';

  @override
  String get help => 'Help';

  @override
  String get guide => 'Guide';

  @override
  String get helpline => 'Helpline';

  @override
  String get reportIssue => 'Report an Issue';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get sosAlert => 'SOS Alert Triggered!';

  @override
  String get aiCopilot => 'AI Copilot';

  @override
  String greeting(String userName) {
    return '👩‍⚕️ Namaste $userName,';
  }

  @override
  String get progressToday => 'Here is your progress for today.';

  @override
  String get aiHealthCopilot => 'AI Health Copilot';

  @override
  String get detectIllnessPrompt => 'Take a photo to detect illness';

  @override
  String get myTasks => 'My Tasks';

  @override
  String tasksDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks due',
      one: '1 task due',
      zero: 'No tasks due',
    );
    return '$_temp0';
  }

  @override
  String get scanAadhar => 'Scan Aadhar';

  @override
  String get myMissions => 'My Missions';

  @override
  String get weeklyAnalytics => 'Weekly Analytics';

  @override
  String get familiesVisitedThisWeek => 'Families Visited This Week';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get quote1 => '🌸 Healthy Gaon, Strong Bharat. 🌸';

  @override
  String get quote2 => '🌸 Swasth Gaon, Samruddh Bharat. 🌸';

  @override
  String get quote3 => '🌸 Aapki Seva, Desh Ki Seva. 🌸';

  @override
  String get gamificationHint =>
      'Level up to be eligible for promotions and stipend bonuses!';

  @override
  String get syncingNow => 'Syncing now...';

  @override
  String get nationalHealthPrograms => 'Health Programs';

  @override
  String get progAyushmanBharat => 'Ayushman Bharat PM-JAY';

  @override
  String get descAyushmanBharat =>
      'Provides health coverage of up to ₹5 lakh per family per year for secondary and tertiary care hospitalization.';

  @override
  String get progJSSK => 'Janani Shishu Suraksha Karyakram (JSSK)';

  @override
  String get descJSSK =>
      'Entitles pregnant women to free delivery, including caesarean section, in public health institutions.';

  @override
  String get progRBSK => 'Rashtriya Bal Swasthya Karyakram (RBSK)';

  @override
  String get descRBSK =>
      'An initiative for early identification and intervention for children from birth to 18 years to cover defects at birth, deficiencies, diseases, development delays.';

  @override
  String get progPMNDP => 'Pradhan Mantri National Dialysis Programme';

  @override
  String get descPMNDP =>
      'Supports dialysis facilities in all district hospitals for free or subsidized care to patients with end-stage renal disease.';

  @override
  String get voiceAssistant => 'Voice Assistant';

  @override
  String get listening => 'Listening...';

  @override
  String get trySaying =>
      'Try saying: \'Open Search\', \'My Tasks\', or \'Health Programs\'';

  @override
  String get selectVillage => 'Select Village';

  @override
  String get selectFamily => 'Select Family';

  @override
  String get scanAadharQR => 'Scan Aadhar QR';

  @override
  String get noPendingTasks => 'No pending tasks';

  @override
  String get myFamily => 'My Family';

  @override
  String get viewSchedule => 'View Schedule';

  @override
  String get viewHealthDetails => 'View Health Details';

  @override
  String get yourHealthQRCode => 'Your Health QR Code';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';
}
