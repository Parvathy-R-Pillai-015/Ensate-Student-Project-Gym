import 'package:flutter/material.dart';
import 'package:gymfit/models/user.dart';
import 'package:gymfit/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  
  // Check authentication status on startup
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await _authService.getCurrentUser();
        _isAuthenticated = _currentUser != null;
        print('🔄 Auth status checked: authenticated=${_isAuthenticated}, user=${_currentUser?.email}');
      } else {
        print('⚠️ No active session found');
      }
    } catch (e) {
      print('❌ Error checking auth status: $e');
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      final result = await _authService.login(email, password);
      
      if (result['success']) {
        _currentUser = result['user'];
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      final result = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      
      if (result['success']) {
        // Auto-login after successful registration if tokens are provided
        if (await _authService.isLoggedIn()) {
          _currentUser = await _authService.getCurrentUser();
          _isAuthenticated = _currentUser != null;
        }
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      final result = await _authService.resetPassword(email);
      
      if (!result['success']) {
        _errorMessage = result['message'];
      }
      
      notifyListeners();
      return result['success'];
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Update profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      final result = await _authService.updateProfile(data);
      
      if (result['success']) {
        _currentUser = result['user'];
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  bool isMember() => _currentUser?.role == 'MEMBER';
  bool isTrainer() => _currentUser?.role == 'TRAINER';
  bool isAdmin() => _currentUser?.role == 'ADMIN';
  
  // Update user profile with onboarding data
  Future<bool> updateUserProfile(Map<String, dynamic> userData) async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      print('🔄 Updating user profile with data: $userData');
      print('📋 hasCompletedOnboarding from data: ${userData['hasCompletedOnboarding']}');
      
      // Update the local user object
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          gender: userData['gender'],
          currentWeight: userData['currentWeight'],
          height: userData['height'],
          targetWeight: userData['targetWeight'],
          fitnessGoal: userData['fitnessGoal'],
          dietaryPreference: userData['dietaryPreference'],
          activityLevel: userData['activityLevel'],
          targetDays: userData['targetDays'],
          foodAllergies: userData['foodAllergies'],
          healthConditions: userData['healthConditions'],
          hasCompletedOnboarding: userData['hasCompletedOnboarding'] ?? true,
        );
        
        print('✨ Updated user object: hasCompletedOnboarding = ${_currentUser!.hasCompletedOnboarding}');
        
        // Send data to backend API
        final backendResult = await _authService.updateProfileOnBackend(userData);
        if (backendResult['success'] == true) {
          print('✅ Profile updated on backend');
          // Update local user with response if available
          if (backendResult['user'] != null) {
            _currentUser = User.fromJson(backendResult['user']);
          }
        } else {
          print('⚠️ Backend update failed: ${backendResult['message']}');
          // Continue with local save even if backend fails
        }
        
        // Save updated user data to persistent storage
        final result = await _authService.saveUserToStorage(_currentUser!);
        
        if (result) {
          print('✅ Profile updated successfully');
          notifyListeners();
          return true;
        } else {
          print('❌ Failed to save to storage');
        }
      } else {
        print('❌ No current user to update');
      }
      return false;
    } catch (e) {
      print('❌ Error updating profile: $e');
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
