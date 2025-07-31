import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapair/models/user_model.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memoryStorage = {};
  static bool _useMemoryFallback = false;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      
      // Test if SharedPreferences is working
      await _prefs!.setString('test_key', 'test_value');
      final testValue = _prefs!.getString('test_key');
      await _prefs!.remove('test_key');
      
      if (testValue != 'test_value') {
        print('LocalStorage: SharedPreferences test failed, using memory fallback');
        _useMemoryFallback = true;
      } else {
        print('LocalStorage: SharedPreferences test passed');
      }
    } catch (e) {
      print('LocalStorage: Error initializing SharedPreferences: $e');
      _useMemoryFallback = true;
    }
  }

  static Future<void> testStorage() async {
    try {
      if (_useMemoryFallback) {
        _memoryStorage['test_key'] = 'test_value';
        final testValue = _memoryStorage['test_key'];
        _memoryStorage.remove('test_key');
        print('LocalStorage: Memory storage test result: $testValue');
      } else {
        await _prefs?.setString('test_key', 'test_value');
        final testValue = _prefs?.getString('test_key');
        await _prefs?.remove('test_key');
        print('LocalStorage: Test read result: $testValue');
      }
    } catch (e) {
      print('LocalStorage: Storage test error: $e');
      _useMemoryFallback = true;
    }
  }

  // User data methods
  static Future<void> saveCurrentUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toMap());
      print('LocalStorage: Saving user data: ${user.toMap()}');
      
      if (_useMemoryFallback) {
        _memoryStorage['current_user'] = userJson;
        print('LocalStorage: User saved to memory');
      } else {
        await _prefs?.setString('current_user', userJson);
        print('LocalStorage: User saved to SharedPreferences');
      }
    } catch (e) {
      print('LocalStorage: Error saving user: $e');
    }
  }

  static UserModel? getCurrentUser() {
    try {
      String? userJson;
      
      if (_useMemoryFallback) {
        userJson = _memoryStorage['current_user'];
        print('LocalStorage: Getting user from memory: $userJson');
      } else {
        userJson = _prefs?.getString('current_user');
        print('LocalStorage: Getting user from SharedPreferences: $userJson');
      }
      
      if (userJson != null && userJson.isNotEmpty) {
        final userMap = Map<String, dynamic>.from(jsonDecode(userJson));
        final user = UserModel.fromMap(userMap);
        print('LocalStorage: Retrieved user: ${user.toMap()}');
        return user;
      }
      
      print('LocalStorage: No user data found');
      return null;
    } catch (e) {
      print('LocalStorage: Error getting user: $e');
      return null;
    }
  }

  static Future<void> updateUserRole(String role) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        currentUser.setRole(role);
        await saveCurrentUser(currentUser);
        print('LocalStorage: Role updated to: $role');
      }
    } catch (e) {
      print('LocalStorage: Error updating role: $e');
    }
  }

  static Future<void> completeUserOnboarding(Map<String, dynamic> onboardingData) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        currentUser.completeOnboarding(onboardingData);
        await saveCurrentUser(currentUser);
        print('LocalStorage: Onboarding completed with data: $onboardingData');
      }
    } catch (e) {
      print('LocalStorage: Error completing onboarding: $e');
    }
  }

  static Future<void> updateUserProfilePicture(String picturePath) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        currentUser.setProfilePicture(picturePath);
        await saveCurrentUser(currentUser);
        print('LocalStorage: Profile picture updated: $picturePath');
      }
    } catch (e) {
      print('LocalStorage: Error updating profile picture: $e');
    }
  }

  static Future<void> updateUserDisplayName(String displayName) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        currentUser.updateLastLogin();
        await saveCurrentUser(currentUser);
        print('LocalStorage: Display name updated: $displayName');
      }
    } catch (e) {
      print('LocalStorage: Error updating display name: $e');
    }
  }

  static Future<void> updateLastLogin() async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        currentUser.updateLastLogin();
        await saveCurrentUser(currentUser);
        print('LocalStorage: Last login updated');
      }
    } catch (e) {
      print('LocalStorage: Error updating last login: $e');
    }
  }

  // Therapist data methods
  static Future<void> saveTherapistData(Map<String, dynamic> therapistData) async {
    try {
      final therapistJson = jsonEncode(therapistData);
      print('LocalStorage: Saving therapist data: $therapistData');
      
      if (_useMemoryFallback) {
        _memoryStorage['therapist_data'] = therapistJson;
        print('LocalStorage: Therapist saved to memory');
      } else {
        await _prefs?.setString('therapist_data', therapistJson);
        print('LocalStorage: Therapist saved to SharedPreferences');
      }
    } catch (e) {
      print('LocalStorage: Error saving therapist: $e');
    }
  }

  static Map<String, dynamic>? getTherapistData() {
    try {
      String? therapistJson;
      
      if (_useMemoryFallback) {
        therapistJson = _memoryStorage['therapist_data'];
        print('LocalStorage: Getting therapist from memory: $therapistJson');
      } else {
        therapistJson = _prefs?.getString('therapist_data');
        print('LocalStorage: Getting therapist from SharedPreferences: $therapistJson');
      }
      
      if (therapistJson != null && therapistJson.isNotEmpty) {
        final therapistMap = Map<String, dynamic>.from(jsonDecode(therapistJson));
        print('LocalStorage: Retrieved therapist: $therapistMap');
        return therapistMap;
      }
      
      print('LocalStorage: No therapist data found');
      return null;
    } catch (e) {
      print('LocalStorage: Error getting therapist: $e');
      return null;
    }
  }

  static List<Map<String, dynamic>> getAllTherapists() {
    try {
      String? therapistsJson;
      
      if (_useMemoryFallback) {
        therapistsJson = _memoryStorage['all_therapists'];
        print('LocalStorage: Getting all therapists from memory: $therapistsJson');
      } else {
        therapistsJson = _prefs?.getString('all_therapists');
        print('LocalStorage: Getting all therapists from SharedPreferences: $therapistsJson');
      }
      
      if (therapistsJson != null && therapistsJson.isNotEmpty) {
        final List<dynamic> therapistsList = jsonDecode(therapistsJson);
        final therapists = therapistsList.map((t) => Map<String, dynamic>.from(t)).toList();
        print('LocalStorage: Retrieved ${therapists.length} therapists');
        return therapists;
      }
      
      print('LocalStorage: No therapists found');
      return [];
    } catch (e) {
      print('LocalStorage: Error getting all therapists: $e');
      return [];
    }
  }

  static Future<void> addTherapistToList(Map<String, dynamic> therapistData) async {
    try {
      final therapists = getAllTherapists();
      therapists.add(therapistData);
      
      final therapistsJson = jsonEncode(therapists);
      print('LocalStorage: Adding therapist to list, total: ${therapists.length}');
      
      if (_useMemoryFallback) {
        _memoryStorage['all_therapists'] = therapistsJson;
        print('LocalStorage: Therapists list saved to memory');
      } else {
        await _prefs?.setString('all_therapists', therapistsJson);
        print('LocalStorage: Therapists list saved to SharedPreferences');
      }
    } catch (e) {
      print('LocalStorage: Error adding therapist to list: $e');
    }
  }

  static void debugPrintAllTherapists() {
    try {
      final allTherapists = getAllTherapists();
      print('=== DEBUG: ALL THERAPISTS ===');
      print('Total therapists: ${allTherapists.length}');
      for (int i = 0; i < allTherapists.length; i++) {
        final therapist = allTherapists[i];
        print('Therapist $i:');
        print('  - Name: ${therapist['name']}');
        print('  - Username: ${therapist['username']}');
        print('  - Email: ${therapist['email']}');
        print('  - Specialization: ${therapist['specialization']}');
        print('  - Therapeutic Approach: ${therapist['therapeuticApproach']}');
        print('  - Session Type: ${therapist['sessionType']}');
        print('  - Communication Style: ${therapist['communicationStyle']}');
        print('  - Bio: ${therapist['bio']}');
        print('  - Completed At: ${therapist['completedAt']}');
        print('---');
      }
      print('=== END DEBUG ===');
    } catch (e) {
      print('Error in debugPrintAllTherapists: $e');
    }
  }

  // Query methods
  static bool isOnboardingCompleted() {
    try {
      final currentUser = getCurrentUser();
      return currentUser?.isOnboardingCompleted ?? false;
    } catch (e) {
      print('LocalStorage: Error checking onboarding status: $e');
      return false;
    }
  }

  static bool hasRole() {
    try {
      final currentUser = getCurrentUser();
      return currentUser?.role != null && currentUser!.role!.isNotEmpty;
    } catch (e) {
      print('LocalStorage: Error checking role: $e');
      return false;
    }
  }

  static String? getUserRole() {
    try {
      final currentUser = getCurrentUser();
      return currentUser?.role;
    } catch (e) {
      print('LocalStorage: Error getting user role: $e');
      return null;
    }
  }

  static bool isTherapist() {
    try {
      final currentUser = getCurrentUser();
      return currentUser?.isTherapist ?? false;
    } catch (e) {
      print('LocalStorage: Error checking if therapist: $e');
      return false;
    }
  }

  static bool isClient() {
    try {
      final currentUser = getCurrentUser();
      return currentUser?.isClient ?? false;
    } catch (e) {
      print('LocalStorage: Error checking if client: $e');
      return false;
    }
  }

  static String getUserDisplayName() {
    try {
      final currentUser = getCurrentUser();
      return currentUser?.getDisplayName() ?? 'User';
    } catch (e) {
      print('LocalStorage: Error getting display name: $e');
      return 'User';
    }
  }

  static Map<String, dynamic>? getUserOnboardingData() {
    try {
      final currentUser = getCurrentUser();
      return currentUser?.onboardingData;
    } catch (e) {
      print('LocalStorage: Error getting onboarding data: $e');
      return null;
    }
  }

  static String? getUserProfilePicturePath() {
    try {
      final currentUser = getCurrentUser();
      return currentUser?.profilePicturePath;
    } catch (e) {
      print('LocalStorage: Error getting profile picture path: $e');
      return null;
    }
  }

  // Clear methods
  static Future<void> clearAuthData() async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        // Clear only auth-related fields, keep role, onboarding, and profile data
        currentUser.uid = null;
        currentUser.email = null;
        currentUser.lastLoginAt = null;
        await saveCurrentUser(currentUser);
        print('LocalStorage: Auth data cleared, preserving user preferences');
      }
    } catch (e) {
      print('LocalStorage: Error clearing auth data: $e');
    }
  }

  static Future<void> clearUserData() async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        // Clear only user-specific fields, preserve app data like bookings
        currentUser.uid = null;
        currentUser.email = null;
        currentUser.displayName = null;
        currentUser.username = null;
        currentUser.role = null;
        currentUser.profilePicturePath = null;
        currentUser.isOnboardingCompleted = false;
        currentUser.onboardingData = null;
        currentUser.lastLoginAt = null;
        await saveCurrentUser(currentUser);
        print('LocalStorage: User data cleared, app data preserved');
      }
    } catch (e) {
      print('LocalStorage: Error clearing user data: $e');
    }
  }

  static Future<void> clearAllData() async {
    try {
      if (_useMemoryFallback) {
        _memoryStorage.clear();
        print('LocalStorage: All data cleared from memory');
      } else {
        await _prefs?.clear();
        print('LocalStorage: All data cleared from SharedPreferences');
      }
    } catch (e) {
      print('LocalStorage: Error clearing all data: $e');
    }
  }

  static Future<void> clearCurrentUser() async {
    try {
      if (_useMemoryFallback) {
        _memoryStorage.remove('current_user');
        print('LocalStorage: Current user cleared from memory');
      } else {
        await _prefs?.remove('current_user');
        print('LocalStorage: Current user cleared from SharedPreferences');
      }
    } catch (e) {
      print('LocalStorage: Error clearing current user: $e');
    }
  }

  // Booking data methods
  static Future<void> saveBooking(Map<String, dynamic> bookingData) async {
    try {
      final bookings = getAllBookings();
      bookings.add(bookingData);
      
      final bookingsJson = jsonEncode(bookings);
      print('LocalStorage: Saving booking, total: ${bookings.length}');
      
      if (_useMemoryFallback) {
        _memoryStorage['all_bookings'] = bookingsJson;
        print('LocalStorage: Bookings saved to memory');
      } else {
        await _prefs?.setString('all_bookings', bookingsJson);
        print('LocalStorage: Bookings saved to SharedPreferences');
      }
    } catch (e) {
      print('LocalStorage: Error saving booking: $e');
    }
  }

  static List<Map<String, dynamic>> getAllBookings() {
    try {
      String? bookingsJson;
      
      if (_useMemoryFallback) {
        bookingsJson = _memoryStorage['all_bookings'];
        print('LocalStorage: Getting all bookings from memory: $bookingsJson');
      } else {
        bookingsJson = _prefs?.getString('all_bookings');
        print('LocalStorage: Getting all bookings from SharedPreferences: $bookingsJson');
      }
      
      if (bookingsJson != null && bookingsJson.isNotEmpty) {
        final List<dynamic> bookingsList = jsonDecode(bookingsJson);
        final bookings = bookingsList.map((b) => Map<String, dynamic>.from(b)).toList();
        print('LocalStorage: Retrieved ${bookings.length} bookings');
        return bookings;
      }
      
      print('LocalStorage: No bookings found');
      return [];
    } catch (e) {
      print('LocalStorage: Error getting all bookings: $e');
      return [];
    }
  }

  static List<Map<String, dynamic>> getClientBookings(String clientEmail) {
    try {
      final allBookings = getAllBookings();
      final clientBookings = allBookings.where((booking) => booking['clientEmail'] == clientEmail).toList();
      print('LocalStorage: Found ${clientBookings.length} bookings for client $clientEmail');
      return clientBookings;
    } catch (e) {
      print('LocalStorage: Error getting client bookings: $e');
      return [];
    }
  }

  static List<Map<String, dynamic>> getTherapistBookings(String therapistEmail) {
    try {
      final allBookings = getAllBookings();
      final therapistBookings = allBookings.where((booking) => booking['therapistEmail'] == therapistEmail).toList();
      print('LocalStorage: Found ${therapistBookings.length} bookings for therapist $therapistEmail');
      return therapistBookings;
    } catch (e) {
      print('LocalStorage: Error getting therapist bookings: $e');
      return [];
    }
  }

  static Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      final allBookings = getAllBookings();
      final bookingIndex = allBookings.indexWhere((booking) => booking['bookedAt'] == bookingId);
      
      if (bookingIndex != -1) {
        // Preserve all existing booking data and only update the status
        final updatedBooking = Map<String, dynamic>.from(allBookings[bookingIndex]);
        updatedBooking['status'] = newStatus;
        allBookings[bookingIndex] = updatedBooking;
        
        final bookingsJson = jsonEncode(allBookings);
        print('LocalStorage: Updating booking status to $newStatus for booking: ${updatedBooking['clientName']} with ${updatedBooking['therapistName']}');
        
        if (_useMemoryFallback) {
          _memoryStorage['all_bookings'] = bookingsJson;
          print('LocalStorage: Booking status updated in memory');
        } else {
          await _prefs?.setString('all_bookings', bookingsJson);
          print('LocalStorage: Booking status updated in SharedPreferences');
        }
      } else {
        print('LocalStorage: Booking not found for ID: $bookingId');
      }
    } catch (e) {
      print('LocalStorage: Error updating booking status: $e');
    }
  }

  // Feedback methods
  static Future<void> saveFeedback(Map<String, dynamic> feedbackData) async {
    try {
      final allFeedback = getAllFeedback();
      allFeedback.add(feedbackData);
      
      final feedbackJson = jsonEncode(allFeedback);
      print('LocalStorage: Saving feedback for therapist: ${feedbackData['therapistEmail']}');
      
      if (_useMemoryFallback) {
        _memoryStorage['all_feedback'] = feedbackJson;
        print('LocalStorage: Feedback saved to memory');
      } else {
        await _prefs?.setString('all_feedback', feedbackJson);
        print('LocalStorage: Feedback saved to SharedPreferences');
      }
    } catch (e) {
      print('LocalStorage: Error saving feedback: $e');
    }
  }

  static List<Map<String, dynamic>> getAllFeedback() {
    try {
      String? feedbackJson;
      
      if (_useMemoryFallback) {
        feedbackJson = _memoryStorage['all_feedback'];
        print('LocalStorage: Getting all feedback from memory: $feedbackJson');
      } else {
        feedbackJson = _prefs?.getString('all_feedback');
        print('LocalStorage: Getting all feedback from SharedPreferences: $feedbackJson');
      }
      
      if (feedbackJson != null && feedbackJson.isNotEmpty) {
        final List<dynamic> feedbackList = jsonDecode(feedbackJson);
        final List<Map<String, dynamic>> feedback = feedbackList.map((item) => Map<String, dynamic>.from(item)).toList();
        print('LocalStorage: Retrieved ${feedback.length} feedback entries');
        return feedback;
      }
      
      print('LocalStorage: No feedback found, returning empty list');
      return [];
    } catch (e) {
      print('LocalStorage: Error getting all feedback: $e');
      return [];
    }
  }

  static List<Map<String, dynamic>> getTherapistFeedback(String therapistEmail) {
    try {
      final allFeedback = getAllFeedback();
      final therapistFeedback = allFeedback.where((feedback) => 
        feedback['therapistEmail'] == therapistEmail
      ).toList();
      
      print('LocalStorage: Found ${therapistFeedback.length} feedback entries for therapist: $therapistEmail');
      return therapistFeedback;
    } catch (e) {
      print('LocalStorage: Error getting therapist feedback: $e');
      return [];
    }
  }

  static void debugPrintAllBookings() {
    try {
      final allBookings = getAllBookings();
      print('=== DEBUG: ALL BOOKINGS ===');
      print('Total bookings: ${allBookings.length}');
      for (int i = 0; i < allBookings.length; i++) {
        final booking = allBookings[i];
        print('Booking $i:');
        print('  - Therapist Email: ${booking['therapistEmail']}');
        print('  - Therapist Name: ${booking['therapistName']}');
        print('  - Client Email: ${booking['clientEmail']}');
        print('  - Client Name: ${booking['clientName']}');
        print('  - Date: ${booking['date']}');
        print('  - Time: ${booking['time']}');
        print('  - Status: ${booking['status']}');
        print('  - Session Type: ${booking['sessionType']}');
        print('  - Duration: ${booking['duration']}');
        print('  - Notes: ${booking['notes']}');
        print('  - Booked At: ${booking['bookedAt']}');
        print('---');
      }
      print('=== END DEBUG ===');
    } catch (e) {
      print('Error in debugPrintAllBookings: $e');
    }
  }

  // User-specific data methods (by email)
  static Future<void> saveUserDataByEmail(String email, UserModel user) async {
    try {
      final userJson = jsonEncode(user.toMap());
      final key = 'user_data_${email.replaceAll('@', '_at_').replaceAll('.', '_dot_')}';
      print('LocalStorage: Saving user data for $email with key: $key');
      
      if (_useMemoryFallback) {
        _memoryStorage[key] = userJson;
        print('LocalStorage: User data saved to memory for $email');
      } else {
        await _prefs?.setString(key, userJson);
        print('LocalStorage: User data saved to SharedPreferences for $email');
      }
    } catch (e) {
      print('LocalStorage: Error saving user data for $email: $e');
    }
  }

  static UserModel? getUserDataByEmail(String email) {
    try {
      final key = 'user_data_${email.replaceAll('@', '_at_').replaceAll('.', '_dot_')}';
      String? userJson;
      
      if (_useMemoryFallback) {
        userJson = _memoryStorage[key];
        print('LocalStorage: Getting user data from memory for $email: $userJson');
      } else {
        userJson = _prefs?.getString(key);
        print('LocalStorage: Getting user data from SharedPreferences for $email: $userJson');
      }
      
      if (userJson != null && userJson.isNotEmpty) {
        final userMap = Map<String, dynamic>.from(jsonDecode(userJson));
        final user = UserModel.fromMap(userMap);
        print('LocalStorage: Retrieved user data for $email: ${user.toMap()}');
        return user;
      }
      
      print('LocalStorage: No user data found for $email');
      return null;
    } catch (e) {
      print('LocalStorage: Error getting user data for $email: $e');
      return null;
    }
  }

  static Future<void> updateUserDataByEmail(String email, UserModel user) async {
    try {
      await saveUserDataByEmail(email, user);
      print('LocalStorage: Updated user data for $email');
    } catch (e) {
      print('LocalStorage: Error updating user data for $email: $e');
    }
  }
} 