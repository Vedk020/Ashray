import 'package:ashray/main.dart';
import 'package:ashray/pages/achievements_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/sync_service.dart';
import '../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  final void Function(ThemeMode) changeTheme;
  const SettingsPage({super.key, required this.changeTheme});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                AshrayApp.setLocale(context, const Locale('en'));
                Navigator.pop(context);
              },
              child: const Text('English'),
            ),
            SimpleDialogOption(
              onPressed: () {
                AshrayApp.setLocale(context, const Locale('hi'));
                Navigator.pop(context);
              },
              child: const Text('हिंदी (Hindi)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                AshrayApp.setLocale(context, const Locale('bn'));
                Navigator.pop(context);
              },
              child: const Text('বাংলা (Bengali)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                AshrayApp.setLocale(context, const Locale('ta'));
                Navigator.pop(context);
              },
              child: const Text('தமிழ் (Tamil)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                AshrayApp.setLocale(context, const Locale('te'));
                Navigator.pop(context);
              },
              child: const Text('తెలుగు (Telugu)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                AshrayApp.setLocale(context, const Locale('mr'));
                Navigator.pop(context);
              },
              child: const Text('मराठी (Marathi)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                AshrayApp.setLocale(context, const Locale('pa'));
                Navigator.pop(context);
              },
              child: const Text('ਪੰਜਾਬੀ (Punjabi)'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final double topPadding =
        MediaQuery.of(context).padding.top + kToolbarHeight;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              title: Text(localizations.settings,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              backgroundColor: isDarkMode
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              elevation: 0,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.only(
                top: topPadding + 20, left: 16, right: 16, bottom: 16),
            children: [
              _buildSettingTile(
                context: context,
                title: localizations.darkMode,
                icon: isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    changeTheme(value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ),
              _buildSettingTile(
                context: context,
                title: localizations.language,
                icon: Icons.language_rounded,
                subtitle: _getLanguageName(
                    Localizations.localeOf(context).languageCode),
                onTap: () => _showLanguageDialog(context),
              ),
              const SizedBox(height: 16),
              _buildSettingTile(
                context: context,
                title: localizations.manualSync,
                icon: Icons.sync_rounded,
                subtitle: localizations.syncSubtitle,
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Starting manual sync...'),
                    ),
                  );
                  await SyncService.instance.startSync();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Manual sync completed!'),
                      ),
                    );
                  }
                },
              ),
              _buildSettingTile(
                context: context,
                title: localizations.achievements,
                icon: Icons.emoji_events_rounded,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AchievementsPage())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'hi':
        return 'हिंदी';
      case 'bn':
        return 'বাংলা';
      case 'ta':
        return 'தமிழ்';
      case 'te':
        return 'తెలుగు';
      case 'mr':
        return 'मराठी';
      case 'pa':
        return 'ਪੰਜਾਬੀ';
      default:
        return 'English';
    }
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: subtitle != null
                  ? Text(subtitle,
                      style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.8)))
                  : null,
              trailing: trailing,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
