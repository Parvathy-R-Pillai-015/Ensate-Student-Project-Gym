from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from django.db.models import Sum, Q
from datetime import date, timedelta
from .models import FoodItem, NutritionLog, FoodLog
from decimal import Decimal


class FoodItemViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for viewing available food items
    """
    permission_classes = [IsAuthenticated]
    queryset = FoodItem.objects.filter(is_active=True)
    
    def list(self, request):
        """Get all food items, optionally filtered by category or dietary type"""
        queryset = self.get_queryset()
        
        # Filter by category
        category = request.query_params.get('category', None)
        if category:
            queryset = queryset.filter(category=category)
        
        # Filter by dietary type
        dietary_type = request.query_params.get('dietary_type', None)
        if dietary_type:
            queryset = queryset.filter(dietary_type=dietary_type)
        
        # Search by name
        search = request.query_params.get('search', None)
        if search:
            queryset = queryset.filter(name__icontains=search)
        
        foods = []
        for food in queryset:
            foods.append({
                'id': food.id,
                'name': food.name,
                'category': food.category,
                'dietary_type': food.dietary_type,
                'serving_size_g': float(food.serving_size_g),
                'calories': food.calories,
                'protein_g': float(food.protein_g),
                'carbs_g': float(food.carbs_g),
                'fats_g': float(food.fats_g),
                'fiber_g': float(food.fiber_g) if food.fiber_g else 0,
            })
        
        return Response({
            'foods': foods,
            'count': len(foods)
        })
    
    @action(detail=False, methods=['get'])
    def categories(self, request):
        """Get all available food categories"""
        categories = [
            {'value': choice[0], 'label': choice[1]}
            for choice in FoodItem.CATEGORY_CHOICES
        ]
        return Response({'categories': categories})


class DailyFoodLogViewSet(viewsets.ViewSet):
    """
    ViewSet for logging daily food intake
    """
    permission_classes = [IsAuthenticated]
    
    def list(self, request):
        """Get today's food log with total calories"""
        user = request.user
        today = date.today()
        
        # Get or create today's nutrition log
        nutrition_log, created = NutritionLog.objects.get_or_create(
            user=user,
            date=today,
            defaults={
                'total_calories': 0,
                'total_protein_g': 0,
                'total_carbs_g': 0,
                'total_fats_g': 0,
            }
        )
        
        # Get all food logs for today
        food_logs = FoodLog.objects.filter(
            nutrition_log=nutrition_log
        ).select_related('food_item').order_by('-created_at')
        
        # Format response
        logged_foods = []
        for log in food_logs:
            logged_foods.append({
                'id': log.id,
                'food_item': {
                    'id': log.food_item.id,
                    'name': log.food_item.name,
                    'category': log.food_item.category,
                },
                'meal_type': log.meal_type,
                'quantity_g': float(log.quantity_g),
                'calories': log.calories,
                'protein_g': float(log.protein_g),
                'carbs_g': float(log.carbs_g),
                'fats_g': float(log.fats_g),
                'consumed_time': log.consumed_time.strftime('%H:%M') if log.consumed_time else None,
                'created_at': log.created_at.isoformat(),
            })
        
        return Response({
            'date': today.isoformat(),
            'total_calories': nutrition_log.total_calories,
            'total_protein_g': float(nutrition_log.total_protein_g),
            'total_carbs_g': float(nutrition_log.total_carbs_g),
            'total_fats_g': float(nutrition_log.total_fats_g),
            'logged_foods': logged_foods,
            'count': len(logged_foods),
        })
    
    def create(self, request):
        """Add a food item to today's log"""
        user = request.user
        today = date.today()
        
        # Get parameters
        food_item_id = request.data.get('food_item_id')
        quantity_g = request.data.get('quantity_g')
        meal_type = request.data.get('meal_type', 'SNACK')
        
        # Validate
        if not food_item_id or not quantity_g:
            return Response(
                {'error': 'food_item_id and quantity_g are required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            food_item = FoodItem.objects.get(id=food_item_id, is_active=True)
        except FoodItem.DoesNotExist:
            return Response(
                {'error': 'Food item not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Get or create nutrition log for today
        nutrition_log, created = NutritionLog.objects.get_or_create(
            user=user,
            date=today,
            defaults={
                'total_calories': 0,
                'total_protein_g': 0,
                'total_carbs_g': 0,
                'total_fats_g': 0,
            }
        )
        
        # Calculate nutrition based on quantity
        quantity_decimal = Decimal(str(quantity_g))
        multiplier = quantity_decimal / food_item.serving_size_g
        
        calories = int(food_item.calories * multiplier)
        protein_g = food_item.protein_g * multiplier
        carbs_g = food_item.carbs_g * multiplier
        fats_g = food_item.fats_g * multiplier
        
        # Create food log entry
        food_log = FoodLog.objects.create(
            nutrition_log=nutrition_log,
            food_item=food_item,
            meal_type=meal_type,
            quantity_g=quantity_decimal,
            calories=calories,
            protein_g=protein_g,
            carbs_g=carbs_g,
            fats_g=fats_g,
            consumed_time=timezone.now().time(),
        )
        
        # Update nutrition log totals
        self._update_nutrition_totals(nutrition_log)
        
        return Response({
            'message': 'Food logged successfully',
            'food_log': {
                'id': food_log.id,
                'food_item': {
                    'id': food_item.id,
                    'name': food_item.name,
                },
                'quantity_g': float(quantity_decimal),
                'calories': calories,
                'protein_g': float(protein_g),
                'carbs_g': float(carbs_g),
                'fats_g': float(fats_g),
            },
            'total_calories': nutrition_log.total_calories,
        }, status=status.HTTP_201_CREATED)
    
    def destroy(self, request, pk=None):
        """Remove a food entry from today's log"""
        user = request.user
        
        try:
            food_log = FoodLog.objects.get(
                id=pk,
                nutrition_log__user=user
            )
        except FoodLog.DoesNotExist:
            return Response(
                {'error': 'Food log entry not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        nutrition_log = food_log.nutrition_log
        food_log.delete()
        
        # Update nutrition log totals
        self._update_nutrition_totals(nutrition_log)
        
        return Response({
            'message': 'Food entry removed successfully',
            'total_calories': nutrition_log.total_calories,
        })
    
    @action(detail=False, methods=['get'])
    def history(self, request):
        """Get food log history for the past week"""
        user = request.user
        days = int(request.query_params.get('days', 7))
        
        end_date = date.today()
        start_date = end_date - timedelta(days=days-1)
        
        logs = NutritionLog.objects.filter(
            user=user,
            date__range=[start_date, end_date]
        ).order_by('-date')
        
        history = []
        for log in logs:
            food_count = FoodLog.objects.filter(nutrition_log=log).count()
            history.append({
                'date': log.date.isoformat(),
                'total_calories': log.total_calories,
                'total_protein_g': float(log.total_protein_g),
                'total_carbs_g': float(log.total_carbs_g),
                'total_fats_g': float(log.total_fats_g),
                'food_count': food_count,
            })
        
        return Response({
            'history': history,
            'start_date': start_date.isoformat(),
            'end_date': end_date.isoformat(),
        })
    
    def _update_nutrition_totals(self, nutrition_log):
        """Recalculate and update nutrition log totals"""
        totals = FoodLog.objects.filter(
            nutrition_log=nutrition_log
        ).aggregate(
            total_calories=Sum('calories'),
            total_protein_g=Sum('protein_g'),
            total_carbs_g=Sum('carbs_g'),
            total_fats_g=Sum('fats_g'),
        )
        
        nutrition_log.total_calories = totals['total_calories'] or 0
        nutrition_log.total_protein_g = totals['total_protein_g'] or 0
        nutrition_log.total_carbs_g = totals['total_carbs_g'] or 0
        nutrition_log.total_fats_g = totals['total_fats_g'] or 0
        nutrition_log.save()
