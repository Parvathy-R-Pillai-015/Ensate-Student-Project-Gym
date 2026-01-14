"""
URL configuration for gymfit project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.shortcuts import redirect
from rest_framework.response import Response
from rest_framework.decorators import api_view

def home_redirect(request):
    return redirect('/api/')

@api_view(['GET'])
def api_root(request):
    return Response({
        'message': 'GymFit API',
        'version': '1.0.0',
        'endpoints': {
            'auth': {
                'register': '/api/auth/register/',
                'login': '/api/auth/login/',
                'profile': '/api/auth/profile/',
                'dashboard': '/api/auth/dashboard/',
            },
            'workouts': '/api/workouts/',
            'classes': '/api/classes/',
            'memberships': '/api/memberships/',
            'nutrition': '/api/nutrition/',
            'progress': '/api/progress/',
        }
    })

urlpatterns = [
    path('', home_redirect),
    path('admin/', admin.site.urls),
    path('api/', api_root),
    path('api/auth/', include('users.urls')),
    path('api/nutrition/', include('nutrition.urls')),
]
