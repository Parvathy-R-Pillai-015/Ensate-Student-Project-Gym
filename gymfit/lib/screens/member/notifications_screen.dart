import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  
  // Mock notifications data
  final List<NotificationItem> _allNotifications = [
    NotificationItem(
      id: '1',
      type: 'Renewal',
      title: 'Membership Expiring Soon',
      message: 'Your Premium membership will expire in 7 days. Renew now to continue enjoying all benefits!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      icon: Icons.warning_amber,
      color: Colors.orange,
    ),
    NotificationItem(
      id: '2',
      type: 'Offer',
      title: 'Special New Year Offer! 🎉',
      message: 'Get 25% off on Annual Premium membership. Limited time offer valid till Jan 15, 2026.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      icon: Icons.local_offer,
      color: Colors.red,
    ),
    NotificationItem(
      id: '3',
      type: 'General',
      title: 'New Workout Plan Available',
      message: 'Your trainer has assigned a new workout plan. Check it out now!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      icon: Icons.fitness_center,
      color: ThemeConfig.primaryColor,
    ),
    NotificationItem(
      id: '4',
      type: 'Offer',
      title: 'Friend Referral Bonus',
      message: 'Refer a friend and get 1 month free! Share your unique referral code: GYM2026',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      isRead: true,
      icon: Icons.card_giftcard,
      color: Colors.purple,
    ),
    NotificationItem(
      id: '5',
      type: 'General',
      title: 'Gym Maintenance Notice',
      message: 'The gym will be closed for maintenance on Sunday, Jan 5 from 6 AM to 10 AM.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      icon: Icons.build,
      color: Colors.grey,
    ),
    NotificationItem(
      id: '6',
      type: 'Renewal',
      title: 'Payment Successful',
      message: 'Your membership payment of \$99.99 has been processed successfully.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      icon: Icons.check_circle,
      color: ThemeConfig.successColor,
    ),
    NotificationItem(
      id: '7',
      type: 'Offer',
      title: 'Personal Training Discount',
      message: 'Book 10 personal training sessions and get 2 free! Offer valid this month.',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
      icon: Icons.person,
      color: Colors.blue,
    ),
    NotificationItem(
      id: '8',
      type: 'General',
      title: 'New Class Added: Yoga',
      message: 'Join our new morning Yoga class every Monday & Wednesday at 7 AM.',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
      icon: Icons.self_improvement,
      color: Colors.teal,
    ),
    NotificationItem(
      id: '9',
      type: 'Offer',
      title: 'Diet Plan Consultation Free',
      message: 'Get a free nutrition consultation with our expert dietitian this week.',
      timestamp: DateTime.now().subtract(const Duration(days: 6)),
      isRead: true,
      icon: Icons.restaurant_menu,
      color: Colors.green,
    ),
    NotificationItem(
      id: '10',
      type: 'General',
      title: 'Attendance Milestone! 🏆',
      message: 'Congratulations! You\'ve completed 30 days of consistent gym attendance.',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
      icon: Icons.emoji_events,
      color: Colors.amber,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    switch (_selectedFilter) {
      case 'Unread':
        return _allNotifications.where((n) => !n.isRead).toList();
      case 'Offers':
        return _allNotifications.where((n) => n.type == 'Offer').toList();
      case 'Renewals':
        return _allNotifications.where((n) => n.type == 'Renewal').toList();
      default:
        return _allNotifications;
    }
  }

  int get _unreadCount => _allNotifications.where((n) => !n.isRead).length;

  void _markAsRead(String id) {
    setState(() {
      final notification = _allNotifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      _allNotifications.removeWhere((n) => n.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
              onPressed: _markAllAsRead,
            ),
        ],
      ),
      body: Column(
        children: [
          // Header with unread count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConfig.accentColor,
                  ThemeConfig.accentColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.notifications_active,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  _unreadCount > 0
                      ? 'You have $_unreadCount unread notification${_unreadCount > 1 ? 's' : ''}'
                      : 'All caught up!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
                  _buildFilterChip('All', _allNotifications.length),
                  const SizedBox(width: 8),
                  _buildFilterChip('Unread', _unreadCount),
                  const SizedBox(width: 8),
                  _buildFilterChip('Offers', _allNotifications.where((n) => n.type == 'Offer').length),
                  const SizedBox(width: 8),
                  _buildFilterChip('Renewals', _allNotifications.where((n) => n.type == 'Renewal').length),
                ],
              ),
            ),
          ),
          
          // Notifications List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications found',
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
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? ThemeConfig.accentColor : Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: ThemeConfig.accentColor.withOpacity(0.2),
      checkmarkColor: ThemeConfig.accentColor,
      labelStyle: TextStyle(
        color: isSelected ? ThemeConfig.accentColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: notification.isRead ? Colors.white : ThemeConfig.accentColor.withOpacity(0.05),
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              _markAsRead(notification.id);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: notification.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: ThemeConfig.accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getTimeAgo(notification.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: notification.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              notification.type,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: notification.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.icon,
    required this.color,
  });
}
