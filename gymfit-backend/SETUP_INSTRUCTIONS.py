# Setup script for GymFit Backend
# Run this after: python manage.py startproject gymfit . and creating apps

import os
import django

# Copy this content to gymfit/settings.py after INSTALLED_APPS

INSTALLED_APPS_ADDITIONS = """
# Django REST Framework
'rest_framework',
'rest_framework_simplejwt',
'corsheaders',

# GymFit Apps
'users',
'workouts',
'nutrition',
'memberships',
'classes',
'progress',
"""

MIDDLEWARE_ADDITIONS = """
Add 'corsheaders.middleware.CorsMiddleware', at the top of MIDDLEWARE
"""

SETTINGS_ADDITIONS = """
# Add to end of settings.py:

from dotenv import load_dotenv
load_dotenv()

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.getenv('DB_NAME', 'gymfit_db'),
        'USER': os.getenv('DB_USER', 'root'),
        'PASSWORD': os.getenv('DB_PASSWORD', ''),
        'HOST': os.getenv('DB_HOST', 'localhost'),
        'PORT': os.getenv('DB_PORT', '3306'),
        'OPTIONS': {
            'charset': 'utf8mb4',
        }
    }
}

# REST Framework
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticated',
    ],
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
}

# JWT Settings
from datetime import timedelta
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=int(os.getenv('JWT_ACCESS_TOKEN_LIFETIME', 60))),
    'REFRESH_TOKEN_LIFETIME': timedelta(minutes=int(os.getenv('JWT_REFRESH_TOKEN_LIFETIME', 1440))),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
}

# CORS Settings
CORS_ALLOWED_ORIGINS = os.getenv('CORS_ALLOWED_ORIGINS', '').split(',')
CORS_ALLOW_CREDENTIALS = True

# Custom User Model
AUTH_USER_MODEL = 'users.User'
"""

print("GymFit Backend Setup Instructions")
print("=" * 50)
print("\\n1. Update gymfit/settings.py:")
print("   - Add apps to INSTALLED_APPS")
print("   - Add corsheaders middleware")
print("   - Add settings at the end")
print("\\n2. Create .env file from .env.example")
print("\\n3. Install MySQL client: pip install mysqlclient")
print("\\n4. Create database in MySQL")
print("\\n5. Run migrations: python manage.py migrate")
