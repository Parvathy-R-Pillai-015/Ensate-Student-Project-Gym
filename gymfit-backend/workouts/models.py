from django.db import models
from users.models import User


class WorkoutPlan(models.Model):
    """Personalized workout plan for each user"""
    
    FREQUENCY_CHOICES = [
        ('DAILY', 'Daily'),
        ('3_DAYS', '3 Days per Week'),
        ('4_DAYS', '4 Days per Week'),
        ('5_DAYS', '5 Days per Week'),
        ('6_DAYS', '6 Days per Week'),
    ]
    
    DIFFICULTY_CHOICES = [
        ('BEGINNER', 'Beginner'),
        ('INTERMEDIATE', 'Intermediate'),
        ('ADVANCED', 'Advanced'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='workout_plans')
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    
    # Plan Configuration
    fitness_goal = models.CharField(max_length=20)  # WEIGHT_LOSS, MUSCLE_GAIN, etc.
    frequency = models.CharField(max_length=10, choices=FREQUENCY_CHOICES, default='3_DAYS')
    difficulty_level = models.CharField(max_length=20, choices=DIFFICULTY_CHOICES, default='BEGINNER')
    duration_weeks = models.IntegerField(default=8, help_text="Plan duration in weeks")
    
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


class Exercise(models.Model):
    """Exercise library"""
    
    CATEGORY_CHOICES = [
        ('STRENGTH', 'Strength Training'),
        ('CARDIO', 'Cardio'),
        ('FLEXIBILITY', 'Flexibility'),
        ('HIIT', 'HIIT'),
        ('YOGA', 'Yoga'),
        ('SPORTS', 'Sports'),
    ]
    
    MUSCLE_GROUP_CHOICES = [
        ('CHEST', 'Chest'),
        ('BACK', 'Back'),
        ('SHOULDERS', 'Shoulders'),
        ('ARMS', 'Arms'),
        ('LEGS', 'Legs'),
        ('CORE', 'Core'),
        ('FULL_BODY', 'Full Body'),
        ('CARDIO', 'Cardio'),
    ]
    
    EQUIPMENT_CHOICES = [
        ('NONE', 'No Equipment'),
        ('DUMBBELLS', 'Dumbbells'),
        ('BARBELL', 'Barbell'),
        ('MACHINE', 'Machine'),
        ('RESISTANCE_BAND', 'Resistance Band'),
        ('CABLE', 'Cable'),
        ('BODYWEIGHT', 'Bodyweight'),
    ]
    
    name = models.CharField(max_length=200)
    description = models.TextField()
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES)
    muscle_group = models.CharField(max_length=20, choices=MUSCLE_GROUP_CHOICES)
    equipment = models.CharField(max_length=20, choices=EQUIPMENT_CHOICES)
    
    # Exercise Details
    difficulty_level = models.CharField(max_length=20, choices=WorkoutPlan.DIFFICULTY_CHOICES)
    calories_per_minute = models.DecimalField(max_digits=4, decimal_places=1, default=5.0)
    
    # Instructions
    instructions = models.TextField(help_text="Step by step instructions")
    video_url = models.URLField(blank=True, null=True)
    image_url = models.URLField(blank=True, null=True)
    
    # Metadata
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['name']
    
    def __str__(self):
        return self.name


class WorkoutDay(models.Model):
    """Individual workout day in a plan"""
    
    DAY_CHOICES = [
        ('MONDAY', 'Monday'),
        ('TUESDAY', 'Tuesday'),
        ('WEDNESDAY', 'Wednesday'),
        ('THURSDAY', 'Thursday'),
        ('FRIDAY', 'Friday'),
        ('SATURDAY', 'Saturday'),
        ('SUNDAY', 'Sunday'),
    ]
    
    workout_plan = models.ForeignKey(WorkoutPlan, on_delete=models.CASCADE, related_name='workout_days')
    day_name = models.CharField(max_length=20, choices=DAY_CHOICES)
    week_number = models.IntegerField(default=1, help_text="Week number in the plan")
    focus = models.CharField(max_length=100, help_text="e.g., Upper Body, Cardio, Legs")
    
    # Day Details
    total_duration_minutes = models.IntegerField(default=60)
    estimated_calories_burned = models.IntegerField(default=300)
    notes = models.TextField(blank=True)
    
    # Order
    order = models.IntegerField(default=0)
    
    class Meta:
        ordering = ['workout_plan', 'week_number', 'order']
        unique_together = ['workout_plan', 'week_number', 'day_name']
    
    def __str__(self):
        return f"{self.workout_plan.name} - Week {self.week_number} - {self.day_name}"


class WorkoutExercise(models.Model):
    """Exercise assigned to a specific workout day"""
    
    workout_day = models.ForeignKey(WorkoutDay, on_delete=models.CASCADE, related_name='exercises')
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    
    # Exercise Parameters
    sets = models.IntegerField(default=3)
    reps = models.IntegerField(blank=True, null=True, help_text="Reps per set (leave blank for time-based)")
    duration_seconds = models.IntegerField(blank=True, null=True, help_text="Duration for time-based exercises")
    rest_seconds = models.IntegerField(default=60, help_text="Rest between sets")
    
    # Weight/Resistance
    weight_kg = models.DecimalField(max_digits=5, decimal_places=1, blank=True, null=True)
    
    # Order and Notes
    order = models.IntegerField(default=0)
    notes = models.TextField(blank=True)
    
    class Meta:
        ordering = ['workout_day', 'order']
    
    def __str__(self):
        return f"{self.exercise.name} - {self.sets}x{self.reps or f'{self.duration_seconds}s'}"


class WorkoutLog(models.Model):
    """Track user's workout completion"""
    
    STATUS_CHOICES = [
        ('COMPLETED', 'Completed'),
        ('SKIPPED', 'Skipped'),
        ('IN_PROGRESS', 'In Progress'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='workout_logs')
    workout_day = models.ForeignKey(WorkoutDay, on_delete=models.CASCADE, related_name='logs')
    
    # Completion Details
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='IN_PROGRESS')
    completed_date = models.DateField()
    duration_minutes = models.IntegerField(blank=True, null=True)
    calories_burned = models.IntegerField(blank=True, null=True)
    
    # User Feedback
    difficulty_rating = models.IntegerField(blank=True, null=True, help_text="1-5 rating")
    notes = models.TextField(blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-completed_date']
        unique_together = ['user', 'workout_day', 'completed_date']
    
    def __str__(self):
        return f"{self.user.full_name} - {self.workout_day} - {self.completed_date}"


class ExerciseLog(models.Model):
    """Track individual exercise performance"""
    
    workout_log = models.ForeignKey(WorkoutLog, on_delete=models.CASCADE, related_name='exercise_logs')
    workout_exercise = models.ForeignKey(WorkoutExercise, on_delete=models.CASCADE)
    
    # Actual Performance
    sets_completed = models.IntegerField()
    reps_completed = models.IntegerField(blank=True, null=True)
    duration_seconds = models.IntegerField(blank=True, null=True)
    weight_used_kg = models.DecimalField(max_digits=5, decimal_places=1, blank=True, null=True)
    
    # Notes
    notes = models.TextField(blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['workout_log', 'workout_exercise__order']
    
    def __str__(self):
        return f"{self.workout_exercise.exercise.name} - {self.sets_completed} sets"
