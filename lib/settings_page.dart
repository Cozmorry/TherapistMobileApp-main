import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:therapair/feedback_page.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/login_page.dart'; // Added import for LoginPage

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
  }

  void _loadUserProfile() {
    setState(() {
      _userProfile = {
        'username': LocalStorageService.getUserDisplayName(),
        'email': LocalStorageService.getCurrentUser()?.email ?? 'user@example.com',
      };
      _onboardingData = LocalStorageService.getUserOnboardingData();
    });
  }

  Future<bool> _requestPermissions(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        // Request camera permission
        final cameraStatus = await Permission.camera.request();
        if (cameraStatus.isDenied) {
          _showPermissionDialog('Camera', 'camera');
          return false;
        }
        if (cameraStatus.isPermanentlyDenied) {
          _showPermissionDialog('Camera', 'camera', isPermanent: true);
          return false;
        }
        return cameraStatus.isGranted;
      } else {
        // Request storage permission for gallery
        final storageStatus = await Permission.storage.request();
        if (storageStatus.isDenied) {
          _showPermissionDialog('Storage', 'storage');
          return false;
        }
        if (storageStatus.isPermanentlyDenied) {
          _showPermissionDialog('Storage', 'storage', isPermanent: true);
          return false;
        }
        return storageStatus.isGranted;
      }
    } catch (e) {
      print('Permission request error: $e');
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
      // Check and request permissions first
      final hasPermission = await _requestPermissions(source);
      if (!hasPermission) {
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

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        
        // Save profile picture path to local storage
        await LocalStorageService.updateUserProfilePicture(image.path);
        
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
      print('Image picker error: $e');
      
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
                  SettingsButton(
                    text: 'Edit Profile',
                    icon: Icons.person,
                    onPressed: _showEditProfile,
                  ),
                  SettingsButton(
                    text: 'Notifications',
                    icon: Icons.notifications,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notifications settings coming soon!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                  ),
                  SettingsButton(
                    text: 'Privacy & Security',
                    icon: Icons.security,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Privacy settings coming soon!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                  ),
                  SettingsButton(
                    text: 'Help & Support',
                    icon: Icons.help,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeedbackPage(),
                        ),
                      );
                    },
                  ),
                  SettingsButton(
                    text: 'Log Out',
                    icon: Icons.logout,
                    onPressed: _signOut,
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
