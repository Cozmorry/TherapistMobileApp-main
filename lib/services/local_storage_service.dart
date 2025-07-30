import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapair/models/user_model.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;
  static Map<String, dynamic> _memoryStorage = {};
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
} 