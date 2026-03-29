// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'ఆశ్రయ్';

  @override
  String get healthCompanion => 'మీ ఆరోగ్య సహచరుడు';

  @override
  String get loginTitle => 'లాగిన్';

  @override
  String get ashaWorker => 'ఆశా వర్కర్';

  @override
  String get citizen => 'పౌరుడు';

  @override
  String get loginId => 'లాగిన్ ఐడి';

  @override
  String get password => 'పాస్వర్డ్';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navSearch => 'వెతకండి';

  @override
  String get navReels => 'రీల్స్';

  @override
  String get navMissions => 'మిషన్లు';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get settings => 'సెట్టింగులు';

  @override
  String get logout => 'లాగ్ అవుట్';

  @override
  String get darkMode => 'డార్క్ మోడ్';

  @override
  String get language => 'భాష';

  @override
  String get manualSync => 'మాన్యువల్ సింక్';

  @override
  String get syncSubtitle => 'ఆఫ్‌లైన్ డేటాను సర్వర్‌కు పంపండి';

  @override
  String get achievements => 'నా విజయాలు';

  @override
  String get help => 'సహాయం';

  @override
  String get guide => 'గైడ్';

  @override
  String get helpline => 'హెల్ప్‌లైన్';

  @override
  String get reportIssue => 'సమస్యను నివేదించండి';

  @override
  String get selectLanguage => 'భాషను ఎంచుకోండి';

  @override
  String get sosAlert => 'SOS హెచ్చరిక ప్రేరేపించబడింది!';

  @override
  String get aiCopilot => 'AI కోపైలట్';

  @override
  String greeting(String userName) {
    return '👩‍⚕️ నమస్తే $userName,';
  }

  @override
  String get progressToday => 'ఈ రోజు మీ పురోగతి ఇక్కడ ఉంది.';

  @override
  String get aiHealthCopilot => 'AI హెల్త్ కోపైలట్';

  @override
  String get detectIllnessPrompt => 'అనారోగ్యాన్ని గుర్తించడానికి ఫోటో తీయండి';

  @override
  String get myTasks => 'నా పనులు';

  @override
  String tasksDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count పనులు ఉన్నాయి',
      one: '1 పని ఉంది',
      zero: 'పనులు లేవు',
    );
    return '$_temp0';
  }

  @override
  String get scanAadhar => 'ఆధార్ స్కాన్';

  @override
  String get myMissions => 'నా మిషన్లు';

  @override
  String get weeklyAnalytics => 'వారపు విశ్లేషణలు';

  @override
  String get familiesVisitedThisWeek => 'ఈ వారం సందర్శించిన కుటుంబాలు';

  @override
  String get dayMon => 'సోమ';

  @override
  String get dayTue => 'మంగళ';

  @override
  String get dayWed => 'బుధ';

  @override
  String get dayThu => 'గురు';

  @override
  String get dayFri => 'శుక్ర';

  @override
  String get daySat => 'శని';

  @override
  String get quote1 => '🌸 ఆరోగ్యకరమైన గ్రామం, బలమైన భారత్। 🌸';

  @override
  String get quote2 => '🌸 స్వస్థ గ్రామం, సమృద్ధ భారత్। 🌸';

  @override
  String get quote3 => '🌸 మీ సేవ, దేశ సేవ। 🌸';

  @override
  String get gamificationHint =>
      'పదోన్నతులు మరియు స్టైఫండ్ బోనస్‌లకు అర్హత పొందడానికి స్థాయిని పెంచుకోండి!';

  @override
  String get syncingNow => 'ఇప్పుడు సింక్ అవుతోంది...';

  @override
  String get nationalHealthPrograms => 'ఆరోగ్య కార్యక్రమాలు';

  @override
  String get progAyushmanBharat => 'ఆయుష్మాన్ భారత్ PM-JAY';

  @override
  String get descAyushmanBharat =>
      'ద్వితీయ మరియు తృతీయ సంరక్షణ ఆసుపత్రిలో చేరడం కోసం ప్రతి కుటుంబానికి సంవత్సరానికి ₹5 లక్షల వరకు ఆరోగ్య కవరేజీని అందిస్తుంది.';

  @override
  String get progJSSK => 'జనని శిశు సురక్షా కార్యక్రమం (JSSK)';

  @override
  String get descJSSK =>
      'గర్భిణీ స్త్రీలకు ప్రభుత్వ ఆరోగ్య సంస్థలలో సిజేరియన్ సెక్షన్‌తో సహా ఉచిత ప్రసవానికి అర్హులు.';

  @override
  String get progRBSK => 'రాష్ట్రీయ బాల్ స్వస్థ్య కార్యక్రమం (RBSK)';

  @override
  String get descRBSK =>
      'పుట్టుక నుండి 18 సంవత్సరాల వయస్సు గల పిల్లలకు పుట్టుకతో వచ్చే లోపాలు, లోపాలు, వ్యాధులు, అభివృద్ధి ఆలస్యాన్ని కవర్ చేయడానికి ప్రారంభ గుర్తింపు మరియు జోక్యం కోసం ఒక చొరవ.';

  @override
  String get progPMNDP => 'ప్రధాన్ మంత్రి జాతీయ డయాలసిస్ కార్యక్రమం';

  @override
  String get descPMNDP =>
      'అంతిమ దశ మూత్రపిండ వ్యాధితో బాధపడుతున్న రోగులకు ఉచిత లేదా రాయితీ సంరక్షణ కోసం అన్ని జిల్లా ఆసుపత్రులలో డయాలసిస్ సౌకర్యాలకు మద్దతు ఇస్తుంది.';

  @override
  String get voiceAssistant => 'వాయిస్ అసిస్టెంట్';

  @override
  String get listening => 'వినడం...';

  @override
  String get trySaying =>
      'చెప్పడానికి ప్రయత్నించండి: \'శోధనను తెరవండి\', \'నా పనులు\', లేదా \'ఆరోగ్య కార్యక్రమాలు\'';

  @override
  String get selectVillage => 'గ్రామాన్ని ఎంచుకోండి';

  @override
  String get selectFamily => 'కుటుంబాన్ని ఎంచుకోండి';

  @override
  String get scanAadharQR => 'ఆధార్ QR స్కాన్ చేయండి';

  @override
  String get noPendingTasks => 'పెండింగ్ పనులు లేవు';

  @override
  String get myFamily => 'నా కుటుంబం';

  @override
  String get viewSchedule => 'షెడ్యూల్ చూడండి';

  @override
  String get viewHealthDetails => 'ఆరోగ్య వివరాలు చూడండి';

  @override
  String get yourHealthQRCode => 'మీ ఆరోగ్య QR కోడ్';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';
}
