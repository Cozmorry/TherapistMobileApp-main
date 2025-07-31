import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static bool _isInitialized = false;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize Android settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Initialize iOS settings
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Initialize settings
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Initialize the plugin
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          print('NotificationService: Notification tapped: ${response.payload}');
        },
      );

      _isInitialized = true;
      print('NotificationService: Initialized successfully');
    } catch (e) {
      print('NotificationService: Error initializing: $e');
    }
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
    try {
      print('NotificationService: Showing notification - $title: $body');
      
      // Check if we have permission before attempting to show notification
      final hasPermission = await hasNotificationPermission();
      if (!hasPermission) {
        print('NotificationService: No notification permission, cannot show notification');
        return;
      }

      // Create Android notification details
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'therapair_channel',
        'TheraPair Notifications',
        channelDescription: 'Notifications for TheraPair app',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        playSound: true,
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(body),
      );

      // Create iOS notification details
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Create notification details
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      // Show the notification
      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      print('NotificationService: Notification displayed successfully: $title - $body');
    } catch (e) {
      print('NotificationService: Error showing notification: $e');
    }
  }

  // Test notification method to ensure permission is being used
  static Future<void> testNotification() async {
    print('NotificationService: Testing notification permission...');
    
    final hasPermission = await hasNotificationPermission();
    print('NotificationService: Has permission: $hasPermission');
    
    if (hasPermission) {
      await showNotification(
        title: 'TheraPair Test',
        body: 'This is a test notification to verify permissions',
        id: 999,
      );
    }
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
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      print('NotificationService: All notifications cancelled');
    } catch (e) {
      print('NotificationService: Error cancelling all notifications: $e');
    }
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      print('NotificationService: Notification $id cancelled');
    } catch (e) {
      print('NotificationService: Error cancelling notification $id: $e');
    }
  }
} 