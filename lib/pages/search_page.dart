import 'package:ashray/pages/add_family_page.dart';
import 'package:ashray/pages/family_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../database_helper.dart';
import '../l10n/app_localizations.dart';

enum SearchState { villages, families }

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchState _searchState = SearchState.villages;
  String? _selectedVillage;

  List<String> _villages = [];
  List<String> _filteredVillages = [];
  List<Map<String, dynamic>> _families = [];
  List<Map<String, dynamic>> _filteredFamilies = [];

  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVillages();
    _searchController.addListener(_filterLists);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVillages() async {
    setState(() => _isLoading = true);
    final villages = await DatabaseHelper.instance.getVillages();
    if (mounted) {
      setState(() {
        _villages = villages;
        _filteredVillages = villages;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFamilies(String village) async {
    setState(() => _isLoading = true);
    final families =
        await DatabaseHelper.instance.getFamiliesByVillage(village, '');
    if (mounted) {
      setState(() {
        _families = families;
        _filteredFamilies = families;
        _selectedVillage = village;
        _searchState = SearchState.families;
        _searchController.clear();
        _isLoading = false;
      });
    }
  }

  void _filterLists() {
    final query = _searchController.text.toLowerCase();
    if (_searchState == SearchState.villages) {
      setState(() {
        _filteredVillages =
            _villages.where((v) => v.toLowerCase().contains(query)).toList();
      });
    } else {
      setState(() {
        _filteredFamilies = _families
            .where((f) => f['name'].toString().toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final double topPadding =
        MediaQuery.of(context).padding.top + kToolbarHeight + 70;

    return WillPopScope(
      onWillPop: () async {
        if (_searchState == SearchState.families) {
          setState(() {
            _searchState = SearchState.villages;
            _selectedVillage = null;
            _searchController.clear();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 70),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: AppBar(
                title: Text(
                  _searchState == SearchState.villages
                      ? l10n.selectVillage
                      : _selectedVillage ?? l10n.selectFamily,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                backgroundColor: isDark
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white.withOpacity(0.5),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.group_add_outlined),
                    tooltip: 'Add New Family',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddFamilyPage(),
                        ),
                      ).then((_) {
                        if (_searchState == SearchState.villages) {
                          _loadVillages();
                        } else if (_selectedVillage != null) {
                          _loadFamilies(_selectedVillage!);
                        }
                      });
                    },
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(70.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.search,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _searchState == SearchState.villages
                ? _buildVillageList(topPadding)
                : _buildFamilyList(topPadding),
      ),
    );
  }

  Widget _buildVillageList(double topPadding) {
    if (_filteredVillages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No villages found.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddFamilyPage()))
                      .then((_) => _loadVillages());
                },
                child: const Text('Add a Family to get started'),
              )
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: topPadding, bottom: 16),
      itemCount: _filteredVillages.length,
      itemBuilder: (context, index) {
        final village = _filteredVillages[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.holiday_village_rounded),
            title: Text(village,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _loadFamilies(village),
          ),
        ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: -0.1);
      },
    );
  }

  Widget _buildFamilyList(double topPadding) {
    if (_filteredFamilies.isEmpty) {
      return const Center(child: Text('No families found in this village.'));
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: topPadding, bottom: 16),
      itemCount: _filteredFamilies.length,
      itemBuilder: (context, index) {
        final family = _filteredFamilies[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.home_work_rounded),
            title: Text(family['name'].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FamilyDetailsPage(familyId: family['id'] as int),
                ),
              );
            },
          ),
        ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: -0.1);
      },
    );
  }
}
