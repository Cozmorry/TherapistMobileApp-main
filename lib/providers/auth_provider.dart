import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:therapair/services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;

  User? get user => _user;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get userRole => _userProfile?['role'];

  AuthProvider() {
    _initAuth();
  }

  void _initAuth() {
    FirebaseService.authStateChanges.listen((User? user) {
      print('AuthProvider: Auth state changed - user: ${user?.uid}'); // Debug log
      _user = user;
      if (user != null) {
        loadUserProfile();
      } else {
        print('AuthProvider: User signed out, clearing profile'); // Debug log
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  Future<void> loadUserProfile() async {
    if (_user != null) {
      try {
        print('AuthProvider: Loading profile for user: ${_user!.uid}'); // Debug log
        _userProfile = await FirebaseService.getUserProfile(_user!.uid);
        print('AuthProvider: Loaded profile: $_userProfile'); // Debug log
        notifyListeners();
      } catch (e) {
        print('Error loading user profile: $e');
      }
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String role,
    String? specialties,
  }) async {
    _setLoading(true);
    try {
      await FirebaseService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
        role: role,
        specialties: specialties,
      );
      // Reload user profile after successful signup
      await loadUserProfile();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
    _setLoading(false);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await FirebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Reload user profile after successful signin
      await loadUserProfile();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
    _setLoading(false);
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      print('AuthProvider: Starting sign out'); // Debug log
      await FirebaseService.signOut();
      print('AuthProvider: Sign out successful'); // Debug log
    } catch (e) {
      print('AuthProvider: Sign out error: $e'); // Debug log
      _setLoading(false);
      rethrow;
    }
    _setLoading(false);
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      print('AuthProvider: Starting Google Sign-In'); // Debug log
      await FirebaseService.signInWithGoogle();
      print('AuthProvider: Google Sign-In successful'); // Debug log
      // Reload user profile after successful Google signin
      await loadUserProfile();
      print('AuthProvider: Profile reloaded after Google Sign-In'); // Debug log
    } catch (e) {
      print('AuthProvider: Google Sign-In error: $e'); // Debug log
      _setLoading(false);
      rethrow;
    }
    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 