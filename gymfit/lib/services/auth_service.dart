import 'package:gymfit/services/api_service.dart';
import 'package:gymfit/services/mock_auth_service.dart';
import 'package:gymfit/config/app_config.dart';
import 'package:gymfit/models/user.dart';
import 'package:gymfit/utils/constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final MockAuthService _mockService = MockAuthService();
  
  // Toggle this to use mock data instead of real API
  static const bool useMockData = false; // Set to false when backend is ready
  
  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Use mock service in demo mode
      if (useMockData) {
        final mockData = await _mockService.login(email, password);
        
        if (mockData['success']) {
          // Save tokens
          await _apiService.saveAuthTokens(
            mockData['access_token'],
            mockData['refresh_token'],
          );
          
          User user = User.fromJson(mockData['user']);
          
          // Try to restore user data from email-keyed storage
          final prefs = await SharedPreferences.getInstance();
          final allProfiles = prefs.getString(AppConstants.keyUserProfiles);
          
          if (allProfiles != null) {
            try {
              final profilesMap = json.decode(allProfiles) as Map<String, dynamic>;
              if (profilesMap.containsKey(email)) {
                print('🔄 Found existing profile for ${email}, restoring data...');
                final existingUser = User.fromJson(profilesMap[email]);
                // Merge: keep onboarding data from existing profile
                user = user.copyWith(
                  gender: existingUser.gender,
                  dateOfBirth: existingUser.dateOfBirth,
                  currentWeight: existingUser.currentWeight,
                  height: existingUser.height,
                  targetWeight: existingUser.targetWeight,
                  fitnessGoal: existingUser.fitnessGoal,
                  dietaryPreference: existingUser.dietaryPreference,
                  activityLevel: existingUser.activityLevel,
                  targetDays: existingUser.targetDays,
                  foodAllergies: existingUser.foodAllergies,
                  healthConditions: existingUser.healthConditions,
                  hasCompletedOnboarding: existingUser.hasCompletedOnboarding,
                );
                print('✅ Restored profile data: hasCompletedOnboarding=${user.hasCompletedOnboarding}');
              }
            } catch (e) {
              print('⚠️ Error restoring profile: $e');
            }
          }
          
          // Save merged user data
          await _saveUserData(user);
          
          return {
            'success': true,
            'user': user,
            'message': mockData['message'],
          };
        }
        return mockData;
      }
      
      // Real API call
      final response = await _apiService.post(
        AppConfig.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Save tokens from nested tokens object
        final tokens = data['tokens'];
        await _apiService.saveAuthTokens(
          tokens['access'],
          tokens['refresh'],
        );
        
        // Save user data
        final user = User.fromJson(data['user']);
        await _saveUserData(user);
        
        return {
          'success': true,
          'user': user,
          'message': data['message'] ?? 'Login successful',
        };
      }
      
      return {
        'success': false,
        'message': 'Login failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  
  // Register
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      // Use mock service in demo mode
      if (useMockData) {
        final mockData = await _mockService.register(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );
        
        if (mockData['success']) {
          // Save tokens
          await _apiService.saveAuthTokens(
            mockData['access_token'],
            mockData['refresh_token'],
          );
          
          // Save user data
          final user = User.fromJson(mockData['user']);
          await _saveUserData(user);
          
          return {
            'success': true,
            'message': mockData['message'],
          };
        }
        return mockData;
      }
      
      // Real API call
      final response = await _apiService.post(
        AppConfig.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          'password2': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phone,
          'username': email.split('@')[0],
        },
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        
        // Save tokens from nested tokens object
        final tokens = data['tokens'];
        await _apiService.saveAuthTokens(
          tokens['access'],
          tokens['refresh'],
        );
        
        // Save user data
        final user = User.fromJson(data['user']);
        await _saveUserData(user);
        
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
        };
      }
      
      return {
        'success': false,
        'message': 'Registration failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  
  // Logout
  Future<void> logout() async {
    await _apiService.clearAuthTokens();
    // Keep user data in SharedPreferences so onboarding info persists
    // across login/logout cycles
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove(AppConstants.keyUserData);
  }
  
  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // First, migrate any old user_data to email-keyed storage
      await _migrateOldUserData();
      
      final userData = prefs.getString(AppConstants.keyUserData);
      
      print('🔍 Loading user data from storage...');
      print('📦 Stored data exists: ${userData != null}');
      
      if (userData != null) {
        final user = User.fromJson(json.decode(userData));
        print('✅ Loaded user: ${user.email}, hasCompletedOnboarding: ${user.hasCompletedOnboarding}');
        return user;
      }
      
      print('⚠️ No stored data found, returning null');
      
      // Use mock service in demo mode
      if (useMockData) {
        return await _mockService.getCurrentUser();
      }
      
      // Fetch from API
      final response = await _apiService.get(AppConfig.profileEndpoint);
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await _saveUserData(user);
        return user;
      }
    } catch (e) {
      print('❌ Error loading user: $e');
      return null;
    }
    return null;
  }
  
  // Migrate old user_data to email-keyed storage
  Future<void> _migrateOldUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final oldUserData = prefs.getString(AppConstants.keyUserData);
      final allProfiles = prefs.getString(AppConstants.keyUserProfiles);
      
      if (oldUserData != null && allProfiles == null) {
        print('🔄 Migrating old user data to email-keyed storage...');
        final user = User.fromJson(json.decode(oldUserData));
        
        // Create email-keyed storage with this user
        Map<String, dynamic> profilesMap = {
          user.email: user.toJson(),
        };
        
        await prefs.setString(AppConstants.keyUserProfiles, json.encode(profilesMap));
        print('✅ Migration complete for ${user.email}');
      }
    } catch (e) {
      print('⚠️ Migration error (non-critical): $e');
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getAuthToken();
    return token != null;
  }
  
  // Save user data locally
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user.toJson());
    
    // Save current user data
    await prefs.setString(AppConstants.keyUserData, userJson);
    
    // Also save to email-keyed storage for cross-port persistence
    final allProfiles = prefs.getString(AppConstants.keyUserProfiles);
    Map<String, dynamic> profilesMap = {};
    
    if (allProfiles != null) {
      try {
        profilesMap = json.decode(allProfiles);
      } catch (e) {
        print('Error parsing profiles: $e');
      }
    }
    
    // Store user data keyed by email
    profilesMap[user.email] = user.toJson();
    await prefs.setString(AppConstants.keyUserProfiles, json.encode(profilesMap));
    
    print('💾 Saved user data: ${user.email}, hasCompletedOnboarding: ${user.hasCompletedOnboarding}');
    print('📝 Data length: ${userJson.length} characters');
  }
  
  // Public method to save user to storage
  Future<bool> saveUserToStorage(User user) async {
    try {
      await _saveUserData(user);
      return true;
    } catch (e) {
      print('❌ Error saving user: $e');
      return false;
    }
  }
  
  // Update profile on backend
  Future<Map<String, dynamic>> updateProfileOnBackend(Map<String, dynamic> userData) async {
    try {
      print('🌐 Sending profile update to backend API...');
      
      final response = await _apiService.patch(
        AppConfig.profileEndpoint,
        data: {
          'gender': userData['gender']?.toString().toUpperCase(),
          'age': userData['age'],
          'current_weight': userData['currentWeight'],
          'height': userData['height'],
          'target_weight': userData['targetWeight'],
          'fitness_goal': userData['fitnessGoal']?.toString().toUpperCase().replaceAll(' ', '_'),
          'dietary_preference': userData['dietaryPreference']?.toString().toUpperCase().replaceAll(' ', '_'),
          'activity_level': userData['activityLevel']?.toString().toUpperCase().replaceAll(' ', '_'),
          'target_timeline_days': userData['targetDays'],
          'food_allergies': userData['foodAllergies'] ?? [],
          'health_conditions': userData['healthConditions'] ?? [],
          'has_completed_onboarding': userData['hasCompletedOnboarding'] ?? true,
        },
      );
      
      if (response.statusCode == 200) {
        print('✅ Backend profile update successful');
        return {
          'success': true,
          'message': response.data['message'] ?? 'Profile updated',
          'user': response.data['user'],
        };
      }
      
      print('⚠️ Backend returned status: ${response.statusCode}');
      return {
        'success': false,
        'message': 'Failed to update profile on backend',
      };
    } catch (e) {
      print('❌ Error updating backend profile: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  
  // Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      // Use mock service in demo mode
      if (useMockData) {
        return await _mockService.resetPassword(email);
      }
      
      final response = await _apiService.post(
        AppConfig.resetPasswordEndpoint,
        data: {'email': email},
      );
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Password reset link sent to your email',
        };
      }
      
      return {
        'success': false,
        'message': 'Failed to send reset link',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
  
  // Update profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      // Use mock service in demo mode
      if (useMockData) {
        // Get current user from storage
        final prefs = await SharedPreferences.getInstance();
        final userJson = prefs.getString(AppConstants.keyUserData);
        
        if (userJson != null) {
          final currentUser = User.fromJson(json.decode(userJson));
          
          // Update user with new data
          final updatedUser = currentUser.copyWith(
            firstName: data['firstName'] ?? currentUser.firstName,
            lastName: data['lastName'] ?? currentUser.lastName,
            phone: data['phone'] ?? currentUser.phone,
            dateOfBirth: data['dateOfBirth'],
            gender: data['gender'],
            address: data['address'],
            emergencyContact: data['emergencyContact'],
          );
          
          // Save updated user
          await _saveUserData(updatedUser);
          
          // Simulate delay
          await Future.delayed(const Duration(milliseconds: 500));
          
          return {
            'success': true,
            'user': updatedUser,
            'message': 'Profile updated successfully (Demo Mode)',
          };
        }
        
        return {
          'success': false,
          'message': 'User not found',
        };
      }
      
      // Real API call
      final response = await _apiService.patch(
        AppConfig.profileEndpoint,
        data: data,
      );
      
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await _saveUserData(user);
        
        return {
          'success': true,
          'user': user,
          'message': 'Profile updated successfully',
        };
      }
      
      return {
        'success': false,
        'message': 'Failed to update profile',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
