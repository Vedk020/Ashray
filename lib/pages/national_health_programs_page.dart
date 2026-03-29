import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/app_localizations.dart';

class NationalHealthProgramsPage extends StatelessWidget {
  const NationalHealthProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    // Dummy data for health programs
    final programs = [
      {
        'title': localizations.progAyushmanBharat,
        'description': localizations.descAyushmanBharat,
        'icon': Icons.local_hospital_rounded,
        'color': Colors.blue,
      },
      {
        'title': localizations.progJSSK,
        'description': localizations.descJSSK,
        'icon': Icons.pregnant_woman_rounded,
        'color': Colors.pink,
      },
      {
        'title': localizations.progRBSK,
        'description': localizations.descRBSK,
        'icon': Icons.child_care_rounded,
        'color': Colors.green,
      },
      {
        'title': localizations.progPMNDP,
        'description': localizations.descPMNDP,
        'icon': Icons.food_bank_rounded,
        'color': Colors.orange,
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              title: Text(localizations.nationalHealthPrograms,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              backgroundColor: isDark
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
                  center: Alignment.bottomLeft,
                  radius: 1.5,
                  colors: [
                    theme.colorScheme.secondary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + kToolbarHeight + 20,
                16,
                16),
            itemCount: programs.length,
            itemBuilder: (context, index) {
              final program = programs[index];
              return _buildProgramCard(
                context,
                title: program['title'] as String,
                description: program['description'] as String,
                icon: program['icon'] as IconData,
                color: program['color'] as Color,
                index: index,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgramCard(BuildContext context,
      {required String title,
      required String description,
      required IconData icon,
      required Color color,
      required int index}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: -0.2);
  }
}
