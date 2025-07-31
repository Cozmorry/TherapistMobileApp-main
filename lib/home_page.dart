import 'package:flutter/material.dart';
import 'package:therapair/sessions_page.dart';
import 'package:therapair/resources_page.dart';
import 'package:therapair/settings_page.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/therapist_search_results_page.dart';
import 'package:therapair/notification_center_page.dart'; // Added import for NotificationCenterPage
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = 'User';
  bool _onboardingCompleted = false;
  String? _profilePicturePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Get current user from Firebase
    final currentUser = AuthService().currentUser;
    if (currentUser != null) {
      final userEmail = currentUser.email!;
      
      // Load user data by email
      final userData = LocalStorageService.getUserDataByEmail(userEmail);
      
      setState(() {
        _username = userData?.getDisplayName() ?? userEmail.split('@')[0];
        _onboardingCompleted = userData?.isOnboardingCompleted ?? false;
        _profilePicturePath = userData?.profilePicturePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFE91E63),
              child: _profilePicturePath != null
                  ? ClipOval(
                      child: Image.file(
                        File(_profilePicturePath!),
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(
                      _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    _username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationCenterPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Find My Therapist Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              child: ElevatedButton(
                onPressed: _findMyTherapist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFE91E63),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Find My Therapist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Quick Actions Grid
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildActionCard(
                  'My Sessions',
                  Icons.calendar_today,
                  const Color(0xFF4CAF50),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SessionsPage()),
                  ),
                ),
                _buildActionCard(
                  'Progress',
                  Icons.trending_up,
                  const Color(0xFF2196F3),
                  _showProgress,
                ),
                _buildActionCard(
                  'Resources',
                  Icons.library_books,
                  const Color(0xFFFF9800),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResourcesPage()),
                  ),
                ),
                _buildActionCard(
                  'Settings',
                  Icons.settings,
                  const Color(0xFF9C27B0),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _findMyTherapist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TherapistSearchResultsPage(),
      ),
    );
  }

  void _showProgress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress tracking coming soon!'),
        backgroundColor: Color(0xFF2196F3),
      ),
    );
  }
}
