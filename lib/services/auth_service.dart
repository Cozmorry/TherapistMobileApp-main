import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:therapair/models/user_model.dart';
import 'package:therapair/services/local_storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Test Firebase connection
  Future<bool> testFirebaseConnection() async {
    try {
      print('AuthService: Testing Firebase connection...');
      // Try to get current user (this will test if Firebase is initialized)
      final currentUser = _auth.currentUser;
      print('AuthService: Firebase connection test successful. Current user: ${currentUser?.email ?? 'none'}');
      return true;
    } catch (e) {
      print('AuthService: Firebase connection test failed: $e');
      return false;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Sign out first to avoid PigeonUserDetails error
      await _googleSignIn.signOut();
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Google Sign-In cancelled by user');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Save user data to local storage
      if (userCredential.user != null) {
        print('Google Sign-In: Saving user data to local storage');
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        await LocalStorageService.saveCurrentUser(userModel);
        await LocalStorageService.updateLastLogin();
        print('Google Sign-In: User data saved successfully');
      }
      
      print('Google Sign-In successful');
      return userCredential;
    } catch (e) {
      print('Google Sign-In error: $e');
      
      // Handle specific error types
      if (e.toString().contains('PigeonUserDetails')) {
        print('PigeonUserDetails error detected - checking if user is actually signed in');
        
        // Check if the user is actually signed in despite the error
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          print('User is actually signed in despite PigeonUserDetails error');
          // Save user data to local storage
          final userModel = UserModel.fromFirebaseUser(currentUser);
          await LocalStorageService.saveCurrentUser(userModel);
          await LocalStorageService.updateLastLogin();
          return null; // We'll handle this in the login page by checking currentUser
        }
        
        return null;
      }
      
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      print('AuthService: Starting email/password signup for $email');
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('AuthService: Firebase signup successful');
      
      // Save user data to local storage
      if (userCredential.user != null) {
        print('Email/Password Sign-Up: Saving user data to local storage');
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        await LocalStorageService.saveCurrentUser(userModel);
        await LocalStorageService.updateLastLogin();
        print('Email/Password Sign-Up: User data saved successfully');
      }
      
      print('Email/Password Sign-Up successful');
      return userCredential;
    } catch (e) {
      print('Email/Password Sign-Up error: $e');
      
      // Handle PigeonUserDetails error (same as Google Sign-In)
      if (e.toString().contains('PigeonUserDetails')) {
        print('PigeonUserDetails error detected in signup - checking if user is actually created');
        
        // Check if the user is actually created despite the error
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          print('User is actually created despite PigeonUserDetails error');
          // Save user data to local storage
          final userModel = UserModel.fromFirebaseUser(currentUser);
          await LocalStorageService.saveCurrentUser(userModel);
          await LocalStorageService.updateLastLogin();
          return null; // We'll handle this in the login page by checking currentUser
        }
      }
      
      // Provide specific error messages
      String errorMessage = 'Sign up failed';
      
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'This email is already registered. Please use a different email or sign in.';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'Password is too weak. Please use a stronger password.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Please enter a valid email address.';
      } else if (e.toString().contains('operation-not-allowed')) {
        errorMessage = 'Email/password sign up is not enabled. Please contact support.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      
      print('AuthService: Signup error message: $errorMessage');
      return null;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      print('AuthService: Starting email/password signin for $email');
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('AuthService: Firebase signin successful');
      
      // Save user data to local storage
      if (userCredential.user != null) {
        print('Email/Password Sign-In: Saving user data to local storage');
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        await LocalStorageService.saveCurrentUser(userModel);
        await LocalStorageService.updateLastLogin();
        print('Email/Password Sign-In: User data saved successfully');
      }
      
      print('Email/Password Sign-In successful');
      return userCredential;
    } catch (e) {
      print('Email/Password Sign-In error: $e');
      
      // Handle PigeonUserDetails error (same as signup and Google Sign-In)
      if (e.toString().contains('PigeonUserDetails')) {
        print('PigeonUserDetails error detected in signin - checking if user is actually signed in');
        
        // Check if the user is actually signed in despite the error
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          print('User is actually signed in despite PigeonUserDetails error');
          // Save user data to local storage
          final userModel = UserModel.fromFirebaseUser(currentUser);
          await LocalStorageService.saveCurrentUser(userModel);
          await LocalStorageService.updateLastLogin();
          return null; // We'll handle this in the login page by checking currentUser
        }
      }
      
      // Provide specific error messages
      String errorMessage = 'Sign in failed';
      
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'No account found with this email. Please sign up first.';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Please enter a valid email address.';
      } else if (e.toString().contains('user-disabled')) {
        errorMessage = 'This account has been disabled. Please contact support.';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Too many failed attempts. Please try again later.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      
      print('AuthService: Signin error message: $errorMessage');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      print('Sign out: Starting logout process');
      await _auth.signOut();
      await _googleSignIn.signOut();
      // Don't clear all data - just clear authentication data
      await LocalStorageService.clearAuthData();
      print('Sign out successful');
    } catch (e) {
      print('Sign out error: $e');
    }
  }
} 