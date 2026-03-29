import 'package:ashray/pages/add_member_page.dart';
import 'package:ashray/pages/member_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../database_helper.dart';
import '../l10n/app_localizations.dart';

class FamilyDetailsPage extends StatefulWidget {
  final int familyId;
  final bool isCitizenView;
  const FamilyDetailsPage(
      {super.key, required this.familyId, this.isCitizenView = false});

  @override
  State<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends State<FamilyDetailsPage> {
  Map<String, dynamic>? _family;
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
  }

  Future<void> _loadFamilyData() async {
    setState(() => _isLoading = true);
    final dbHelper = DatabaseHelper.instance;
    final familyData = await dbHelper.getFamily(widget.familyId);
    final membersData = await dbHelper.getMembers(widget.familyId);
    if (mounted) {
      setState(() {
        _family = familyData;
        _members = membersData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    final double topPadding =
        MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              title: Text(
                _family?['name'] ?? localizations.selectFamily,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              backgroundColor: isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              elevation: 0,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _members.isEmpty
                ? Center(child: Text('No members found in this family.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    itemCount: _members.length,
                    itemBuilder: (context, index) {
                      final member = _members[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            child:
                                Text(member['name'].toString().substring(0, 1)),
                          ),
                          title: Text(member['name'] as String,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Age: ${member['age'] ?? 'N/A'}, Gender: ${member['gender'] ?? 'N/A'}'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemberDetailsPage(
                                    memberId: member['id'] as int),
                              ),
                            ).then((_) => _loadFamilyData());
                          },
                        ),
                      ).animate().fadeIn(delay: (index * 100).ms).slideX();
                    },
                  ),
      ),
      floatingActionButton: widget.isCitizenView
          ? null // Hide the Add Member button for citizens
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddMemberPage(familyId: widget.familyId),
                  ),
                ).then((_) => _loadFamilyData());
              },
              label: const Text('Add Member'),
              icon: const Icon(Icons.add),
            ),
    );
  }
}
