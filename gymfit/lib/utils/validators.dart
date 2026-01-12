import 'package:email_validator/email_validator.dart';

class Validators {
  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }
  
  // Confirm Password Validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  // Name Validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }
  
  // Phone Validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
  
  // Required Field Validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // Number Validation
  static String? validateNumber(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }
  
  // Positive Number Validation
  static String? validatePositiveNumber(String? value, {String fieldName = 'Value'}) {
    final numberError = validateNumber(value, fieldName: fieldName);
    if (numberError != null) return numberError;
    
    if (double.parse(value!) <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }
  
  // Date Validation
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }
    return null;
  }
  
  // Age Validation
  static String? validateAge(String? value) {
    final numberError = validateNumber(value, fieldName: 'Age');
    if (numberError != null) return numberError;
    
    final age = int.parse(value!);
    if (age < 13 || age > 120) {
      return 'Please enter a valid age between 13 and 120';
    }
    return null;
  }
  
  // Weight Validation (kg)
  static String? validateWeight(String? value) {
    final numberError = validatePositiveNumber(value, fieldName: 'Weight');
    if (numberError != null) return numberError;
    
    final weight = double.parse(value!);
    if (weight < 20 || weight > 300) {
      return 'Please enter a valid weight between 20 and 300 kg';
    }
    return null;
  }
  
  // Height Validation (cm)
  static String? validateHeight(String? value) {
    final numberError = validatePositiveNumber(value, fieldName: 'Height');
    if (numberError != null) return numberError;
    
    final height = double.parse(value!);
    if (height < 100 || height > 250) {
      return 'Please enter a valid height between 100 and 250 cm';
    }
    return null;
  }
}
