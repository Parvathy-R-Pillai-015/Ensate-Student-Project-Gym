import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';
import 'package:gymfit/models/nutrition.dart';
import 'package:gymfit/services/nutrition_service.dart';

class FoodLoggingScreen extends StatefulWidget {
  const FoodLoggingScreen({super.key});

  @override
  State<FoodLoggingScreen> createState() => _FoodLoggingScreenState();
}

class _FoodLoggingScreenState extends State<FoodLoggingScreen> {
  final NutritionService _nutritionService = NutritionService();
  DailyFoodLog? _dailyLog;
  List<FoodItem> _allFoods = [];
  List<FoodItem> _filteredFoods = [];
  bool _isLoading = true;
  String _selectedCategory = 'ALL';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dailyLog = await _nutritionService.getTodaysFoodLog();
      final foods = await _nutritionService.getFoodItems();

      setState(() {
        _dailyLog = dailyLog;
        _allFoods = foods;
        _filteredFoods = foods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  void _filterFoods(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFoods = _allFoods
            .where((food) => 
                _selectedCategory == 'ALL' || 
                food.category == _selectedCategory)
            .toList();
      } else {
        _filteredFoods = _allFoods
            .where((food) => 
                food.name.toLowerCase().contains(query.toLowerCase()) &&
                (_selectedCategory == 'ALL' || food.category == _selectedCategory))
            .toList();
      }
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterFoods(_searchController.text);
  }

  Future<void> _addFoodToLog(FoodItem food) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _AddFoodDialog(food: food),
    );

    if (result != null) {
      try {
        await _nutritionService.addFoodToLog(
          foodItemId: food.id,
          quantityG: result['quantity'],
          mealType: result['mealType'],
        );

        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added ${food.name} to your log'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _removeFoodFromLog(int logId) async {
    try {
      await _nutritionService.removeFoodFromLog(logId);
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Food removed from log'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Food Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Calorie Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeConfig.secondaryColor.withOpacity(0.8),
                          ThemeConfig.secondaryColor,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Today's Total Calories",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_dailyLog?.totalCalories ?? 0}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_dailyLog?.loggedFoods.length ?? 0} food items logged',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Today's Food Log
                  if (_dailyLog != null && _dailyLog!.loggedFoods.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Today's Food Intake",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dailyLog!.loggedFoods.length,
                      itemBuilder: (context, index) {
                        final log = _dailyLog!.loggedFoods[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getMealTypeColor(log.mealType),
                              child: Icon(
                                _getMealTypeIcon(log.mealType),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(log.foodItem.name),
                            subtitle: Text(
                              '${log.quantityG.toStringAsFixed(0)}g • ${log.calories} cal',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeFoodFromLog(log.id!),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Add Food Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Food',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        
                        // Search Bar
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search foods...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterFoods('');
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: _filterFoods,
                        ),
                        const SizedBox(height: 12),

                        // Category Filter
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _CategoryChip(
                                label: 'All',
                                isSelected: _selectedCategory == 'ALL',
                                onTap: () => _filterByCategory('ALL'),
                              ),
                              _CategoryChip(
                                label: 'Breakfast',
                                isSelected: _selectedCategory == 'GRAINS',
                                onTap: () => _filterByCategory('GRAINS'),
                              ),
                              _CategoryChip(
                                label: 'Protein',
                                isSelected: _selectedCategory == 'PROTEIN',
                                onTap: () => _filterByCategory('PROTEIN'),
                              ),
                              _CategoryChip(
                                label: 'Vegetables',
                                isSelected: _selectedCategory == 'VEGETABLES',
                                onTap: () => _filterByCategory('VEGETABLES'),
                              ),
                              _CategoryChip(
                                label: 'Snacks',
                                isSelected: _selectedCategory == 'SNACKS',
                                onTap: () => _filterByCategory('SNACKS'),
                              ),
                              _CategoryChip(
                                label: 'Fruits',
                                isSelected: _selectedCategory == 'FRUITS',
                                onTap: () => _filterByCategory('FRUITS'),
                              ),
                              _CategoryChip(
                                label: 'Dairy',
                                isSelected: _selectedCategory == 'DAIRY',
                                onTap: () => _filterByCategory('DAIRY'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Food List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = _filteredFoods[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(food.name),
                          subtitle: Text(
                            '${food.calories} cal • ${food.proteinG.toStringAsFixed(1)}g protein',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () => _addFoodToLog(food),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType) {
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

  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'BREAKFAST':
        return Icons.free_breakfast;
      case 'LUNCH':
        return Icons.lunch_dining;
      case 'DINNER':
        return Icons.dinner_dining;
      case 'SNACK':
        return Icons.fastfood;
      default:
        return Icons.restaurant;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: ThemeConfig.primaryColor.withOpacity(0.2),
        checkmarkColor: ThemeConfig.primaryColor,
      ),
    );
  }
}

class _AddFoodDialog extends StatefulWidget {
  final FoodItem food;

  const _AddFoodDialog({required this.food});

  @override
  State<_AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<_AddFoodDialog> {
  late double _quantity;
  String _mealType = 'SNACK';
  late int _calculatedCalories;

  @override
  void initState() {
    super.initState();
    _quantity = widget.food.servingSizeG;
    _calculateNutrition();
  }

  void _calculateNutrition() {
    final multiplier = _quantity / widget.food.servingSizeG;
    setState(() {
      _calculatedCalories = (widget.food.calories * multiplier).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ${widget.food.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quantity (grams):'),
          Slider(
            value: _quantity,
            min: 10,
            max: widget.food.servingSizeG * 5,
            divisions: 50,
            label: _quantity.toStringAsFixed(0),
            onChanged: (value) {
              setState(() {
                _quantity = value;
                _calculateNutrition();
              });
            },
          ),
          Text(
            '${_quantity.toStringAsFixed(0)}g = $_calculatedCalories cal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text('Meal Type:'),
          DropdownButton<String>(
            value: _mealType,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'BREAKFAST', child: Text('Breakfast')),
              DropdownMenuItem(value: 'LUNCH', child: Text('Lunch')),
              DropdownMenuItem(value: 'DINNER', child: Text('Dinner')),
              DropdownMenuItem(value: 'SNACK', child: Text('Snack')),
              DropdownMenuItem(value: 'MORNING_SNACK', child: Text('Morning Snack')),
              DropdownMenuItem(value: 'EVENING_SNACK', child: Text('Evening Snack')),
            ],
            onChanged: (value) {
              setState(() {
                _mealType = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'quantity': _quantity,
              'mealType': _mealType,
            });
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
