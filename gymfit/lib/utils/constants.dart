class AppConstants {
  // User Roles
  static const String roleMember = 'MEMBER';
  static const String roleTrainer = 'TRAINER';
  static const String roleAdmin = 'ADMIN';
  
  // Membership Status
  static const String membershipActive = 'ACTIVE';
  static const String membershipExpired = 'EXPIRED';
  static const String membershipFrozen = 'FROZEN';
  
  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserData = 'user_data';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyUserProfiles = 'user_profiles'; // Store all user profiles by email
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Workout Categories
  static const List<String> workoutCategories = [
    'Cardio',
    'Strength',
    'Flexibility',
    'HIIT',
    'Yoga',
    'CrossFit',
    'Pilates',
    'Swimming',
    'Cycling',
    'Running',
  ];
  
  // Muscle Groups
  static const List<String> muscleGroups = [
    'Chest',
    'Back',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Forearms',
    'Abs',
    'Obliques',
    'Quads',
    'Hamstrings',
    'Calves',
    'Glutes',
  ];
  
  // Fitness Goals
  static const List<String> fitnessGoals = [
    'Weight Loss',
    'Muscle Gain',
    'Maintain Fitness',
    'Improve Endurance',
    'Increase Flexibility',
    'Build Strength',
    'General Health',
  ];
  
  // Activity Levels
  static const List<String> activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extremely Active',
  ];
  
  // Class Types
  static const List<String> classTypes = [
    'Yoga',
    'Zumba',
    'Spinning',
    'CrossFit',
    'Pilates',
    'Aerobics',
    'Boxing',
    'Dance',
    'Strength Training',
    'HIIT',
  ];
}
