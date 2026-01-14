class Meal {
  final int? id;
  final String name;
  final String type; // BREAKFAST, LUNCH, DINNER, SNACK
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final DateTime dateTime;
  final String? notes;

  Meal({
    this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.dateTime,
    this.notes,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? 'SNACK',
      calories: json['calories'] ?? 0,
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
      dateTime: json['date_time'] != null 
          ? DateTime.parse(json['date_time']) 
          : DateTime.now(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'date_time': dateTime.toIso8601String(),
      'notes': notes,
    };
  }
}

class FoodItem {
  final int id;
  final String name;
  final String category;
  final String dietaryType;
  final double servingSizeG;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final double fiberG;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.dietaryType,
    required this.servingSizeG,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    this.fiberG = 0,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      dietaryType: json['dietary_type'] ?? '',
      servingSizeG: (json['serving_size_g'] ?? 100).toDouble(),
      calories: json['calories'] ?? 0,
      proteinG: (json['protein_g'] ?? 0).toDouble(),
      carbsG: (json['carbs_g'] ?? 0).toDouble(),
      fatsG: (json['fats_g'] ?? 0).toDouble(),
      fiberG: (json['fiber_g'] ?? 0).toDouble(),
    );
  }
}

class FoodLog {
  final int? id;
  final FoodItem foodItem;
  final String mealType;
  final double quantityG;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final String? consumedTime;
  final DateTime? createdAt;

  FoodLog({
    this.id,
    required this.foodItem,
    required this.mealType,
    required this.quantityG,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    this.consumedTime,
    this.createdAt,
  });

  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: json['id'],
      foodItem: FoodItem.fromJson(json['food_item']),
      mealType: json['meal_type'] ?? 'SNACK',
      quantityG: (json['quantity_g'] ?? 0).toDouble(),
      calories: json['calories'] ?? 0,
      proteinG: (json['protein_g'] ?? 0).toDouble(),
      carbsG: (json['carbs_g'] ?? 0).toDouble(),
      fatsG: (json['fats_g'] ?? 0).toDouble(),
      consumedTime: json['consumed_time'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }
}

class DailyFoodLog {
  final String date;
  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatsG;
  final List<FoodLog> loggedFoods;

  DailyFoodLog({
    required this.date,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatsG,
    required this.loggedFoods,
  });

  factory DailyFoodLog.fromJson(Map<String, dynamic> json) {
    return DailyFoodLog(
      date: json['date'] ?? '',
      totalCalories: json['total_calories'] ?? 0,
      totalProteinG: (json['total_protein_g'] ?? 0).toDouble(),
      totalCarbsG: (json['total_carbs_g'] ?? 0).toDouble(),
      totalFatsG: (json['total_fats_g'] ?? 0).toDouble(),
      loggedFoods: (json['logged_foods'] as List<dynamic>?)
          ?.map((item) => FoodLog.fromJson(item))
          .toList() ?? [],
    );
  }
}
    };
  }
}

class NutritionGoal {
  final int dailyCalories;
  final double dailyProtein;
  final double dailyCarbs;
  final double dailyFats;
  final int dailyWater; // in ml

  NutritionGoal({
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyCarbs,
    required this.dailyFats,
    this.dailyWater = 2000,
  });

  factory NutritionGoal.fromJson(Map<String, dynamic> json) {
    return NutritionGoal(
      dailyCalories: json['daily_calories'] ?? 2000,
      dailyProtein: (json['daily_protein'] ?? 150).toDouble(),
      dailyCarbs: (json['daily_carbs'] ?? 200).toDouble(),
      dailyFats: (json['daily_fats'] ?? 60).toDouble(),
      dailyWater: json['daily_water'] ?? 2000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_calories': dailyCalories,
      'daily_protein': dailyProtein,
      'daily_carbs': dailyCarbs,
      'daily_fats': dailyFats,
      'daily_water': dailyWater,
    };
  }
}
