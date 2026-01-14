import 'package:gymfit/services/api_service.dart';
import 'package:gymfit/models/nutrition.dart';
import 'package:gymfit/models/user.dart';

class NutritionService {
  final ApiService _apiService = ApiService();

  // Generate personalized meal plan based on user profile
  Future<List<Meal>> generatePersonalizedMealPlan(User user, DateTime date) async {
    try {
      // In production, this would call the backend API
      // For now, generate based on user's dietary preferences and goals
      return _generateMockMealPlan(user, date);
    } catch (e) {
      throw Exception('Failed to generate meal plan: $e');
    }
  }

  List<Meal> _generateMockMealPlan(User user, DateTime date) {
    final targetCalories = user.targetDailyCalories ?? 2000;
    final isVegetarian = user.dietaryPreference?.toUpperCase() == 'VEGETARIAN';
    final isVegan = user.dietaryPreference?.toUpperCase() == 'VEGAN';
    final isPescatarian = user.dietaryPreference?.toUpperCase() == 'PESCATARIAN';
    
    final List<Meal> meals = [];
    
    // Calculate meal calories to ensure they add up exactly to target
    final breakfastCal = (targetCalories * 0.25).round();
    final lunchCal = (targetCalories * 0.35).round();
    final snackCal = (targetCalories * 0.10).round();
    // Adjust dinner to make total exactly match target (accounts for rounding)
    final dinnerCal = targetCalories - breakfastCal - lunchCal - snackCal;
    
    // Breakfast (25% of daily calories)
    meals.add(_generateBreakfast(
      targetCalories: breakfastCal,
      date: date,
      isVegetarian: isVegetarian || isVegan,
      isVegan: isVegan,
    ));
    
    // Lunch (35% of daily calories)
    meals.add(_generateLunch(
      targetCalories: lunchCal,
      date: date,
      isVegetarian: isVegetarian || isVegan,
      isVegan: isVegan,
      isPescatarian: isPescatarian,
    ));
    
    // Snack (10% of daily calories)
    meals.add(_generateSnack(
      targetCalories: snackCal,
      date: date,
      isVegan: isVegan,
    ));
    
    // Dinner (adjusted to match exact total)
    meals.add(_generateDinner(
      targetCalories: dinnerCal,
      date: date,
      isVegetarian: isVegetarian || isVegan,
      isVegan: isVegan,
      isPescatarian: isPescatarian,
    ));
    
    return meals;
  }

  Meal _generateBreakfast({
    required int targetCalories,
    required DateTime date,
    required bool isVegetarian,
    required bool isVegan,
  }) {
    final dayOfWeek = date.weekday; // 1=Monday, 7=Sunday
    
    if (isVegan) {
      // VEGAN: Only plant-based (no eggs, no dairy, no animal products)
      final veganBreakfasts = [
        {'name': 'Oatmeal with Berries, Nuts and Almond Milk', 'notes': 'Rolled oats, mixed berries, walnuts, almond milk'},
        {'name': 'Avocado Toast with Cherry Tomatoes', 'notes': 'Whole grain bread, mashed avocado, cherry tomatoes, seeds'},
        {'name': 'Smoothie Bowl with Banana and Peanut Butter', 'notes': 'Banana, peanut butter, oat milk, granola topping'},
        {'name': 'Chia Seed Pudding with Mango', 'notes': 'Chia seeds, coconut milk, fresh mango, coconut flakes'},
        {'name': 'Vegan Pancakes with Maple Syrup', 'notes': 'Flour, plant milk, flaxseed, maple syrup, berries'},
        {'name': 'Quinoa Breakfast Bowl with Fruits', 'notes': 'Quinoa, almond milk, banana, berries, nuts'},
        {'name': 'Tofu Scramble with Vegetables', 'notes': 'Crumbled tofu, peppers, onions, turmeric, toast'},
      ];
      final breakfast = veganBreakfasts[dayOfWeek - 1];
      return Meal(
        name: breakfast['name']!,
        type: 'BREAKFAST',
        calories: targetCalories,
        protein: (targetCalories * 0.15 / 4).round().toDouble(),
        carbs: (targetCalories * 0.55 / 4).round().toDouble(),
        fats: (targetCalories * 0.30 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 7, 0),
        notes: '100% VEGAN - ${breakfast['notes']}',
      );
    } else if (isVegetarian) {
      // VEGETARIAN: Eggs and dairy allowed (no meat, no fish)
      final vegBreakfasts = [
        {'name': 'Scrambled Eggs with Cheese and Toast', 'notes': '3 eggs, cheddar cheese, whole wheat toast'},
        {'name': 'Greek Yogurt Parfait with Granola', 'notes': 'Greek yogurt, homemade granola, honey, berries'},
        {'name': 'Vegetable Omelette with Cheese', 'notes': '3-egg omelette, bell peppers, onions, cheese'},
        {'name': 'Paneer Paratha with Yogurt', 'notes': 'Whole wheat paratha stuffed with cottage cheese, yogurt'},
        {'name': 'Poached Eggs on Avocado Toast', 'notes': '2 poached eggs, avocado, whole grain bread'},
        {'name': 'Cottage Cheese Pancakes with Berries', 'notes': 'Cottage cheese, flour, eggs, fresh berries'},
        {'name': 'Masala Dosa with Coconut Chutney', 'notes': 'Rice crepe, potato filling, coconut chutney'},
      ];
      final breakfast = vegBreakfasts[dayOfWeek - 1];
      return Meal(
        name: breakfast['name']!,
        type: 'BREAKFAST',
        calories: targetCalories,
        protein: (targetCalories * 0.25 / 4).round().toDouble(),
        carbs: (targetCalories * 0.45 / 4).round().toDouble(),
        fats: (targetCalories * 0.30 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 7, 0),
        notes: 'VEGETARIAN (Eggs & Dairy OK) - ${breakfast['notes']}',
      );
    } else {
      // NON-VEGETARIAN: All foods allowed
      final nonVegBreakfasts = [
        {'name': 'Eggs with Chicken Sausage and Toast', 'notes': '2 eggs, chicken sausage, avocado, whole grain toast'},
        {'name': 'Breakfast Burrito with Bacon', 'notes': 'Eggs, bacon, cheese, beans, tortilla'},
        {'name': 'Smoked Salmon with Cream Cheese Bagel', 'notes': 'Smoked salmon, cream cheese, whole wheat bagel'},
        {'name': 'Turkey Sausage and Egg Sandwich', 'notes': 'Turkey sausage, eggs, cheese, English muffin'},
        {'name': 'Spanish Omelette with Ham', 'notes': '3-egg omelette, ham, potatoes, peppers'},
        {'name': 'Protein Pancakes with Chicken Sausage', 'notes': 'Protein pancakes, grilled chicken sausage, berries'},
        {'name': 'Steak and Eggs with Hash Browns', 'notes': 'Lean steak, 2 eggs, crispy hash browns'},
      ];
      final breakfast = nonVegBreakfasts[dayOfWeek - 1];
      return Meal(
        name: breakfast['name']!,
        type: 'BREAKFAST',
        calories: targetCalories,
        protein: (targetCalories * 0.30 / 4).round().toDouble(),
        carbs: (targetCalories * 0.40 / 4).round().toDouble(),
        fats: (targetCalories * 0.30 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 7, 0),
        notes: 'NON-VEG (All foods) - ${breakfast['notes']}',
      );
    }
  }

  Meal _generateLunch({
    required int targetCalories,
    required DateTime date,
    required bool isVegetarian,
    required bool isVegan,
    required bool isPescatarian,
  }) {
    final dayOfWeek = date.weekday;
    
    if (isVegan) {
      // VEGAN: Only plant-based foods
      final veganLunches = [
        {'name': 'Quinoa Buddha Bowl with Chickpeas', 'notes': 'Quinoa, roasted chickpeas, mixed vegetables, tahini'},
        {'name': 'Lentil Curry with Brown Rice', 'notes': 'Red lentils, coconut milk, spices, brown rice'},
        {'name': 'Black Bean Burrito Bowl', 'notes': 'Black beans, rice, lettuce, salsa, guacamole'},
        {'name': 'Thai Peanut Tofu Stir-fry', 'notes': 'Crispy tofu, vegetables, peanut sauce, rice noodles'},
        {'name': 'Falafel Wrap with Hummus', 'notes': 'Falafel balls, hummus, tahini, vegetables, pita'},
        {'name': 'Vegetable Biryani with Raita', 'notes': 'Basmati rice, mixed vegetables, spices, vegan raita'},
        {'name': 'Mushroom and Spinach Pasta', 'notes': 'Whole wheat pasta, mushrooms, spinach, garlic, olive oil'},
      ];
      final lunch = veganLunches[dayOfWeek - 1];
      return Meal(
        name: lunch['name']!,
        type: 'LUNCH',
        calories: targetCalories,
        protein: (targetCalories * 0.20 / 4).round().toDouble(),
        carbs: (targetCalories * 0.50 / 4).round().toDouble(),
        fats: (targetCalories * 0.30 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 12, 30),
        notes: '100% VEGAN - ${lunch['notes']}',
      );
    } else if (isVegetarian) {
      // VEGETARIAN: Dairy and eggs allowed
      final vegLunches = [
        {'name': 'Paneer Tikka with Brown Rice', 'notes': 'Grilled cottage cheese, brown rice, mint chutney'},
        {'name': 'Vegetable Lasagna', 'notes': 'Pasta layers, ricotta cheese, vegetables, marinara'},
        {'name': 'Egg Salad Sandwich with Soup', 'notes': 'Boiled eggs, mayo, lettuce, tomato soup'},
        {'name': 'Palak Paneer with Naan', 'notes': 'Spinach curry, cottage cheese cubes, whole wheat naan'},
        {'name': 'Cheese Quesadilla with Beans', 'notes': 'Tortilla, cheese, black beans, sour cream, salsa'},
        {'name': 'Caprese Sandwich with Mozzarella', 'notes': 'Mozzarella, tomatoes, basil, balsamic, ciabatta'},
        {'name': 'Greek Salad with Feta and Pita', 'notes': 'Feta cheese, olives, cucumbers, tomatoes, pita bread'},
      ];
      final lunch = vegLunches[dayOfWeek - 1];
      return Meal(
        name: lunch['name']!,
        type: 'LUNCH',
        calories: targetCalories,
        protein: (targetCalories * 0.25 / 4).round().toDouble(),
        carbs: (targetCalories * 0.45 / 4).round().toDouble(),
        fats: (targetCalories * 0.30 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 12, 30),
        notes: 'VEGETARIAN (Eggs & Dairy OK) - ${lunch['notes']}',
      );
    } else if (isPescatarian) {
      // PESCATARIAN: Fish allowed (no other meat)
      final pescLunches = [
        {'name': 'Grilled Salmon with Quinoa', 'notes': 'Atlantic salmon, quinoa, roasted vegetables'},
        {'name': 'Tuna Poke Bowl', 'notes': 'Fresh tuna, rice, edamame, avocado, seaweed'},
        {'name': 'Fish Tacos with Cabbage Slaw', 'notes': 'Grilled white fish, corn tortillas, lime, slaw'},
        {'name': 'Shrimp Stir-fry with Noodles', 'notes': 'Shrimp, vegetables, rice noodles, soy sauce'},
        {'name': 'Baked Cod with Sweet Potato', 'notes': 'Herb-crusted cod, baked sweet potato, greens'},
        {'name': 'Seafood Pasta Primavera', 'notes': 'Mixed seafood, pasta, vegetables, white wine sauce'},
        {'name': 'Teriyaki Salmon Bowl', 'notes': 'Teriyaki glazed salmon, brown rice, broccoli'},
      ];
      final lunch = pescLunches[dayOfWeek - 1];
      return Meal(
        name: lunch['name']!,
        type: 'LUNCH',
        calories: targetCalories,
        protein: (targetCalories * 0.35 / 4).round().toDouble(),
        carbs: (targetCalories * 0.35 / 4).round().toDouble(),
        fats: (targetCalories * 0.30 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 12, 30),
        notes: 'PESCATARIAN (Fish OK, No Meat) - ${lunch['notes']}',
      );
    } else {
      // NON-VEGETARIAN: All meats allowed
      final nonVegLunches = [
        {'name': 'Grilled Chicken with Sweet Potato', 'notes': 'Chicken breast, baked sweet potato, green salad'},
        {'name': 'Beef Burrito Bowl', 'notes': 'Ground beef, rice, beans, cheese, guacamole'},
        {'name': 'Turkey Club Sandwich', 'notes': 'Turkey breast, bacon, lettuce, tomato, mayo'},
        {'name': 'Chicken Tikka Masala with Rice', 'notes': 'Chicken in creamy tomato sauce, basmati rice'},
        {'name': 'Steak Salad with Blue Cheese', 'notes': 'Grilled steak strips, mixed greens, blue cheese'},
        {'name': 'BBQ Pulled Pork Sandwich', 'notes': 'Slow-cooked pork, BBQ sauce, coleslaw, bun'},
        {'name': 'Lamb Gyro with Tzatziki', 'notes': 'Lamb meat, pita bread, tzatziki, vegetables'},
      ];
      final lunch = nonVegLunches[dayOfWeek - 1];
      return Meal(
        name: lunch['name']!,
        type: 'LUNCH',
        calories: targetCalories,
        protein: (targetCalories * 0.35 / 4).round().toDouble(),
        carbs: (targetCalories * 0.40 / 4).round().toDouble(),
        fats: (targetCalories * 0.25 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 12, 30),
        notes: 'NON-VEG (All foods) - ${lunch['notes']}',
      );
    }
  }

  Meal _generateSnack({
    required int targetCalories,
    required DateTime date,
    required bool isVegan,
  }) {
    final dayOfWeek = date.weekday;
    
    if (isVegan) {
      // VEGAN: Only plant-based
      final veganSnacks = [
        {'name': 'Hummus with Veggie Sticks', 'notes': 'Carrots, cucumber, bell peppers, hummus'},
        {'name': 'Apple Slices with Almond Butter', 'notes': 'Fresh apple, natural almond butter'},
        {'name': 'Trail Mix with Dried Fruits', 'notes': 'Mixed nuts, raisins, dried cranberries'},
        {'name': 'Roasted Chickpeas', 'notes': 'Spiced roasted chickpeas, sea salt'},
        {'name': 'Banana with Peanut Butter', 'notes': 'Ripe banana, natural peanut butter'},
        {'name': 'Energy Balls with Dates', 'notes': 'Dates, oats, cocoa powder, coconut'},
        {'name': 'Avocado on Rice Cakes', 'notes': 'Mashed avocado, whole grain rice cakes'},
      ];
      final snack = veganSnacks[dayOfWeek - 1];
      return Meal(
        name: snack['name']!,
        type: 'SNACK',
        calories: targetCalories,
        protein: (targetCalories * 0.15 / 4).round().toDouble(),
        carbs: (targetCalories * 0.45 / 4).round().toDouble(),
        fats: (targetCalories * 0.40 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 15, 30),
        notes: '100% VEGAN - ${snack['notes']}',
      );
    } else {
      // VEGETARIAN/NON-VEG: Dairy allowed
      final dairySnacks = [
        {'name': 'Greek Yogurt with Berries', 'notes': 'Greek yogurt, mixed berries, honey'},
        {'name': 'Cheese and Crackers', 'notes': 'Cheddar cheese, whole grain crackers'},
        {'name': 'Protein Smoothie', 'notes': 'Whey protein, banana, milk, berries'},
        {'name': 'Cottage Cheese with Pineapple', 'notes': 'Low-fat cottage cheese, fresh pineapple'},
        {'name': 'Hard-boiled Eggs', 'notes': '2 hard-boiled eggs, salt, pepper'},
        {'name': 'Mozzarella Sticks with Marinara', 'notes': 'Part-skim mozzarella, tomato sauce'},
        {'name': 'Protein Bar with Milk', 'notes': 'Whey protein bar, glass of milk'},
      ];
      final snack = dairySnacks[dayOfWeek - 1];
      return Meal(
        name: snack['name']!,
        type: 'SNACK',
        calories: targetCalories,
        protein: (targetCalories * 0.30 / 4).round().toDouble(),
        carbs: (targetCalories * 0.50 / 4).round().toDouble(),
        fats: (targetCalories * 0.20 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 15, 30),
        notes: 'Dairy-based snack - ${snack['notes']}',
      );
    }
  }

  Meal _generateDinner({
    required int targetCalories,
    required DateTime date,
    required bool isVegetarian,
    required bool isVegan,
    required bool isPescatarian,
  }) {
    final dayOfWeek = date.weekday;
    
    if (isVegan) {
      // VEGAN: Only plant-based
      final veganDinners = [
        {'name': 'Tofu Stir-fry with Brown Rice', 'notes': 'Crispy tofu, mixed vegetables, brown rice, soy sauce'},
        {'name': 'Vegan Chili with Cornbread', 'notes': 'Bean chili, tomatoes, spices, cornbread'},
        {'name': 'Lentil Bolognese Pasta', 'notes': 'Red lentils, tomato sauce, whole wheat pasta'},
        {'name': 'Chickpea Curry with Rice', 'notes': 'Chickpeas, coconut milk, curry spices, rice'},
        {'name': 'Stuffed Bell Peppers', 'notes': 'Bell peppers, quinoa, black beans, tomatoes'},
        {'name': 'Vegan Buddha Bowl', 'notes': 'Quinoa, roasted vegetables, tahini dressing'},
        {'name': 'Vegetable Pad Thai', 'notes': 'Rice noodles, tofu, vegetables, peanut sauce'},
      ];
      final dinner = veganDinners[dayOfWeek - 1];
      return Meal(
        name: dinner['name']!,
        type: 'DINNER',
        calories: targetCalories,
        protein: (targetCalories * 0.20 / 4).round().toDouble(),
        carbs: (targetCalories * 0.50 / 4).round().toDouble(),
        fats: (targetCalories * 0.30 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 19, 0),
        notes: '100% VEGAN - ${dinner['notes']}',
      );
    } else if (isVegetarian) {
      // VEGETARIAN: Eggs and dairy allowed
      final vegDinners = [
        {'name': 'Lentil Dal with Paneer and Roti', 'notes': 'Yellow lentils, cottage cheese cubes, whole wheat roti'},
        {'name': 'Eggplant Parmesan with Pasta', 'notes': 'Breaded eggplant, mozzarella, marinara, pasta'},
        {'name': 'Vegetable Quiche with Salad', 'notes': 'Egg quiche, vegetables, cheese, side salad'},
        {'name': 'Paneer Butter Masala with Naan', 'notes': 'Cottage cheese in creamy tomato sauce, naan'},
        {'name': 'Cheese Ravioli with Marinara', 'notes': 'Ricotta-filled ravioli, tomato sauce, parmesan'},
        {'name': 'Vegetable Lasagna', 'notes': 'Pasta layers, ricotta, vegetables, mozzarella'},
        {'name': 'Shakshuka with Feta', 'notes': 'Eggs poached in tomato sauce, feta cheese, bread'},
      ];
      final dinner = vegDinners[dayOfWeek - 1];
      return Meal(
        name: dinner['name']!,
        type: 'DINNER',
        calories: targetCalories,
        protein: (targetCalories * 0.25 / 4).round().toDouble(),
        carbs: (targetCalories * 0.50 / 4).round().toDouble(),
        fats: (targetCalories * 0.25 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 19, 0),
        notes: 'VEGETARIAN (Eggs & Dairy OK) - ${dinner['notes']}',
      );
    } else if (isPescatarian) {
      // PESCATARIAN: Fish allowed
      final pescDinners = [
        {'name': 'Baked Salmon with Quinoa and Broccoli', 'notes': 'Herb-baked salmon, quinoa, steamed broccoli'},
        {'name': 'Fish Curry with Rice', 'notes': 'White fish, coconut curry sauce, basmati rice'},
        {'name': 'Grilled Tuna Steak with Salad', 'notes': 'Seared tuna, mixed greens, balsamic dressing'},
        {'name': 'Shrimp Scampi with Pasta', 'notes': 'Shrimp, garlic, white wine, linguine'},
        {'name': 'Baked Cod with Roasted Vegetables', 'notes': 'Lemon herb cod, roasted root vegetables'},
        {'name': 'Fish Tacos with Black Beans', 'notes': 'Grilled fish, corn tortillas, cabbage slaw, beans'},
        {'name': 'Seafood Paella', 'notes': 'Mixed seafood, saffron rice, vegetables'},
      ];
      final dinner = pescDinners[dayOfWeek - 1];
      return Meal(
        name: dinner['name']!,
        type: 'DINNER',
        calories: targetCalories,
        protein: (targetCalories * 0.35 / 4).round().toDouble(),
        carbs: (targetCalories * 0.40 / 4).round().toDouble(),
        fats: (targetCalories * 0.25 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 19, 0),
        notes: 'PESCATARIAN (Fish OK, No Meat) - ${dinner['notes']}',
      );
    } else {
      // NON-VEGETARIAN: All meats allowed
      final nonVegDinners = [
        {'name': 'Grilled Chicken with Roasted Vegetables', 'notes': 'Chicken breast, roasted vegetables, brown rice'},
        {'name': 'Beef Stir-fry with Noodles', 'notes': 'Lean beef strips, vegetables, rice noodles'},
        {'name': 'Turkey Meatballs with Spaghetti', 'notes': 'Turkey meatballs, whole wheat pasta, marinara'},
        {'name': 'Lamb Curry with Basmati Rice', 'notes': 'Tender lamb, curry sauce, basmati rice'},
        {'name': 'Grilled Steak with Sweet Potato', 'notes': 'Sirloin steak, baked sweet potato, asparagus'},
        {'name': 'Chicken Fajitas', 'notes': 'Grilled chicken, peppers, onions, tortillas'},
        {'name': 'Pork Chops with Apple Sauce', 'notes': 'Grilled pork chops, apple sauce, green beans'},
      ];
      final dinner = nonVegDinners[dayOfWeek - 1];
      return Meal(
        name: dinner['name']!,
        type: 'DINNER',
        calories: targetCalories,
        protein: (targetCalories * 0.35 / 4).round().toDouble(),
        carbs: (targetCalories * 0.35 / 4).round().toDouble(),
        fats: (targetCalories * 0.30 / 9).round().toDouble(),
        dateTime: DateTime(date.year, date.month, date.day, 19, 0),
        notes: 'NON-VEG (All foods) - ${dinner['notes']}',
      );
    }
  }

  // Get meals for a specific date
  Future<List<Meal>> getMeals(DateTime date) async {
    try {
      final response = await _apiService.get(
        '/nutrition/meals/',
        queryParameters: {
          'date': date.toIso8601String().split('T')[0],
        },
      );
      return (response.data as List)
          .map((json) => Meal.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch meals: $e');
    }
  }

  // Log a meal
  Future<Meal> logMeal(Meal meal) async {
    try {
      final response = await _apiService.post(
        '/nutrition/meals/',
        data: meal.toJson(),
      );
      return Meal.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to log meal: $e');
    }
  }

  // Update meal
  Future<Meal> updateMeal(int id, Meal meal) async {
    try {
      final response = await _apiService.put(
        '/nutrition/meals/$id/',
        data: meal.toJson(),
      );
      return Meal.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update meal: $e');
    }
  }

  // Delete meal
  Future<void> deleteMeal(int id) async {
    try {
      await _apiService.delete('/nutrition/meals/$id/');
    } catch (e) {
      throw Exception('Failed to delete meal: $e');
    }
  }

  // Get nutrition goals
  Future<NutritionGoal> getGoals() async {
    try {
      final response = await _apiService.get('/nutrition/goals/');
      return NutritionGoal.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch nutrition goals: $e');
    }
  }

  // Update nutrition goals
  Future<NutritionGoal> updateGoals(NutritionGoal goals) async {
    try {
      final response = await _apiService.put(
        '/nutrition/goals/',
        data: goals.toJson(),
      );
      return NutritionGoal.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update nutrition goals: $e');
    }
  }

  // Log water intake
  Future<void> logWater(int amount) async {
    try {
      await _apiService.post(
        '/nutrition/water/',
        data: {'amount': amount},
      );
    } catch (e) {
      throw Exception('Failed to log water intake: $e');
    }
  }

  // Get daily nutrition summary
  Future<Map<String, dynamic>> getDailySummary(DateTime date) async {
    try {
      final response = await _apiService.get(
        '/nutrition/summary/',
        queryParameters: {
          'date': date.toIso8601String().split('T')[0],
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch nutrition summary: $e');
    }
  }
}
