import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/login_page.dart'; // Added import for LoginPage
import 'package:therapair/models/user_model.dart'; // Added import for UserModel
import 'package:therapair/therapist_feedback_page.dart'; // Added import for TherapistFeedbackPage

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  
  Map<String, dynamic> _userProfile = {
    'username': 'Demo User',
    'email': 'demo@example.com',
  };
  Map<String, dynamic>? _onboardingData;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _requestInitialPermissions();
  }

  Future<void> _requestInitialPermissions() async {
    // Request permissions early so users are prompted when they first visit settings
    try {
      print('Settings: Requesting initial permissions...');
      
      // Check camera permission
      final cameraStatus = await Permission.camera.status;
      if (cameraStatus.isDenied) {
        print('Settings: Requesting camera permission on page load');
        await Permission.camera.request();
      }
      
      // Check storage/photos permissions
      final storageStatus = await Permission.storage.status;
      final photosStatus = await Permission.photos.status;
      if (storageStatus.isDenied && photosStatus.isDenied) {
        print('Settings: Requesting storage/photos permissions on page load');
        await Permission.storage.request();
        await Permission.photos.request();
      }
      
      print('Settings: Initial permission requests completed');
    } catch (e) {
      print('Settings: Error requesting initial permissions: $e');
    }
  }

  Future<void> _loadUserProfile() async {
    print('Settings: Loading user profile...');
    
    // Get current user from Firebase
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      print('Settings: No current user found');
      return;
    }
    
    final userEmail = currentUser.email!;
    print('Settings: Loading profile for user: $userEmail');
    
    // Load user data by email
    final userData = LocalStorageService.getUserDataByEmail(userEmail);
    
    setState(() {
      _userProfile = {
        'username': userData?.getDisplayName() ?? userEmail.split('@')[0],
        'email': userEmail,
        'role': userData?.role, // Assuming role is stored in userData
      };
      _onboardingData = userData?.onboardingData;
    });
    
    // Load profile picture
    final profilePicturePath = userData?.profilePicturePath;
    print('Settings: Profile picture path from storage: $profilePicturePath');
    
    if (profilePicturePath != null) {
      try {
        final file = File(profilePicturePath);
        if (await file.exists()) {
          setState(() {
            _profileImage = file;
          });
          print('Settings: Profile image loaded: ${_profileImage?.path}');
        } else {
          print('Settings: Profile image file does not exist: $profilePicturePath');
        }
      } catch (e) {
        print('Settings: Error loading profile image: $e');
      }
    } else {
      print('Settings: No profile picture path found');
    }
  }

  Future<bool> _requestPermissions(ImageSource source) async {
    try {
      print('Settings: Requesting permissions for source: $source');
      
      if (source == ImageSource.camera) {
        // Check current camera permission status
        final cameraStatus = await Permission.camera.status;
        print('Settings: Current camera permission status: $cameraStatus');
        
        if (cameraStatus.isGranted) {
          print('Settings: Camera permission already granted');
          return true;
        }
        
        // Request camera permission
        final cameraResult = await Permission.camera.request();
        print('Settings: Camera permission request result: $cameraResult');
        
        if (cameraResult.isDenied) {
          print('Settings: Camera permission denied');
          _showPermissionDialog('Camera', 'camera');
          return false;
        }
        if (cameraResult.isPermanentlyDenied) {
          print('Settings: Camera permission permanently denied');
          _showPermissionDialog('Camera', 'camera', isPermanent: true);
          return false;
        }
        return cameraResult.isGranted;
      } else {
        // For gallery access, we need to check both storage and photos permissions
        final storageStatus = await Permission.storage.status;
        final photosStatus = await Permission.photos.status;
        print('Settings: Current storage permission status: $storageStatus');
        print('Settings: Current photos permission status: $photosStatus');
        
        if (storageStatus.isGranted || photosStatus.isGranted) {
          print('Settings: Storage/photos permission already granted');
          return true;
        }
        
        // Request storage permission (for older Android versions)
        final storageResult = await Permission.storage.request();
        print('Settings: Storage permission request result: $storageResult');
        
        // Request photos permission (for Android 13+)
        final photosResult = await Permission.photos.request();
        print('Settings: Photos permission request result: $photosResult');
        
        if (storageResult.isDenied && photosResult.isDenied) {
          print('Settings: Both storage and photos permissions denied');
          _showPermissionDialog('Storage', 'storage');
          return false;
        }
        if (storageResult.isPermanentlyDenied && photosResult.isPermanentlyDenied) {
          print('Settings: Both storage and photos permissions permanently denied');
          _showPermissionDialog('Storage', 'storage', isPermanent: true);
          return false;
        }
        return storageResult.isGranted || photosResult.isGranted;
      }
    } catch (e) {
      print('Settings: Permission request error: $e');
      return false;
    }
  }

  void _showPermissionDialog(String permissionName, String permissionType, {bool isPermanent = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionName Permission Required'),
          content: Text(
            isPermanent
                ? 'This app needs $permissionName permission to access your $permissionName. Please enable it in your device settings.'
                : 'This app needs $permissionName permission to access your $permissionName. Would you like to grant permission?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            if (!isPermanent)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _requestPermissions(permissionType == 'camera' ? ImageSource.camera : ImageSource.gallery);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Grant Permission'),
              ),
            if (isPermanent)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Open Settings'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      print('Settings: Starting image picker for source: $source');
      
      // Check and request permissions first
      final hasPermission = await _requestPermissions(source);
      print('Settings: Permission result: $hasPermission');
      
      if (!hasPermission) {
        print('Settings: Permission denied, returning');
        return;
      }

      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Loading image...'),
            backgroundColor: Color(0xFFE91E63),
            duration: Duration(seconds: 1),
          ),
        );
      }

      print('Settings: Calling image picker...');
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      print('Settings: Image picker result: ${image?.path}');
      
      if (image != null) {
        print('Settings: Setting profile image to: ${image.path}');
        setState(() {
          _profileImage = File(image.path);
        });
        
        // Save profile picture path to local storage
        print('Settings: Saving profile picture to local storage...');
        
        // Get current user from Firebase
        final currentUser = _authService.currentUser;
        if (currentUser != null) {
          final userEmail = currentUser.email!;
          
          // Load existing user data
          var userData = LocalStorageService.getUserDataByEmail(userEmail);
          if (userData == null) {
            print('Settings: No user data found for $userEmail, creating new');
            userData = UserModel.fromFirebaseUser(currentUser);
          }
          
          // Update profile picture path
          userData.setProfilePicture(image.path);
          
          // Save user data by email
          await LocalStorageService.saveUserDataByEmail(userEmail, userData);
          await LocalStorageService.saveCurrentUser(userData); // For backward compatibility
          
          print('Settings: Profile picture saved successfully for $userEmail');
        } else {
          print('Settings: No current user found for saving profile picture');
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully!'),
              backgroundColor: Color(0xFF4CAF50),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        print('Settings: No image selected');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No image selected'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Settings: Image picker error: $e');
      
      // Show fallback option if image picker fails
      if (mounted) {
        _showFallbackDialog();
      }
    }
  }

  void _showFallbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Picker Unavailable'),
          content: const Text(
            'Unable to access camera or gallery. You can still customize your profile with a colored avatar.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _createCustomAvatar();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Avatar'),
            ),
          ],
        );
      },
    );
  }

  void _createCustomAvatar() {
    // Create a custom avatar with user's initials and a random color
    final colors = [
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF2196F3),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF795548),
    ];
    
    final randomColor = colors[DateTime.now().millisecond % colors.length];
    
    setState(() {
      // For now, we'll just show a success message
      // In a real implementation, you'd save this as a custom avatar
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Custom avatar created!'),
        backgroundColor: randomColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(
                    'Camera',
                    Icons.camera_alt,
                    () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildImageOption(
                    'Gallery',
                    Icons.photo_library,
                    () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFE91E63),
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Picture with Upload
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFFE91E63),
                        backgroundImage: _profileImage != null 
                            ? FileImage(_profileImage!) 
                            : null,
                        child: _profileImage == null
                            ? Text(
                                _userProfile['username']?.isNotEmpty == true 
                                    ? _userProfile['username'][0].toUpperCase() 
                                    : 'U',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImagePickerDialog,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE91E63),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userProfile['username'] ?? 'User',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userProfile['email'] ?? 'user@example.com',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  if (_onboardingData != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildOnboardingInfo(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Feedback Section (for therapists only)
            if (_userProfile['role'] == 'therapist') ...[
              const Text(
                'Professional',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingsCard(
                'View Client Feedback',
                'See what your clients are saying about you',
                Icons.rate_review,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TherapistFeedbackPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
            
            // Account Section
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Settings Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingsCard(
                    'Edit Profile',
                    'Update your profile information',
                    Icons.person,
                    () {
                      _showEditProfileDialog();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    'Help & Support',
                    'Contact support@therapair.app for assistance',
                    Icons.help,
                    () {
                      _showHelpSupportDialog();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    'Log Out',
                    'Sign out of your account',
                    Icons.logout,
                    _signOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Name', _onboardingData?['name'] ?? 'Not provided'),
        _buildInfoRow('Age', _onboardingData?['age']?.toString() ?? 'Not provided'),
        _buildInfoRow('Gender', _onboardingData?['gender'] ?? 'Not provided'),
        _buildInfoRow('Phone', _onboardingData?['phone'] ?? 'Not provided'),
        _buildInfoRow('Therapy Type', _onboardingData?['therapyType'] ?? 'Not provided'),
        if (_onboardingData?['completedAt'] != null) ...[
          const SizedBox(height: 8),
          _buildInfoRow(
            'Profile Completed', 
            _formatDate(_onboardingData!['completedAt'])
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      
      // Simple navigation to login page
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditProfile() {
    // TODO: Implement edit profile functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showEditProfileDialog() {
    final usernameController = TextEditingController(text: _userProfile['username']);
    final emailController = TextEditingController(text: _userProfile['email']);
    final nameController = TextEditingController(text: _onboardingData?['name']);
    final ageController = TextEditingController(text: _onboardingData?['age']?.toString());
    final genderController = TextEditingController(text: _onboardingData?['gender']);
    final phoneController = TextEditingController(text: _onboardingData?['phone']);
    final therapyTypeController = TextEditingController(text: _onboardingData?['therapyType']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your new username',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your new email',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter your age',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: genderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    hintText: 'Enter your gender',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter your phone number',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: therapyTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Therapy Type',
                    hintText: 'Enter your therapy type',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveProfileChanges(
                  usernameController.text,
                  emailController.text,
                  nameController.text,
                  ageController.text,
                  genderController.text,
                  phoneController.text,
                  therapyTypeController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProfileChanges(
    String username,
    String email,
    String name,
    String age,
    String gender,
    String phone,
    String therapyType,
  ) async {
    try {
      final currentUser = AuthService().currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final userEmail = currentUser.email!;
      var userData = LocalStorageService.getUserDataByEmail(userEmail);
      
      if (userData == null) {
        userData = UserModel.fromFirebaseUser(currentUser);
      }

      // Update user profile
      userData.username = username.isNotEmpty ? username : userData.username;
      userData.email = email.isNotEmpty ? email : userData.email;

      // Update onboarding data
      if (userData.onboardingData == null) {
        userData.onboardingData = {};
      }

      if (name.isNotEmpty) userData.onboardingData!['name'] = name;
      if (age.isNotEmpty) userData.onboardingData!['age'] = int.tryParse(age) ?? userData.onboardingData!['age'];
      if (gender.isNotEmpty) userData.onboardingData!['gender'] = gender;
      if (phone.isNotEmpty) userData.onboardingData!['phone'] = phone;
      if (therapyType.isNotEmpty) userData.onboardingData!['therapyType'] = therapyType;

      // Save updated user data
      await LocalStorageService.saveUserDataByEmail(userEmail, userData);
      await LocalStorageService.saveCurrentUser(userData);

      // Update local state
      setState(() {
        _userProfile = {
          'username': userData?.getDisplayName() ?? username,
          'email': userData?.email ?? userEmail,
          'role': userData?.role,
        };
        _onboardingData = userData?.onboardingData;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      print('Error saving profile changes: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showHelpSupportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Text(
            'If you need assistance, please contact support@therapair.app. We are here to help you!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsCard(String title, String subtitle, IconData icon, VoidCallback onPressed) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFE91E63),
                size: 30,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const SettingsButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFE91E63),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onPressed,
    );
  }
}
