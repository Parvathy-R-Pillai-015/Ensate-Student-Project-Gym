from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    """Custom User model with fitness profile fields"""
    
    GENDER_CHOICES = [
        ('MALE', 'Male'),
        ('FEMALE', 'Female'),
        ('OTHER', 'Other'),
    ]
    
    FITNESS_GOAL_CHOICES = [
        ('WEIGHT_LOSS', 'Weight Loss'),
        ('WEIGHT_GAIN', 'Weight Gain'),
        ('MUSCLE_GAIN', 'Muscle Gain'),
        ('GENERAL_FITNESS', 'General Fitness'),
        ('ENDURANCE', 'Endurance'),
    ]
    
    ACTIVITY_LEVEL_CHOICES = [
        ('SEDENTARY', 'Sedentary'),
        ('LIGHTLY_ACTIVE', 'Lightly Active'),
        ('MODERATELY_ACTIVE', 'Moderately Active'),
        ('VERY_ACTIVE', 'Very Active'),
        ('EXTREMELY_ACTIVE', 'Extremely Active'),
    ]
    
    DIETARY_PREFERENCE_CHOICES = [
        ('VEGETARIAN', 'Vegetarian'),
        ('NON_VEGETARIAN', 'Non-Vegetarian'),
        ('VEGAN', 'Vegan'),
        ('PESCATARIAN', 'Pescatarian'),
    ]
    
    # Basic Info
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    date_of_birth = models.DateField(blank=True, null=True)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, blank=True, null=True)
    
    # Physical Attributes
    age = models.IntegerField(blank=True, null=True)
    current_weight = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True, help_text="Weight in kg")
    target_weight = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True, help_text="Target weight in kg")
    height = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True, help_text="Height in cm")
    
    # Fitness Profile
    fitness_goal = models.CharField(max_length=20, choices=FITNESS_GOAL_CHOICES, blank=True, null=True)
    activity_level = models.CharField(max_length=20, choices=ACTIVITY_LEVEL_CHOICES, blank=True, null=True)
    dietary_preference = models.CharField(max_length=20, choices=DIETARY_PREFERENCE_CHOICES, blank=True, null=True)
    
    # Allergies and Health
    food_allergies = models.JSONField(default=list, blank=True, help_text="List of food allergies")
    health_conditions = models.JSONField(default=list, blank=True, help_text="List of health conditions")
    
    # Goals and Targets
    target_daily_calories = models.IntegerField(blank=True, null=True, help_text="Target daily calorie intake")
    target_timeline_days = models.IntegerField(blank=True, null=True, help_text="Days to achieve fitness goal")
    
    # Onboarding Status
    has_completed_onboarding = models.BooleanField(default=False)
    
    # Profile Image
    profile_image = models.ImageField(upload_to='profile_images/', blank=True, null=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'users'
        ordering = ['-created_at']
    
    def __str__(self):
        return self.email
    
    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}".strip() or self.username
    
    def calculate_bmi(self):
        """Calculate BMI if height and weight are available"""
        if self.current_weight and self.height:
            height_m = float(self.height) / 100
            bmi = float(self.current_weight) / (height_m ** 2)
            return round(bmi, 2)
        return None
    
    def calculate_daily_calories(self):
        """Calculate recommended daily calories"""
        if not all([self.current_weight, self.height, self.age, self.gender]):
            return None
        
        weight_kg = float(self.current_weight)
        height_cm = float(self.height)
        age = self.age
        
        if self.gender == 'MALE':
            bmr = (10 * weight_kg) + (6.25 * height_cm) - (5 * age) + 5
        else:
            bmr = (10 * weight_kg) + (6.25 * height_cm) - (5 * age) - 161
        
        activity_multipliers = {
            'SEDENTARY': 1.2,
            'LIGHTLY_ACTIVE': 1.375,
            'MODERATELY_ACTIVE': 1.55,
            'VERY_ACTIVE': 1.725,
            'EXTREMELY_ACTIVE': 1.9,
        }
        
        multiplier = activity_multipliers.get(self.activity_level, 1.2)
        tdee = bmr * multiplier
        
        if self.fitness_goal == 'WEIGHT_LOSS':
            target_calories = tdee - 500  # Calorie deficit for weight loss
        elif self.fitness_goal == 'WEIGHT_GAIN':
            target_calories = tdee + 500  # Higher surplus for weight gain
        elif self.fitness_goal == 'MUSCLE_GAIN':
            target_calories = tdee + 400  # Moderate surplus for muscle gain
        else:
            target_calories = tdee  # Maintenance
        
        return int(target_calories)
