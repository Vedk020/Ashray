import 'package:flutter/material.dart';
import '../database_helper.dart';

class EditMemberPage extends StatefulWidget {
  final int memberId;
  const EditMemberPage({super.key, required this.memberId});

  @override
  State<EditMemberPage> createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
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
    _loadMemberData();
  }

  Future<void> _loadMemberData() async {
    final data = await DatabaseHelper.instance.getMember(widget.memberId);
    if (data != null && mounted) {
      setState(() {
        _nameController.text = data['name'] ?? '';
        _ageController.text = data['age']?.toString() ?? '';
        _phoneController.text = data['phoneNumber'] ?? '';
        _dobController.text = data['dateOfBirth'] ?? '';
        _weightController.text = data['weight']?.toString() ?? '';
        _heightController.text = data['height']?.toString() ?? '';
        _bloodGroupController.text = data['bloodGroup'] ?? '';
        _allergiesController.text = data['allergies'] ?? '';
        _selectedGender = data['gender'];
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final db = DatabaseHelper.instance;
      final weight = double.tryParse(_weightController.text);
      final height = double.tryParse(_heightController.text);
      double? bmi;
      if (weight != null && height != null && height > 0) {
        bmi = weight / ((height / 100) * (height / 100));
      }

      await db.updateMember({
        'id': widget.memberId,
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text),
        'gender': _selectedGender,
        'phoneNumber': _phoneController.text,
        'dateOfBirth': _dobController.text,
        'weight': weight,
        'height': height,
        'bmi': bmi,
        'bloodGroup': _bloodGroupController.text,
        'allergies': _allergiesController.text,
      });

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Member Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildTextField(_nameController, 'Full Name', Icons.person),
                  _buildTextField(_phoneController, 'Phone Number', Icons.phone,
                      keyboardType: TextInputType.phone),
                  _buildTextField(_ageController, 'Age', Icons.cake,
                      keyboardType: TextInputType.number),
                  _buildGenderDropdown(),
                  _buildTextField(_dobController, 'Date of Birth (YYYY-MM-DD)',
                      Icons.calendar_today),
                  _buildTextField(
                      _weightController, 'Weight (kg)', Icons.monitor_weight,
                      keyboardType: TextInputType.number),
                  _buildTextField(
                      _heightController, 'Height (cm)', Icons.height,
                      keyboardType: TextInputType.number),
                  _buildTextField(
                      _bloodGroupController, 'Blood Group', Icons.bloodtype),
                  _buildTextField(_allergiesController, 'Allergies',
                      Icons.medical_services),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _saveChanges,
                    icon: const Icon(Icons.save_as_rounded),
                    label: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
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
          if (label == 'Full Name' && (value == null || value.isEmpty)) {
            return 'Please enter a name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: const InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.wc),
        ),
        items: ['Male', 'Female', 'Other']
            .map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
        validator: (value) => value == null ? 'Please select a gender' : null,
      ),
    );
  }
}
