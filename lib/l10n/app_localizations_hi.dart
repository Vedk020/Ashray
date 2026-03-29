// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'आश्रय';

  @override
  String get healthCompanion => 'आपका स्वास्थ्य साथी';

  @override
  String get loginTitle => 'लॉग इन करें';

  @override
  String get ashaWorker => 'आशा कार्यकर्ता';

  @override
  String get citizen => 'नागरिक';

  @override
  String get loginId => 'लॉगिन आईडी';

  @override
  String get password => 'पासवर्ड';

  @override
  String get navHome => 'होम';

  @override
  String get navSearch => 'खोजें';

  @override
  String get navReels => 'रील्स';

  @override
  String get navMissions => 'मिशन';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get language => 'भाषा';

  @override
  String get manualSync => 'मैनुअल सिंक';

  @override
  String get syncSubtitle => 'ऑफ़लाइन डेटा को सर्वर पर भेजें';

  @override
  String get achievements => 'मेरी उपलब्धियां';

  @override
  String get help => 'मदद';

  @override
  String get guide => 'गाइड';

  @override
  String get helpline => 'हेल्पलाइन';

  @override
  String get reportIssue => 'समस्या की रिपोर्ट करें';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get sosAlert => 'एसओएस अलर्ट शुरू हो गया!';

  @override
  String get aiCopilot => 'एआई सह-पायलट';

  @override
  String greeting(String userName) {
    return '👩‍⚕️ नमस्ते $userName,';
  }

  @override
  String get progressToday => 'आज के लिए आपकी प्रगति यहां है।';

  @override
  String get aiHealthCopilot => 'एआई स्वास्थ्य सह-पायलट';

  @override
  String get detectIllnessPrompt => 'बीमारी का पता लगाने के लिए एक फोटो लें';

  @override
  String get myTasks => 'मेरे कार्य';

  @override
  String tasksDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कार्य देय हैं',
      one: '1 कार्य देय',
      zero: 'कोई कार्य देय नहीं',
    );
    return '$_temp0';
  }

  @override
  String get scanAadhar => 'Scan Aadhar';

  @override
  String get myMissions => 'मेरे मिशन';

  @override
  String get weeklyAnalytics => 'साप्ताहिक विश्लेषण';

  @override
  String get familiesVisitedThisWeek => 'इस सप्ताह देखे गए परिवार';

  @override
  String get dayMon => 'सोम';

  @override
  String get dayTue => 'मंगल';

  @override
  String get dayWed => 'बुध';

  @override
  String get dayThu => 'गुरु';

  @override
  String get dayFri => 'शुक्र';

  @override
  String get daySat => 'शनि';

  @override
  String get quote1 => '🌸 स्वस्थ गांव, मजबूत भारत। 🌸';

  @override
  String get quote2 => '🌸 स्वस्थ गांव, समृद्ध भारत। 🌸';

  @override
  String get quote3 => '🌸 आपकी सेवा, देश की सेवा। 🌸';

  @override
  String get gamificationHint =>
      'पदोन्नति और वजीफा बोनस के लिए पात्र होने के लिए स्तर बढ़ाएं!';

  @override
  String get syncingNow => 'अब सिंक हो रहा है...';

  @override
  String get nationalHealthPrograms => 'स्वास्थ्य कार्यक्रम';

  @override
  String get progAyushmanBharat => 'आयुष्मान भारत PM-JAY';

  @override
  String get descAyushmanBharat =>
      'माध्यमिक और तृतीयक देखभाल अस्पताल में भर्ती के लिए प्रति परिवार प्रति वर्ष ₹5 लाख तक का स्वास्थ्य कवर प्रदान करता है।';

  @override
  String get progJSSK => 'जननी शिशु सुरक्षा कार्यक्रम (JSSK)';

  @override
  String get descJSSK =>
      'गर्भवती महिलाओं को सार्वजनिक स्वास्थ्य संस्थानों में सिजेरियन सेक्शन सहित मुफ्त डिलीवरी का अधिकार देता है।';

  @override
  String get progRBSK => 'राष्ट्रीय बाल स्वास्थ्य कार्यक्रम (RBSK)';

  @override
  String get descRBSK =>
      'जन्म से 18 वर्ष तक के बच्चों के लिए जन्मजात दोष, कमियों, बीमारियों, विकास में देरी को कवर करने के लिए शीघ्र पहचान और हस्तक्षेप की एक पहल।';

  @override
  String get progPMNDP => 'प्रधानमंत्री राष्ट्रीय डायलिसिस कार्यक्रम';

  @override
  String get descPMNDP =>
      'अंतिम चरण के गुर्दे की बीमारी वाले रोगियों को मुफ्त या रियायती देखभाल के लिए सभी जिला अस्पतालों में डायलिसिस सुविधाओं का समर्थन करता है।';

  @override
  String get voiceAssistant => 'आवाज सहायक';

  @override
  String get listening => 'सुन रहा है...';

  @override
  String get trySaying =>
      'कहने का प्रयास करें: \'खोज खोलो\', \'मेरे कार्य\', या \'स्वास्थ्य कार्यक्रम\'';

  @override
  String get selectVillage => 'गांव चुनें';

  @override
  String get selectFamily => 'परिवार चुनें';

  @override
  String get scanAadharQR => 'Scan Aadhar QR';

  @override
  String get noPendingTasks => 'कोई लंबित कार्य नहीं';

  @override
  String get myFamily => 'मेरा परिवार';

  @override
  String get viewSchedule => 'शेड्यूल देखें';

  @override
  String get viewHealthDetails => 'स्वास्थ्य विवरण देखें';

  @override
  String get yourHealthQRCode => 'Your Health QR Code';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';
}
