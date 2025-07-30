import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication methods
  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up methods
  static Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String role,
    String? specialties,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'onboardingCompleted': role == 'therapist', // Only therapists skip onboarding
        if (specialties != null) 'specialties': specialties,
      });

      return userCredential;
    } catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }

  // Sign in method
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign out method
  static Future<void> signOut() async {
    try {
      print('FirebaseService: Starting sign out'); // Debug log
      // Sign out from Google first
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      print('FirebaseService: Google sign out successful'); // Debug log
      
      // Then sign out from Firebase
      await _auth.signOut();
      print('FirebaseService: Firebase sign out successful'); // Debug log
    } catch (e) {
      print('FirebaseService: Sign out error: $e'); // Debug log
      // If Google sign out fails, still sign out from Firebase
      await _auth.signOut();
      throw Exception('Sign out failed: $e');
    }
  }

  // Google Sign In method
  static Future<UserCredential> signInWithGoogle() async {
    try {
      // Create GoogleSignIn instance
      final GoogleSignIn googleSignIn = GoogleSignIn();
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google Sign In was cancelled');
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
      
      // Check if user profile exists in Firestore
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      
      if (!userDoc.exists) {
        // For new Google users, don't set role initially
        // Role will be set in the role selection page
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': userCredential.user!.displayName ?? 'User',
          'email': userCredential.user!.email,
          'createdAt': FieldValue.serverTimestamp(),
          // Role and onboardingCompleted will be set in role selection
        });
      }

      return userCredential;
    } catch (e) {
      throw Exception('Google Sign In failed: $e');
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Get current user profile
  static Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      if (_auth.currentUser == null) return null;
      return await getUserProfile(_auth.currentUser!.uid);
    } catch (e) {
      throw Exception('Failed to get current user profile: $e');
    }
  }

  // Get user preferences (for clients)
  static Future<Map<String, dynamic>?> getUserPreferences(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'therapeuticApproach': data['therapeuticApproach'],
          'communicationStyle': data['communicationStyle'],
          'therapyNeeds': data['therapyNeeds'],
          'onboardingCompleted': data['onboardingCompleted'] ?? false,
        };
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user preferences: $e');
    }
  }

  // Update user profile
  static Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      print('FirebaseService: Updating profile for user $uid with data: $data'); // Debug log
      // Use set with merge to handle cases where document might not exist
      await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
      print('FirebaseService: Profile updated successfully'); // Debug log
    } catch (e) {
      print('FirebaseService: Error updating profile: $e'); // Debug log
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Therapist-related methods
  static Future<List<Map<String, dynamic>>> getTherapists() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'therapist')
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Failed to get therapists: $e');
    }
  }

  // Get therapist by ID
  static Future<Map<String, dynamic>?> getTherapistById(String therapistId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(therapistId).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['role'] == 'therapist') {
          return {'id': doc.id, ...data};
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get therapist: $e');
    }
  }

  // Get clients (for therapists to see their clients)
  static Future<List<Map<String, dynamic>>> getClients() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'client')
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Failed to get clients: $e');
    }
  }

  // Get client by ID
  static Future<Map<String, dynamic>?> getClientById(String clientId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(clientId).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['role'] == 'client') {
          return {'id': doc.id, ...data};
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get client: $e');
    }
  }

  // Session-related methods
  static Future<void> createSession({
    required String clientId,
    required String therapistId,
    required DateTime dateTime,
    required String status,
  }) async {
    try {
      await _firestore.collection('sessions').add({
        'clientId': clientId,
        'therapistId': therapistId,
        'dateTime': dateTime,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserSessions(String userId, String role) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('sessions')
          .where(role == 'therapist' ? 'therapistId' : 'clientId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Failed to get sessions: $e');
    }
  }

  // Booking request methods
  static Future<void> createBookingRequest({
    required String clientId,
    required String therapistId,
    required DateTime dateTime,
  }) async {
    try {
      await _firestore.collection('booking_requests').add({
        'clientId': clientId,
        'therapistId': therapistId,
        'dateTime': dateTime,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create booking request: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getBookingRequests(String therapistId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('booking_requests')
          .where('therapistId', isEqualTo: therapistId)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Failed to get booking requests: $e');
    }
  }

  static Future<void> updateBookingRequest(String requestId, String status) async {
    try {
      await _firestore.collection('booking_requests').doc(requestId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update booking request: $e');
    }
  }

  // Feedback methods
  static Future<void> submitFeedback({
    required String userId,
    required String feedback,
  }) async {
    try {
      await _firestore.collection('feedback').add({
        'userId': userId,
        'feedback': feedback,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }
} 