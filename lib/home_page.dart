import 'package:ashray/pages/add_family_page.dart';
import 'package:ashray/pages/copilot_page.dart';
import 'package:ashray/pages/member_details_page.dart';
import 'package:ashray/pages/missions_page.dart';
import 'package:ashray/pages/national_health_programs_page.dart';
import 'package:ashray/pages/profile_page.dart';
import 'package:ashray/pages/reels_page.dart';
import 'package:ashray/pages/search_page.dart';
import 'package:ashray/pages/tasks_page.dart';
import 'package:ashray/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'database_helper.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'pages/add_member_page.dart';

class HomePage extends StatefulWidget {
  final void Function(ThemeMode) changeTheme;

  const HomePage({
    super.key,
    required this.changeTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      _DashboardPage(
        changeTheme: widget.changeTheme,
        onNavigateToPage: _navigateToPage,
      ),
      const SearchPage(),
      const ReelsPage(),
      const MissionsPage(),
      ProfilePage(changeTheme: widget.changeTheme),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToPage(Widget page) {
    int pageIndex = pages.indexWhere((p) => p.runtimeType == page.runtimeType);
    if (pageIndex != -1) {
      if (_selectedIndex == pageIndex)
        return; // Do nothing if already on the page
      _onItemTapped(pageIndex);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: _buildGlassBottomNav(context, localizations),
    );
  }

  Widget _buildGlassBottomNav(
      BuildContext context, AppLocalizations localizations) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.7)
                  : Colors.white.withOpacity(0.7),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                      0, Icons.home_rounded, localizations.navHome, theme),
                  _buildNavItem(
                      1, Icons.search_rounded, localizations.navSearch, theme),
                  _buildNavItem(2, Icons.video_library_rounded,
                      localizations.navReels, theme),
                  _buildNavItem(3, Icons.emoji_events_rounded,
                      localizations.navMissions, theme),
                  _buildNavItem(
                      4, Icons.person_rounded, localizations.navProfile, theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, String label, ThemeData theme) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(label),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashboardPage extends StatefulWidget {
  final void Function(ThemeMode) changeTheme;
  final Function(Widget) onNavigateToPage;

  const _DashboardPage(
      {required this.changeTheme, required this.onNavigateToPage});

  @override
  State<_DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<_DashboardPage>
    with SingleTickerProviderStateMixin {
  String _currentQuote = '';
  bool _isLoading = true;
  int _pendingTasksCount = 0;
  late final AnimationController _syncAnimationController;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _syncAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _syncAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final List<String> motivationalQuotes = [
      l10n.quote1,
      l10n.quote2,
      l10n.quote3,
    ];
    final dbHelper = DatabaseHelper.instance;
    final pendingTasks = await dbHelper.getPendingTasks();

    if (mounted) {
      setState(() {
        _currentQuote =
            motivationalQuotes[Random().nextInt(motivationalQuotes.length)];
        _pendingTasksCount = pendingTasks.length;
        _isLoading = false;
      });
    }
  }

  void _navigateTo(Widget page) {
    widget.onNavigateToPage(page);
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    if (mounted) setState(() {});
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.5),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mic, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            const Text('Listening...',
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    if (mounted) {
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      final command = result.recognizedWords.toLowerCase();
      _stopListening();
      _processVoiceCommand(command);
    }
  }

  void _processVoiceCommand(String command) {
    if (command.contains('search')) {
      _navigateTo(const SearchPage());
    } else if (command.contains('tasks') || command.contains('to do')) {
      _navigateTo(const TasksPage());
    } else if (command.contains('reels') || command.contains('videos')) {
      _navigateTo(const ReelsPage());
    } else if (command.contains('missions') ||
        command.contains('achievements')) {
      _navigateTo(const MissionsPage());
    } else if (command.contains('profile')) {
      _navigateTo(ProfilePage(changeTheme: widget.changeTheme));
    } else if (command.contains('add family') ||
        command.contains('new family')) {
      _navigateTo(const AddFamilyPage());
    } else if (command.contains('scan aadhar') ||
        command.contains('scan card')) {
      _handleAadhaarScanAndOCR();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Command not recognized: '$command'")),
      );
    }
  }

  Future<void> _handleAadhaarScanAndOCR() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Aadhaar card...')),
    );

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      textRecognizer.close();

      String fullText = recognizedText.text;

      final aadharRegex = RegExp(r'(\d{4}[\s-]?\d{4}[\s-]?\d{4})');
      final aadharMatch = aadharRegex.firstMatch(fullText);
      final aadharNumber =
          aadharMatch?.group(0)?.replaceAll(RegExp(r'[\s-]'), '');

      if (aadharNumber != null) {
        final existingMember =
            await DatabaseHelper.instance.getMemberByAadhar(aadharNumber);

        if (mounted) {
          if (existingMember != null) {
            _navigateTo(
                MemberDetailsPage(memberId: existingMember['id'] as int));
          } else {
            final initialData = _parseAadharDataForForm(fullText);
            _navigateTo(AddMemberPage(
              familyId: -1,
              initialData: initialData,
            ));
          }
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Could not find an Aadhaar number in the photo.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      }
    }
  }

  Map<String, dynamic> _parseAadharDataForForm(String text) {
    final data = <String, dynamic>{};
    final aadharRegex = RegExp(r'(\d{4}[\s-]?\d{4}[\s-]?\d{4})');
    final aadharMatch = aadharRegex.firstMatch(text);
    if (aadharMatch != null) {
      data['aadharNumber'] =
          aadharMatch.group(0)!.replaceAll(RegExp(r'[\s-]'), '');
    }

    if (text.toLowerCase().contains('female')) {
      data['gender'] = 'Female';
    } else if (text.toLowerCase().contains('male')) {
      data['gender'] = 'Male';
    }

    final dobRegex = RegExp(r'(DOB|Birth)[:\s]*(\d{2}/\d{2}/\d{4}|\d{4})');
    final dobMatch = dobRegex.firstMatch(text);
    if (dobMatch != null) {
      final dobString = dobMatch.group(2)!;
      data['dateOfBirth'] = dobString;
      int year;
      if (dobString.length == 4) {
        year = int.parse(dobString);
      } else {
        year = int.parse(dobString.split('/').last);
      }
      final currentYear = DateTime.now().year;
      if (year > 1900 && year <= currentYear) {
        data['age'] = (currentYear - year).toString();
      }
    }

    final lines = text.split('\n');
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains(RegExp(r'DOB|Year of Birth|Address'))) {
        if (i > 0) {
          final potentialName = lines[i - 1];
          if (RegExp(r'[a-zA-Z]{3,}').hasMatch(potentialName) &&
              !potentialName.toLowerCase().contains('india')) {
            data['name'] = potentialName;
            break;
          }
        }
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final double topPadding =
        MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildGlassAppBar(theme, isDark, l10n),
      floatingActionButton:
          _isLoading ? null : _buildFloatingCopilot(theme, l10n),
      body: Stack(
        children: [
          _buildBackgroundDecorations(theme),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadDashboardData,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: topPadding + 20, left: 20, right: 20, bottom: 20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSmartBanner(theme, l10n),
                        const SizedBox(height: 32),
                        _buildMainDashboard(l10n),
                        const SizedBox(height: 32),
                        _buildSectionTitle(theme, l10n.weeklyAnalytics),
                        const SizedBox(height: 16),
                        const SizedBox(height: 32),
                        _buildMotivationalQuote(theme),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildGlassAppBar(
      ThemeData theme, bool isDark, AppLocalizations l10n) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              l10n.appTitle,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            backgroundColor: isDark
                ? Colors.black.withOpacity(0.5)
                : Colors.white.withOpacity(0.5),
            elevation: 0,
            actions: [
              _buildSyncStatusIcon(l10n),
              IconButton(
                icon: Icon(_speechEnabled ? Icons.mic : Icons.mic_off),
                onPressed: _speechEnabled ? _startListening : null,
                tooltip: 'Voice Commands',
              ),
              IconButton(
                icon: Icon(isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded),
                onPressed: () {
                  widget.changeTheme(isDark ? ThemeMode.light : ThemeMode.dark);
                },
              ),
              IconButton(
                icon: Icon(Icons.sos_rounded, color: theme.colorScheme.error),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.sosAlert)),
                  );
                },
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () =>
                    _navigateTo(ProfilePage(changeTheme: widget.changeTheme)),
                child: const Hero(
                  tag: 'profile_avatar',
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        AssetImage('assets/images/asha_placeholder.png'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusIcon(AppLocalizations l10n) {
    return ValueListenableBuilder<SyncStatus>(
      valueListenable: SyncService.instance.syncStatus,
      builder: (context, status, child) {
        Widget icon;
        String tooltip;
        switch (status) {
          case SyncStatus.syncing:
            icon = RotationTransition(
                turns: _syncAnimationController,
                child: const Icon(Icons.sync_rounded));
            tooltip = 'Syncing...';
            break;
          case SyncStatus.synced:
            icon = const Icon(Icons.cloud_done_rounded, color: Colors.green);
            tooltip = 'Data Synced';
            break;
          case SyncStatus.offline:
            icon = const Icon(Icons.cloud_off_rounded);
            tooltip = 'Offline';
            break;
          case SyncStatus.error:
            icon = const Icon(Icons.error_outline_rounded, color: Colors.red);
            tooltip = 'Sync Error';
            break;
        }
        return IconButton(
          icon: icon,
          tooltip: tooltip,
          onPressed: () {
            SyncService.instance.startSync();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(l10n.syncingNow),
                  duration: const Duration(seconds: 2)),
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingCopilot(ThemeData theme, AppLocalizations l10n) {
    return FloatingActionButton.extended(
      onPressed: () => _navigateTo(const CopilotPage()),
      label: Text(l10n.aiCopilot,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      icon: const Icon(Icons.support_agent_rounded),
    );
  }

  Widget _buildBackgroundDecorations(ThemeData theme) {
    return const SizedBox.shrink();
  }

  Widget _buildSmartBanner(ThemeData theme, AppLocalizations l10n) {
    return const SizedBox.shrink();
  }

  Widget _buildMainDashboard(AppLocalizations l10n) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _DashboardCard(
            title: l10n.aiHealthCopilot,
            icon: Icons.support_agent_rounded,
            color: Theme.of(context).colorScheme.primaryContainer,
            onTap: () => _navigateTo(const CopilotPage()),
            index: 0,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _DashboardCard(
            title: l10n.myTasks,
            icon: Icons.checklist_rtl_rounded,
            color: Theme.of(context).colorScheme.tertiaryContainer,
            onTap: () => _navigateTo(const TasksPage()),
            index: 1,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _DashboardCard(
            title: l10n.scanAadhar,
            icon: Icons.camera_alt_outlined,
            color: Theme.of(context).colorScheme.secondaryContainer,
            onTap: _handleAadhaarScanAndOCR,
            index: 2,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _DashboardCard(
            title: l10n.myMissions,
            icon: Icons.emoji_events_rounded,
            color: Theme.of(context).colorScheme.errorContainer,
            onTap: () => _navigateTo(const MissionsPage()),
            index: 3,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: _DashboardCard(
            title: l10n.nationalHealthPrograms,
            icon: Icons.local_hospital_outlined,
            color: Colors.teal.shade100,
            onTap: () => _navigateTo(const NationalHealthProgramsPage()),
            index: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style:
          theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
    );
  }

  Widget _buildMotivationalQuote(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.3),
            theme.colorScheme.secondaryContainer.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _currentQuote,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleMedium?.copyWith(
            fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int index;

  const _DashboardCard(
      {required this.title,
      required this.icon,
      required this.color,
      required this.onTap,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon,
                      size: 32, color: theme.colorScheme.onPrimaryContainer)),
              const Spacer(),
              Text(title,
                  style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (index * 80).ms, duration: 400.ms)
        .scale(begin: const Offset(0.95, 0.95));
  }
}
