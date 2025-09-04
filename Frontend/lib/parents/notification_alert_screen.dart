// lib/parents/notification_alert_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

// Define consistent color palette
// Make sure these are the same as in your other screens (e.g., ChildProgressScreen)
const Color _primaryGradientStart = Color(0xFFDFF2B2);
const Color _primaryGradientEnd = Color(0xFFB4E197);
const Color _primaryAccentColor = Color(0xFF218838); // Dark green accent
const Color _iconBgColor = Color(0xFFE6F4EA); // Very light green for icon backgrounds

// Enum to define different types of notifications
enum NotificationType {
  general,
  attendance,
  homework,
  alert,
  announcement,
}

// Model for a single notification item
class NotificationItem {
  final String id; // Unique ID for potential future dismissal/tracking
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.type = NotificationType.general,
    this.isRead = false,
  });

  // Helper getters to determine icon and color based on type
  IconData get icon {
    switch (type) {
      case NotificationType.attendance:
        return Icons.event_note;
      case NotificationType.homework:
        return Icons.assignment;
      case NotificationType.alert:
        return Icons.warning_amber;
      case NotificationType.announcement:
        return Icons.campaign;
      case NotificationType.general:
      default:
        return Icons.notifications;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.attendance:
        return Colors.blue[700]!;
      case NotificationType.homework:
        return Colors.deepPurple[700]!;
      case NotificationType.alert:
        return Colors.red[700]!;
      case NotificationType.announcement:
        return Colors.orange[700]!;
      case NotificationType.general:
      default:
        return Colors.grey[700]!;
    }
  }
}

class NotificationAlertScreen extends StatefulWidget {
  const NotificationAlertScreen({super.key});

  @override
  State<NotificationAlertScreen> createState() => _NotificationAlertScreenState();
}

class _NotificationAlertScreenState extends State<NotificationAlertScreen> {
  // Dummy data for notifications
  // In a real app, this would come from an API or local database
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New Homework Assigned',
      message: 'Math homework on Algebra has been assigned. Due Friday.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.homework,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Attendance Alert: John Absent',
      message: 'John Doe was marked absent today, July 9th.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      type: NotificationType.attendance,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'School Closed Tomorrow',
      message: 'Due to heavy rain, school will remain closed on July 10th.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      type: NotificationType.announcement,
      isRead: false,
    ),
    NotificationItem(
      id: '4',
      title: 'Reminder: Parent-Teacher Meeting',
      message: 'Your meeting with Ms. Smith is scheduled for July 15th at 3 PM.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.general,
      isRead: true, // Example of an already read notification
    ),
    NotificationItem(
      id: '5',
      title: 'High Priority: Fee Payment Overdue',
      message: 'Action Required: Your tuition fee payment for Q2 is overdue. Please pay by end of week.',
      timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
      type: NotificationType.alert,
      isRead: false,
    ),
    NotificationItem(
      id: '6',
      title: 'New Grade Available: Science Quiz',
      message: 'John Doe\'s Science quiz results are now available. Check progress page.',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      type: NotificationType.general,
      isRead: true,
    ),
    NotificationItem(
      id: '7',
      title: 'Field Trip Reminder',
      message: 'Permission slips for the zoo field trip are due next Monday.',
      timestamp: DateTime.now().subtract(const Duration(days: 9)),
      type: NotificationType.announcement,
      isRead: false,
    ),
  ];

  void _toggleReadStatus(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((item) => item.id == notificationId);
      if (index != -1) {
        _notifications[index].isRead = !_notifications[index].isRead;
      }
    });
  }

  void _dismissNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((item) => item.id == notificationId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification dismissed'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // In a real app, you might restore from a temporary list
            // For this example, we'll just show it's "undone" visually
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Undo not implemented in demo')),
            );
          },
        ),
      ),
    );
  }

  // Helper function to format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final notificationDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (notificationDate.isAtSameMomentAs(today)) {
      return DateFormat.jm().format(timestamp); // e.g., 2:30 PM
    } else if (notificationDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday, ${DateFormat.jm().format(timestamp)}';
    } else {
      return DateFormat('MMM d, hh:mm a').format(timestamp); // e.g., Jul 5, 10:45 AM
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryGradientStart, _primaryGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Notifications & Alerts',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button space
                ],
              ),
            ),
          ),
        ),
      ),
      body: _notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No new notifications',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildNotificationCard(notification),
          );
        },
      ),
    );
  }

  // --- Helper Widget for a single notification card ---
  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.grey[50] : Colors.white, // Lighter background for read notifications
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: _primaryAccentColor.withOpacity(notification.isRead ? 0.05 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material( // Use Material to enable InkWell for tap effects
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () => _toggleReadStatus(notification.id),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: notification.iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(notification.icon, color: notification.iconColor, size: 28),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: notification.isRead ? Colors.grey[700] : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: notification.isRead ? Colors.grey : Colors.grey[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                // Optional: Add a dismiss button or swipe-to-dismiss gesture
                // For now, let's add a trailing icon for visual feedback on read status
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    notification.isRead ? Icons.check_circle_outline : Icons.circle,
                    size: 18,
                    color: notification.isRead ? Colors.green : Colors.grey[300],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[400], size: 20),
                  onPressed: () => _dismissNotification(notification.id),
                  tooltip: 'Dismiss',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}