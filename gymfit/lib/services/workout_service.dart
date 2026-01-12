import 'package:gymfit/services/api_service.dart';
import 'package:gymfit/models/workout.dart';
import 'package:gymfit/models/user.dart';

class WorkoutService {
  final ApiService _apiService = ApiService();

  // Generate personalized workout plan based on user profile
  Future<List<Workout>> generatePersonalizedWorkoutPlan(User user) async {
    try {
      // In production, this would call the backend API
      // For now, generate based on user's goals
      return _generateMockWorkoutPlan(user);
    } catch (e) {
      throw Exception('Failed to generate workout plan: $e');
    }
  }

  List<Workout> _generateMockWorkoutPlan(User user) {
    final List<Workout> workouts = [];
    
    switch (user.fitnessGoal?.toUpperCase()) {
      case 'WEIGHT_LOSS':
        workouts.addAll(_weightLossWorkouts(user));
        break;
      case 'WEIGHT_GAIN':
      case 'MUSCLE_BUILDING':
        workouts.addAll(_muscleGainWorkouts(user));
        break;
      case 'ENDURANCE':
        workouts.addAll(_enduranceWorkouts(user));
        break;
      default:
        workouts.addAll(_generalFitnessWorkouts(user));
    }
    
    return workouts;
  }

  List<Workout> _weightLossWorkouts(User user) {
    // High intensity, cardio-focused workouts
    return [
      Workout(
        id: 1,
        userId: user.id,
        name: 'Cardio Burn',
        description: 'High-intensity cardio to burn calories',
        exercises: [
          WorkoutExercise(
            exercise: Exercise(
              id: 1,
              name: 'Jump Rope',
              category: 'Cardio',
              muscleGroups: ['Full Body'],
              difficulty: 'Medium',
            ),
            sets: 3,
            reps: 100,
            duration: 5,
          ),
          WorkoutExercise(
            exercise: Exercise(
              id: 2,
              name: 'Burpees',
              category: 'Cardio',
              muscleGroups: ['Full Body'],
              difficulty: 'Hard',
            ),
            sets: 3,
            reps: 15,
          ),
          WorkoutExercise(
            exercise: Exercise(
              id: 3,
              name: 'Mountain Climbers',
              category: 'Cardio',
              muscleGroups: ['Core', 'Legs'],
              difficulty: 'Medium',
            ),
            sets: 3,
            reps: 20,
          ),
        ],
        durationMinutes: 45,
        caloriesBurned: 400,
      ),
      Workout(
        id: 2,
        userId: user.id,
        name: 'HIIT Circuit',
        description: 'Interval training for fat loss',
        exercises: [
          WorkoutExercise(
            exercise: Exercise(
              id: 4,
              name: 'High Knees',
              category: 'Cardio',
              muscleGroups: ['Legs'],
              difficulty: 'Easy',
            ),
            sets: 4,
            reps: 30,
          ),
          WorkoutExercise(
            exercise: Exercise(
              id: 5,
              name: 'Jumping Jacks',
              category: 'Cardio',
              muscleGroups: ['Full Body'],
              difficulty: 'Easy',
            ),
            sets: 4,
            reps: 30,
          ),
        ],
        durationMinutes: 30,
        caloriesBurned: 350,
      ),
    ];
  }

  List<Workout> _muscleGainWorkouts(User user) {
    // Strength training focused
    return [
      Workout(
        id: 3,
        userId: user.id,
        name: 'Upper Body Strength',
        description: 'Build upper body muscle',
        exercises: [
          WorkoutExercise(
            exercise: Exercise(
              id: 6,
              name: 'Push-ups',
              category: 'Strength',
              muscleGroups: ['Chest', 'Triceps'],
              difficulty: 'Medium',
            ),
            sets: 4,
            reps: 12,
          ),
          WorkoutExercise(
            exercise: Exercise(
              id: 7,
              name: 'Pull-ups',
              category: 'Strength',
              muscleGroups: ['Back', 'Biceps'],
              difficulty: 'Hard',
            ),
            sets: 4,
            reps: 8,
          ),
          WorkoutExercise(
            exercise: Exercise(
              id: 8,
              name: 'Dumbbell Curls',
              category: 'Strength',
              muscleGroups: ['Biceps'],
              difficulty: 'Easy',
            ),
            sets: 3,
            reps: 15,
          ),
        ],
        durationMinutes: 60,
        caloriesBurned: 200,
      ),
      Workout(
        id: 4,
        userId: user.id,
        name: 'Lower Body Power',
        description: 'Build leg muscle and strength',
        exercises: [
          WorkoutExercise(
            exercise: Exercise(
              id: 9,
              name: 'Squats',
              category: 'Strength',
              muscleGroups: ['Legs', 'Glutes'],
              difficulty: 'Medium',
            ),
            sets: 4,
            reps: 12,
          ),
          WorkoutExercise(
            exercise: Exercise(
              id: 10,
              name: 'Lunges',
              category: 'Strength',
              muscleGroups: ['Legs', 'Glutes'],
              difficulty: 'Medium',
            ),
            sets: 3,
            reps: 10,
          ),
        ],
        durationMinutes: 50,
        caloriesBurned: 250,
      ),
    ];
  }

  List<Workout> _enduranceWorkouts(User user) {
    return [
      Workout(
        id: 5,
        userId: user.id,
        name: 'Stamina Builder',
        description: 'Improve cardiovascular endurance',
        exercises: [
          WorkoutExercise(
            exercise: Exercise(
              id: 11,
              name: 'Running',
              category: 'Cardio',
              muscleGroups: ['Legs'],
              difficulty: 'Medium',
            ),
            sets: 1,
            reps: 1,
            duration: 30,
          ),
          WorkoutExercise(
            exercise: Exercise(
              id: 12,
              name: 'Cycling',
              category: 'Cardio',
              muscleGroups: ['Legs'],
              difficulty: 'Medium',
            ),
            sets: 1,
            reps: 1,
            duration: 20,
          ),
        ],
        durationMinutes: 60,
        caloriesBurned: 400,
      ),
    ];
  }

  List<Workout> _generalFitnessWorkouts(User user) {
    return [
      Workout(
        id: 6,
        userId: user.id,
        name: 'Full Body Workout',
        description: 'Balanced workout for overall fitness',
        exercises: [
          WorkoutExercise(
            exercise: Exercise(
              id: 13,
              name: 'Plank',
              category: 'Core',
              muscleGroups: ['Core'],
              difficulty: 'Easy',
            ),
            sets: 3,
            reps: 1,
            duration: 1,
          ),
          WorkoutExercise(
            exercise: Exercise(
              id: 14,
              name: 'Squats',
              category: 'Strength',
              muscleGroups: ['Legs'],
              difficulty: 'Medium',
            ),
            sets: 3,
            reps: 15,
          ),
        ],
        durationMinutes: 45,
        caloriesBurned: 300,
      ),
    ];
  }

  // Get user's workouts
  Future<List<Workout>> getWorkouts() async {
    try {
      final response = await _apiService.get('/workouts/');
      return (response.data as List)
          .map((json) => Workout.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch workouts: $e');
    }
  }

  // Get single workout by ID
  Future<Workout> getWorkout(int id) async {
    try {
      final response = await _apiService.get('/workouts/$id/');
      return Workout.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch workout: $e');
    }
  }

  // Create new workout
  Future<Workout> createWorkout(Workout workout) async {
    try {
      final response = await _apiService.post(
        '/workouts/',
        data: workout.toJson(),
      );
      return Workout.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create workout: $e');
    }
  }

  // Update workout
  Future<Workout> updateWorkout(int id, Workout workout) async {
    try {
      final response = await _apiService.put(
        '/workouts/$id/',
        data: workout.toJson(),
      );
      return Workout.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update workout: $e');
    }
  }

  // Delete workout
  Future<void> deleteWorkout(int id) async {
    try {
      await _apiService.delete('/workouts/$id/');
    } catch (e) {
      throw Exception('Failed to delete workout: $e');
    }
  }

  // Log workout session
  Future<void> logWorkoutSession(int workoutId, Map<String, dynamic> data) async {
    try {
      await _apiService.post(
        '/workouts/$workoutId/log/',
        data: data,
      );
    } catch (e) {
      throw Exception('Failed to log workout session: $e');
    }
  }
}
