class UserModel {
  String? uid;
  String? email;
  String? displayName;
  String? username; // Add username field
  String? role; // 'client' or 'therapist'
  String? profilePicturePath;
  bool isOnboardingCompleted;
  Map<String, dynamic>? onboardingData;
  DateTime? createdAt;
  DateTime? lastLoginAt;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
    this.username, // Add username parameter
    this.role,
    this.profilePicturePath,
    this.isOnboardingCompleted = false,
    this.onboardingData,
    this.createdAt,
    this.lastLoginAt,
  });

  // Factory constructor to create from Firebase User
  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  // Convert to Map for easy serialization
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'username': username, // Add username to map
      'role': role,
      'profilePicturePath': profilePicturePath,
      'isOnboardingCompleted': isOnboardingCompleted,
      'onboardingData': onboardingData,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  // Create from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      username: map['username'], // Add username from map
      role: map['role'],
      profilePicturePath: map['profilePicturePath'],
      isOnboardingCompleted: map['isOnboardingCompleted'] ?? false,
      onboardingData: map['onboardingData'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      lastLoginAt: map['lastLoginAt'] != null ? DateTime.parse(map['lastLoginAt']) : null,
    );
  }

  // Update last login
  void updateLastLogin() {
    lastLoginAt = DateTime.now();
  }

  // Set role
  void setRole(String newRole) {
    role = newRole;
  }

  // Complete onboarding
  void completeOnboarding(Map<String, dynamic> data) {
    isOnboardingCompleted = true;
    onboardingData = data;
  }

  // Set profile picture
  void setProfilePicture(String path) {
    profilePicturePath = path;
  }

  // Get display name for UI - prioritize username, then displayName, then email
  String getDisplayName() {
    return username ?? displayName ?? email?.split('@')[0] ?? 'User';
  }

  // Check if user is a therapist
  bool get isTherapist => role == 'therapist';

  // Check if user is a client
  bool get isClient => role == 'client';
} 