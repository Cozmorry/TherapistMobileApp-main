import 'package:flutter/material.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/services/notification_service.dart';

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  bool _hasNotificationPermission = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
    _loadNotifications();
  }

  Future<void> _checkNotificationPermission() async {
    final hasPermission = await NotificationService.hasNotificationPermission();
    setState(() {
      _hasNotificationPermission = hasPermission;
    });
    
    if (!hasPermission) {
      // Request permission if not granted
      await NotificationService.requestPermissions();
      // Check again after request
      final newPermissionStatus = await NotificationService.hasNotificationPermission();
      setState(() {
        _hasNotificationPermission = newPermissionStatus;
      });
    }
  }

  void _loadNotifications() {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = AuthService().currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email!;
        final userData = LocalStorageService.getUserDataByEmail(userEmail);
        final isTherapist = userData?.role == 'therapist';
        
        // Get all bookings to create notifications
        final allBookings = LocalStorageService.getAllBookings();
        final List<Map<String, dynamic>> notifications = [];
        
        if (isTherapist) {
          // For therapists: show new bookings
          for (final booking in allBookings) {
            if (booking['therapistEmail'] == userEmail && booking['status'] == 'pending') {
              notifications.add({
                'type': 'new_booking',
                'title': 'New Booking Request',
                'message': '${booking['clientName']} has requested a ${booking['sessionType']} session on ${booking['date']}',
                'timestamp': booking['bookedAt'],
                'booking': booking,
              });
            }
          }
        } else {
          // For clients: show booking status updates
          for (final booking in allBookings) {
            if (booking['clientEmail'] == userEmail) {
              String title = '';
              String message = '';
              
              switch (booking['status']) {
                case 'confirmed':
                  title = 'Booking Confirmed!';
                  message = '${booking['therapistName']} has confirmed your ${booking['sessionType']} session on ${booking['date']}';
                  break;
                case 'cancelled':
                  title = 'Booking Declined';
                  message = '${booking['therapistName']} has declined your ${booking['sessionType']} session on ${booking['date']}';
                  break;
                case 'completed':
                  title = 'Session Completed';
                  message = 'Your ${booking['sessionType']} session with ${booking['therapistName']} on ${booking['date']} has been marked as completed';
                  break;
              }
              
              if (title.isNotEmpty) {
                notifications.add({
                  'type': booking['status'],
                  'title': title,
                  'message': message,
                  'timestamp': booking['bookedAt'],
                  'booking': booking,
                });
              }
            }
          }
        }
        
        // Sort by timestamp (newest first)
        notifications.sort((a, b) {
          final timestampA = a['timestamp'] ?? '';
          final timestampB = b['timestamp'] ?? '';
          return timestampB.compareTo(timestampA); // Latest first
        });
        
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
        
        print('NotificationCenter: Loaded ${notifications.length} notifications for user: $userEmail');
      } else {
        setState(() {
          _notifications = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _notifications = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Permission status indicator
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _hasNotificationPermission ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _hasNotificationPermission ? Icons.notifications_active : Icons.notifications_off,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _hasNotificationPermission ? 'Enabled' : 'Disabled',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
            )
          : _notifications.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    _loadNotifications();
                  },
                  color: const Color(0xFFE91E63),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(_notifications[index]);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.notifications_none,
              color: Color(0xFFE91E63),
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'You\'ll see notifications here when you have new updates.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final title = notification['title'] ?? '';
    final message = notification['message'] ?? '';
    final type = notification['type'] ?? '';
    final timestamp = notification['timestamp'] ?? '';
    
    // Get icon and color based on notification type
    IconData icon;
    Color color;
    
    switch (type) {
      case 'new_booking':
        icon = Icons.calendar_today;
        color = Colors.blue;
        break;
      case 'confirmed':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'cancelled':
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case 'completed':
        icon = Icons.done_all;
        color = Colors.purple;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Just now', // You could format the actual timestamp here
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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
} 