import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';
import 'package:gymfit/models/nutrition.dart';
import 'package:intl/intl.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  DateTime _selectedDate = DateTime.now();
  int _waterIntake = 0; // in ml
  
  // Mock nutrition goal
  final NutritionGoal _goal = NutritionGoal(
    dailyCalories: 2000,
    dailyProtein: 150,
    dailyCarbs: 200,
    dailyFats: 60,
    dailyWater: 2000,
  );

  // Mock meals data
  final List<Meal> _meals = [
    Meal(
      id: 1,
      name: 'Oatmeal with Berries',
      type: 'BREAKFAST',
      calories: 350,
      protein: 12,
      carbs: 58,
      fats: 8,
      dateTime: DateTime.now(),
      notes: 'With honey and almonds',
    ),
    Meal(
      id: 2,
      name: 'Grilled Chicken Salad',
      type: 'LUNCH',
      calories: 450,
      protein: 45,
      carbs: 30,
      fats: 15,
      dateTime: DateTime.now(),
    ),
    Meal(
      id: 3,
      name: 'Protein Shake',
      type: 'SNACK',
      calories: 200,
      protein: 30,
      carbs: 15,
      fats: 3,
      dateTime: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _waterIntake = 1200; // Mock water intake
  }

  int get totalCalories => _meals.fold(0, (sum, meal) => sum + meal.calories);
  double get totalProtein => _meals.fold(0, (sum, meal) => sum + meal.protein);
  double get totalCarbs => _meals.fold(0, (sum, meal) => sum + meal.carbs);
  double get totalFats => _meals.fold(0, (sum, meal) => sum + meal.fats);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showGoalSettings(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date selector
            Container(
              padding: const EdgeInsets.all(16),
              color: ThemeConfig.primaryColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                      });
                    },
                  ),
                  Text(
                    DateFormat('EEEE, MMM d').format(_selectedDate),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      if (_selectedDate.isBefore(DateTime.now())) {
                        setState(() {
                          _selectedDate = _selectedDate.add(const Duration(days: 1));
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calorie Overview
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Daily Calories',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: CircularProgressIndicator(
                                  value: totalCalories / _goal.dailyCalories,
                                  strokeWidth: 12,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    totalCalories > _goal.dailyCalories
                                        ? ThemeConfig.errorColor
                                        : ThemeConfig.successColor,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    totalCalories.toString(),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'of ${_goal.dailyCalories}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    '${_goal.dailyCalories - totalCalories} left',
                                    style: TextStyle(
                                      color: totalCalories > _goal.dailyCalories
                                          ? ThemeConfig.errorColor
                                          : ThemeConfig.successColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Macros breakdown
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Macronutrients',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          _buildMacroBar('Protein', totalProtein, _goal.dailyProtein, ThemeConfig.primaryColor),
                          const SizedBox(height: 12),
                          _buildMacroBar('Carbs', totalCarbs, _goal.dailyCarbs, ThemeConfig.secondaryColor),
                          const SizedBox(height: 12),
                          _buildMacroBar('Fats', totalFats, _goal.dailyFats, ThemeConfig.accentColor),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Water intake
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Water Intake',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${_waterIntake}ml / ${_goal.dailyWater}ml',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: _waterIntake / _goal.dailyWater,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildWaterButton('250ml', 250),
                              _buildWaterButton('500ml', 500),
                              _buildWaterButton('1L', 1000),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Meals by type
                  _buildMealSection('Breakfast', 'BREAKFAST'),
                  const SizedBox(height: 16),
                  _buildMealSection('Lunch', 'LUNCH'),
                  const SizedBox(height: 16),
                  _buildMealSection('Dinner', 'DINNER'),
                  const SizedBox(height: 16),
                  _buildMealSection('Snacks', 'SNACK'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMealDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Log Meal'),
      ),
    );
  }

  Widget _buildMacroBar(String label, double current, double goal, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '${current.toStringAsFixed(0)}g / ${goal.toStringAsFixed(0)}g',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: current / goal,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildWaterButton(String label, int amount) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _waterIntake += amount;
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(label),
    );
  }

  Widget _buildMealSection(String title, String type) {
    final meals = _meals.where((m) => m.type == type).toList();
    final sectionCalories = meals.fold(0, (sum, meal) => sum + meal.calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${sectionCalories} cal',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: ThemeConfig.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (meals.isEmpty)
          Card(
            child: InkWell(
              onTap: () => _showAddMealDialog(type: type),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Text(
                      'Add $title',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...meals.map((meal) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getMealTypeColor(type),
                child: const Icon(Icons.restaurant, color: Colors.white, size: 20),
              ),
              title: Text(meal.name),
              subtitle: Text(
                'P: ${meal.protein.toStringAsFixed(0)}g  '
                'C: ${meal.carbs.toStringAsFixed(0)}g  '
                'F: ${meal.fats.toStringAsFixed(0)}g',
              ),
              trailing: Text(
                '${meal.calories} cal',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onTap: () => _showMealDetails(meal),
            ),
          )),
      ],
    );
  }

  Color _getMealTypeColor(String type) {
    switch (type) {
      case 'BREAKFAST':
        return Colors.orange;
      case 'LUNCH':
        return Colors.green;
      case 'DINNER':
        return Colors.blue;
      case 'SNACK':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _showAddMealDialog({String? type}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Meal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: type ?? 'BREAKFAST',
                decoration: const InputDecoration(labelText: 'Meal Type'),
                items: const [
                  DropdownMenuItem(value: 'BREAKFAST', child: Text('Breakfast')),
                  DropdownMenuItem(value: 'LUNCH', child: Text('Lunch')),
                  DropdownMenuItem(value: 'DINNER', child: Text('Dinner')),
                  DropdownMenuItem(value: 'SNACK', child: Text('Snack')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Meal Name',
                  hintText: 'e.g., Grilled Chicken',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Calories'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Protein (g)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Carbs (g)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Fats (g)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Meal logged successfully!'),
                  backgroundColor: ThemeConfig.successColor,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showMealDetails(Meal meal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(meal.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${meal.type}'),
            const SizedBox(height: 8),
            Text('Calories: ${meal.calories}'),
            Text('Protein: ${meal.protein.toStringAsFixed(1)}g'),
            Text('Carbs: ${meal.carbs.toStringAsFixed(1)}g'),
            Text('Fats: ${meal.fats.toStringAsFixed(1)}g'),
            if (meal.notes != null) ...[
              const SizedBox(height: 8),
              Text('Notes: ${meal.notes}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Meal deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: ThemeConfig.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showGoalSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nutrition Goals'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Daily Calories',
                  hintText: _goal.dailyCalories.toString(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Daily Protein (g)',
                  hintText: _goal.dailyProtein.toString(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Daily Carbs (g)',
                  hintText: _goal.dailyCarbs.toString(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Daily Fats (g)',
                  hintText: _goal.dailyFats.toString(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Daily Water (ml)',
                  hintText: _goal.dailyWater.toString(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Goals updated successfully!'),
                  backgroundColor: ThemeConfig.successColor,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
