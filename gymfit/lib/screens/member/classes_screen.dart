import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  
  // Mock class data
  final Map<DateTime, List<Map<String, dynamic>>> _classes = {};

  @override
  void initState() {
    super.initState();
    _loadMockClasses();
  }

  void _loadMockClasses() {
    final today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = today.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);
      
      _classes[normalizedDate] = [
        {
          'name': 'Morning Yoga',
          'trainer': 'Sarah Johnson',
          'time': '07:00 AM',
          'duration': '60 min',
          'capacity': 20,
          'enrolled': 15,
          'type': 'Yoga',
        },
        {
          'name': 'HIIT Training',
          'trainer': 'Mike Chen',
          'time': '09:00 AM',
          'duration': '45 min',
          'capacity': 15,
          'enrolled': 15,
          'type': 'HIIT',
        },
        {
          'name': 'Spin Class',
          'trainer': 'Emma Davis',
          'time': '06:00 PM',
          'duration': '50 min',
          'capacity': 25,
          'enrolled': 18,
          'type': 'Spinning',
        },
      ];
    }
  }

  List<Map<String, dynamic>> _getClassesForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _classes[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () => _showMyBookings(),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 30)),
              lastDay: DateTime.now().add(const Duration(days: 90)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: ThemeConfig.primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: ThemeConfig.primaryColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Classes on ${_selectedDay.day}/${_selectedDay.month}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${_getClassesForDay(_selectedDay).length} classes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildClassList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClassList() {
    final classes = _getClassesForDay(_selectedDay);
    
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No classes scheduled for this day'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classInfo = classes[index];
        final isFull = classInfo['enrolled'] >= classInfo['capacity'];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getClassColor(classInfo['type']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        classInfo['type'],
                        style: TextStyle(
                          color: _getClassColor(classInfo['type']),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (isFull)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: ThemeConfig.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'FULL',
                          style: TextStyle(
                            color: ThemeConfig.errorColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  classInfo['name'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16),
                    const SizedBox(width: 4),
                    Text(classInfo['trainer']),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text('${classInfo['time']} • ${classInfo['duration']}'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: classInfo['enrolled'] / classInfo['capacity'],
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isFull ? ThemeConfig.errorColor : ThemeConfig.successColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${classInfo['enrolled']}/${classInfo['capacity']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isFull ? null : () => _bookClass(classInfo['name']),
                    child: Text(isFull ? 'Class Full' : 'Book Class'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getClassColor(String type) {
    switch (type) {
      case 'Yoga': return ThemeConfig.accentColor;
      case 'HIIT': return ThemeConfig.secondaryColor;
      case 'Spinning': return ThemeConfig.primaryColor;
      case 'Zumba': return Colors.orange;
      default: return ThemeConfig.primaryColor;
    }
  }

  void _bookClass(String className) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Class'),
        content: Text('Book $className?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$className booked successfully!'),
                  backgroundColor: ThemeConfig.successColor,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showMyBookings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Bookings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            const Text('You have 3 upcoming classes booked.'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Morning Yoga'),
              subtitle: const Text('Tomorrow at 07:00 AM'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
