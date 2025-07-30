import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final List<Map<String, dynamic>> _sessions = [
    {
      'therapistName': 'Dr. Sarah Johnson',
      'date': 'March 15, 2024',
      'time': '2:00 PM',
    },
    {
      'therapistName': 'Dr. Michael Chen',
      'date': 'March 18, 2024',
      'time': '10:00 AM',
    },
    {
      'therapistName': 'Dr. Emily Rodriguez',
      'date': 'March 22, 2024',
      'time': '3:30 PM',
    },
  ];

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
          if (_sessions.isEmpty)
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
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
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
