class AppConfig {
  // API Configuration
  static const String baseUrl = 'http://localhost:8000/api'; // Change for production
  static const int apiTimeout = 30; // seconds
  
  // App Information
  static const String appName = 'GymFit';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login/';
  static const String registerEndpoint = '/auth/register/';
  static const String resetPasswordEndpoint = '/auth/password-reset/';
  static const String profileEndpoint = '/auth/profile/';
  static const String dashboardEndpoint = '/auth/dashboard/';
  static const String membershipPlansEndpoint = '/memberships/plans/';
  static const String workoutsEndpoint = '/workouts/';
  static const String classesEndpoint = '/classes/';
  static const String nutritionEndpoint = '/nutrition/';
  static const String progressEndpoint = '/progress/';
}
