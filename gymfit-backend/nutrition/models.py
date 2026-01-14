from django.db import models
from users.models import User


class NutritionPlan(models.Model):
    """Personalized nutrition plan for each user"""
    
    PLAN_TYPE_CHOICES = [
        ('WEIGHT_LOSS', 'Weight Loss'),
        ('WEIGHT_GAIN', 'Weight Gain'),
        ('MUSCLE_GAIN', 'Muscle Gain'),
        ('MAINTENANCE', 'Maintenance'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='nutrition_plans')
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    
    # Plan Configuration
    plan_type = models.CharField(max_length=20, choices=PLAN_TYPE_CHOICES)
    dietary_preference = models.CharField(max_length=20)  # VEGETARIAN, VEGAN, etc.
    
    # Nutritional Targets
    daily_calories = models.IntegerField(help_text="Daily calorie target")
    daily_protein_g = models.IntegerField(help_text="Daily protein target in grams")
    daily_carbs_g = models.IntegerField(help_text="Daily carbs target in grams")
    daily_fats_g = models.IntegerField(help_text="Daily fats target in grams")
    daily_fiber_g = models.IntegerField(blank=True, null=True)
    
    # Meal Configuration
    meals_per_day = models.IntegerField(default=3, help_text="Number of meals per day")
    
    # Status
    is_active = models.BooleanField(default=True)
    start_date = models.DateField(blank=True, null=True)
    end_date = models.DateField(blank=True, null=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.user.full_name} - {self.name}"


class FoodItem(models.Model):
    """Food item library with nutritional information"""
    
    CATEGORY_CHOICES = [
        ('PROTEIN', 'Protein'),
        ('CARBS', 'Carbohydrates'),
        ('VEGETABLES', 'Vegetables'),
        ('FRUITS', 'Fruits'),
        ('DAIRY', 'Dairy'),
        ('GRAINS', 'Grains'),
        ('FATS', 'Fats & Oils'),
        ('SNACKS', 'Snacks'),
        ('BEVERAGES', 'Beverages'),
    ]
    
    DIETARY_TYPE_CHOICES = [
        ('VEGETARIAN', 'Vegetarian'),
        ('NON_VEGETARIAN', 'Non-Vegetarian'),
        ('VEGAN', 'Vegan'),
        ('PESCATARIAN', 'Pescatarian'),
    ]
    
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES)
    dietary_type = models.CharField(max_length=20, choices=DIETARY_TYPE_CHOICES)
    
    # Nutritional Information (per 100g)
    serving_size_g = models.DecimalField(max_digits=6, decimal_places=1, default=100)
    calories = models.IntegerField(help_text="Calories per serving")
    protein_g = models.DecimalField(max_digits=5, decimal_places=1, help_text="Protein in grams")
    carbs_g = models.DecimalField(max_digits=5, decimal_places=1, help_text="Carbs in grams")
    fats_g = models.DecimalField(max_digits=5, decimal_places=1, help_text="Fats in grams")
    fiber_g = models.DecimalField(max_digits=5, decimal_places=1, blank=True, null=True)
    
    # Additional Info
    common_allergens = models.JSONField(default=list, blank=True, help_text="List of common allergens")
    image_url = models.URLField(blank=True, null=True)
    
    # Metadata
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['name']
    
    def __str__(self):
        return self.name


class MealPlan(models.Model):
    """Daily meal plan with multiple meals"""
    
    nutrition_plan = models.ForeignKey(NutritionPlan, on_delete=models.CASCADE, related_name='meal_plans')
    day_number = models.IntegerField(help_text="Day number in the nutrition plan")
    date = models.DateField(blank=True, null=True)
    
    # Daily Totals
    total_calories = models.IntegerField(default=0)
    total_protein_g = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    total_carbs_g = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    total_fats_g = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    
    notes = models.TextField(blank=True)
    
    class Meta:
        ordering = ['nutrition_plan', 'day_number']
        unique_together = ['nutrition_plan', 'day_number']
    
    def __str__(self):
        return f"{self.nutrition_plan.name} - Day {self.day_number}"


class Meal(models.Model):
    """Individual meal in a day"""
    
    MEAL_TYPE_CHOICES = [
        ('BREAKFAST', 'Breakfast'),
        ('MORNING_SNACK', 'Morning Snack'),
        ('LUNCH', 'Lunch'),
        ('AFTERNOON_SNACK', 'Afternoon Snack'),
        ('DINNER', 'Dinner'),
        ('EVENING_SNACK', 'Evening Snack'),
    ]
    
    meal_plan = models.ForeignKey(MealPlan, on_delete=models.CASCADE, related_name='meals')
    meal_type = models.CharField(max_length=20, choices=MEAL_TYPE_CHOICES)
    meal_name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    
    # Timing
    scheduled_time = models.TimeField(blank=True, null=True)
    
    # Nutritional Totals
    total_calories = models.IntegerField(default=0)
    total_protein_g = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    total_carbs_g = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    total_fats_g = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    
    # Recipe/Instructions
    recipe_instructions = models.TextField(blank=True)
    preparation_time_minutes = models.IntegerField(blank=True, null=True)
    
    # Order
    order = models.IntegerField(default=0)
    
    class Meta:
        ordering = ['meal_plan', 'order']
    
    def __str__(self):
        return f"{self.meal_type} - {self.meal_name}"


class MealFoodItem(models.Model):
    """Food items included in a meal"""
    
    meal = models.ForeignKey(Meal, on_delete=models.CASCADE, related_name='food_items')
    food_item = models.ForeignKey(FoodItem, on_delete=models.CASCADE)
    
    # Quantity
    quantity_g = models.DecimalField(max_digits=6, decimal_places=1, help_text="Quantity in grams")
    
    # Calculated Nutrition (based on quantity)
    calories = models.IntegerField()
    protein_g = models.DecimalField(max_digits=5, decimal_places=1)
    carbs_g = models.DecimalField(max_digits=5, decimal_places=1)
    fats_g = models.DecimalField(max_digits=5, decimal_places=1)
    
    # Order
    order = models.IntegerField(default=0)
    
    class Meta:
        ordering = ['meal', 'order']
    
    def __str__(self):
        return f"{self.food_item.name} ({self.quantity_g}g)"
    
    def save(self, *args, **kwargs):
        # Auto-calculate nutrition based on quantity
        if self.food_item:
            multiplier = float(self.quantity_g) / float(self.food_item.serving_size_g)
            self.calories = int(self.food_item.calories * multiplier)
            self.protein_g = self.food_item.protein_g * multiplier
            self.carbs_g = self.food_item.carbs_g * multiplier
            self.fats_g = self.food_item.fats_g * multiplier
        super().save(*args, **kwargs)


class NutritionLog(models.Model):
    """Track user's daily nutrition intake"""
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='nutrition_logs')
    date = models.DateField()
    meal_plan = models.ForeignKey(MealPlan, on_delete=models.SET_NULL, blank=True, null=True)
    
    # Daily Totals
    total_calories = models.IntegerField(default=0)
    total_protein_g = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    total_carbs_g = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    total_fats_g = models.DecimalField(max_digits=6, decimal_places=1, default=0)
    total_water_ml = models.IntegerField(default=0, help_text="Water intake in ml")
    
    # Targets Met
    calories_target_met = models.BooleanField(default=False)
    protein_target_met = models.BooleanField(default=False)
    
    notes = models.TextField(blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-date']
        unique_together = ['user', 'date']
    
    def __str__(self):
        return f"{self.user.full_name} - {self.date}"


class FoodLog(models.Model):
    """Track individual food intake"""
    
    MEAL_TYPE_CHOICES = Meal.MEAL_TYPE_CHOICES
    
    nutrition_log = models.ForeignKey(NutritionLog, on_delete=models.CASCADE, related_name='food_logs')
    food_item = models.ForeignKey(FoodItem, on_delete=models.CASCADE)
    meal_type = models.CharField(max_length=20, choices=MEAL_TYPE_CHOICES)
    
    # Consumed Details
    quantity_g = models.DecimalField(max_digits=6, decimal_places=1)
    consumed_time = models.TimeField(blank=True, null=True)
    
    # Calculated Nutrition
    calories = models.IntegerField()
    protein_g = models.DecimalField(max_digits=5, decimal_places=1)
    carbs_g = models.DecimalField(max_digits=5, decimal_places=1)
    fats_g = models.DecimalField(max_digits=5, decimal_places=1)
    
    notes = models.TextField(blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['nutrition_log', 'consumed_time']
    
    def __str__(self):
        return f"{self.food_item.name} - {self.quantity_g}g"
