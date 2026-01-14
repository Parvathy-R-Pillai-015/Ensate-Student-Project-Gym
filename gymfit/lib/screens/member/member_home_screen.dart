import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gymfit/providers/auth_provider.dart';
import 'package:gymfit/utils/helpers.dart';
import 'package:gymfit/config/theme_config.dart';
import 'package:gymfit/screens/member/subscription_plans_screen.dart';
import 'package:gymfit/screens/member/subscription_status_screen.dart';
import 'package:gymfit/screens/member/my_workout_plans_screen.dart';
import 'package:gymfit/screens/member/my_diet_plans_screen.dart';
import 'package:gymfit/screens/member/attendance_history_screen.dart';
import 'package:gymfit/screens/member/notifications_screen.dart';
import 'package:gymfit/screens/member/food_logging_screen.dart';
import 'package:gymfit/screens/onboarding/onboarding_screen.dart';
import 'package:gymfit/services/workout_service.dart';
import 'package:gymfit/services/nutrition_service.dart';
import 'package:gymfit/services/dashboard_service.dart';
import 'package:gymfit/models/workout.dart';
import 'package:gymfit/models/nutrition.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({super.key});

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  final DashboardService _dashboardService = DashboardService();
  final NutritionService _nutritionService = NutritionService();
  Map<String, dynamic>? _dashboardData;
  int _dailyCalories = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final data = await _dashboardService.getDashboardData();
      
      // Load today's food log calories
      try {
        final foodLog = await _nutritionService.getTodaysFoodLog();
        _dailyCalories = foodLog.totalCalories;
      } catch (e) {
        print('Error loading food log: $e');
        _dailyCalories = 0;
      }
      
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final stats = _dashboardData?['stats'] ?? {};
    final membership = _dashboardData?['membership'] ?? {};
    final userData = _dashboardData?['user'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('GymFit'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: ThemeConfig.primaryColor,
                      child: Text(
                        Helpers.getInitials(user?.fullName ?? 'User'),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['greeting'] ?? Helpers.getGreeting(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData['name'] ?? user?.fullName ?? 'User',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Personalized Fitness Journey Banner
            if (user?.hasCompletedOnboarding != true)
              Card(
                color: Theme.of(context).primaryColor,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnboardingScreen(existingUser: user),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Get Your Personalized Plan!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Complete your profile to get custom workouts and meal plans',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              _buildPersonalizedSection(context, user!, _dashboardData?['fitness_profile']),
            
            const SizedBox(height: 24),
            
            // Quick Stats
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Workouts',
                    '${stats['workouts'] ?? 12}',
                    Icons.fitness_center,
                    ThemeConfig.primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyWorkoutPlansScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Daily Food Calories',
                    '${Helpers.formatNumber(_dailyCalories)}',
                    Icons.local_fire_department,
                    ThemeConfig.secondaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FoodLoggingScreen(),
                        ),
                      ).then((_) => _loadDashboardData());
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Classes',
                    '${stats['classes'] ?? 8}',
                    Icons.group,
                    ThemeConfig.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Days Active',
                    '${stats['days_active'] ?? 15}',
                    Icons.calendar_today,
                    ThemeConfig.warningColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AttendanceHistoryScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Membership Status
            Text(
              'Membership',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ThemeConfig.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.card_membership,
                        color: ThemeConfig.successColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            membership['type'] ?? 'Premium Membership',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${membership['days_remaining'] ?? 10} days remaining',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SubscriptionStatusScreen(),
                              ),
                            );
                          },
                          child: const Text('View'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SubscriptionPlansScreen(),
                              ),
                            );
                          },
                          child: const Text('Renew'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(
                  context,
                  'Upgrade Plan',
                  Icons.workspace_premium,
                  ThemeConfig.primaryColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionPlansScreen(),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Book Class',
                  Icons.calendar_month,
                  ThemeConfig.secondaryColor,
                  () {
                    // TODO: Navigate to classes
                  },
                ),
                _buildActionCard(
                  context,
                  'Attendance',
                  Icons.event_available,
                  ThemeConfig.successColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AttendanceHistoryScreen(),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Track Progress',
                  Icons.trending_up,
                  ThemeConfig.accentColor,
                  () {
                    // TODO: Navigate to progress
                  },
                ),
                _buildActionCard(
                  context,
                  'Meal Plan',
                  Icons.restaurant_menu,
                  ThemeConfig.warningColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyDietPlansScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Logout Button (temporary for testing)
            OutlinedButton.icon(
              onPressed: () async {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ThemeConfig.errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoPlayer(BuildContext context, String workoutName, String videoUrl) {
    final String viewId = 'video-player-${DateTime.now().millisecondsSinceEpoch}';
    
    // Register the iframe
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) => html.IFrameElement()
        ..src = videoUrl
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
        ..allowFullscreen = true,
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 800,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.black87,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        workoutName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: HtmlElementView(viewType: viewId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkoutVideos(BuildContext context) {
    final workouts = [
      {'name': 'Single Leg Bridge', 'video': 'https://www.youtube.com/embed/AVAXhy6pl7o', 'duration': '15 min'},
      {'name': 'Jumping Jacks', 'video': 'https://www.youtube.com/embed/2W4ZNSwoW_4', 'duration': '10 min'},
      {'name': 'Step Mill', 'video': 'https://www.youtube.com/embed/9ZknEYboBOQ', 'duration': '20 min'},
      {'name': 'Bench Press', 'video': 'https://www.youtube.com/embed/rT7DgCr-3pg', 'duration': '12 min'},
      {'name': 'Pull-up', 'video': 'https://www.youtube.com/embed/eGo4IYlbE5g', 'duration': '8 min'},
      {'name': 'Squat', 'video': 'https://www.youtube.com/embed/ultWZbUMPL8', 'duration': '15 min'},
      {'name': 'Jump Rope', 'video': 'https://www.youtube.com/embed/FJmRQ5iTXKE', 'duration': '5 min'},
      {'name': 'Burpees', 'video': 'https://www.youtube.com/embed/TU8QYVW0gDU', 'duration': '5 min'},
      {'name': 'Deadlift', 'video': 'https://www.youtube.com/embed/op9kVnSso6Q', 'duration': '10 min'},
      {'name': 'Lunges', 'video': 'https://www.youtube.com/embed/QOVaHwm-Q6U', 'duration': '12 min'},
      {'name': 'Plank', 'video': 'https://www.youtube.com/embed/ASdvN_XEl_c', 'duration': '8 min'},
      {'name': 'Mountain Climbers', 'video': 'https://www.youtube.com/embed/nmwgirgXLYM', 'duration': '10 min'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
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
                    'Workout Videos',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: workouts.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: ThemeConfig.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.play_circle_outline,
                          color: ThemeConfig.primaryColor,
                          size: 32,
                        ),
                      ),
                      title: Text(
                        workout['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Duration: ${workout['duration']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the workout list
                        _showVideoPlayer(context, workout['name']!, workout['video']!);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizedSection(BuildContext context, user, Map<String, dynamic>? fitnessProfile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fitness Profile Summary
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_pin,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Your Fitness Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileInfoTile(
                        'Goal',
                        fitnessProfile?['goal'] ?? user.fitnessGoal?.replaceAll('_', ' ') ?? 'Not Set',
                        Icons.flag,
                      ),
                    ),
                    Expanded(
                      child: _buildProfileInfoTile(
                        'Diet',
                        fitnessProfile?['diet'] ?? user.dietaryPreference?.replaceAll('_', ' ') ?? 'Not Set',
                        Icons.restaurant_menu,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileInfoTile(
                        'Current',
                        fitnessProfile?['current_weight'] != null 
                          ? '${fitnessProfile!['current_weight']} kg' 
                          : (user.currentWeight != null ? '${user.currentWeight} kg' : 'Not Set'),
                        Icons.monitor_weight,
                      ),
                    ),
                    Expanded(
                      child: _buildProfileInfoTile(
                        'Target',
                        fitnessProfile?['target_weight'] != null 
                          ? '${fitnessProfile!['target_weight']} kg' 
                          : (user.targetWeight != null ? '${user.targetWeight} kg' : 'Not Set'),
                        Icons.emoji_events,
                      ),
                    ),
                  ],
                ),
                if (fitnessProfile?['daily_calories'] != null || user.targetDailyCalories != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Daily Target: ${fitnessProfile?['daily_calories'] ?? user.targetDailyCalories} calories',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Quick Action to update profile
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingScreen(existingUser: user),
              ),
            );
          },
          icon: const Icon(Icons.edit),
          label: const Text('Update Fitness Profile'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    final child = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );

    return Card(
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: child,
            )
          : child,
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
