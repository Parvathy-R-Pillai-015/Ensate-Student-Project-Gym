class User {
  final int id;
  final String email;
  final String? phone;
  final String firstName;
  final String lastName;
  final String role;
  final String? profileImage;
  final DateTime? dateJoined;
  final bool isActive;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? emergencyContact;
  
  // Personal Fitness Details
  final double? currentWeight; // in kg
  final double? height; // in cm
  final double? targetWeight; // in kg
  final String? fitnessGoal; // WEIGHT_LOSS, WEIGHT_GAIN, MUSCLE_BUILDING, GENERAL_FITNESS, ENDURANCE
  final String? dietaryPreference; // VEGETARIAN, NON_VEGETARIAN, VEGAN, PESCATARIAN
  final String? activityLevel; // SEDENTARY, LIGHTLY_ACTIVE, MODERATELY_ACTIVE, VERY_ACTIVE, EXTREMELY_ACTIVE
  final int? targetDays; // number of days to achieve goal
  final List<String>? foodAllergies;
  final List<String>? healthConditions;
  final bool? hasCompletedOnboarding;
  
  User({
    required this.id,
    required this.email,
    this.phone,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.profileImage,
    this.dateJoined,
    this.isActive = true,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.emergencyContact,
    this.currentWeight,
    this.height,
    this.targetWeight,
    this.fitnessGoal,
    this.dietaryPreference,
    this.activityLevel,
    this.targetDays,
    this.foodAllergies,
    this.healthConditions,
    this.hasCompletedOnboarding,
  });
  
  String get fullName => '$firstName $lastName';
  
  // Calculate BMI
  double? get bmi {
    if (currentWeight != null && height != null && height! > 0) {
      return currentWeight! / ((height! / 100) * (height! / 100));
    }
    return null;
  }
  
  // Calculate target daily calories based on goal
  int? get targetDailyCalories {
    if (currentWeight == null || height == null || gender == null) return null;
    
    // Basic BMR calculation (Mifflin-St Jeor Equation)
    double bmr;
    int age = dateOfBirth != null 
        ? DateTime.now().year - DateTime.parse(dateOfBirth!).year 
        : 25;
    
    if (gender?.toUpperCase() == 'MALE') {
      bmr = (10 * currentWeight!) + (6.25 * height!) - (5 * age) + 5;
    } else {
      bmr = (10 * currentWeight!) + (6.25 * height!) - (5 * age) - 161;
    }
    
    // Apply activity level multiplier
    double activityMultiplier = 1.2; // Default sedentary
    switch (activityLevel?.toUpperCase()) {
      case 'LIGHTLY_ACTIVE':
        activityMultiplier = 1.375;
        break;
      case 'MODERATELY_ACTIVE':
        activityMultiplier = 1.55;
        break;
      case 'VERY_ACTIVE':
        activityMultiplier = 1.725;
        break;
      case 'EXTREMELY_ACTIVE':
        activityMultiplier = 1.9;
        break;
    }
    
    double tdee = bmr * activityMultiplier;
    
    // Adjust for goal
    switch (fitnessGoal?.toUpperCase()) {
      case 'WEIGHT_LOSS':
        return (tdee - 500).round(); // 500 calorie deficit
      case 'WEIGHT_GAIN':
      case 'MUSCLE_BUILDING':
        return (tdee + 500).round(); // 500 calorie surplus
      default:
        return tdee.round(); // Maintenance
    }
  }
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      phone: json['phone'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? 'MEMBER',
      profileImage: json['profile_image'],
      dateJoined: json['date_joined'] != null 
          ? DateTime.parse(json['date_joined']) 
          : null,
      isActive: json['is_active'] ?? true,
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      address: json['address'],
      emergencyContact: json['emergency_contact'],
      currentWeight: _parseDouble(json['current_weight']),
      height: _parseDouble(json['height']),
      targetWeight: _parseDouble(json['target_weight']),
      fitnessGoal: json['fitness_goal'],
      dietaryPreference: json['dietary_preference'],
      activityLevel: json['activity_level'],
      targetDays: json['target_days'],
      foodAllergies: json['food_allergies'] != null 
          ? List<String>.from(json['food_allergies']) 
          : null,
      healthConditions: json['health_conditions'] != null 
          ? List<String>.from(json['health_conditions']) 
          : null,
      hasCompletedOnboarding: json['has_completed_onboarding'],
    );
  }
  
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'profile_image': profileImage,
      'date_joined': dateJoined?.toIso8601String(),
      'is_active': isActive,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'address': address,
      'emergency_contact': emergencyContact,
      'current_weight': currentWeight,
      'height': height,
      'target_weight': targetWeight,
      'fitness_goal': fitnessGoal,
      'dietary_preference': dietaryPreference,
      'activity_level': activityLevel,
      'target_days': targetDays,
      'food_allergies': foodAllergies,
      'health_conditions': healthConditions,
      'has_completed_onboarding': hasCompletedOnboarding,
    };
  }
  
  User copyWith({
    int? id,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? role,
    String? profileImage,
    DateTime? dateJoined,
    bool? isActive,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? emergencyContact,
    double? currentWeight,
    double? height,
    double? targetWeight,
    String? fitnessGoal,
    String? dietaryPreference,
    String? activityLevel,
    int? targetDays,
    List<String>? foodAllergies,
    List<String>? healthConditions,
    bool? hasCompletedOnboarding,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      dateJoined: dateJoined ?? this.dateJoined,
      isActive: isActive ?? this.isActive,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      currentWeight: currentWeight ?? this.currentWeight,
      height: height ?? this.height,
      targetWeight: targetWeight ?? this.targetWeight,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      activityLevel: activityLevel ?? this.activityLevel,
      targetDays: targetDays ?? this.targetDays,
      foodAllergies: foodAllergies ?? this.foodAllergies,
      healthConditions: healthConditions ?? this.healthConditions,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}
