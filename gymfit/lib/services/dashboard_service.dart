import 'api_service.dart';
import '../config/app_config.dart';

class DashboardService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      print('🔄 Fetching dashboard data from API...');
      final response = await _apiService.get(AppConfig.dashboardEndpoint);
      print('✅ Dashboard data fetched successfully from API');
      print('📊 Response data: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ Error fetching dashboard data: $e');
      print('⚠️ Using fallback data instead');
      // Return fallback data if API fails
      return {
        'user': {
          'name': 'Sree',
          'greeting': 'Good Afternoon',
        },
        'stats': {
          'workouts': 12,
          'calories': 2450,
          'classes': 8,
          'days_active': 15,
        },
        'membership': {
          'type': 'Premium Membership',
          'days_remaining': 10,
        },
        'fitness_profile': {
          'goal': 'WEIGHT LOSS',
          'current_weight': 69,
          'target_weight': 55,
          'diet': 'VEGETARIAN',
          'daily_calories': 1222,
        }
      };
    }
  }
}
