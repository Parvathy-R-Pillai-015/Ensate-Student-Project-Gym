import 'package:flutter/material.dart';
import 'dietary_preferences_screen.dart';
import '../../models/user.dart';

class FitnessGoalsScreen extends StatefulWidget {
  final Map<String, dynamic> personalData;
  final User? existingUser;

  const FitnessGoalsScreen({
    Key? key,
    required this.personalData,
    this.existingUser,
  }) : super(key: key);

  @override
  State<FitnessGoalsScreen> createState() => _FitnessGoalsScreenState();
}

class _FitnessGoalsScreenState extends State<FitnessGoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetWeightController = TextEditingController();
  final _targetDaysController = TextEditingController();
  
  String? _selectedGoal;
  String? _selectedActivityLevel;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing data if available
    if (widget.existingUser != null) {
      _selectedGoal = widget.existingUser!.fitnessGoal;
      _targetWeightController.text = widget.existingUser!.targetWeight?.toString() ?? '';
      _targetDaysController.text = widget.existingUser!.targetDays?.toString() ?? '';
      _selectedActivityLevel = widget.existingUser!.activityLevel;
    }
  }

  final List<Map<String, dynamic>> _fitnessGoals = [
    {
      'id': 'WEIGHT_LOSS',
      'title': 'Weight Loss',
      'icon': Icons.trending_down,
      'description': 'Lose weight and burn fat',
    },
    {
      'id': 'WEIGHT_GAIN',
      'title': 'Weight Gain',
      'icon': Icons.trending_up,
      'description': 'Gain healthy weight',
    },
    {
      'id': 'MUSCLE_BUILDING',
      'title': 'Muscle Building',
      'icon': Icons.fitness_center,
      'description': 'Build muscle mass',
    },
    {
      'id': 'GENERAL_FITNESS',
      'title': 'General Fitness',
      'icon': Icons.favorite,
      'description': 'Stay fit and healthy',
    },
    {
      'id': 'ENDURANCE',
      'title': 'Endurance',
      'icon': Icons.directions_run,
      'description': 'Improve stamina',
    },
  ];

  final List<Map<String, String>> _activityLevels = [
    {
      'id': 'SEDENTARY',
      'title': 'Sedentary',
      'description': 'Little or no exercise',
    },
    {
      'id': 'LIGHTLY_ACTIVE',
      'title': 'Lightly Active',
      'description': 'Exercise 1-3 days/week',
    },
    {
      'id': 'MODERATELY_ACTIVE',
      'title': 'Moderately Active',
      'description': 'Exercise 3-5 days/week',
    },
    {
      'id': 'VERY_ACTIVE',
      'title': 'Very Active',
      'description': 'Exercise 6-7 days/week',
    },
    {
      'id': 'EXTREMELY_ACTIVE',
      'title': 'Extremely Active',
      'description': 'Physical job + exercise',
    },
  ];

  @override
  void dispose() {
    _targetWeightController.dispose();
    _targetDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Goals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What\'s your fitness goal?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your primary objective',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              
              // Fitness Goals Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: _fitnessGoals.length,
                itemBuilder: (context, index) {
                  final goal = _fitnessGoals[index];
                  return _buildGoalCard(
                    goal['id'],
                    goal['title'],
                    goal['icon'],
                    goal['description'],
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // Target Weight
              TextFormField(
                controller: _targetWeightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Target Weight (kg)',
                  hintText: 'Your goal weight',
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your target weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 30 || weight > 300) {
                    return 'Please enter a valid weight (30-300 kg)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Target Timeline
              TextFormField(
                controller: _targetDaysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Target Timeline (days)',
                  hintText: 'Days to reach your goal',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target timeline';
                  }
                  final days = int.tryParse(value);
                  if (days == null || days < 7 || days > 365) {
                    return 'Please enter 7-365 days';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Activity Level
              const Text(
                'Activity Level',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ..._activityLevels.map((level) => _buildActivityLevelTile(
                level['id']!,
                level['title']!,
                level['description']!,
              )),
              const SizedBox(height: 32),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
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
      ),
    );
  }

  Widget _buildGoalCard(String id, String title, IconData icon, String description) {
    final isSelected = _selectedGoal == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = id;
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

  Widget _buildActivityLevelTile(String id, String title, String description) {
    final isSelected = _selectedActivityLevel == id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RadioListTile<String>(
        value: id,
        groupValue: _selectedActivityLevel,
        onChanged: (value) {
          setState(() {
            _selectedActivityLevel = value;
          });
        },
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(description),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey[100],
      ),
    );
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate() && 
        _selectedGoal != null && 
        _selectedActivityLevel != null) {
      final fitnessData = {
        ...widget.personalData,
        'fitnessGoal': _selectedGoal,
        'targetWeight': double.parse(_targetWeightController.text),
        'targetDays': int.parse(_targetDaysController.text),
        'activityLevel': _selectedActivityLevel,
      };
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DietaryPreferencesScreen(
            userData: fitnessData,
            existingUser: widget.existingUser,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }
}
