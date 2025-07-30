import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapair/models/user_model.dart';

class LocalStorageService {
  static const String _userKey = 'currentUser';
  static SharedPreferences? _prefs;
  
  // Fallback in-memory storage
  static Map<String, dynamic> _memoryStorage = {};
  static bool _useMemoryFallback = false;

  // Initialize SharedPreferences
  static Future<void> init() async {
    try {
      print('LocalStorage: Initializing SharedPreferences...');
      _prefs = await SharedPreferences.getInstance();
      print('LocalStorage: SharedPreferences initialized successfully');
      
      // Test if we can read/write
      await _prefs?.setString('test', 'test_value');
      final testValue = _prefs?.getString('test');
      print('LocalStorage: Test read/write - $testValue');
      
      // If test fails, use memory fallback
      if (testValue != 'test_value') {
        print('LocalStorage: SharedPreferences test failed, using memory fallback');
        _useMemoryFallback = true;
      }
    } catch (e) {
      print('SharedPreferences initialization error: $e, using memory fallback');
      _useMemoryFallback = true;
    }
  }

  // Save current user as JSON
  static Future<void> saveCurrentUser(UserModel user) async {
    try {
      print('LocalStorage: Saving user data - UID: ${user.uid}, Email: ${user.email}, Role: ${user.role}');
      
      final userJson = jsonEncode(user.toMap());
      print('LocalStorage: User JSON: $userJson');
      
      if (_useMemoryFallback) {
        // Use memory storage
        _memoryStorage[_userKey] = userJson;
        print('LocalStorage: User data saved to memory');
      } else {
        // Use SharedPreferences
        if (_prefs == null) {
          print('LocalStorage: SharedPreferences not initialized, initializing now...');
          await init();
        }
        
        await _prefs?.setString(_userKey, userJson);
        
        // Verify the save worked
        final savedData = _prefs?.getString(_userKey);
        print('LocalStorage: Verification - saved data: $savedData');
      }
      
      print('LocalStorage: User data saved successfully');
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  // Get current user from JSON
  static UserModel? getCurrentUser() {
    try {
      String? userJson;
      
      if (_useMemoryFallback) {
        // Get from memory storage
        userJson = _memoryStorage[_userKey];
        print('LocalStorage: Retrieved user data from memory: $userJson');
      } else {
        // Get from SharedPreferences
        if (_prefs == null) {
          print('LocalStorage: SharedPreferences not initialized for getCurrentUser');
          return null;
        }
        
        userJson = _prefs?.getString(_userKey);
        print('LocalStorage: Retrieved user data from SharedPreferences: $userJson');
      }
      
      if (userJson != null && userJson.isNotEmpty) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = UserModel.fromMap(userMap);
        print('LocalStorage: Parsed user - UID: ${user.uid}, Email: ${user.email}, Role: ${user.role}');
        return user;
      }
      print('LocalStorage: No user data found');
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Update user role
  static Future<void> updateUserRole(String role) async {
    try {
      print('LocalStorage: Updating user role to $role');
      final user = getCurrentUser();
      if (user != null) {
        user.setRole(role);
        await saveCurrentUser(user);
        print('LocalStorage: User role updated successfully to $role');
      } else {
        print('LocalStorage: No user found to update role');
      }
    } catch (e) {
      print('Error updating role: $e');
    }
  }

  // Complete user onboarding
  static Future<void> completeUserOnboarding(Map<String, dynamic> onboardingData) async {
    try {
      final user = getCurrentUser();
      if (user != null) {
        user.completeOnboarding(onboardingData);
        await saveCurrentUser(user);
      }
    } catch (e) {
      print('Error completing onboarding: $e');
    }
  }

  // Update user profile picture
  static Future<void> updateUserProfilePicture(String path) async {
    try {
      final user = getCurrentUser();
      if (user != null) {
        user.setProfilePicture(path);
        await saveCurrentUser(user);
      }
    } catch (e) {
      print('Error updating profile picture: $e');
    }
  }

  // Update user display name
  static Future<void> updateUserDisplayName(String displayName) async {
    try {
      final user = getCurrentUser();
      if (user != null) {
        user.displayName = displayName;
        await saveCurrentUser(user);
      }
    } catch (e) {
      print('Error updating display name: $e');
    }
  }

  // Update last login
  static Future<void> updateLastLogin() async {
    try {
      final user = getCurrentUser();
      if (user != null) {
        user.updateLastLogin();
        await saveCurrentUser(user);
      }
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  // Check if user has completed onboarding
  static bool isOnboardingCompleted() {
    try {
      final user = getCurrentUser();
      return user?.isOnboardingCompleted ?? false;
    } catch (e) {
      print('Error checking onboarding: $e');
      return false;
    }
  }

  // Check if user has selected a role
  static bool hasRole() {
    try {
      final user = getCurrentUser();
      final hasRole = user?.role != null;
      print('LocalStorage: Has role check - $hasRole (role: ${user?.role})');
      return hasRole;
    } catch (e) {
      print('Error checking role: $e');
      return false;
    }
  }

  // Get user role
  static String? getUserRole() {
    try {
      final user = getCurrentUser();
      return user?.role;
    } catch (e) {
      print('Error getting role: $e');
      return null;
    }
  }

  // Check if user is therapist
  static bool isTherapist() {
    try {
      final user = getCurrentUser();
      return user?.isTherapist ?? false;
    } catch (e) {
      print('Error checking therapist: $e');
      return false;
    }
  }

  // Check if user is client
  static bool isClient() {
    try {
      final user = getCurrentUser();
      return user?.isClient ?? false;
    } catch (e) {
      print('Error checking client: $e');
      return false;
    }
  }

  // Get user display name
  static String getUserDisplayName() {
    try {
      final user = getCurrentUser();
      final displayName = user?.getDisplayName() ?? 'User';
      print('LocalStorage: Get display name - $displayName');
      return displayName;
    } catch (e) {
      print('Error getting display name: $e');
      return 'User';
    }
  }

  // Get user onboarding data
  static Map<String, dynamic>? getUserOnboardingData() {
    try {
      final user = getCurrentUser();
      return user?.onboardingData;
    } catch (e) {
      print('Error getting onboarding data: $e');
      return null;
    }
  }

  // Clear only authentication data (preserve user preferences and onboarding)
  static Future<void> clearAuthData() async {
    try {
      final user = getCurrentUser();
      if (user != null) {
        // Keep role, onboarding data, and profile info, but clear auth-specific data
        final preservedUser = UserModel(
          uid: null, // Clear auth UID
          email: null, // Clear email
          displayName: user.displayName, // Keep display name
          role: user.role, // Keep role
          profilePicturePath: user.profilePicturePath, // Keep profile picture
          isOnboardingCompleted: user.isOnboardingCompleted, // Keep onboarding status
          onboardingData: user.onboardingData, // Keep onboarding data
          createdAt: user.createdAt, // Keep creation date
          lastLoginAt: null, // Clear last login
        );
        await saveCurrentUser(preservedUser);
      }
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  // Test SharedPreferences functionality
  static Future<void> testStorage() async {
    try {
      print('LocalStorage: Testing storage functionality...');
      
      // Ensure SharedPreferences is initialized
      if (_prefs == null) {
        await init();
      }
      
      if (_useMemoryFallback) {
        print('LocalStorage: Using memory fallback - test PASSED');
        return;
      }
      
      // Test write
      await _prefs?.setString('test_key', 'test_value');
      print('LocalStorage: Test write completed');
      
      // Test read
      final testValue = _prefs?.getString('test_key');
      print('LocalStorage: Test read result: $testValue');
      
      if (testValue == 'test_value') {
        print('LocalStorage: Storage test PASSED');
      } else {
        print('LocalStorage: Storage test FAILED - switching to memory fallback');
        _useMemoryFallback = true;
      }
    } catch (e) {
      print('LocalStorage: Storage test error: $e - switching to memory fallback');
      _useMemoryFallback = true;
    }
  }

  // Clear all data (for complete reset)
  static Future<void> clearAllData() async {
    try {
      if (_useMemoryFallback) {
        _memoryStorage.clear();
      } else {
        await _prefs?.clear();
      }
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }
} 