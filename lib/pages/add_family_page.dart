import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../database_helper.dart';

class AddFamilyPage extends StatefulWidget {
  const AddFamilyPage({super.key});

  @override
  State<AddFamilyPage> createState() => _AddFamilyPageState();
}

class _AddFamilyPageState extends State<AddFamilyPage> {
  final _formKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _villageController = TextEditingController();
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _familyNameController.dispose();
    _villageController.dispose();
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveFamily() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.insertFamily({
        'name': _familyNameController.text,
        'village': _villageController.text,
        'loginId': _loginIdController.text,
        'password': _passwordController.text,
        'synced': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Family saved successfully!'),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              title: const Text('Register New Family',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              backgroundColor: isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              elevation: 0,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveFamily,
        label: const Text('Save Family',
            style: TextStyle(fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.save_rounded),
      ).animate().fadeIn(delay: 400.ms).scale(delay: 400.ms),
      body: Stack(
        children: [
          _buildBackground(theme),
          Form(
            key: _formKey,
            child: ListView(
              padding:
                  const EdgeInsets.fromLTRB(20, kToolbarHeight + 60, 20, 100),
              children: [
                _buildGlassTextField(
                  controller: _familyNameController,
                  label: 'Family Name',
                  icon: Icons.family_restroom_rounded,
                  theme: theme,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter a family name'
                      : null,
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                const SizedBox(height: 20),
                _buildGlassTextField(
                  controller: _villageController,
                  label: 'Village',
                  icon: Icons.location_on_rounded,
                  theme: theme,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter a village name'
                      : null,
                )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 400.ms)
                    .slideX(begin: -0.2),
                const SizedBox(height: 20),
                _buildGlassTextField(
                  controller: _loginIdController,
                  label: 'Family Login ID',
                  icon: Icons.person_pin_rounded,
                  theme: theme,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please set a Login ID' : null,
                )
                    .animate()
                    .fadeIn(delay: 150.ms, duration: 400.ms)
                    .slideX(begin: -0.2),
                const SizedBox(height: 20),
                _buildGlassTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.password_rounded,
                  theme: theme,
                  isPassword: true,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please set a password' : null,
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideX(begin: -0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(ThemeData theme) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              theme.colorScheme.primary.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ThemeData theme,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: theme.colorScheme.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }
}
