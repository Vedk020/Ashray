// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'আশ্রয়';

  @override
  String get healthCompanion => 'আপনার স্বাস্থ্য সঙ্গী';

  @override
  String get loginTitle => 'লগইন';

  @override
  String get ashaWorker => 'আশা কর্মী';

  @override
  String get citizen => 'নাগরিক';

  @override
  String get loginId => 'লগইন আইডি';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get navHome => 'হোম';

  @override
  String get navSearch => 'অনুসন্ধান';

  @override
  String get navReels => 'রিলস';

  @override
  String get navMissions => 'মিশন';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get settings => 'সেটিংস';

  @override
  String get logout => 'লগ আউট';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get language => 'ভাষা';

  @override
  String get manualSync => 'ম্যানুয়াল সিঙ্ক';

  @override
  String get syncSubtitle => 'অফলাইন ডেটা সার্ভারে পুশ করুন';

  @override
  String get achievements => 'আমার অর্জন';

  @override
  String get help => 'সাহায্য';

  @override
  String get guide => 'গাইড';

  @override
  String get helpline => 'হেল্পলাইন';

  @override
  String get reportIssue => 'সমস্যা রিপোর্ট করুন';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get sosAlert => 'এসওএস সতর্কতা সক্রিয় করা হয়েছে!';

  @override
  String get aiCopilot => 'এআই কপাইলট';

  @override
  String greeting(String userName) {
    return '👩‍⚕️ নমস্তে $userName,';
  }

  @override
  String get progressToday => 'এখানে আপনার আজকের অগ্রগতি।';

  @override
  String get aiHealthCopilot => 'এআই হেলথ কপাইলট';

  @override
  String get detectIllnessPrompt => 'অসুস্থতা সনাক্ত করতে একটি ছবি তুলুন';

  @override
  String get myTasks => 'আমার কাজ';

  @override
  String tasksDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি কাজ বাকি',
      one: '১টি কাজ বাকি',
      zero: 'কোনো কাজ বাকি নেই',
    );
    return '$_temp0';
  }

  @override
  String get scanAadhar => 'Scan Aadhar';

  @override
  String get myMissions => 'আমার মিশন';

  @override
  String get weeklyAnalytics => 'সাপ্তাহিক বিশ্লেষণ';

  @override
  String get familiesVisitedThisWeek => 'এই সপ্তাহে পরিদর্শন করা পরিবার';

  @override
  String get dayMon => 'সোম';

  @override
  String get dayTue => 'মঙ্গল';

  @override
  String get dayWed => 'বুধ';

  @override
  String get dayThu => 'বৃহস্পতি';

  @override
  String get dayFri => 'শুক্র';

  @override
  String get daySat => 'শনি';

  @override
  String get quote1 => '🌸 স্বাস্থ্যকর গ্রাম, শক্তিশালী ভারত। 🌸';

  @override
  String get quote2 => '🌸 সুস্থ গ্রাম, সমৃদ্ধ ভারত। 🌸';

  @override
  String get quote3 => '🌸 আপনার সেবা, দেশের সেবা। 🌸';

  @override
  String get gamificationHint =>
      'পদোন্নতি এবং উপবৃত্তি বোনাসের জন্য যোগ্য হতে লেভেল আপ করুন!';

  @override
  String get syncingNow => 'এখন সিঙ্ক হচ্ছে...';

  @override
  String get nationalHealthPrograms => 'স্বাস্থ্য কর্মসূচি';

  @override
  String get progAyushmanBharat => 'আয়ুষ্মান ভারত PM-JAY';

  @override
  String get descAyushmanBharat =>
      'মাধ্যমিক এবং তৃতীয় স্তরের যত্নের জন্য প্রতি পরিবার প্রতি বছরে ₹5 লক্ষ পর্যন্ত স্বাস্থ্য কভারেজ প্রদান করে।';

  @override
  String get progJSSK => 'জননী শিশু সুরক্ষা কার্যক্রম (JSSK)';

  @override
  String get descJSSK =>
      'গর্ভবতী মহিলাদের সরকারি স্বাস্থ্য প্রতিষ্ঠানে সিজারিয়ান সেকশন সহ বিনামূল্যে প্রসবের অধিকার দেয়।';

  @override
  String get progRBSK => 'রাষ্ট্রীয় বাল স্বাস্থ্য কার্যক্রম (RBSK)';

  @override
  String get descRBSK =>
      'জন্ম থেকে ১৮ বছর বয়সী শিশুদের জন্মগত ত্রুটি, ঘাটতি, রোগ, বিকাশের বিলম্ব কভার করার জন্য প্রাথমিক সনাক্তকরণ এবং হস্তক্ষেপের একটি উদ্যোগ।';

  @override
  String get progPMNDP => 'প্রধানমন্ত্রী জাতীয় ডায়ালাইসিস কর্মসূচি';

  @override
  String get descPMNDP =>
      'শেষ পর্যায়ের রেনাল ডিজিজ রোগীদের জন্য বিনামূল্যে বা ভর্তুকিযুক্ত যত্নের জন্য সমস্ত জেলা হাসপাতালে ডায়ালাইসিস সুবিধার সমর্থন করে।';

  @override
  String get voiceAssistant => 'ভয়েস অ্যাসিস্ট্যান্ট';

  @override
  String get listening => 'শুনছি...';

  @override
  String get trySaying =>
      'বলার চেষ্টা করুন: \'অনুসন্ধান খুলুন\', \'আমার কাজ\', বা \'স্বাস্থ্য কর্মসূচি\'';

  @override
  String get selectVillage => 'গ্রাম নির্বাচন করুন';

  @override
  String get selectFamily => 'পরিবার নির্বাচন করুন';

  @override
  String get scanAadharQR => 'Scan Aadhar QR';

  @override
  String get noPendingTasks => 'কোনো মুলতুবি কাজ নেই';

  @override
  String get myFamily => 'আমার পরিবার';

  @override
  String get viewSchedule => 'সময়সূচী দেখুন';

  @override
  String get viewHealthDetails => 'স্বাস্থ্য বিবরণ দেখুন';

  @override
  String get yourHealthQRCode => 'Your Health QR Code';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';
}
