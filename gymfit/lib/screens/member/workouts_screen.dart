import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';
import 'package:gymfit/utils/constants.dart';
import 'package:gymfit/screens/member/workout_timer_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Workouts'),
            Tab(text: 'Exercise Library'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyWorkouts(),
          _buildExerciseLibrary(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateWorkoutDialog(),
        icon: const Icon(Icons.add),
        label: const Text('New Workout'),
      ),
    );
  }

  Widget _buildMyWorkouts() {
    // Mock workout data
    final workouts = [
      {'name': 'Morning Cardio', 'exercises': 5, 'duration': '45 min', 'date': 'Today'},
      {'name': 'Upper Body Strength', 'exercises': 8, 'duration': '60 min', 'date': 'Yesterday'},
      {'name': 'Leg Day', 'exercises': 6, 'duration': '50 min', 'date': '2 days ago'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeConfig.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fitness_center, color: ThemeConfig.primaryColor),
            ),
            title: Text(workout['name'] as String),
            subtitle: Text('${workout['exercises']} exercises • ${workout['duration']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  color: ThemeConfig.successColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutTimerScreen(
                          workoutName: workout['name'] as String,
                        ),
                      ),
                    );
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      workout['date'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
              ],
            ),
            onTap: () => _showWorkoutDetails(workout['name'] as String),
          ),
        );
      },
    );
  }

  Widget _buildExerciseLibrary() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: AppConstants.workoutCategories.length,
      itemBuilder: (context, index) {
        final category = AppConstants.workoutCategories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Icon(_getCategoryIcon(category), color: ThemeConfig.primaryColor),
            title: Text(category),
            subtitle: Text('${_getExerciseCount(category)} exercises'),
            children: _buildCategoryExercises(category),
          ),
        );
      },
    );
  }

  List<Widget> _buildCategoryExercises(String category) {
    // Mock exercises
    final exercises = {
      'Cardio': ['Running', 'Cycling', 'Jump Rope', 'Rowing'],
      'Strength': ['Bench Press', 'Squats', 'Deadlifts', 'Pull-ups'],
      'Flexibility': ['Stretching', 'Yoga Flow', 'Foam Rolling'],
    };

    final categoryExercises = exercises[category] ?? ['Exercise 1', 'Exercise 2'];
    
    return categoryExercises.map((exercise) => ListTile(
      dense: true,
      leading: const Icon(Icons.play_circle_outline, size: 20),
      title: Text(exercise),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        onPressed: () => _addExerciseToWorkout(exercise),
      ),
      onTap: () => _showExerciseDetails(exercise),
    )).toList();
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Cardio': return Icons.directions_run;
      case 'Strength': return Icons.fitness_center;
      case 'Flexibility': return Icons.self_improvement;
      case 'HIIT': return Icons.flash_on;
      case 'Yoga': return Icons.spa;
      default: return Icons.sports_gymnastics;
    }
  }

  int _getExerciseCount(String category) {
    return 10 + category.length; // Mock count
  }

  void _showCreateWorkoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                hintText: 'e.g., Morning Cardio',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Feature coming soon: Create custom workouts with exercise selection!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Workout created! (Demo)')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showWorkoutDetails(String name) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            const Text('Exercise details and tracking will appear here.'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Workout started! (Demo)')),
                  );
                },
                child: const Text('Start Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExerciseDetails(String exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Instructions:'),
            const SizedBox(height: 8),
            Text('Detailed instructions for $exercise would appear here with form tips and video demonstrations.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addExerciseToWorkout(String exercise) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$exercise added to workout!')),
    );
  }
}
