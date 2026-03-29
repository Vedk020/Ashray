import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class AddMemberPage extends StatefulWidget {
  final int familyId;
  final Map<String, dynamic>? initialData;

  const AddMemberPage({
    super.key,
    required this.familyId,
    this.initialData,
  });

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  int? _selectedFamilyId;
  List<Map<String, dynamic>> _families = [];

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _aadharController = TextEditingController();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedFamilyId = widget.familyId != -1 ? widget.familyId : null;
    _loadFamilies();

    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _ageController.text = widget.initialData!['age'] ?? '';
      _aadharController.text = widget.initialData!['aadharNumber'] ?? '';
      _dobController.text = widget.initialData!['dateOfBirth'] ?? '';
      _selectedGender = widget.initialData!['gender'];
    }
  }

  Future<void> _loadFamilies() async {
    final db = await DatabaseHelper.instance.database;
    final families = await db.query('families');
    if (mounted) {
      setState(() {
        _families = families;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _aadharController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _scanAndOcrAadhaar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;
    setState(() => _isProcessing = true);

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      textRecognizer.close();
      _parseAadharData(recognizedText.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _parseAadharData(String text) {
    final lines = text.split('\n');
    final aadharRegex = RegExp(r'(\d{4}[\s-]?\d{4}[\s-]?\d{4})');
    final aadharMatch = aadharRegex.firstMatch(text);
    if (aadharMatch != null) {
      _aadharController.text =
          aadharMatch.group(0)!.replaceAll(RegExp(r'[\s-]'), '');
    }

    if (text.toLowerCase().contains('female')) {
      _selectedGender = 'Female';
    } else if (text.toLowerCase().contains('male')) {
      _selectedGender = 'Male';
    }

    final dobRegex = RegExp(r'(DOB|Birth)[:\s]*(\d{2}/\d{2}/\d{4}|\d{4})');
    final dobMatch = dobRegex.firstMatch(text);
    if (dobMatch != null) {
      final dobString = dobMatch.group(2)!;
      _dobController.text = dobString;
      int year;
      if (dobString.length == 4) {
        year = int.parse(dobString);
      } else {
        year = int.parse(dobString.split('/').last);
      }
      final currentYear = DateTime.now().year;
      if (year > 1900 && year <= currentYear) {
        _ageController.text = (currentYear - year).toString();
      }
    }

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains(RegExp(r'DOB|Year of Birth|Address'))) {
        if (i > 0) {
          final potentialName = lines[i - 1];
          if (RegExp(r'[a-zA-Z]{3,}').hasMatch(potentialName) &&
              !potentialName.toLowerCase().contains('india')) {
            _nameController.text = potentialName;
            break;
          }
        }
      }
    }
    setState(() {});
  }

  Future<void> _saveMember() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFamilyId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select a family for this member.')),
        );
        return;
      }

      final weight = double.tryParse(_weightController.text);
      final height = double.tryParse(_heightController.text);
      double? bmi;
      if (weight != null && height != null && height > 0) {
        bmi = weight / ((height / 100) * (height / 100));
      }

      try {
        await DatabaseHelper.instance.insertMember({
          'familyId': _selectedFamilyId,
          'name': _nameController.text,
          'age': int.tryParse(_ageController.text),
          'gender': _selectedGender,
          'aadharNumber': _aadharController.text,
          'phoneNumber': _phoneController.text,
          'dateOfBirth': _dobController.text,
          'weight': weight,
          'height': height,
          'bmi': bmi,
          'bloodGroup': _bloodGroupController.text,
          'allergies': _allergiesController.text,
          'synced': 0,
        });

        if (mounted) {
          Navigator.pop(context);
        }
      } on DatabaseException catch (e) {
        if (mounted && e.isUniqueConstraintError()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Error: A member with this Aadhaar number already exists.')),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Database Error: $e')),
          );
        }
      }
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text,
      bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'This field cannot be empty';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Member'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _scanAndOcrAadhaar,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Aadhar to Auto-fill'),
            ),
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            const SizedBox(height: 16),
            if (widget.familyId == -1)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField<int>(
                  value: _selectedFamilyId,
                  decoration: const InputDecoration(
                    labelText: 'Select Family',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.group_add_outlined),
                  ),
                  items: _families
                      .map((family) => DropdownMenuItem(
                            value: family['id'] as int,
                            child: Text(family['name'].toString()),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedFamilyId = value),
                  validator: (value) =>
                      value == null ? 'Please select a family' : null,
                ),
              ),
            _buildTextField(_aadharController, 'Aadhar Number', Icons.badge,
                keyboardType: TextInputType.number, isRequired: true),
            _buildTextField(_nameController, 'Full Name', Icons.person,
                isRequired: true),
            _buildTextField(_phoneController, 'Phone Number', Icons.phone,
                keyboardType: TextInputType.phone),
            _buildTextField(_ageController, 'Age', Icons.cake,
                keyboardType: TextInputType.number),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((label) =>
                        DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
                validator: (value) =>
                    value == null ? 'Please select a gender' : null,
              ),
            ),
            _buildTextField(_dobController, 'Date of Birth (DD/MM/YYYY)',
                Icons.calendar_today),
            _buildTextField(
                _weightController, 'Weight (kg)', Icons.monitor_weight,
                keyboardType: TextInputType.number),
            _buildTextField(_heightController, 'Height (cm)', Icons.height,
                keyboardType: TextInputType.number),
            _buildTextField(
                _bloodGroupController, 'Blood Group', Icons.bloodtype),
            _buildTextField(
                _allergiesController, 'Allergies', Icons.medical_services),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveMember,
              icon: const Icon(Icons.save),
              label: const Text('Save Member'),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
            )
          ],
        ),
      ),
    );
  }
}
