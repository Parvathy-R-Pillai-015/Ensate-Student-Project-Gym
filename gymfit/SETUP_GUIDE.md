# GymFit - Quick Setup Guide

## ✅ What's Been Built

I've created the foundation for your GymFit application based on the SRS document. Here's what's ready:

### 🎨 **Completed Features**

1. **Authentication System**
   - Login screen with email/password
   - Registration screen with full validation
   - Secure token storage
   - Auto-login after registration
   - Password visibility toggles

2. **Project Architecture**
   - Clean folder structure
   - 5 data models (User, Membership, Workout, Class, Progress)
   - API service with JWT authentication
   - Authentication state management with Provider
   - Theme configuration (Light & Dark mode)

3. **Utilities & Helpers**
   - Form validators (email, password, phone, etc.)
   - Helper functions (BMI, calories, date formatting)
   - Constants for roles, categories, muscle groups

4. **Member Dashboard**
   - Personalized greeting
   - Quick stats cards
   - Membership status
   - Quick action buttons

## 🚀 **How to Run the App**

### Option 1: Run on Mobile Emulator/Device

\`\`\`bash
# Make sure you're in the project directory
cd "c:\\GYM PROJECT\\gymfit"

# Run the app
flutter run
\`\`\`

### Option 2: Run on Web Browser

\`\`\`bash
flutter run -d chrome
\`\`\`

### Option 3: Run on Windows Desktop

\`\`\`bash
flutter run -d windows
\`\`\`

## ⚙️ **Backend Configuration**

The app is ready for backend integration. Update the API endpoint:

**File**: \`lib/config/app_config.dart\`

\`\`\`dart
static const String baseUrl = 'http://localhost:8000/api'; // Change this
\`\`\`

### Expected Django API Endpoints:

\`\`\`
POST   /api/auth/login/           - Login
POST   /api/auth/register/        - Register
POST   /api/auth/password-reset/  - Reset password
POST   /api/auth/token/refresh/   - Refresh token
GET    /api/users/profile/        - Get profile
PATCH  /api/users/profile/        - Update profile
\`\`\`

## 📱 **Testing Without Backend**

The app will show network errors when trying to login/register without a backend. To test the UI:

1. **View Login Screen**: The app opens directly to the login screen
2. **View Register Screen**: Tap "Sign Up" on the login screen
3. **Test Form Validation**: Try submitting empty forms to see validators in action

## 🎯 **Next Development Steps**

### Immediate Next Features:
1. **Membership Screens**
   - View available plans
   - Purchase membership
   - View membership card with QR code

2. **Workout Tracking**
   - Exercise library browser
   - Create workout routines
   - Log workout sessions
   - View workout history

3. **Class Booking**
   - Weekly class schedule
   - Book/cancel classes
   - View booked classes

### Color Scheme:
- **Primary**: Purple (#6C63FF) - Main actions
- **Secondary**: Pink (#FF6584) - Accents
- **Success**: Green (#28A745) - Confirmations
- **Error**: Red (#DC3545) - Errors

## 📦 **Installed Packages**

All dependencies are already installed:
- ✅ provider - State management
- ✅ dio - HTTP client
- ✅ flutter_secure_storage - Token storage
- ✅ shared_preferences - User data storage
- ✅ google_fonts - Typography
- ✅ fl_chart - Charts (for progress tracking)
- ✅ table_calendar - Calendar (for classes)
- ✅ image_picker - Photo uploads
- ✅ qr_flutter - QR code generation
- ✅ firebase_messaging - Push notifications
- ✅ And many more...

## 🔍 **Project Structure Overview**

\`\`\`
lib/
├── config/         → App configuration & themes
├── models/         → Data models (User, Membership, etc.)
├── providers/      → State management
├── screens/        → UI screens organized by role
│   ├── auth/      → Login, Register
│   ├── member/    → Member screens
│   ├── trainer/   → Trainer screens (planned)
│   └── admin/     → Admin screens (planned)
├── services/       → API calls & business logic
├── utils/          → Helpers, validators, constants
├── widgets/        → Reusable widgets (to be added)
└── main.dart       → App entry point
\`\`\`

## 💡 **Tips for Development**

1. **Hot Reload**: Press 'r' in terminal or Ctrl+S to see changes instantly
2. **Hot Restart**: Press 'R' for full app restart
3. **Debug Console**: Check terminal for errors
4. **State Management**: All auth state is in AuthProvider

## 🐛 **Common Issues & Solutions**

### Issue: "No device found"
**Solution**: 
\`\`\`bash
flutter devices  # See available devices
flutter emulators --launch <emulator_name>  # Start emulator
\`\`\`

### Issue: "Package not found"
**Solution**:
\`\`\`bash
flutter pub get
flutter clean
flutter pub get
\`\`\`

### Issue: API errors
**Solution**: Make sure backend is running and baseUrl is correct

## 📚 **Resources**

- **SRS Document**: Refer to your GymFit_SRS.pdf for full requirements
- **Flutter Docs**: https://flutter.dev/docs
- **Material Design**: https://m3.material.io

## 🎉 **What You Can Do Now**

1. ✅ Run the app and see the login screen
2. ✅ Test form validation
3. ✅ View the member dashboard design
4. ✅ Start building the backend API
5. ✅ Add more screens based on SRS requirements

---

**Need to add a feature?** All models, services, and utilities are ready. Just create new screens and connect them to the services!

**Questions?** Check the code comments - every file is well-documented.
