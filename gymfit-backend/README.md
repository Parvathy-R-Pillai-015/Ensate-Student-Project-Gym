# GymFit Backend

Django REST API backend for the GymFit fitness application.

## Prerequisites

- Python 3.10 or higher
- MySQL 8.0 or higher
- pip (Python package manager)

## Setup Instructions

### 1. Create Virtual Environment

```bash
cd "c:\GYM PROJECT\gymfit-backend"
python -m venv venv
venv\Scripts\activate
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Configure MySQL Database

Create a MySQL database:

```sql
CREATE DATABASE gymfit_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'gymfit_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON gymfit_db.* TO 'gymfit_user'@'localhost';
FLUSH PRIVILEGES;
```

### 4. Environment Configuration

Copy `.env.example` to `.env` and update the values:

```bash
copy .env.example .env
```

Edit `.env` and set your database credentials and secret key.

### 5. Run Migrations

```bash
python manage.py makemigrations
python manage.py migrate
```

### 6. Create Superuser

```bash
python manage.py createsuperuser
```

### 7. Run Development Server

```bash
python manage.py runserver
```

The API will be available at `http://localhost:8000/`

## API Endpoints

### Authentication
- `POST /api/auth/register/` - User registration
- `POST /api/auth/login/` - User login (returns JWT tokens)
- `POST /api/auth/token/refresh/` - Refresh access token
- `POST /api/auth/logout/` - Logout user

### User Profile
- `GET /api/profile/` - Get current user profile
- `PUT /api/profile/` - Update user profile
- `PATCH /api/profile/` - Partial update user profile

### Workouts
- `GET /api/workouts/` - List user workouts
- `POST /api/workouts/` - Create workout
- `GET /api/workouts/{id}/` - Get workout details
- `PUT /api/workouts/{id}/` - Update workout
- `DELETE /api/workouts/{id}/` - Delete workout

### Nutrition
- `GET /api/nutrition/meals/` - List meals
- `POST /api/nutrition/meals/` - Log meal
- `GET /api/nutrition/goals/` - Get nutrition goals
- `PUT /api/nutrition/goals/` - Update nutrition goals

### Memberships
- `GET /api/memberships/` - List memberships
- `POST /api/memberships/` - Create membership
- `GET /api/memberships/{id}/` - Get membership details

### Classes
- `GET /api/classes/` - List gym classes
- `POST /api/classes/book/` - Book a class
- `GET /api/classes/my-bookings/` - Get user's bookings

### Progress
- `GET /api/progress/` - Get progress records
- `POST /api/progress/` - Log progress
- `GET /api/progress/stats/` - Get statistics

## Admin Panel

Access the Django admin panel at `http://localhost:8000/admin/`

## Project Structure

```
gymfit-backend/
├── gymfit/              # Main project settings
├── users/               # User authentication & profiles
├── workouts/            # Workout management
├── nutrition/           # Nutrition tracking
├── memberships/         # Membership management
├── classes/             # Class bookings
├── progress/            # Progress tracking
├── requirements.txt     # Python dependencies
├── manage.py           # Django management script
└── .env                # Environment variables
```

## Connect Flutter App

In your Flutter app, update `lib/services/auth_service.dart`:

```dart
static const bool useMockData = false; // Change to false
```

And update `lib/config/app_config.dart`:

```dart
static const String baseUrl = 'http://localhost:8000';
```
