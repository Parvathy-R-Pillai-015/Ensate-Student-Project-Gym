from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth import get_user_model

User = get_user_model()

@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ['email', 'username', 'first_name', 'last_name', 'fitness_goal', 'has_completed_onboarding', 'is_staff']
    list_filter = ['fitness_goal', 'activity_level', 'dietary_preference', 'has_completed_onboarding', 'is_staff']
    search_fields = ['email', 'username', 'first_name', 'last_name']
    
    fieldsets = BaseUserAdmin.fieldsets + (
        ('Personal Info', {
            'fields': ('phone_number', 'date_of_birth', 'gender', 'age', 'profile_image')
        }),
        ('Physical Attributes', {
            'fields': ('current_weight', 'target_weight', 'height')
        }),
        ('Fitness Profile', {
            'fields': ('fitness_goal', 'activity_level', 'dietary_preference', 'target_daily_calories', 'target_timeline_days')
        }),
        ('Health Information', {
            'fields': ('food_allergies', 'health_conditions')
        }),
        ('Onboarding', {
            'fields': ('has_completed_onboarding',)
        }),
    )
