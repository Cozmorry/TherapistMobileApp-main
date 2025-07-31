import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    print('NotificationService: Initialized successfully');
  }

  static Future<void> requestPermissions() async {
    try {
      print('NotificationService: Requesting notification permissions...');
      
      // Check current notification permission status
      final notificationStatus = await Permission.notification.status;
      print('NotificationService: Current notification permission status: $notificationStatus');
      
      if (notificationStatus.isGranted) {
        print('NotificationService: Notification permission already granted');
        return;
      }
      
      // Request notification permission
      final notificationResult = await Permission.notification.request();
      print('NotificationService: Notification permission request result: $notificationResult');
      
      if (notificationResult.isDenied) {
        print('NotificationService: Notification permission denied');
      } else if (notificationResult.isPermanentlyDenied) {
        print('NotificationService: Notification permission permanently denied');
      } else if (notificationResult.isGranted) {
        print('NotificationService: Notification permission granted');
      }
      
    } catch (e) {
      print('NotificationService: Error requesting notification permissions: $e');
    }
  }

  static Future<bool> hasNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      return status.isGranted;
    } catch (e) {
      print('NotificationService: Error checking notification permission: $e');
      return false;
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    print('NotificationService: Would show notification - $title: $body');
    
    // Check if we have permission before attempting to show notification
    final hasPermission = await hasNotificationPermission();
    if (!hasPermission) {
      print('NotificationService: No notification permission, cannot show notification');
      return;
    }
    
    // In a real app, this would show a local notification
    // For now, we'll just log it
    print('NotificationService: Notification would be displayed: $title - $body');
  }

  // Therapist notifications
  static Future<void> notifyTherapistNewBooking({
    required String clientName,
    required String sessionType,
    required String date,
  }) async {
    await showNotification(
      id: 1,
      title: 'New Booking Request',
      body: '$clientName has requested a $sessionType session on $date',
      payload: 'new_booking',
    );
  }

  // Client notifications
  static Future<void> notifyClientBookingAccepted({
    required String therapistName,
    required String sessionType,
    required String date,
  }) async {
    await showNotification(
      id: 2,
      title: 'Booking Confirmed!',
      body: '$therapistName has confirmed your $sessionType session on $date',
      payload: 'booking_accepted',
    );
  }

  static Future<void> notifyClientBookingDeclined({
    required String therapistName,
    required String sessionType,
    required String date,
  }) async {
    await showNotification(
      id: 3,
      title: 'Booking Declined',
      body: '$therapistName has declined your $sessionType session on $date',
      payload: 'booking_declined',
    );
  }

  static Future<void> notifyClientSessionCompleted({
    required String therapistName,
    required String sessionType,
    required String date,
  }) async {
    await showNotification(
      id: 4,
      title: 'Session Completed',
      body: 'Your $sessionType session with $therapistName on $date has been marked as completed',
      payload: 'session_completed',
    );
  }

  static Future<void> cancelAllNotifications() async {
    print('NotificationService: All notifications cancelled');
  }

  static Future<void> cancelNotification(int id) async {
    print('NotificationService: Notification $id cancelled');
  }
} 