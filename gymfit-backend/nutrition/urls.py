from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'foods', views.FoodItemViewSet, basename='food')
router.register(r'daily-log', views.DailyFoodLogViewSet, basename='daily-food-log')

urlpatterns = [
    path('', include(router.urls)),
]
