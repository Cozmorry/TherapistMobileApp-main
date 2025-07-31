
class NotificationService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    print('NotificationService: Initialized successfully (simplified version)');
  }

  static Future<void> requestPermissions() async {
    // Simplified - no actual permission request needed for this version
    print('NotificationService: Permissions requested (simplified)');
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    print('NotificationService: Would show notification - $title: $body');
    // In a real app, this would show a local notification
    // For now, we'll just log it
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