import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gymfit/config/theme_config.dart';
import 'package:gymfit/models/nutrition.dart';
import 'package:gymfit/providers/auth_provider.dart';
import 'package:gymfit/services/nutrition_service.dart';

class MyDietPlansScreen extends StatefulWidget {
  const MyDietPlansScreen({super.key});

  @override
  State<MyDietPlansScreen> createState() => _MyDietPlansScreenState();
}

class _MyDietPlansScreenState extends State<MyDietPlansScreen> {
  final NutritionService _nutritionService = NutritionService();
  Map<String, List<Meal>> _weeklyMealPlan = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMealPlans();
  }

  Future<void> _loadMealPlans() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      final now = DateTime.now();
      final weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      
      for (int i = 0; i < 7; i++) {
        final date = now.add(Duration(days: i));
        final dayName = weekDays[date.weekday - 1];
        final meals = await _nutritionService.generatePersonalizedMealPlan(user, date);
        _weeklyMealPlan[dayName] = meals;
      }
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  NutritionGoal get _nutritionGoal {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    final dailyCalories = user?.targetDailyCalories ?? 2200;
    
    return NutritionGoal(
      dailyCalories: dailyCalories,
      dailyProtein: (dailyCalories * 0.25 / 4), // 25% from protein
      dailyCarbs: (dailyCalories * 0.45 / 4),   // 45% from carbs
      dailyFats: (dailyCalories * 0.30 / 9),    // 30% from fats
      dailyWater: 3000,
    );
  }

  int _selectedDayIndex = 0;
  final List<String> _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Diet Plans'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final selectedDay = _daysOfWeek[_selectedDayIndex];
    final mealsForDay = _weeklyMealPlan[selectedDay] ?? [];
    
    if (mealsForDay.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Diet Plans'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No meal plan available. Complete your profile first.'),
        ),
      );
    }
    
    final totalCalories = mealsForDay.fold(0, (sum, meal) => sum + meal.calories);
    final totalProtein = mealsForDay.fold(0.0, (sum, meal) => sum + meal.protein);
    final totalCarbs = mealsForDay.fold(0.0, (sum, meal) => sum + meal.carbs);
    final totalFats = mealsForDay.fold(0.0, (sum, meal) => sum + meal.fats);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diet Plans'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header with Daily Goals
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConfig.secondaryColor,
                  ThemeConfig.secondaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.restaurant_menu,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Nutrition Plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGoalChip('${_nutritionGoal.dailyCalories} cal', Icons.local_fire_department),
                    _buildGoalChip('${_nutritionGoal.dailyProtein.toInt()}g protein', Icons.egg_outlined),
                    _buildGoalChip('${(_nutritionGoal.dailyWater / 1000).toStringAsFixed(1)}L water', Icons.water_drop),
                  ],
                ),
              ],
            ),
          ),

          // Day Selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _daysOfWeek.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedDayIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? ThemeConfig.primaryColor : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _daysOfWeek[index].substring(0, 3),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Daily Summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$totalCalories / ${_nutritionGoal.dailyCalories} cal',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ThemeConfig.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMacroStat('Protein', totalProtein, _nutritionGoal.dailyProtein, ThemeConfig.primaryColor),
                        _buildMacroStat('Carbs', totalCarbs, _nutritionGoal.dailyCarbs, ThemeConfig.secondaryColor),
                        _buildMacroStat('Fats', totalFats, _nutritionGoal.dailyFats, ThemeConfig.warningColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Meals List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mealsForDay.length,
              itemBuilder: (context, index) {
                final meal = mealsForDay[index];
                return _buildMealCard(meal);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroStat(String label, double value, double goal, Color color) {
    final percentage = (value / goal * 100).clamp(0, 100);
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toInt()}g',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${percentage.toInt()}%',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(Meal meal) {
    IconData mealIcon;
    Color mealColor;
    
    switch (meal.type) {
      case 'BREAKFAST':
        mealIcon = Icons.wb_sunny;
        mealColor = Colors.orange;
        break;
      case 'LUNCH':
        mealIcon = Icons.restaurant;
        mealColor = Colors.green;
        break;
      case 'DINNER':
        mealIcon = Icons.dinner_dining;
        mealColor = Colors.blue;
        break;
      default:
        mealIcon = Icons.fastfood;
        mealColor = Colors.purple;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: mealColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(mealIcon, color: mealColor),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.type,
              style: TextStyle(
                fontSize: 11,
                color: mealColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              meal.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${meal.calories} cal • ${meal.protein.toInt()}g protein',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNutrientInfo('Calories', '${meal.calories}', 'kcal', Icons.local_fire_department, Colors.orange),
                    _buildNutrientInfo('Protein', '${meal.protein.toInt()}', 'g', Icons.egg_outlined, ThemeConfig.primaryColor),
                    _buildNutrientInfo('Carbs', '${meal.carbs.toInt()}', 'g', Icons.grain, ThemeConfig.secondaryColor),
                    _buildNutrientInfo('Fats', '${meal.fats.toInt()}', 'g', Icons.opacity, ThemeConfig.warningColor),
                  ],
                ),
                if (meal.notes != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            meal.notes!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value, String unit, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
