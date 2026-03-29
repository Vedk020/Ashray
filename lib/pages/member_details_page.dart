import 'package:ashray/pages/add_edit_record_page.dart';
import 'package:ashray/pages/edit_member_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../database_helper.dart';
import 'package:intl/intl.dart';

class MemberDetailsPage extends StatefulWidget {
  final int memberId;
  const MemberDetailsPage({super.key, required this.memberId});

  @override
  State<MemberDetailsPage> createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, dynamic>? _member;
  bool _isLoading = true;
  List<String> _tabs = [];

  Map<String, List<Map<String, dynamic>>> _healthData = {};

  @override
  void initState() {
    super.initState();
    _loadMemberData();
  }

  Future<void> _loadMemberData() async {
    setState(() => _isLoading = true);
    final memberData = await DatabaseHelper.instance.getMember(widget.memberId);

    if (memberData == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final isFemale = memberData['gender'] == 'Female';
    _tabs = [
      'Basic Details',
      'Medical History',
      if (isFemale) 'Maternal Care',
      if (isFemale) 'Women\'s Health',
      'Visits',
    ];

    _healthData = {for (var tab in _tabs) tab: []};

    _healthData['Medical History'] = await DatabaseHelper.instance
        .getHealthRecords('medical_history', widget.memberId);
    _healthData['Visits'] = await DatabaseHelper.instance
        .getHealthRecords('visits', widget.memberId);
    if (isFemale) {
      _healthData['Maternal Care'] = await DatabaseHelper.instance
          .getHealthRecords('maternal_care', widget.memberId);
      _healthData['Women\'s Health'] = await DatabaseHelper.instance
          .getHealthRecords('womens_health', widget.memberId);
    }

    _tabController?.dispose();
    _tabController = TabController(length: _tabs.length, vsync: this);

    if (mounted) {
      setState(() {
        _member = memberData;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final familyId = _member?['familyId'];
    if (familyId == null) return;

    final loginController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'Please enter the family credentials to delete this member.'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: loginController,
                  decoration:
                      const InputDecoration(labelText: 'Family Login ID'),
                  validator: (value) =>
                      value!.isEmpty ? 'Cannot be empty' : null,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Cannot be empty' : null,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FilledButton(
              child: const Text('Delete'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final isValid =
                      await DatabaseHelper.instance.verifyFamilyCredentials(
                    familyId,
                    loginController.text,
                    passwordController.text,
                  );

                  if (isValid && mounted) {
                    await DatabaseHelper.instance.deleteMember(widget.memberId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Member deleted successfully')),
                    );
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back from details page
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Error: Invalid credentials')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showScheduleVisitDialog() async {
    final familyId = _member?['familyId'];
    if (familyId == null) return;

    final descriptionController = TextEditingController();
    DateTime? selectedDate;
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Schedule New Visit'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          labelText: 'Visit Purpose / Notes'),
                      validator: (value) =>
                          value!.isEmpty ? 'Cannot be empty' : null,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today),
                      title: Text(selectedDate == null
                          ? 'Select Due Date'
                          : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null) {
                          setDialogState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FilledButton(
                  child: const Text('Schedule'),
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        selectedDate != null) {
                      await DatabaseHelper.instance.insertTask({
                        'familyId': familyId,
                        'type': 'Scheduled Visit',
                        'description': descriptionController.text,
                        'dueDate':
                            DateFormat('yyyy-MM-dd').format(selectedDate!),
                        'completed': 0,
                        'synced': 0,
                      });

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Visit scheduled successfully!')),
                        );
                        Navigator.of(context).pop();
                      }
                    } else if (selectedDate == null && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select a due date.')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final double topPadding =
        MediaQuery.of(context).padding.top + kToolbarHeight + 48;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 48),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              title: Text(
                _member?['name'] ?? 'Member Details',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              backgroundColor: isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.calendar_month_outlined),
                  tooltip: 'Schedule Visit',
                  onPressed: _isLoading ? null : _showScheduleVisitDialog,
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: theme.colorScheme.error),
                  tooltip: 'Delete Member',
                  onPressed: _isLoading ? null : _showDeleteConfirmationDialog,
                ),
              ],
              bottom: _isLoading
                  ? null
                  : TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: _tabs.map((title) => Tab(text: title)).toList(),
                    ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _member == null
              ? const Center(child: Text('Member not found.'))
              : Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabs.map((title) {
                      return _HealthRecordTab(
                        member: _member!,
                        title: title,
                        records: _healthData[title]!,
                        onAdd: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditRecordPage(
                                memberId: widget.memberId,
                                recordType: title,
                              ),
                            ),
                          );
                          _loadMemberData();
                        },
                        onEdit: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditMemberPage(memberId: widget.memberId),
                              ));
                          _loadMemberData();
                        },
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}

class _HealthRecordTab extends StatelessWidget {
  final Map<String, dynamic> member;
  final String title;
  final List<Map<String, dynamic>> records;
  final VoidCallback onAdd;
  final VoidCallback onEdit;

  const _HealthRecordTab({
    required this.member,
    required this.title,
    required this.records,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
        children: [
          if (title == 'Basic Details')
            _buildInfoCard(context, {
              'Name': member['name'],
              'Age': member['age']?.toString(),
              'Gender': member['gender'],
              'Date of Birth': member['dateOfBirth'],
              'Weight (kg)': member['weight']?.toString(),
              'Height (cm)': member['height']?.toString(),
              'Blood Group': member['bloodGroup'],
              'Allergies': member['allergies'],
              'BMI': member['bmi']?.toStringAsFixed(2),
            }),
          if (title != 'Basic Details')
            if (records.isEmpty)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No records found for this category.'),
              ))
            else
              ...records.map((record) {
                final displayRecord = Map<String, String?>.fromEntries(record
                    .entries
                    .where((e) => ![
                          'id',
                          'memberId',
                          'synced',
                          'serverId',
                          'timestamp',
                          'memberServerId'
                        ].contains(e.key))
                    .map((e) => MapEntry(e.key, e.value?.toString())));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildInfoCard(context, displayRecord),
                );
              }).toList(),
        ],
      ),
      floatingActionButton: title == 'Basic Details'
          ? FloatingActionButton.extended(
              onPressed: onEdit,
              label: const Text('Edit Details'),
              icon: const Icon(Icons.edit_rounded),
            )
          : FloatingActionButton.extended(
              onPressed: onAdd,
              label: Text('Add $title Record'),
              icon: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildInfoCard(BuildContext context, Map<String, String?> data) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: data.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key
                        .replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'),
                            (match) => ' ${match.group(0)}')
                        .replaceFirstMapped(RegExp(r'^[a-z]'),
                            (m) => m.group(0)!.toUpperCase()),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value ?? 'N/A',
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
