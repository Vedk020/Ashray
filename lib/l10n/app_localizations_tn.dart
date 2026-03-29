// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tswana (`tn`).
class AppLocalizationsTn extends AppLocalizations {
  AppLocalizationsTn([String locale = 'tn']) : super(locale);

  @override
  String get appTitle => 'ஆஷ்ரய்';

  @override
  String get healthCompanion => 'உங்கள் சுகாதார துணை';

  @override
  String get loginTitle => 'உள்நுழை';

  @override
  String get ashaWorker => 'ஆஷா பணியாளர்';

  @override
  String get citizen => 'குடிமகன்';

  @override
  String get loginId => 'உள்நுழைவு ஐடி';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navSearch => 'தேடு';

  @override
  String get navReels => 'ரீல்ஸ்';

  @override
  String get navMissions => 'பயணங்கள்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get darkMode => 'இருண்ட பயன்முறை';

  @override
  String get language => 'மொழி';

  @override
  String get manualSync => 'கையேடு ஒத்திசைவு';

  @override
  String get syncSubtitle => 'ஆஃப்லைன் தரவை சேவையகத்திற்கு தள்ளவும்';

  @override
  String get achievements => 'எனது சாதனைகள்';

  @override
  String get help => 'உதவி';

  @override
  String get guide => 'வழிகாட்டி';

  @override
  String get helpline => 'உதவி எண்';

  @override
  String get reportIssue => 'சிக்கலைப் புகாரளி';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get sosAlert => 'SOS எச்சரிக்கை இயக்கப்பட்டது!';

  @override
  String get aiCopilot => 'AI காதலர்';

  @override
  String greeting(String userName) {
    return '👩‍⚕️ வணக்கம் $userName,';
  }

  @override
  String get progressToday => 'இன்றைய உங்கள் முன்னேற்றம் இங்கே.';

  @override
  String get aiHealthCopilot => 'AI சுகாதார காதலர்';

  @override
  String get detectIllnessPrompt => 'நோய் கண்டறிய ஒரு புகைப்படம் எடுக்கவும்';

  @override
  String get myTasks => 'எனது பணிகள்';

  @override
  String tasksDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பணிகள் உள்ளன',
      one: '1 பணி உள்ளது',
      zero: 'பணிகள் எதுவும் இல்லை',
    );
    return '$_temp0';
  }

  @override
  String get scanAadhar => 'Scan Aadhar';

  @override
  String get myMissions => 'எனது பயணங்கள்';

  @override
  String get weeklyAnalytics => 'வாராந்திர பகுப்பாய்வு';

  @override
  String get familiesVisitedThisWeek => 'இந்த வாரம் பார்வையிட்ட குடும்பங்கள்';

  @override
  String get dayMon => 'திங்கள்';

  @override
  String get dayTue => 'செவ்வாய்';

  @override
  String get dayWed => 'புதன்';

  @override
  String get dayThu => 'வியாழன்';

  @override
  String get dayFri => 'வெள்ளி';

  @override
  String get daySat => 'சனி';

  @override
  String get quote1 => '🌸 ஆரோக்கியமான கிராமம், வலிமையான பாரதம்। 🌸';

  @override
  String get quote2 => '🌸 ஸ்வஸ்த் கிராம், சம்ருத் பாரத்। 🌸';

  @override
  String get quote3 => '🌸 உங்கள் சேவை, தேசத்தின் சேவை। 🌸';

  @override
  String get gamificationHint =>
      'விளம்பரங்கள் மற்றும் உதவித்தொகை போனஸுக்கு தகுதி பெற cấp độ ஏறுங்கள்!';

  @override
  String get syncingNow => 'இப்போது ஒத்திசைக்கிறது...';

  @override
  String get nationalHealthPrograms => 'சுகாதார திட்டங்கள்';

  @override
  String get progAyushmanBharat => 'ஆயுஷ்மான் பாரத் PM-JAY';

  @override
  String get descAyushmanBharat =>
      'இரண்டாம் மற்றும் மூன்றாம் நிலை மருத்துவமனை பராமரிப்புக்காக ஒரு குடும்பத்திற்கு ஆண்டுக்கு ₹5 லட்சம் வரை சுகாதார காப்பீடு வழங்குகிறது.';

  @override
  String get progJSSK => 'ஜனனி சிசு சுரக்ஷா காரியக்ரம் (JSSK)';

  @override
  String get descJSSK =>
      'கர்ப்பிணிப் பெண்களுக்கு பொது சுகாதார நிறுவனங்களில் சிசேரியன் பிரிவு உட்பட இலவச பிரசவத்திற்கு உரிமை அளிக்கிறது.';

  @override
  String get progRBSK => 'ராஷ்டிரிய பால் ஸ்வஸ்திய காரியக்ரம் (RBSK)';

  @override
  String get descRBSK =>
      'பிறப்பு முதல் 18 வயது வரையிலான குழந்தைகளுக்கு பிறப்பு குறைபாடுகள், குறைபாடுகள், நோய்கள், வளர்ச்சி தாமதங்களை ஈடுகட்ட ஆரம்பகால அடையாளம் மற்றும் தலையீட்டிற்கான ஒரு முயற்சி.';

  @override
  String get progPMNDP => 'பிரதான் மந்திரி தேசிய டயாலிசிஸ் திட்டம்';

  @override
  String get descPMNDP =>
      'இறுதி நிலை சிறுநீரக நோயால் பாதிக்கப்பட்ட நோயாளிகளுக்கு இலவச அல்லது மானிய விலையில் சிகிச்சை அளிக்க அனைத்து மாவட்ட மருத்துவமனைகளிலும் டயாலிசிஸ் வசதிகளை ஆதரிக்கிறது.';

  @override
  String get voiceAssistant => 'குரல் உதவியாளர்';

  @override
  String get listening => 'கேட்கிறது...';

  @override
  String get trySaying =>
      'சொல்லிப் பாருங்கள்: \'தேடலைத் திற\', \'எனது பணிகள்\', அல்லது \'சுகாதாரத் திட்டங்கள்\'';

  @override
  String get selectVillage => 'கிராமத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectFamily => 'குடும்பத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get scanAadharQR => 'Scan Aadhar QR';

  @override
  String get noPendingTasks => 'நிலுவையில் உள்ள பணிகள் இல்லை';

  @override
  String get myFamily => 'என் குடும்பம்';

  @override
  String get viewSchedule => 'அட்டவணையைப் பார்க்கவும்';

  @override
  String get viewHealthDetails => 'சுகாதார விவரங்களைக் காண்க';

  @override
  String get yourHealthQRCode => 'Your Health QR Code';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';
}
