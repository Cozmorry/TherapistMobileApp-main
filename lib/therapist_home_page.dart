import 'package:flutter/material.dart';
import 'package:therapair/session_schedule_page.dart';
import 'package:therapair/settings_page.dart';
import 'package:therapair/therapist_sessions_page.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/services/notification_service.dart';
import 'package:therapair/therapist_feedback_page.dart'; // Added import for TherapistFeedbackPage
import 'package:therapair/notification_center_page.dart'; // Added import for NotificationCenterPage
import 'dart:io';

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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadSessionStats();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session stats refreshed!'),
                  backgroundColor: Color(0xFFE91E63),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
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
    return RefreshIndicator(
      onRefresh: () async {
        _loadSessionStats();
      },
      color: const Color(0xFFE91E63),
      child: SingleChildScrollView(
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
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'View Sessions',
                    'Manage your sessions',
                    Icons.calendar_today,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TherapistSessionsPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    'Client Feedback',
                    'See what clients are saying',
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
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            
            // Additional content to make it scrollable
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Pull down to refresh your session statistics and get the latest updates.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            
            // Quick Tips Section
            const Text(
              'Quick Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Tips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• Pull down on this screen to refresh session data\n• Check your sessions tab for detailed booking information\n• Use the settings to manage your profile',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100.0), // Extra space to ensure scrollability
          ],
        ),
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

  Widget _buildActionCard(String title, String subtitle, IconData icon, VoidCallback onPressed) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFFE91E63), size: 30),
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
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionsTab() {
    return const TherapistSessionsPage();
  }

  Widget _buildClientsTab() {
    return _ClientsTabContent();
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

class _ClientsTabContent extends StatefulWidget {
  @override
  State<_ClientsTabContent> createState() => _ClientsTabContentState();
}

class _ClientsTabContentState extends State<_ClientsTabContent> {
  List<Map<String, dynamic>> _clients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  void _loadClients() {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = AuthService().currentUser;
      if (currentUser != null) {
        final therapistEmail = currentUser.email!;
        final allBookings = LocalStorageService.getAllBookings();
        
        // Get unique clients who have booked with this therapist
        final Map<String, Map<String, dynamic>> uniqueClients = {};
        
        for (final booking in allBookings) {
          final bookingTherapistEmail = booking['therapistEmail'];
          if (bookingTherapistEmail == therapistEmail) {
            final clientEmail = booking['clientEmail'];
            final clientName = booking['clientName'];
            
            if (clientEmail != null && !uniqueClients.containsKey(clientEmail)) {
              uniqueClients[clientEmail] = {
                'email': clientEmail,
                'name': clientName ?? 'Unknown Client',
                'totalBookings': 1,
                'lastBooking': booking['bookedAt'],
              };
            } else if (clientEmail != null) {
              // Increment booking count for existing client
              uniqueClients[clientEmail]!['totalBookings'] = 
                  (uniqueClients[clientEmail]!['totalBookings'] ?? 0) + 1;
            }
          }
        }
        
        setState(() {
          _clients = uniqueClients.values.toList();
          _isLoading = false;
        });
        
        print('ClientsTab: Loaded ${_clients.length} clients for therapist: $therapistEmail');
      } else {
        setState(() {
          _clients = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading clients: $e');
      setState(() {
        _clients = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
            )
          : _clients.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    _loadClients();
                  },
                  color: const Color(0xFFE91E63),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _clients.length,
                    itemBuilder: (context, index) {
                      return _buildClientCard(_clients[index]);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
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
            'Your clients will appear here once they book sessions with you.',
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

  Widget _buildClientCard(Map<String, dynamic> client) {
    final clientName = client['name'] ?? 'Unknown Client';
    final clientEmail = client['email'] ?? '';
    
    // Get client profile picture
    String? clientProfilePicturePath;
    if (clientEmail.isNotEmpty) {
      final clientData = LocalStorageService.getUserDataByEmail(clientEmail);
      clientProfilePicturePath = clientData?.profilePicturePath;
    }
    
    // Count total bookings for this client
    final currentUser = AuthService().currentUser;
    int totalBookings = 0;
    if (currentUser != null) {
      final therapistEmail = currentUser.email!;
      final allBookings = LocalStorageService.getAllBookings();
      totalBookings = allBookings.where((booking) => 
        booking['therapistEmail'] == therapistEmail && 
        booking['clientEmail'] == clientEmail
      ).length;
    }

    return GestureDetector(
      onTap: () {
        _showClientBookingsModal(client);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFFE91E63),
                child: clientProfilePicturePath != null
                    ? ClipOval(
                        child: Image.file(
                          File(clientProfilePicturePath),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              clientName.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        clientName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      clientEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$totalBookings booking${totalBookings != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClientBookingsModal(Map<String, dynamic> client) {
    final clientName = client['name'] ?? 'Unknown Client';
    final clientEmail = client['email'] ?? '';
    
    // Get client profile picture
    String? clientProfilePicturePath;
    if (clientEmail.isNotEmpty) {
      final clientData = LocalStorageService.getUserDataByEmail(clientEmail);
      clientProfilePicturePath = clientData?.profilePicturePath;
    }
    
    // Get all bookings for this specific client
    final currentUser = AuthService().currentUser;
    if (currentUser == null) return;
    
    final therapistEmail = currentUser.email!;
    final allBookings = LocalStorageService.getAllBookings();
    final clientBookings = allBookings.where((booking) => 
      booking['therapistEmail'] == therapistEmail && 
      booking['clientEmail'] == clientEmail
    ).toList();
    
    // Sort bookings by date (newest first)
    clientBookings.sort((a, b) => 
      DateTime.parse(b['date']).compareTo(DateTime.parse(a['date']))
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE91E63),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: clientProfilePicturePath != null
                            ? ClipOval(
                                child: Image.file(
                                  File(clientProfilePicturePath),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      clientName.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFFE91E63),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Text(
                                clientName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFFE91E63),
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
                              clientName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              clientEmail,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                
                // Bookings List
                Flexible(
                  child: clientBookings.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No bookings found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: clientBookings.length,
                          itemBuilder: (context, index) {
                            final booking = clientBookings[index];
                            final date = DateTime.parse(booking['date']);
                            final status = booking['status'] ?? 'pending';
                            final sessionType = booking['sessionType'] ?? 'Individual Therapy';
                            final time = booking['time'] ?? 'TBD';
                            final duration = booking['duration'] ?? '60 minutes';
                            
                            Color statusColor;
                            String statusText;
                            
                            switch (status) {
                              case 'confirmed':
                                statusColor = Colors.green;
                                statusText = 'Confirmed';
                                break;
                              case 'pending':
                                statusColor = Colors.orange;
                                statusText = 'Pending';
                                break;
                              case 'cancelled':
                                statusColor = Colors.red;
                                statusText = 'Cancelled';
                                break;
                              case 'completed':
                                statusColor = Colors.blue;
                                statusText = 'Completed';
                                break;
                              default:
                                statusColor = Colors.grey;
                                statusText = 'Unknown';
                            }
                            
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE91E63).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFFE91E63),
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                '${date.day}/${date.month}/${date.year} at $time',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(sessionType),
                                  Text('Duration: $duration'),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: statusColor),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                
                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${clientBookings.length} booking${clientBookings.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Color(0xFFE91E63),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


