import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopzy/utils/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _healthGoalsController = TextEditingController();
  final _healthConditionsController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _likesController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _healthGoalsController.text = prefs.getString('profile_healthGoals') ?? '';
      _healthConditionsController.text = prefs.getString('profile_healthConditions') ?? '';
      _weightController.text = prefs.getString('profile_weight') ?? '';
      _heightController.text = prefs.getString('profile_height') ?? '';
      _ageController.text = prefs.getString('profile_age') ?? '';
      _likesController.text = prefs.getString('profile_likes') ?? '';
      _additionalInfoController.text = prefs.getString('profile_additionalInfo') ?? '';
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_healthGoals', _healthGoalsController.text);
      await prefs.setString('profile_healthConditions', _healthConditionsController.text);
      await prefs.setString('profile_weight', _weightController.text);
      await prefs.setString('profile_height', _heightController.text);
      await prefs.setString('profile_age', _ageController.text);
      await prefs.setString('profile_likes', _likesController.text);
      await prefs.setString('profile_additionalInfo', _additionalInfoController.text);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _healthGoalsController.dispose();
    _healthConditionsController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _likesController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textCharcoal),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textCharcoal,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Help us personalize your experience with better recommendations.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 24),

                // Age, Weight, Height Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _ageController,
                        label: 'Age',
                        hint: 'e.g. 28',
                        keyboardType: TextInputType.number,
                        icon: Icons.cake_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _weightController,
                        label: 'Weight (kg)',
                        hint: 'e.g. 70',
                        keyboardType: TextInputType.number,
                        icon: Icons.monitor_weight_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _heightController,
                        label: 'Height (cm)',
                        hint: 'e.g. 175',
                        keyboardType: TextInputType.number,
                        icon: Icons.height_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _healthGoalsController,
                  label: 'Health Goals',
                  hint: 'e.g. Weight loss, Muscle gain, Eat healthier',
                  icon: Icons.flag_outlined,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _healthConditionsController,
                  label: 'Health Conditions / Allergies',
                  hint: 'e.g. Peanut allergy, Diabetes, None',
                  icon: Icons.medical_information_outlined,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _likesController,
                  label: 'Food Preferences & Likes',
                  hint: 'e.g. Vegan, Spicy food, Seafood',
                  icon: Icons.favorite_border_outlined,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _additionalInfoController,
                  label: 'Additional Information',
                  hint: 'Any other details you want us to know...',
                  icon: Icons.info_outline,
                  maxLines: 4,
                ),
                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textCharcoal,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.secondaryText.withOpacity(0.5),
              fontSize: 14,
            ),
            prefixIcon: maxLines == 1
                ? Icon(icon, color: AppColors.secondaryText, size: 20)
                : Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Icon(icon, color: AppColors.secondaryText, size: 20),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
