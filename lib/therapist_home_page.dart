import 'package:flutter/material.dart';
import 'package:therapair/session_schedule_page.dart';
import 'package:therapair/settings_page.dart';
import 'package:therapair/therapist_sessions_page.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/services/auth_service.dart';

class TherapistHomePage extends StatefulWidget {
  const TherapistHomePage({super.key});

  @override
  State<TherapistHomePage> createState() => _TherapistHomePageState();
}

class _TherapistHomePageState extends State<TherapistHomePage> {
  int _currentIndex = 0;
  
  Map<String, dynamic> _userProfile = {
    'username': 'Therapist',
    'email': 'therapist@example.com',
  };
  
  int _pendingSessions = 0;
  int _confirmedSessions = 0;
  int _completedSessions = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadSessionStats();
  }

  void _loadUserProfile() {
    // Get current user from Firebase
    final currentUser = AuthService().currentUser;
    if (currentUser != null) {
      final userEmail = currentUser.email!;
      
      // Load user data by email
      final userData = LocalStorageService.getUserDataByEmail(userEmail);
      
      setState(() {
        _userProfile = {
          'username': userData?.getDisplayName() ?? userEmail.split('@')[0],
          'email': userEmail,
        };
      });
    }
  }

  void _loadSessionStats() {
    // Get current user from Firebase
    final currentUser = AuthService().currentUser;
    if (currentUser != null) {
      final userEmail = currentUser.email!;
      print('TherapistHomePage: Loading session stats for therapist: $userEmail');
      
      // Debug: Print all therapists and bookings
      LocalStorageService.debugPrintAllTherapists();
      LocalStorageService.debugPrintAllBookings();
      
      final bookings = LocalStorageService.getTherapistBookings(userEmail);
      
      int pending = 0;
      int confirmed = 0;
      int completed = 0;
      
      for (final booking in bookings) {
        final status = booking['status'] ?? 'pending';
        switch (status) {
          case 'pending':
            pending++;
            break;
          case 'confirmed':
            confirmed++;
            break;
          case 'completed':
            completed++;
            break;
        }
      }
      
      print('TherapistHomePage: Session stats - Pending: $pending, Confirmed: $confirmed, Completed: $completed');
      
      setState(() {
        _pendingSessions = pending;
        _confirmedSessions = confirmed;
        _completedSessions = completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Therapist Dashboard'),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildSessionsTab(),
          _buildClientsTab(),
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFE91E63),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${_userProfile['username']}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ready to help your clients today?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),

          // Stats Section
          const Text(
            'Today\'s Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pending Sessions',
                  '$_pendingSessions',
                  Icons.schedule,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Confirmed Sessions',
                  '$_confirmedSessions',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Completed Sessions',
                  '$_completedSessions',
                  Icons.done_all,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Total Sessions',
                  '${_pendingSessions + _confirmedSessions + _completedSessions}',
                  Icons.analytics,
                  const Color(0xFFE91E63),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          // Quick Actions Section
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          // Schedule Session Button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SessionSchedulePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Schedule Session',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsTab() {
    return const TherapistSessionsPage();
  }

  Widget _buildClientsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.people,
              color: Color(0xFFE91E63),
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Clients Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your clients will appear here once they book sessions.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return const SettingsPage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh stats when returning to home tab
    if (_currentIndex == 0) {
      _loadSessionStats();
    }
  }
}


