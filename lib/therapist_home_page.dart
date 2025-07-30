import 'package:flutter/material.dart';
import 'package:therapair/session_schedule_page.dart';
import 'package:provider/provider.dart';
import 'package:therapair/providers/auth_provider.dart';
import 'package:therapair/services/firebase_service.dart';

class TherapistHomePage extends StatefulWidget {
  const TherapistHomePage({super.key});

  @override
  State<TherapistHomePage> createState() => _TherapistHomePageState();
}

class _TherapistHomePageState extends State<TherapistHomePage> {
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _upcomingSessions = [];
  List<Map<String, dynamic>> _clientInteractions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProfile = await FirebaseService.getCurrentUserProfile();
      
      if (userProfile != null) {
        final sessions = await FirebaseService.getUserSessions(
          authProvider.user!.uid,
          'therapist',
        );
        
        setState(() {
          _userProfile = userProfile;
          _upcomingSessions = sessions.where((session) => 
            session['status'] == 'scheduled' || session['status'] == 'confirmed'
          ).toList();
          _clientInteractions = sessions.take(3).toList(); // Show last 3 interactions
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none), // Notification bell icon
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Upcoming Sessions Section
            const Text(
              'Upcoming Sessions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE91E63),
                ),
              )
            else if (_upcomingSessions.isEmpty)
              const Center(
                child: Text(
                  'No upcoming sessions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            else
              ..._upcomingSessions.map((session) => Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE91E63),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(session['clientName'] ?? 'Client'),
                  subtitle: Text('${session['date']} at ${session['time']}'),
                  trailing: Text(
                    session['status'] ?? 'Scheduled',
                    style: const TextStyle(
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
            const SizedBox(height: 20.0),

            // Client Interaction Section
            const Text(
              'Client Interaction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE91E63),
                ),
              )
            else if (_clientInteractions.isEmpty)
              const Center(
                child: Text(
                  'No recent client interactions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            else
              ..._clientInteractions.map((interaction) => Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.chat, color: Colors.white),
                  ),
                  title: Text(interaction['clientName'] ?? 'Client'),
                  subtitle: Text('Last session: ${interaction['date']}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              )),
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
      ),
      // Remove bottom navigation as it will be handled by MainLayout
    );
  }
}

class UpcomingSessionCard extends StatelessWidget {
  final String clientName;
  final String time;
  final String imageUrl;

  const UpcomingSessionCard({super.key, required this.clientName, required this.time, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(imageUrl), // Use AssetImage for local images
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    clientName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey), // Forward arrow icon
          ],
        ),
      ),
    );
  }
}

class ClientInteractionCard extends StatelessWidget {
  final String clientName;
  final String lastContacted;
  final String imageUrl;

  const ClientInteractionCard({super.key, required this.clientName, required this.lastContacted, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(imageUrl), // Use AssetImage for local images
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    clientName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Last contacted: $lastContacted',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey), // Forward arrow icon
          ],
        ),
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const QuickActionButton({super.key, required this.text, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Button color
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: color == Colors.blueAccent ? Colors.white : Colors.black87, // Text color based on button color
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
