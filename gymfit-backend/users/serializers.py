from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    """Serializer for User model"""
    full_name = serializers.ReadOnlyField()
    bmi = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'first_name', 'last_name', 'full_name',
            'phone_number', 'date_of_birth', 'gender', 'age',
            'current_weight', 'target_weight', 'height', 'bmi',
            'fitness_goal', 'activity_level', 'dietary_preference',
            'food_allergies', 'health_conditions',
            'target_daily_calories', 'target_timeline_days',
            'has_completed_onboarding', 'profile_image',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def get_bmi(self, obj):
        return obj.calculate_bmi()


class RegisterSerializer(serializers.ModelSerializer):
    """Serializer for user registration"""
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password2 = serializers.CharField(write_only=True, required=True, label='Confirm Password')
    
    class Meta:
        model = User
        fields = [
            'username', 'email', 'password', 'password2',
            'first_name', 'last_name', 'phone_number'
        ]
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password": "Password fields didn't match."})
        
        if User.objects.filter(email=attrs['email']).exists():
            raise serializers.ValidationError({"email": "Email already exists."})
        
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password2')
        user = User.objects.create_user(**validated_data)
        return user


class ProfileUpdateSerializer(serializers.ModelSerializer):
    """Serializer for updating user profile"""
    
    class Meta:
        model = User
        fields = [
            'first_name', 'last_name', 'phone_number', 'date_of_birth', 'gender',
            'age', 'current_weight', 'target_weight', 'height',
            'fitness_goal', 'activity_level', 'dietary_preference',
            'food_allergies', 'health_conditions',
            'target_daily_calories', 'target_timeline_days',
            'has_completed_onboarding', 'profile_image'
        ]
    
    def update(self, instance, validated_data):
        # Auto-calculate daily calories if not provided
        if 'target_daily_calories' not in validated_data or not validated_data['target_daily_calories']:
            validated_data['target_daily_calories'] = instance.calculate_daily_calories()
        
        return super().update(instance, validated_data)


class LoginSerializer(serializers.Serializer):
    """Serializer for user login"""
    email = serializers.EmailField(required=True)
    password = serializers.CharField(required=True, write_only=True)
