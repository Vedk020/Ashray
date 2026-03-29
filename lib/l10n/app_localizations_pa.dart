// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'ਆਸ਼ਰਯ';

  @override
  String get healthCompanion => 'ਤੁਹਾਡਾ ਸਿਹਤ ਸਾਥੀ';

  @override
  String get loginTitle => 'ਲਾਗਇਨ';

  @override
  String get ashaWorker => 'ਆਸ਼ਾ ਵਰਕਰ';

  @override
  String get citizen => 'ਨਾਗਰਿਕ';

  @override
  String get loginId => 'ਲਾਗਇਨ ਆਈਡੀ';

  @override
  String get password => 'ਪਾਸਵਰਡ';

  @override
  String get navHome => 'ਘਰ';

  @override
  String get navSearch => 'ਖੋਜ';

  @override
  String get navReels => 'ਰੀਲਜ਼';

  @override
  String get navMissions => 'ਮਿਸ਼ਨ';

  @override
  String get navProfile => 'ਪ੍ਰੋਫਾਈਲ';

  @override
  String get settings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get logout => 'ਲੌਗ ਆਉਟ';

  @override
  String get darkMode => 'ਡਾਰਕ ਮੋਡ';

  @override
  String get language => 'ਭਾਸ਼ਾ';

  @override
  String get manualSync => 'ਮੈਨੂਅਲ ਸਿੰਕ';

  @override
  String get syncSubtitle => 'ਆਫਲਾਈਨ ਡੇਟਾ ਨੂੰ ਸਰਵਰ ਤੇ ਭੇਜੋ';

  @override
  String get achievements => 'ਮੇਰੀਆਂ ਪ੍ਰਾਪਤੀਆਂ';

  @override
  String get help => 'ਮਦਦ';

  @override
  String get guide => 'ਗਾਈਡ';

  @override
  String get helpline => 'ਹੈਲਪਲਾਈਨ';

  @override
  String get reportIssue => 'ਸਮੱਸਿਆ ਦੀ ਰਿਪੋਰਟ ਕਰੋ';

  @override
  String get selectLanguage => 'ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get sosAlert => 'SOS ਚੇਤਾਵਨੀ ਸ਼ੁਰੂ ਹੋ ਗਈ ਹੈ!';

  @override
  String get aiCopilot => 'ਏਆਈ ਕੋ-ਪਾਇਲਟ';

  @override
  String greeting(String userName) {
    return '👩‍⚕️ ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ $userName,';
  }

  @override
  String get progressToday => 'ਤੁਹਾਡੀ ਅੱਜ ਦੀ ਤਰੱਕੀ ਇੱਥੇ ਹੈ।';

  @override
  String get aiHealthCopilot => 'ਏਆਈ ਹੈਲਥ ਕੋ-ਪਾਇਲਟ';

  @override
  String get detectIllnessPrompt => 'ਬਿਮਾਰੀ ਦਾ ਪਤਾ ਲਗਾਉਣ ਲਈ ਇੱਕ ਫੋਟੋ ਲਓ';

  @override
  String get myTasks => 'ਮੇਰੇ ਕੰਮ';

  @override
  String tasksDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਕੰਮ ਬਕਾਇਆ ਹਨ',
      one: '1 ਕੰਮ ਬਕਾਇਆ ਹੈ',
      zero: 'ਕੋਈ ਕੰਮ ਬਕਾਇਆ ਨਹੀਂ',
    );
    return '$_temp0';
  }

  @override
  String get scanAadhar => 'Scan Aadhar';

  @override
  String get myMissions => 'ਮੇਰੇ ਮਿਸ਼ਨ';

  @override
  String get weeklyAnalytics => 'ਹਫਤਾਵਾਰੀ ਵਿਸ਼ਲੇਸ਼ਣ';

  @override
  String get familiesVisitedThisWeek => 'ਇਸ ਹਫਤੇ ਦੇਖੇ ਗਏ ਪਰਿਵਾਰ';

  @override
  String get dayMon => 'ਸੋਮ';

  @override
  String get dayTue => 'ਮੰਗਲ';

  @override
  String get dayWed => 'ਬੁੱਧ';

  @override
  String get dayThu => 'ਵੀਰ';

  @override
  String get dayFri => 'ਸ਼ੁੱਕਰ';

  @override
  String get daySat => 'ਸ਼ਨੀ';

  @override
  String get quote1 => '🌸 ਸਿਹਤਮੰਦ ਪਿੰਡ, ਮਜ਼ਬੂਤ ​​ਭਾਰਤ। 🌸';

  @override
  String get quote2 => '🌸 ਸਵਸਥ ਪਿੰਡ, ਖੁਸ਼ਹਾਲ ਭਾਰਤ। 🌸';

  @override
  String get quote3 => '🌸 ਤੁਹਾਡੀ ਸੇਵਾ, ਦੇਸ਼ ਦੀ ਸੇਵਾ। 🌸';

  @override
  String get gamificationHint =>
      'ਤਰੱਕੀਆਂ ਅਤੇ ਵਜ਼ੀਫ਼ੇ ਦੇ ਬੋਨਸਾਂ ਲਈ ਯੋਗ ਹੋਣ ਲਈ ਪੱਧਰ ਵਧਾਓ!';

  @override
  String get syncingNow => 'ਹੁਣ ਸਿੰਕ ਹੋ ਰਿਹਾ ਹੈ...';

  @override
  String get nationalHealthPrograms => 'ਸਿਹਤ ਪ੍ਰੋਗਰਾਮ';

  @override
  String get progAyushmanBharat => 'ਆਯੁਸ਼ਮਾਨ ਭਾਰਤ PM-JAY';

  @override
  String get descAyushmanBharat =>
      'ਸੈਕੰਡਰੀ ਅਤੇ ਤੀਜੇ ਦਰਜੇ ਦੀ ਦੇਖਭਾਲ ਹਸਪਤਾਲ ਵਿੱਚ ਭਰਤੀ ਲਈ ਪ੍ਰਤੀ ਪਰਿਵਾਰ ਪ੍ਰਤੀ ਸਾਲ ₹5 ਲੱਖ ਤੱਕ ਦਾ ਸਿਹਤ ਕਵਰ ਪ੍ਰਦਾਨ ਕਰਦਾ ਹੈ।';

  @override
  String get progJSSK => 'ਜਨਨੀ ਸ਼ਿਸ਼ੂ ਸੁਰੱਖਿਆ ਕਾਰਜਕ੍ਰਮ (JSSK)';

  @override
  String get descJSSK =>
      'ਗਰਭਵਤੀ ਔਰਤਾਂ ਨੂੰ ਜਨਤਕ ਸਿਹਤ ਸੰਸਥਾਵਾਂ ਵਿੱਚ ਸਿਜੇਰੀਅਨ ਸੈਕਸ਼ਨ ਸਮੇਤ ਮੁਫਤ ਡਿਲੀਵਰੀ ਦਾ ਹੱਕਦਾਰ ਬਣਾਉਂਦਾ ਹੈ।';

  @override
  String get progRBSK => 'ਰਾਸ਼ਟਰੀ ਬਾਲ ਸਵਾਸਥਯ ਕਾਰਜਕ੍ਰਮ (RBSK)';

  @override
  String get descRBSK =>
      'ਜਨਮ ਤੋਂ 18 ਸਾਲ ਤੱਕ ਦੇ ਬੱਚਿਆਂ ਲਈ ਜਨਮ ਦੇ ਨੁਕਸ, ਕਮੀਆਂ, ਬਿਮਾਰੀਆਂ, ਵਿਕਾਸ ਵਿੱਚ ਦੇਰੀ ਨੂੰ ਕਵਰ ਕਰਨ ਲਈ ਛੇਤੀ ਪਛਾਣ ਅਤੇ ਦਖਲਅੰਦਾਜ਼ੀ ਲਈ ਇੱਕ ਪਹਿਲ।';

  @override
  String get progPMNDP => 'ਪ੍ਰਧਾਨ ਮੰਤਰੀ ਰਾਸ਼ਟਰੀ ਡਾਇਲਸਿਸ ਪ੍ਰੋਗਰਾਮ';

  @override
  String get descPMNDP =>
      'ਅੰਤਮ ਪੜਾਅ ਦੇ ਗੁਰਦੇ ਦੀ ਬਿਮਾਰੀ ਵਾਲੇ ਮਰੀਜ਼ਾਂ ਨੂੰ ਮੁਫਤ ਜਾਂ ਸਬਸਿਡੀ ਵਾਲੀ ਦੇਖਭਾਲ ਲਈ ਸਾਰੇ ਜ਼ਿਲ੍ਹਾ ਹਸਪਤਾਲਾਂ ਵਿੱਚ ਡਾਇਲਸਿਸ ਸਹੂਲਤਾਂ ਦਾ ਸਮਰਥਨ ਕਰਦਾ ਹੈ।';

  @override
  String get voiceAssistant => 'ਵੌਇਸ ਅਸਿਸਟੈਂਟ';

  @override
  String get listening => 'ਸੁਣ ਰਿਹਾ ਹੈ...';

  @override
  String get trySaying =>
      'ਕਹਿਣ ਦੀ ਕੋਸ਼ਿਸ਼ ਕਰੋ: \'ਖੋਜ ਖੋਲ੍ਹੋ\', \'ਮੇਰੇ ਕੰਮ\', ਜਾਂ \'ਸਿਹਤ ਪ੍ਰੋਗਰਾਮ\'';

  @override
  String get selectVillage => 'ਪਿੰਡ ਚੁਣੋ';

  @override
  String get selectFamily => 'ਪਰਿਵਾਰ ਚੁਣੋ';

  @override
  String get scanAadharQR => 'Scan Aadhar QR';

  @override
  String get noPendingTasks => 'ਕੋਈ ਲੰਬਿਤ ਕੰਮ ਨਹੀਂ';

  @override
  String get myFamily => 'ਮੇਰਾ ਪਰਿਵਾਰ';

  @override
  String get viewSchedule => 'ਸ਼ਡਿਊਲ ਵੇਖੋ';

  @override
  String get viewHealthDetails => 'ਸਿਹਤ ਵੇਰਵੇ ਵੇਖੋ';

  @override
  String get yourHealthQRCode => 'Your Health QR Code';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';
}
