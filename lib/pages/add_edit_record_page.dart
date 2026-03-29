import 'package:flutter/material.dart';
import '../database_helper.dart';

class AddEditRecordPage extends StatefulWidget {
  final int memberId;
  final String recordType;
  final Map<String, dynamic>? initialData;

  const AddEditRecordPage({
    super.key,
    required this.memberId,
    required this.recordType,
    this.initialData,
  });

  @override
  State<AddEditRecordPage> createState() => _AddEditRecordPageState();
}

class _AddEditRecordPageState extends State<AddEditRecordPage> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, List<String>> _fields;

  @override
  void initState() {
    super.initState();
    _fields = _getFieldsForRecordType();
    _controllers = {
      for (var field in _fields.keys)
        field: TextEditingController(
            text: widget.initialData?[field]?.toString() ?? '')
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, List<String>> _getFieldsForRecordType() {
    switch (widget.recordType) {
      case 'Medical History':
        return {'condition': [], 'notes': []};
      case 'Maternal Care':
        return {
          'visitType': ['ANC', 'PNC'],
          'visitDate': [],
          'notes': []
        };
      case 'Women\'s Health':
        return {'method': [], 'details': []};
      case 'Visits':
        return {'visitDate': [], 'notes': []};
      default:
        return {};
    }
  }

  String _getTableName() {
    return widget.recordType.replaceAll(' ', '_').toLowerCase();
  }

  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'memberId': widget.memberId,
        'synced': 0,
        for (var entry in _controllers.entries) entry.key: entry.value.text,
      };

      if (widget.initialData != null) {
        data['id'] = widget.initialData!['id'];
        await DatabaseHelper.instance.updateHealthRecord(_getTableName(), data);
      } else {
        await DatabaseHelper.instance.insertHealthRecord(_getTableName(), data);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.initialData != null ? 'Edit' : 'Add'} ${widget.recordType}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ..._fields.entries.map((entry) {
              final fieldName = entry.key;
              final dropdownItems = entry.value;
              final controller = _controllers[fieldName]!;

              if (dropdownItems.isNotEmpty) {
                return DropdownButtonFormField<String>(
                  value: controller.text.isEmpty ? null : controller.text,
                  items: dropdownItems
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) => controller.text = value ?? '',
                  decoration: InputDecoration(
                    labelText: fieldName
                        .replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'),
                            (match) => ' ${match.group(0)}')
                        .capitalize(),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select an option'
                      : null,
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: fieldName
                          .replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'),
                              (match) => ' ${match.group(0)}')
                          .capitalize(),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'This field cannot be empty' : null,
                  ),
                );
              }
            }).toList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveRecord,
              child: const Text('Save Record'),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
