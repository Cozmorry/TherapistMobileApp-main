import 'package:flutter/material.dart';
import 'package:therapair/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:therapair/providers/auth_provider.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  List<Map<String, dynamic>> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProfile = await FirebaseService.getCurrentUserProfile();
      
      if (userProfile != null) {
        final sessions = await FirebaseService.getUserSessions(
          authProvider.user!.uid,
          userProfile['role'] ?? 'client',
        );
        setState(() {
          _sessions = sessions;
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load sessions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      appBar: AppBar(
        title: const Text('My Sessions'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
            )
          else if (_sessions.isEmpty)
            const Center(
              child: Text(
                'No sessions scheduled',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          else
            ..._sessions.map((session) => SessionCard(
              therapistName: session['therapistName'] ?? 'Unknown Therapist',
              date: session['date'] ?? 'Unknown Date',
              time: session['time'] ?? 'Unknown Time',
              imageUrl: 'assets/images/therapist_placeholder.png', // Default image
            )),
        ],
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final String therapistName;
  final String date;
  final String time;
  final String imageUrl;

  const SessionCard({
    super.key,
    required this.therapistName,
    required this.date,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imageUrl), // Use AssetImage for local images
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  therapistName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
