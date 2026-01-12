import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  String _selectedFilter = 'All';
  
  // Mock attendance data
  final List<AttendanceRecord> _attendanceRecords = [
    AttendanceRecord(
      date: DateTime(2026, 1, 2),
      checkInTime: '06:30 AM',
      checkOutTime: '08:15 AM',
      duration: '1h 45m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2026, 1, 1),
      checkInTime: '07:00 AM',
      checkOutTime: '09:00 AM',
      duration: '2h 0m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 30),
      checkInTime: '06:45 AM',
      checkOutTime: '08:30 AM',
      duration: '1h 45m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 28),
      checkInTime: '05:30 PM',
      checkOutTime: '07:15 PM',
      duration: '1h 45m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 27),
      checkInTime: '06:15 AM',
      checkOutTime: '08:00 AM',
      duration: '1h 45m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 25),
      checkInTime: '07:30 AM',
      checkOutTime: '09:15 AM',
      duration: '1h 45m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 23),
      checkInTime: '06:00 AM',
      checkOutTime: '07:30 AM',
      duration: '1h 30m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 21),
      checkInTime: '05:45 PM',
      checkOutTime: '07:45 PM',
      duration: '2h 0m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 20),
      checkInTime: '06:30 AM',
      checkOutTime: '08:00 AM',
      duration: '1h 30m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 18),
      checkInTime: '07:00 AM',
      checkOutTime: '08:45 AM',
      duration: '1h 45m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 16),
      checkInTime: '06:15 AM',
      checkOutTime: '08:15 AM',
      duration: '2h 0m',
      status: 'Present',
    ),
    AttendanceRecord(
      date: DateTime(2025, 12, 14),
      checkInTime: '05:30 PM',
      checkOutTime: '07:00 PM',
      duration: '1h 30m',
      status: 'Present',
    ),
  ];

  List<AttendanceRecord> get _filteredRecords {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'This Week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return _attendanceRecords.where((r) => r.date.isAfter(weekAgo)).toList();
      case 'This Month':
        final monthAgo = now.subtract(const Duration(days: 30));
        return _attendanceRecords.where((r) => r.date.isAfter(monthAgo)).toList();
      case 'Last 3 Months':
        final threeMonthsAgo = now.subtract(const Duration(days: 90));
        return _attendanceRecords.where((r) => r.date.isAfter(threeMonthsAgo)).toList();
      default:
        return _attendanceRecords;
    }
  }

  int get _totalDaysPresent => _filteredRecords.length;
  
  String get _totalHours {
    int totalMinutes = 0;
    for (var record in _filteredRecords) {
      final parts = record.duration.split(' ');
      final hours = int.parse(parts[0].replaceAll('h', ''));
      final minutes = int.parse(parts[1].replaceAll('m', ''));
      totalMinutes += (hours * 60) + minutes;
    }
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  double get _attendanceRate {
    final now = DateTime.now();
    int expectedDays = 0;
    
    switch (_selectedFilter) {
      case 'This Week':
        expectedDays = 7 * 3; // 3 days per week expected
        break;
      case 'This Month':
        expectedDays = 30 ~/ 7 * 3; // ~12 days
        break;
      case 'Last 3 Months':
        expectedDays = 90 ~/ 7 * 3; // ~38 days
        break;
      default:
        expectedDays = 100; // Arbitrary for "All"
    }
    
    return (_totalDaysPresent / expectedDays * 100).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Statistics Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConfig.primaryColor,
                  ThemeConfig.primaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Attendance Record',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('Days Present', _totalDaysPresent.toString()),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStatItem('Total Hours', _totalHours),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStatItem('Rate', '${_attendanceRate.toStringAsFixed(0)}%'),
                  ],
                ),
              ],
            ),
          ),
          
          // Filter Chips
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('This Week'),
                  const SizedBox(width: 8),
                  _buildFilterChip('This Month'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Last 3 Months'),
                ],
              ),
            ),
          ),
          
          // Attendance List
          Expanded(
            child: _filteredRecords.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No attendance records found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = _filteredRecords[index];
                      return _buildAttendanceCard(record, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: ThemeConfig.primaryColor.withOpacity(0.2),
      checkmarkColor: ThemeConfig.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? ThemeConfig.primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceRecord record, int index) {
    final now = DateTime.now();
    final isToday = record.date.year == now.year &&
        record.date.month == now.month &&
        record.date.day == now.day;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Date Circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isToday
                    ? ThemeConfig.primaryColor.withOpacity(0.1)
                    : ThemeConfig.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getMonthName(record.date.month),
                    style: TextStyle(
                      fontSize: 12,
                      color: isToday ? ThemeConfig.primaryColor : ThemeConfig.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    record.date.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isToday ? ThemeConfig.primaryColor : ThemeConfig.accentColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getDayName(record.date.weekday),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isToday)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ThemeConfig.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Today',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.login, size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        record.checkInTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.logout, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        record.checkOutTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Duration: ${record.duration}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: ThemeConfig.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: ThemeConfig.successColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    record.status,
                    style: const TextStyle(
                      color: ThemeConfig.successColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }
}

class AttendanceRecord {
  final DateTime date;
  final String checkInTime;
  final String checkOutTime;
  final String duration;
  final String status;

  AttendanceRecord({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.duration,
    required this.status,
  });
}
