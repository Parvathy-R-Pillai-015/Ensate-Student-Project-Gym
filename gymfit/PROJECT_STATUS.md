# GymFit - Gym & Fitness Management Application

A comprehensive gym and fitness management platform built with Flutter, following the Software Requirements Specification document.

## 📱 Features Implemented

### Phase 1 - Foundation (✅ Complete)

#### 1. **Project Setup**
- ✅ Clean project structure with organized folders
- ✅ All required dependencies configured
- ✅ Material Design 3 with custom theme (Light/Dark mode support)
- ✅ Google Fonts integration (Poppins)

#### 2. **Core Utilities**
- ✅ **Configuration Files**
  - API configuration with endpoints
  - Theme configuration with custom colors
  - App constants for roles, statuses, and categories
  
- ✅ **Helper Functions**
  - Date/time formatting
  - BMI calculation
  - Calorie calculation
  - Number formatting
  - Text utilities
  
- ✅ **Validators**
  - Email validation
  - Password strength validation
  - Phone number validation
  - Numeric validators
  - Height/weight validators

#### 3. **Data Models**
- ✅ User model with role management
- ✅ Membership & MembershipPlan models
- ✅ Workout & Exercise models
- ✅ GymClass & ClassBooking models
- ✅ Progress & Goal models

#### 4. **Services**
- ✅ **API Service**
  - Dio HTTP client setup
  - JWT token management
  - Automatic token refresh
  - Error handling
  - File upload support
  
- ✅ **Authentication Service**
  - Login functionality
  - Registration
  - Password reset
  - Profile management
  - Secure token storage

#### 5. **State Management**
- ✅ Provider pattern implementation
- ✅ AuthProvider with complete auth flow
- ✅ Loading states
- ✅ Error handling

#### 6. **Screens**
- ✅ **Login Screen**
  - Email/password authentication
  - Form validation
  - Password visibility toggle
  - Social login placeholder
  - Navigation to registration
  
- ✅ **Register Screen**
  - Multi-field registration form
  - Password confirmation
  - Terms acceptance
  - Complete validation
  
- ✅ **Member Home Screen**
  - Personalized greeting
  - Quick stats dashboard
  - Membership status card
  - Quick action buttons
  - Logout functionality

## 🏗️ Project Structure

\`\`\`
lib/
├── config/
│   ├── app_config.dart          # API endpoints and app configuration
│   └── theme_config.dart        # Light and dark theme definitions
├── models/
│   ├── user.dart                # User model
│   ├── membership.dart          # Membership models
│   ├── workout.dart             # Workout and exercise models
│   ├── gym_class.dart           # Class and booking models
│   └── progress.dart            # Progress tracking models
├── providers/
│   └── auth_provider.dart       # Authentication state management
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart    # Login page
│   │   └── register_screen.dart # Registration page
│   ├── member/
│   │   └── member_home_screen.dart
│   ├── trainer/                 # Trainer screens (planned)
│   └── admin/                   # Admin screens (planned)
├── services/
│   ├── api_service.dart         # HTTP client and API calls
│   └── auth_service.dart        # Authentication logic
├── utils/
│   ├── constants.dart           # App constants
│   ├── validators.dart          # Form validators
│   └── helpers.dart             # Helper functions
├── widgets/                     # Reusable widgets (to be added)
└── main.dart                    # App entry point
\`\`\`

## 🔧 Technologies Used

- **Frontend**: Flutter 3.x / Dart 3.x
- **Backend**: Django REST Framework (separate project needed)
- **Database**: MySQL 8.x (backend)
- **State Management**: Provider
- **HTTP Client**: Dio
- **Storage**: SharedPreferences + Flutter Secure Storage
- **UI Components**: Material Design 3, Google Fonts

## 📋 Requirements Implemented (from SRS)

### Functional Requirements
- ✅ FR-001: User registration with email, phone, password
- ✅ FR-002: JWT token authentication
- ✅ FR-003: Password reset support (structure)
- ✅ FR-005: Role-based access control (Member, Trainer, Admin)

### Non-Functional Requirements
- ✅ NFR-010: HTTPS/TLS encryption ready
- ✅ NFR-011: Password hashing (backend requirement)
- ✅ NFR-030: Cross-platform iOS, Android, Web support
- ✅ NFR-032: Light and dark mode themes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.4 or higher
- Dart SDK 3.x
- Android Studio / VS Code
- Django backend server (separate setup required)

### Installation

1. **Clone the repository**
   \`\`\`bash
   cd "c:/GYM PROJECT/gymfit"
   \`\`\`

2. **Install dependencies**
   \`\`\`bash
   flutter pub get
   \`\`\`

3. **Configure API endpoint**
   Update `lib/config/app_config.dart` with your backend URL:
   \`\`\`dart
   static const String baseUrl = 'http://your-backend-url/api';
   \`\`\`

4. **Run the app**
   \`\`\`bash
   flutter run
   \`\`\`

## 🔐 API Configuration

The app expects the following Django backend endpoints:

- `POST /api/auth/login/` - User login
- `POST /api/auth/register/` - User registration
- `POST /api/auth/password-reset/` - Password reset
- `POST /api/auth/token/refresh/` - Token refresh
- `GET /api/users/profile/` - Get user profile
- `PATCH /api/users/profile/` - Update user profile

## 📱 Screenshots & Demo

### Current Screens:
1. **Login Screen** - Clean, modern authentication
2. **Register Screen** - Comprehensive registration form
3. **Home Dashboard** - Personalized member dashboard

## 🎯 Next Steps (Planned Features)

### Phase 2 - Core Features
- [ ] Membership management screens
- [ ] Workout tracking interface
- [ ] Exercise library
- [ ] Class scheduling calendar
- [ ] Booking system

### Phase 3 - Advanced Features
- [ ] Progress tracking with charts
- [ ] Goal setting
- [ ] Nutrition planning
- [ ] Meal logging
- [ ] QR code membership cards

### Phase 4 - Professional Features
- [ ] Trainer dashboard
- [ ] Admin panel
- [ ] Push notifications
- [ ] Real-time chat
- [ ] Reports and analytics

## 🐛 Known Issues
- Backend integration pending
- Some validation messages may need adjustment
- Social login features are placeholders

## 📝 Development Notes

### Code Quality
- All models include JSON serialization
- Comprehensive error handling
- Form validation on all inputs
- Secure token storage
- Clean architecture pattern

### Design Decisions
- Material Design 3 for modern UI
- Provider for scalable state management
- Dio for robust API communication
- Secure storage for sensitive data
- Modular structure for easy maintenance

## 🤝 Contributing

This is an academic project following the GymFit SRS specification.

## 📄 License

Academic Project - All rights reserved

## 👥 Team

Developed according to GymFit Software Requirements Specification v1.0 (December 2025)

---

**Note**: This app requires a Django backend server to be fully functional. The backend should implement the REST API endpoints as specified in the SRS document.
