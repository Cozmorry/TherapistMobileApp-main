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
      _user = user;
      if (user != null) {
        _loadUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserProfile() async {
    if (_user != null) {
      try {
        _userProfile = await FirebaseService.getUserProfile(_user!.uid);
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
    String? medicalHistory,
    String? specialties,
  }) async {
    _setLoading(true);
    try {
      await FirebaseService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
        role: role,
        medicalHistory: medicalHistory,
        specialties: specialties,
      );
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
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
    _setLoading(false);
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await FirebaseService.signOut();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
    _setLoading(false);
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      await FirebaseService.signInWithGoogle();
    } catch (e) {
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