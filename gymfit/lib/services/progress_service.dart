import 'package:gymfit/services/api_service.dart';
import 'package:gymfit/models/progress.dart';

class ProgressService {
  final ApiService _apiService = ApiService();

  // Get all progress entries
  Future<List<Progress>> getProgressEntries({int? limit}) async {
    try {
      final response = await _apiService.get(
        '/progress/',
        queryParameters: limit != null ? {'limit': limit} : null,
      );
      return (response.data as List)
          .map((json) => Progress.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch progress entries: $e');
    }
  }

  // Get single progress entry
  Future<Progress> getProgress(int id) async {
    try {
      final response = await _apiService.get('/progress/$id/');
      return Progress.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch progress entry: $e');
    }
  }

  // Create progress entry
  Future<Progress> createProgress(Progress progress) async {
    try {
      final response = await _apiService.post(
        '/progress/',
        data: progress.toJson(),
      );
      return Progress.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create progress entry: $e');
    }
  }

  // Update progress entry
  Future<Progress> updateProgress(int id, Progress progress) async {
    try {
      final response = await _apiService.put(
        '/progress/$id/',
        data: progress.toJson(),
      );
      return Progress.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update progress entry: $e');
    }
  }

  // Delete progress entry
  Future<void> deleteProgress(int id) async {
    try {
      await _apiService.delete('/progress/$id/');
    } catch (e) {
      throw Exception('Failed to delete progress entry: $e');
    }
  }

  // Upload progress photo
  Future<String> uploadPhoto(String filePath) async {
    try {
      final response = await _apiService.uploadFile(
        '/progress/upload-photo/',
        filePath,
      );
      return response.data['photo_url'];
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  // Get progress statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await _apiService.get('/progress/statistics/');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch progress statistics: $e');
    }
  }
}
