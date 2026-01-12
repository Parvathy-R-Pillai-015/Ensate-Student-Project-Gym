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
