import 'package:gymfit/models/user.dart';
import 'dart:async';

/// Mock Auth Service for testing without backend
/// This simulates API responses for demo purposes
class MockAuthService {
  // Simulated delay to mimic network requests
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }
  
  // Mock login
  Future<Map<String, dynamic>> login(String email, String password) async {
    await _simulateNetworkDelay();
    
    // Extract name from email (e.g., john.doe@email.com -> John Doe)
    String firstName = 'User';
    String lastName = '';
    
    if (email.contains('@')) {
      final username = email.split('@')[0];
      final nameParts = username.split('.');
      if (nameParts.isNotEmpty) {
        firstName = nameParts[0].isNotEmpty 
            ? nameParts[0][0].toUpperCase() + nameParts[0].substring(1)
            : 'User';
        if (nameParts.length > 1) {
          lastName = nameParts[1].isNotEmpty
              ? nameParts[1][0].toUpperCase() + nameParts[1].substring(1)
              : '';
        }
      }
    }
    
    // Simulate successful login
    return {
      'success': true,
      'access_token': 'mock_access_token_12345',
      'refresh_token': 'mock_refresh_token_67890',
      'user': {
        'id': 1,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'role': 'MEMBER',
        'phone': '+1234567890',
        'profile_image': null,
        'is_active': true,
      },
      'message': 'Login successful (Demo Mode)',
    };
  }
  
  // Mock registration
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    await _simulateNetworkDelay();
    
    // Simulate successful registration with auto-login
    return {
      'success': true,
      'access_token': 'mock_access_token_12345',
      'refresh_token': 'mock_refresh_token_67890',
      'user': {
        'id': 1,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'role': 'MEMBER',
        'phone': phone,
        'profile_image': null,
        'is_active': true,
      },
      'message': 'Registration successful (Demo Mode)',
    };
  }
  
  // Mock get current user
  Future<User?> getCurrentUser() async {
    await _simulateNetworkDelay();
    
    return User(
      id: 1,
      email: 'demo@gymfit.com',
      firstName: 'Demo',
      lastName: 'User',
      role: 'MEMBER',
      phone: '+1234567890',
      isActive: true,
    );
  }
  
  // Mock reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    await _simulateNetworkDelay();
    
    return {
      'success': true,
      'message': 'Password reset email sent (Demo Mode)',
    };
  }
}
