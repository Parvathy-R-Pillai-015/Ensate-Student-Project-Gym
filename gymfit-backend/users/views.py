from rest_framework import status, generics, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate, get_user_model
from .serializers import UserSerializer, RegisterSerializer, ProfileUpdateSerializer, LoginSerializer

User = get_user_model()


@api_view(['POST'])
@permission_classes([AllowAny])
def register_view(request):
    """Register a new user"""
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        
        # Generate JWT tokens
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'message': 'User registered successfully',
            'user': UserSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }
        }, status=status.HTTP_201_CREATED)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    """Login user"""
    serializer = LoginSerializer(data=request.data)
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    email = serializer.validated_data['email']
    password = serializer.validated_data['password']
    
    # Get user by email
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
    
    # Authenticate
    user = authenticate(username=user.username, password=password)
    if not user:
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
    
    # Generate JWT tokens
    refresh = RefreshToken.for_user(user)
    
    return Response({
        'message': 'Login successful',
        'user': UserSerializer(user).data,
        'tokens': {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
        }
    }, status=status.HTTP_200_OK)


@api_view(['GET', 'PUT', 'PATCH'])
@permission_classes([IsAuthenticated])
def profile_view(request):
    """Get or update user profile"""
    user = request.user
    
    if request.method == 'GET':
        serializer = UserSerializer(user)
        return Response(serializer.data)
    
    elif request.method in ['PUT', 'PATCH']:
        serializer = ProfileUpdateSerializer(user, data=request.data, partial=(request.method == 'PATCH'))
        if serializer.is_valid():
            serializer.save()
            return Response({
                'message': 'Profile updated successfully',
                'user': UserSerializer(user).data
            })
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def dashboard_view(request):
    """Get dashboard data for authenticated user"""
    user = request.user
    
    # Calculate stats (mock data for now - will be real from database later)
    dashboard_data = {
        'user': {
            'name': user.full_name,
            'greeting': get_greeting(),
        },
        'stats': {
            'workouts': 12,  # TODO: Get from workouts model
            'calories': 2450,  # TODO: Get from progress model
            'classes': 8,  # TODO: Get from classes model
            'days_active': 15,  # TODO: Calculate from user activity
        },
        'membership': {
            'type': 'Premium Membership',  # TODO: Get from memberships model
            'days_remaining': 10,  # TODO: Calculate from membership
        },
        'fitness_profile': {
            'goal': user.fitness_goal or 'Not Set',
            'current_weight': float(user.current_weight) if user.current_weight else None,
            'target_weight': float(user.target_weight) if user.target_weight else None,
            'diet': user.dietary_preference or 'Not Set',
            'daily_calories': user.target_daily_calories or user.calculate_daily_calories(),
        }
    }
    
    return Response(dashboard_data)


def get_greeting():
    """Get time-based greeting"""
    from datetime import datetime
    hour = datetime.now().hour
    if hour < 12:
        return 'Good Morning'
    elif hour < 18:
        return 'Good Afternoon'
    else:
        return 'Good Evening'
