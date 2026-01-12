class Exercise {
  final int id;
  final String name;
  final String category;
  final List<String> muscleGroups;
  final String? description;
  final String? videoUrl;
  final String? imageUrl;
  final String difficulty;
  
  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscleGroups,
    this.description,
    this.videoUrl,
    this.imageUrl,
    this.difficulty = 'Medium',
  });
  
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      muscleGroups: List<String>.from(json['muscle_groups'] ?? []),
      description: json['description'],
      videoUrl: json['video_url'],
      imageUrl: json['image_url'],
      difficulty: json['difficulty'] ?? 'Medium',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'muscle_groups': muscleGroups,
      'description': description,
      'video_url': videoUrl,
      'image_url': imageUrl,
      'difficulty': difficulty,
    };
  }
}

class WorkoutExercise {
  final Exercise exercise;
  final int sets;
  final int reps;
  final double? weight;
  final int? duration;
  final String? notes;
  
  WorkoutExercise({
    required this.exercise,
    required this.sets,
    required this.reps,
    this.weight,
    this.duration,
    this.notes,
  });
  
  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exercise: Exercise.fromJson(json['exercise'] ?? {}),
      sets: json['sets'] ?? 0,
      reps: json['reps'] ?? 0,
      weight: json['weight']?.toDouble(),
      duration: json['duration'],
      notes: json['notes'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise.toJson(),
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration': duration,
      'notes': notes,
    };
  }
}

class Workout {
  final int? id;
  final int userId;
  final String name;
  final String? description;
  final List<WorkoutExercise> exercises;
  final DateTime? date;
  final int? durationMinutes;
  final int? caloriesBurned;
  final String? notes;
  final DateTime? createdAt;
  
  Workout({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.exercises,
    this.date,
    this.durationMinutes,
    this.caloriesBurned,
    this.notes,
    this.createdAt,
  });
  
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      exercises: (json['exercises'] as List?)
          ?.map((e) => WorkoutExercise.fromJson(e))
          .toList() ?? [],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      durationMinutes: json['duration_minutes'],
      caloriesBurned: json['calories_burned'],
      notes: json['notes'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'date': date?.toIso8601String(),
      'duration_minutes': durationMinutes,
      'calories_burned': caloriesBurned,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
