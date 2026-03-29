import 'package:ashray/home_page.dart';
import 'package:ashray/pages/login_page.dart';
import 'package:ashray/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  await SyncService.instance.initialize();
  if (isLoggedIn) {
    await SyncService.instance.startSync();
  }

  runApp(AshrayApp(isLoggedIn: isLoggedIn));
}

class AshrayApp extends StatefulWidget {
  final bool isLoggedIn;
  const AshrayApp({super.key, required this.isLoggedIn});

  static void setLocale(BuildContext context, Locale newLocale) {
    _AshrayAppState? state = context.findAncestorStateOfType<_AshrayAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<AshrayApp> createState() => _AshrayAppState();
}

class _AshrayAppState extends State<AshrayApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF1A237E);

    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      fontFamily: 'NotoSansDevanagari',
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      fontFamily: 'NotoSansDevanagari',
    );

    return MaterialApp(
      title: 'Ashray',
      themeMode: _themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: widget.isLoggedIn
          ? HomePage(changeTheme: _changeTheme)
          : LoginPage(changeTheme: _changeTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}
