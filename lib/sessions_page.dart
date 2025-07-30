import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  // Empty list - no placeholder data
  final List<Map<String, dynamic>> _sessions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('My Sessions'),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _sessions.isEmpty
          ? _buildEmptyState()
          : _buildSessionsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
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
                Icons.event_note,
                size: 60,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Sessions Scheduled',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'You don\'t have any therapy sessions scheduled yet.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _findTherapist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Find a Therapist',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsList() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: _sessions.map((session) => SessionCard(
        therapistName: session['therapistName'] ?? 'Unknown Therapist',
        date: session['date'] ?? 'Unknown Date',
        time: session['time'] ?? 'Unknown Time',
      )).toList(),
    );
  }

  void _findTherapist() {
    // TODO: Navigate to therapist search
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Therapist search coming soon!'),
        backgroundColor: Color(0xFFE91E63),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final String therapistName;
  final String date;
  final String time;

  const SessionCard({
    super.key,
    required this.therapistName,
    required this.date,
    required this.time,
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
              backgroundColor: const Color(0xFFE91E63).withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Color(0xFFE91E63),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
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
            ),
            IconButton(
              onPressed: () {
                // TODO: Add session details or reschedule functionality
              },
              icon: const Icon(
                Icons.more_vert,
                color: Color(0xFFE91E63),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
