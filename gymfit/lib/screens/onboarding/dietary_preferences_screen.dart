import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../member/main_screen.dart';

class DietaryPreferencesScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final User? existingUser;

  const DietaryPreferencesScreen({
    Key? key,
    required this.userData,
    this.existingUser,
  }) : super(key: key);

  @override
  State<DietaryPreferencesScreen> createState() => _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends State<DietaryPreferencesScreen> {
  String? _selectedDietaryPreference;
  final List<String> _selectedAllergies = [];
  final List<String> _selectedHealthConditions = [];

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing data if available
    if (widget.existingUser != null) {
      _selectedDietaryPreference = widget.existingUser!.dietaryPreference;
      if (widget.existingUser!.foodAllergies != null) {
        _selectedAllergies.addAll(widget.existingUser!.foodAllergies!);
      }
      if (widget.existingUser!.healthConditions != null) {
        _selectedHealthConditions.addAll(widget.existingUser!.healthConditions!);
      }
    }
  }

  final List<Map<String, dynamic>> _dietaryOptions = [
    {
      'id': 'VEGETARIAN',
      'title': 'Vegetarian',
      'icon': Icons.eco,
      'description': 'No meat or fish',
    },
    {
      'id': 'NON_VEGETARIAN',
      'title': 'Non-Vegetarian',
      'icon': Icons.restaurant,
      'description': 'All food types',
    },
    {
      'id': 'VEGAN',
      'title': 'Vegan',
      'icon': Icons.spa,
      'description': 'No animal products',
    },
    {
      'id': 'PESCATARIAN',
      'title': 'Pescatarian',
      'icon': Icons.set_meal,
      'description': 'Fish but no meat',
    },
  ];

  final List<String> _allergyOptions = [
    'Dairy',
    'Eggs',
    'Nuts',
    'Soy',
    'Gluten',
    'Shellfish',
    'None',
  ];

  final List<String> _healthConditionOptions = [
    'Diabetes',
    'High Blood Pressure',
    'Heart Disease',
    'Asthma',
    'Joint Problems',
    'None',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietary Preferences'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your dietary preferences',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Help us create your perfect meal plan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Dietary Preference
            const Text(
              'Diet Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: _dietaryOptions.length,
              itemBuilder: (context, index) {
                final option = _dietaryOptions[index];
                return _buildDietCard(
                  option['id'],
                  option['title'],
                  option['icon'],
                  option['description'],
                );
              },
            ),
            const SizedBox(height: 24),
            
            // Food Allergies
            const Text(
              'Food Allergies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allergyOptions.map((allergy) {
                final isSelected = _selectedAllergies.contains(allergy);
                return FilterChip(
                  label: Text(allergy),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (allergy == 'None') {
                        _selectedAllergies.clear();
                        if (selected) {
                          _selectedAllergies.add(allergy);
                        }
                      } else {
                        _selectedAllergies.remove('None');
                        if (selected) {
                          _selectedAllergies.add(allergy);
                        } else {
                          _selectedAllergies.remove(allergy);
                        }
                      }
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  checkmarkColor: Theme.of(context).primaryColor,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Health Conditions
            const Text(
              'Health Conditions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _healthConditionOptions.map((condition) {
                final isSelected = _selectedHealthConditions.contains(condition);
                return FilterChip(
                  label: Text(condition),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (condition == 'None') {
                        _selectedHealthConditions.clear();
                        if (selected) {
                          _selectedHealthConditions.add(condition);
                        }
                      } else {
                        _selectedHealthConditions.remove('None');
                        if (selected) {
                          _selectedHealthConditions.add(condition);
                        } else {
                          _selectedHealthConditions.remove(condition);
                        }
                      }
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  checkmarkColor: Theme.of(context).primaryColor,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            
            // Finish Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleFinish,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Complete Setup',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietCard(String id, String title, IconData icon, String description) {
    final isSelected = _selectedDietaryPreference == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDietaryPreference = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFinish() async {
    if (_selectedDietaryPreference == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a dietary preference')),
      );
      return;
    }

    final completeUserData = {
      ...widget.userData,
      'dietaryPreference': _selectedDietaryPreference,
      'foodAllergies': _selectedAllergies.where((a) => a != 'None').toList(),
      'healthConditions': _selectedHealthConditions.where((c) => c != 'None').toList(),
      'hasCompletedOnboarding': true,
    };

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Save user data
    final success = await authProvider.updateUserProfile(completeUserData);

    if (context.mounted) {
      Navigator.of(context).pop(); // Close loading
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile completed! Your personalized plan is ready.'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
