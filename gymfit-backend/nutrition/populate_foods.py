# Script to populate common Kerala/Indian foods
from nutrition.models import FoodItem

# Common Kerala/Indian foods with nutritional information
FOODS_DATA = [
    # Breakfast Items
    {
        'name': 'Idli (1 piece)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 30,
        'calories': 39,
        'protein_g': 1.2,
        'carbs_g': 8.5,
        'fats_g': 0.1,
        'fiber_g': 0.3,
    },
    {
        'name': 'Dosa (1 piece)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 50,
        'calories': 133,
        'protein_g': 2.6,
        'carbs_g': 25.0,
        'fats_g': 2.0,
        'fiber_g': 1.0,
    },
    {
        'name': 'Appam (1 piece)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 40,
        'calories': 120,
        'protein_g': 1.5,
        'carbs_g': 22.0,
        'fats_g': 2.5,
        'fiber_g': 0.5,
    },
    {
        'name': 'Puttu (1 cup)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 100,
        'calories': 130,
        'protein_g': 3.0,
        'carbs_g': 27.0,
        'fats_g': 1.0,
        'fiber_g': 2.0,
    },
    {
        'name': 'Upma (1 cup)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 150,
        'calories': 250,
        'protein_g': 5.0,
        'carbs_g': 40.0,
        'fats_g': 7.0,
        'fiber_g': 3.0,
    },
    
    # Rice Dishes
    {
        'name': 'White Rice (1 cup cooked)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 158,
        'calories': 205,
        'protein_g': 4.3,
        'carbs_g': 44.5,
        'fats_g': 0.4,
        'fiber_g': 0.6,
    },
    {
        'name': 'Brown Rice (1 cup cooked)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 195,
        'calories': 216,
        'protein_g': 5.0,
        'carbs_g': 45.0,
        'fats_g': 1.8,
        'fiber_g': 3.5,
    },
    {
        'name': 'Biryani (1 plate)',
        'category': 'GRAINS',
        'dietary_type': 'NON_VEGETARIAN',
        'serving_size_g': 300,
        'calories': 500,
        'protein_g': 25.0,
        'carbs_g': 60.0,
        'fats_g': 15.0,
        'fiber_g': 2.0,
    },
    
    # Breads
    {
        'name': 'Chapathi (1 piece)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 40,
        'calories': 104,
        'protein_g': 3.1,
        'carbs_g': 18.0,
        'fats_g': 2.0,
        'fiber_g': 2.0,
    },
    {
        'name': 'Paratha (1 piece)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 60,
        'calories': 210,
        'protein_g': 4.5,
        'carbs_g': 24.0,
        'fats_g': 10.0,
        'fiber_g': 2.5,
    },
    {
        'name': 'Poori (1 piece)',
        'category': 'GRAINS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 30,
        'calories': 112,
        'protein_g': 2.0,
        'carbs_g': 13.0,
        'fats_g': 6.0,
        'fiber_g': 0.5,
    },
    
    # Dal/Curry
    {
        'name': 'Dal (1 cup)',
        'category': 'PROTEIN',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 200,
        'calories': 230,
        'protein_g': 12.0,
        'carbs_g': 35.0,
        'fats_g': 4.0,
        'fiber_g': 8.0,
    },
    {
        'name': 'Sambar (1 cup)',
        'category': 'VEGETABLES',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 250,
        'calories': 150,
        'protein_g': 6.0,
        'carbs_g': 20.0,
        'fats_g': 5.0,
        'fiber_g': 5.0,
    },
    {
        'name': 'Rasam (1 cup)',
        'category': 'BEVERAGES',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 200,
        'calories': 50,
        'protein_g': 2.0,
        'carbs_g': 8.0,
        'fats_g': 1.5,
        'fiber_g': 2.0,
    },
    
    # Non-Veg Curries
    {
        'name': 'Chicken Curry (1 cup)',
        'category': 'PROTEIN',
        'dietary_type': 'NON_VEGETARIAN',
        'serving_size_g': 200,
        'calories': 250,
        'protein_g': 30.0,
        'carbs_g': 8.0,
        'fats_g': 10.0,
        'fiber_g': 2.0,
    },
    {
        'name': 'Fish Curry (1 cup)',
        'category': 'PROTEIN',
        'dietary_type': 'PESCATARIAN',
        'serving_size_g': 200,
        'calories': 220,
        'protein_g': 28.0,
        'carbs_g': 6.0,
        'fats_g': 8.0,
        'fiber_g': 1.5,
    },
    {
        'name': 'Egg Curry (2 eggs)',
        'category': 'PROTEIN',
        'dietary_type': 'NON_VEGETARIAN',
        'serving_size_g': 150,
        'calories': 200,
        'protein_g': 14.0,
        'carbs_g': 6.0,
        'fats_g': 13.0,
        'fiber_g': 1.0,
    },
    {
        'name': 'Boiled Egg (1 piece)',
        'category': 'PROTEIN',
        'dietary_type': 'NON_VEGETARIAN',
        'serving_size_g': 50,
        'calories': 78,
        'protein_g': 6.3,
        'carbs_g': 0.6,
        'fats_g': 5.3,
        'fiber_g': 0,
    },
    
    # Vegetables
    {
        'name': 'Mixed Vegetable Curry (1 cup)',
        'category': 'VEGETABLES',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 150,
        'calories': 120,
        'protein_g': 3.0,
        'carbs_g': 15.0,
        'fats_g': 5.0,
        'fiber_g': 4.0,
    },
    {
        'name': 'Avial (1 cup)',
        'category': 'VEGETABLES',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 150,
        'calories': 110,
        'protein_g': 2.5,
        'carbs_g': 12.0,
        'fats_g': 6.0,
        'fiber_g': 3.5,
    },
    {
        'name': 'Thoran (1 cup)',
        'category': 'VEGETABLES',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 100,
        'calories': 80,
        'protein_g': 2.0,
        'carbs_g': 10.0,
        'fats_g': 3.5,
        'fiber_g': 3.0,
    },
    
    # Snacks
    {
        'name': 'Banana Chips (1 small pack)',
        'category': 'SNACKS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 50,
        'calories': 267,
        'protein_g': 1.5,
        'carbs_g': 28.0,
        'fats_g': 17.0,
        'fiber_g': 2.5,
    },
    {
        'name': 'Murukku (5 pieces)',
        'category': 'SNACKS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 50,
        'calories': 235,
        'protein_g': 4.5,
        'carbs_g': 30.0,
        'fats_g': 11.0,
        'fiber_g': 2.0,
    },
    {
        'name': 'Pakoda (5 pieces)',
        'category': 'SNACKS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 100,
        'calories': 300,
        'protein_g': 6.0,
        'carbs_g': 35.0,
        'fats_g': 15.0,
        'fiber_g': 3.0,
    },
    {
        'name': 'Samosa (1 piece)',
        'category': 'SNACKS',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 60,
        'calories': 262,
        'protein_g': 4.0,
        'carbs_g': 25.0,
        'fats_g': 17.0,
        'fiber_g': 2.0,
    },
    
    # Nuts
    {
        'name': 'Cashew Nuts (1 handful)',
        'category': 'FATS',
        'dietary_type': 'VEGAN',
        'serving_size_g': 30,
        'calories': 165,
        'protein_g': 5.0,
        'carbs_g': 9.0,
        'fats_g': 13.0,
        'fiber_g': 1.0,
    },
    {
        'name': 'Almonds (1 handful)',
        'category': 'FATS',
        'dietary_type': 'VEGAN',
        'serving_size_g': 30,
        'calories': 170,
        'protein_g': 6.0,
        'carbs_g': 6.0,
        'fats_g': 15.0,
        'fiber_g': 3.5,
    },
    {
        'name': 'Peanuts (1 handful)',
        'category': 'FATS',
        'dietary_type': 'VEGAN',
        'serving_size_g': 30,
        'calories': 161,
        'protein_g': 7.0,
        'carbs_g': 6.0,
        'fats_g': 14.0,
        'fiber_g': 2.5,
    },
    
    # Fruits
    {
        'name': 'Banana (1 medium)',
        'category': 'FRUITS',
        'dietary_type': 'VEGAN',
        'serving_size_g': 118,
        'calories': 105,
        'protein_g': 1.3,
        'carbs_g': 27.0,
        'fats_g': 0.4,
        'fiber_g': 3.1,
    },
    {
        'name': 'Apple (1 medium)',
        'category': 'FRUITS',
        'dietary_type': 'VEGAN',
        'serving_size_g': 182,
        'calories': 95,
        'protein_g': 0.5,
        'carbs_g': 25.0,
        'fats_g': 0.3,
        'fiber_g': 4.4,
    },
    {
        'name': 'Mango (1 cup sliced)',
        'category': 'FRUITS',
        'dietary_type': 'VEGAN',
        'serving_size_g': 165,
        'calories': 99,
        'protein_g': 1.4,
        'carbs_g': 25.0,
        'fats_g': 0.6,
        'fiber_g': 2.6,
    },
    
    # Beverages
    {
        'name': 'Tea (1 cup with milk & sugar)',
        'category': 'BEVERAGES',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 200,
        'calories': 50,
        'protein_g': 1.5,
        'carbs_g': 10.0,
        'fats_g': 1.0,
        'fiber_g': 0,
    },
    {
        'name': 'Coffee (1 cup with milk & sugar)',
        'category': 'BEVERAGES',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 200,
        'calories': 60,
        'protein_g': 2.0,
        'carbs_g': 11.0,
        'fats_g': 1.5,
        'fiber_g': 0,
    },
    {
        'name': 'Buttermilk (1 glass)',
        'category': 'DAIRY',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 200,
        'calories': 40,
        'protein_g': 2.0,
        'carbs_g': 5.0,
        'fats_g': 1.0,
        'fiber_g': 0,
    },
    
    # Dairy
    {
        'name': 'Curd/Yogurt (1 cup)',
        'category': 'DAIRY',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 200,
        'calories': 98,
        'protein_g': 7.0,
        'carbs_g': 11.0,
        'fats_g': 3.0,
        'fiber_g': 0,
    },
    {
        'name': 'Milk (1 glass)',
        'category': 'DAIRY',
        'dietary_type': 'VEGETARIAN',
        'serving_size_g': 244,
        'calories': 149,
        'protein_g': 8.0,
        'carbs_g': 12.0,
        'fats_g': 8.0,
        'fiber_g': 0,
    },
]


def populate_foods():
    """Populate the database with common Kerala/Indian foods"""
    created_count = 0
    updated_count = 0
    
    for food_data in FOODS_DATA:
        food_item, created = FoodItem.objects.get_or_create(
            name=food_data['name'],
            defaults=food_data
        )
        
        if created:
            created_count += 1
            print(f"Created: {food_item.name}")
        else:
            # Update existing item
            for key, value in food_data.items():
                setattr(food_item, key, value)
            food_item.save()
            updated_count += 1
            print(f"Updated: {food_item.name}")
    
    print(f"\nPopulation complete!")
    print(f"Created: {created_count} foods")
    print(f"Updated: {updated_count} foods")
    print(f"Total: {len(FOODS_DATA)} foods")


if __name__ == '__main__':
    populate_foods()
