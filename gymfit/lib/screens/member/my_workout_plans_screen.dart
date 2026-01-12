import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';
import 'package:gymfit/models/workout.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class MyWorkoutPlansScreen extends StatefulWidget {
  const MyWorkoutPlansScreen({super.key});

  @override
  State<MyWorkoutPlansScreen> createState() => _MyWorkoutPlansScreenState();
}

class _MyWorkoutPlansScreenState extends State<MyWorkoutPlansScreen> {
  // Mock workout plans - replace with API data
  final List<Workout> _workoutPlans = [
    Workout(
      id: 1,
      userId: 1,
      name: 'Full Body Strength',
      description: 'Complete full body workout targeting all major muscle groups',
      exercises: [
        WorkoutExercise(
          exercise: Exercise(
            id: 1,
            name: 'Barbell Squat',
            category: 'Strength',
            muscleGroups: ['Quadriceps', 'Glutes', 'Hamstrings'],
            difficulty: 'Medium',
            description: 'Stand with feet shoulder-width apart, lower down by bending knees',
            videoUrl: 'https://www.youtube.com/embed/gcNh17Ckjgg',
          ),
          sets: 4,
          reps: 10,
          weight: 135,
        ),
        WorkoutExercise(
          exercise: Exercise(
            id: 2,
            name: 'Bench Press',
            category: 'Strength',
            muscleGroups: ['Chest', 'Triceps', 'Shoulders'],
            difficulty: 'Medium',
            description: 'Lie on bench, lower bar to chest, press up',
            videoUrl: 'https://www.youtube.com/embed/rT7DgCr-3pg',
          ),
          sets: 4,
          reps: 8,
          weight: 155,
        ),
        WorkoutExercise(
          exercise: Exercise(
            id: 3,
            name: 'Deadlift',
            category: 'Strength',
            muscleGroups: ['Back', 'Hamstrings', 'Glutes'],
            difficulty: 'Hard',
            description: 'Bend at hips and knees, grab bar, stand up straight',
            videoUrl: 'https://www.youtube.com/embed/op9kVnSso6Q',
          ),
          sets: 3,
          reps: 8,
          weight: 185,
        ),
        WorkoutExercise(
          exercise: Exercise(
            id: 4,
            name: 'Pull-ups',
            category: 'Strength',
            muscleGroups: ['Back', 'Biceps'],
            difficulty: 'Medium',
            description: 'Hang from bar, pull yourself up until chin over bar',
            videoUrl: 'https://www.youtube.com/embed/eGo4IYlbE5g',
          ),
          sets: 3,
          reps: 10,
        ),
      ],
      durationMinutes: 60,
      date: DateTime.now(),
    ),
    Workout(
      id: 2,
      userId: 1,
      name: 'Cardio Blast',
      description: 'High-intensity cardio workout to burn calories and improve endurance',
      exercises: [
        WorkoutExercise(
          exercise: Exercise(
            id: 5,
            name: 'Treadmill Run',
            category: 'Cardio',
            muscleGroups: ['Legs', 'Cardio'],
            difficulty: 'Medium',
            description: 'Run at moderate to high intensity',
            videoUrl: 'https://www.youtube.com/embed/brFHyOtTwH4',
          ),
          sets: 1,
          reps: 1,
          duration: 20,
          notes: 'Speed: 7.5 mph, Incline: 2%',
        ),
        WorkoutExercise(
          exercise: Exercise(
            id: 6,
            name: 'Burpees',
            category: 'Cardio',
            muscleGroups: ['Full Body'],
            difficulty: 'Hard',
            description: 'Drop to plank, do push-up, jump up with hands overhead',
            videoUrl: 'https://www.youtube.com/embed/dZgVxmf6jkA',
          ),
          sets: 4,
          reps: 15,
        ),
        WorkoutExercise(
          exercise: Exercise(
            id: 7,
            name: 'Mountain Climbers',
            category: 'Cardio',
            muscleGroups: ['Core', 'Cardio'],
            difficulty: 'Medium',
            description: 'In plank position, alternate bringing knees to chest',
            videoUrl: 'https://www.youtube.com/embed/nmwgirgXLYM',
          ),
          sets: 4,
          reps: 30,
        ),
      ],
      durationMinutes: 45,
      date: DateTime.now().add(const Duration(days: 1)),
    ),
    Workout(
      id: 3,
      userId: 1,
      name: 'Upper Body Focus',
      description: 'Intensive upper body workout for chest, back, and arms',
      exercises: [
        WorkoutExercise(
          exercise: Exercise(
            id: 8,
            name: 'Incline Dumbbell Press',
            category: 'Strength',
            muscleGroups: ['Upper Chest', 'Shoulders'],
            difficulty: 'Medium',
            description: 'Press dumbbells up on incline bench',
            videoUrl: 'https://www.youtube.com/embed/8iPEnn-ltC8',
          ),
          sets: 4,
          reps: 10,
          weight: 60,
        ),
        WorkoutExercise(
          exercise: Exercise(
            id: 9,
            name: 'Lat Pulldown',
            category: 'Strength',
            muscleGroups: ['Back', 'Biceps'],
            difficulty: 'Medium',
            description: 'Pull bar down to upper chest',
            videoUrl: 'https://www.youtube.com/embed/CAwf7n6Luuc',
          ),
          sets: 4,
          reps: 12,
          weight: 120,
        ),
        WorkoutExercise(
          exercise: Exercise(
            id: 10,
            name: 'Bicep Curls',
            category: 'Strength',
            muscleGroups: ['Biceps'],
            difficulty: 'Easy',
            description: 'Curl dumbbells up to shoulders',
            videoUrl: 'https://www.youtube.com/embed/ykJmrZ5v0Oo',
          ),
          sets: 3,
          reps: 12,
          weight: 30,
        ),
        WorkoutExercise(
          exercise: Exercise(
            id: 11,
            name: 'Tricep Dips',
            category: 'Strength',
            muscleGroups: ['Triceps', 'Chest'],
            difficulty: 'Medium',
            description: 'Lower body by bending elbows, push back up',
            videoUrl: 'https://www.youtube.com/embed/6kALZikXxLc',
          ),
          sets: 3,
          reps: 15,
        ),
      ],
      durationMinutes: 50,
      date: DateTime.now().add(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workout Plans'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConfig.primaryColor,
                  ThemeConfig.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.fitness_center,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Personalized Plans',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_workoutPlans.length} workout plans available',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Workout Plans List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _workoutPlans.length,
              itemBuilder: (context, index) {
                final workout = _workoutPlans[index];
                return _buildWorkoutPlanCard(workout);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutPlanCard(Workout workout) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showWorkoutDetails(workout),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ThemeConfig.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: ThemeConfig.primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          workout.description ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip(
                    Icons.list_alt,
                    '${workout.exercises.length} Exercises',
                    ThemeConfig.primaryColor,
                  ),
                  _buildStatChip(
                    Icons.timer_outlined,
                    '${workout.durationMinutes} min',
                    ThemeConfig.secondaryColor,
                  ),
                  _buildStatChip(
                    Icons.local_fire_department,
                    '~${(workout.durationMinutes ?? 0) * 8} cal',
                    ThemeConfig.warningColor,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showWorkoutDetails(workout),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showWorkoutDetails(Workout workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    workout.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workout.description ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: workout.exercises.length,
                itemBuilder: (context, index) {
                  final workoutExercise = workout.exercises[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: ThemeConfig.primaryColor.withOpacity(0.1),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: ThemeConfig.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        workoutExercise.exercise.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${workoutExercise.sets} sets × ${workoutExercise.reps} reps'
                        '${workoutExercise.weight != null ? ' @ ${workoutExercise.weight}lbs' : ''}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (workoutExercise.exercise.description != null) ...[
                                const Text(
                                  'Description:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  workoutExercise.exercise.description!,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 12),
                              ],
                              const Text(
                                'Muscle Groups:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: workoutExercise.exercise.muscleGroups.map((muscle) {
                                  return Chip(
                                    label: Text(
                                      muscle,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    backgroundColor: ThemeConfig.primaryColor.withOpacity(0.1),
                                    padding: EdgeInsets.zero,
                                  );
                                }).toList(),
                              ),
                              if (workoutExercise.notes != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          workoutExercise.notes!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showWorkoutVideos(context, workout);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Workout'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkoutVideos(BuildContext context, Workout workout) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeConfig.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.play_circle, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${workout.name} - Exercise Videos',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Video List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: workout.exercises.length,
                  itemBuilder: (context, index) {
                    final workoutExercise = workout.exercises[index];
                    final exercise = workoutExercise.exercise;
                    
                    if (exercise.videoUrl == null || exercise.videoUrl!.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Exercise Title
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: ThemeConfig.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (workoutExercise.sets != null)
                                        Text(
                                          '${workoutExercise.sets} sets × ${workoutExercise.reps} reps',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Video Player
                          Container(
                            height: 250,
                            color: Colors.black,
                            child: _buildVideoPlayer(exercise.videoUrl!, '${workout.name}_${exercise.name}_$index'),
                          ),
                          
                          // Exercise Info
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              exercise.description ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(String videoUrl, String viewId) {
    // Register the iframe
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = videoUrl
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%'
          ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture';
        return iframe;
      },
    );

    return HtmlElementView(viewType: viewId);
  }}