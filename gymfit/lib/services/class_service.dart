import 'package:gymfit/services/api_service.dart';
import 'package:gymfit/models/gym_class.dart';

class ClassService {
  final ApiService _apiService = ApiService();

  // Get all available classes
  Future<List<GymClass>> getClasses({DateTime? startDate, DateTime? endDate}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _apiService.get(
        '/classes/',
        queryParameters: queryParams,
      );
      return (response.data as List)
          .map((json) => GymClass.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch classes: $e');
    }
  }

  // Get user's bookings
  Future<List<GymClass>> getMyBookings() async {
    try {
      final response = await _apiService.get('/classes/my-bookings/');
      return (response.data as List)
          .map((json) => GymClass.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  // Book a class
  Future<void> bookClass(int classId) async {
    try {
      await _apiService.post(
        '/classes/$classId/book/',
        data: {},
      );
    } catch (e) {
      throw Exception('Failed to book class: $e');
    }
  }

  // Cancel booking
  Future<void> cancelBooking(int classId) async {
    try {
      await _apiService.delete('/classes/$classId/cancel/');
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  // Check if user has booked a class
  Future<bool> isClassBooked(int classId) async {
    try {
      final response = await _apiService.get('/classes/$classId/is-booked/');
      return response.data['is_booked'] ?? false;
    } catch (e) {
      return false;
    }
  }
}
