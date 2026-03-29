import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database_helper.dart';

class AddTaskPage extends StatefulWidget {
  final int familyId;
  final String familyName;

  const AddTaskPage(
      {super.key, required this.familyId, required this.familyName});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String? _selectedTaskType;
  DateTime? _selectedDueDate;

  final List<String> _taskTypes = [
    'ANC Visit',
    'PNC Visit',
    'Vaccination Check',
    'General Follow-up',
    'Nutritional Counseling'
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper.instance.insertTask({
        'familyId': widget.familyId,
        'type': _selectedTaskType,
        'dueDate': DateFormat('yyyy-MM-dd').format(_selectedDueDate!),
        'notes': _notesController.text,
        'completed': 0,
        'synced': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task scheduled successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Visit for ${widget.familyName}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DropdownButtonFormField<String>(
              value: _selectedTaskType,
              decoration: const InputDecoration(
                labelText: 'Task Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category_rounded),
              ),
              items: _taskTypes
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedTaskType = value);
              },
              validator: (value) =>
                  value == null ? 'Please select a task type' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Due Date',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.calendar_today_rounded),
                hintText: _selectedDueDate == null
                    ? 'Select a date'
                    : DateFormat.yMMMd().format(_selectedDueDate!),
              ),
              onTap: _pickDueDate,
              validator: (_) =>
                  _selectedDueDate == null ? 'Please select a due date' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Schedule Task'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
