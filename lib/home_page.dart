import 'package:flutter/material.dart';
import 'package:therapair/sessions_page.dart';
import 'package:therapair/resources_page.dart';
import 'package:therapair/settings_page.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/services/notification_service.dart';
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
            onPressed: () async {
              // Check notification permission first
              final hasPermission = await NotificationService.hasNotificationPermission();
              
              if (!hasPermission) {
                // Request permission if not granted
                await NotificationService.requestPermissions();
                
                // Check again after request
                final newPermissionStatus = await NotificationService.hasNotificationPermission();
                
                if (!newPermissionStatus) {
                  // Show a message if permission is still not granted
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification permission is required to receive updates'),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              }
              
              // Navigate to notification center regardless of permission status
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationCenterPage(),
                  ),
                );
              }
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
            
            // Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Book Session',
                    'Schedule therapy session',
                    Icons.calendar_today,
                    () {
                      // Navigate to therapist search
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TherapistSearchResultsPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    'View History',
                    'See your past sessions',
                    Icons.history,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SessionsPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Emergency Contact',
                    'Get immediate support',
                    Icons.emergency,
                    () {
                      _showEmergencyContact();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    'Wellness Tips',
                    'Daily mental health tips',
                    Icons.psychology,
                    () {
                      _showWellnessTips();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Chatbot Section
            const Text(
              'Chatbot',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildChatbotCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, // Fixed height for consistent sizing
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: const Color(0xFFE91E63),
                size: 36,
              ),
              const SizedBox(height: 8),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatbotCard() {
    return GestureDetector(
      onTap: () {
        _showChatbot();
      },
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: const Color(0xFFE91E63),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TheraPair Chat',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Chat with our AI therapist',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 14,
              ),
            ],
          ),
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

  void _showEmergencyContact() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency Contacts'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'If you\'re experiencing a mental health crisis, please contact:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildEmergencyContact('911', 'Emergency Services (US)', Icons.emergency, Colors.red),
              const SizedBox(height: 8),
              _buildEmergencyContact('999', 'Emergency Services (Kenya)', Icons.emergency, Colors.red),
              const SizedBox(height: 8),
              _buildEmergencyContact('116', 'Child Helpline (Kenya)', Icons.child_care, Colors.orange),
              const SizedBox(height: 8),
              _buildEmergencyContact('1195', 'Gender Violence Helpline (Kenya)', Icons.security, Colors.purple),
              const SizedBox(height: 8),
              _buildEmergencyContact('0800 720 072', 'Nairobi Women\'s Hospital Crisis Line', Icons.local_hospital, Colors.green),
              const SizedBox(height: 8),
              _buildEmergencyContact('+254 20 272 0000', 'Aga Khan Hospital Mental Health', Icons.medical_services, Colors.blue),
            ],
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

  Widget _buildEmergencyContact(String number, String description, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showWellnessTips() {
    final today = DateTime.now();
    final tips = _getDailyWellnessTips(today);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.psychology, color: const Color(0xFFE91E63)),
              const SizedBox(width: 8),
              const Text('Daily Wellness Tips'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${today.day}/${today.month}/${today.year}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: const Color(0xFFE91E63),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
            ],
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

  List<String> _getDailyWellnessTips(DateTime date) {
    // Use date to generate consistent tips for the day
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final tips = [
      'Practice deep breathing for 5 minutes to reduce stress and anxiety.',
      'Take a 10-minute walk outside to boost your mood and energy levels.',
      'Write down three things you\'re grateful for today.',
      'Stay hydrated - drink at least 8 glasses of water daily.',
      'Limit screen time before bed to improve sleep quality.',
      'Connect with a friend or family member today.',
      'Try a new hobby or activity that brings you joy.',
      'Practice self-compassion - be kind to yourself today.',
      'Take regular breaks if you\'re working for long periods.',
      'Express your feelings through writing or art.',
      'Practice mindfulness by focusing on the present moment.',
      'Get adequate sleep - aim for 7-9 hours per night.',
      'Eat nutritious meals to support your mental health.',
      'Set small, achievable goals for today.',
      'Practice positive self-talk throughout the day.',
      'Take time to appreciate nature and the outdoors.',
      'Learn something new to keep your mind active.',
      'Practice relaxation techniques like progressive muscle relaxation.',
      'Maintain a regular daily routine for stability.',
      'Seek professional help if you\'re struggling - it\'s a sign of strength.',
    ];
    
    // Select 3 tips based on the day of year
    final selectedTips = <String>[];
    for (int i = 0; i < 3; i++) {
      final index = (dayOfYear + i) % tips.length;
      selectedTips.add(tips[index]);
    }
    
    return selectedTips;
  }

  void _showChatbot() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('TheraPair Chat coming soon!'),
        backgroundColor: Color(0xFFE91E63),
      ),
    );
  }
}
