// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'आश्रय';

  @override
  String get healthCompanion => 'तुमचा आरोग्य सोबती';

  @override
  String get loginTitle => 'लॉगिन';

  @override
  String get ashaWorker => 'आशा वर्कर';

  @override
  String get citizen => 'नागरिक';

  @override
  String get loginId => 'लॉगिन आयडी';

  @override
  String get password => 'पासवर्ड';

  @override
  String get navHome => 'होम';

  @override
  String get navSearch => 'शोधा';

  @override
  String get navReels => 'रील्स';

  @override
  String get navMissions => 'मोहिमा';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get language => 'भाषा';

  @override
  String get manualSync => 'मॅन्युअल सिंक';

  @override
  String get syncSubtitle => 'ऑफलाइन डेटा सर्व्हरवर पाठवा';

  @override
  String get achievements => 'माझी उपलब्धी';

  @override
  String get help => 'मदत';

  @override
  String get guide => 'मार्गदर्शक';

  @override
  String get helpline => 'हेल्पलाइन';

  @override
  String get reportIssue => 'समस्येची तक्रार करा';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get sosAlert => 'एसओएस अलर्ट सुरू झाला!';

  @override
  String get aiCopilot => 'एआय कोपायलट';

  @override
  String greeting(String userName) {
    return '👩‍⚕️ नमस्ते $userName,';
  }

  @override
  String get progressToday => 'तुमची आजची प्रगती येथे आहे.';

  @override
  String get aiHealthCopilot => 'एआय हेल्थ कोपायलट';

  @override
  String get detectIllnessPrompt => 'आजार ओळखण्यासाठी फोटो घ्या';

  @override
  String get myTasks => 'माझी कामे';

  @override
  String tasksDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कामे देय आहेत',
      one: '१ काम देय आहे',
      zero: 'कोणतेही काम देय नाही',
    );
    return '$_temp0';
  }

  @override
  String get scanAadhar => 'Scan Aadhar';

  @override
  String get myMissions => 'माझ्या मोहिमा';

  @override
  String get weeklyAnalytics => 'साप्ताहिक विश्लेषण';

  @override
  String get familiesVisitedThisWeek => 'या आठवड्यात भेट दिलेली कुटुंबे';

  @override
  String get dayMon => 'सोम';

  @override
  String get dayTue => 'मंगळ';

  @override
  String get dayWed => 'बुध';

  @override
  String get dayThu => 'गुरु';

  @override
  String get dayFri => 'शुक्र';

  @override
  String get daySat => 'शनि';

  @override
  String get quote1 => '🌸 निरोगी गाव, बलवान भारत। 🌸';

  @override
  String get quote2 => '🌸 स्वस्थ गाव, समृद्ध भारत। 🌸';

  @override
  String get quote3 => '🌸 तुमची सेवा, देशाची सेवा। 🌸';

  @override
  String get gamificationHint =>
      'पदोन्नती आणि स्टायपेंड बोनससाठी पात्र होण्यासाठी स्तर वाढवा!';

  @override
  String get syncingNow => 'आता सिंक होत आहे...';

  @override
  String get nationalHealthPrograms => 'आरोग्य कार्यक्रम';

  @override
  String get progAyushmanBharat => 'आयुष्मान भारत PM-JAY';

  @override
  String get descAyushmanBharat =>
      'दुय्यम आणि तृतीयक काळजी रुग्णालयात दाखल करण्यासाठी प्रति कुटुंब प्रति वर्ष ₹5 लाख पर्यंत आरोग्य कवच प्रदान करते.';

  @override
  String get progJSSK => 'जननी शिशु सुरक्षा कार्यक्रम (JSSK)';

  @override
  String get descJSSK =>
      'गर्भवती महिलांना सार्वजनिक आरोग्य संस्थांमध्ये सिझेरियन सेक्शनसह विनामूल्य प्रसूतीचा हक्क देतो.';

  @override
  String get progRBSK => 'राष्ट्रीय बाल स्वास्थ्य कार्यक्रम (RBSK)';

  @override
  String get descRBSK =>
      'जन्मापासून ते १८ वर्षांपर्यंतच्या मुलांसाठी जन्मावेळी असलेले दोष, कमतरता, रोग, विकासातील विलंब यासाठी लवकर ओळख आणि हस्तक्षेपासाठी एक उपक्रम.';

  @override
  String get progPMNDP => 'प्रधानमंत्री राष्ट्रीय डायलिसिस कार्यक्रम';

  @override
  String get descPMNDP =>
      'अंतिम टप्प्यातील मूत्रपिंड रोग असलेल्या रुग्णांना विनामूल्य किंवा अनुदानित काळजीसाठी सर्व जिल्हा रुग्णालयांमधील डायलिसिस सुविधांना समर्थन देते.';

  @override
  String get voiceAssistant => 'व्हॉइस असिस्टंट';

  @override
  String get listening => 'ऐकत आहे...';

  @override
  String get trySaying =>
      'म्हणण्याचा प्रयत्न करा: \'शोध उघडा\', \'माझी कामे\', किंवा \'आरोग्य कार्यक्रम\'';

  @override
  String get selectVillage => 'गाव निवडा';

  @override
  String get selectFamily => 'कुटुंब निवडा';

  @override
  String get scanAadharQR => 'Scan Aadhar QR';

  @override
  String get noPendingTasks => 'कोणतेही प्रलंबित कार्य नाही';

  @override
  String get myFamily => 'माझे कुटुंब';

  @override
  String get viewSchedule => 'वेळापत्रक पहा';

  @override
  String get viewHealthDetails => 'आरोग्य तपशील पहा';

  @override
  String get yourHealthQRCode => 'Your Health QR Code';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';
}
