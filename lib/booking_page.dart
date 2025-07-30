import 'package:flutter/material.dart';
import 'package:therapair/session_schedule_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final List<Map<String, dynamic>> _therapists = [
    {
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Cognitive Behavioral Therapy (CBT)',
      'compatibilityScore': 95,
    },
    {
      'name': 'Dr. Michael Chen',
      'specialty': 'Anxiety and Stress Management',
      'compatibilityScore': 88,
    },
    {
      'name': 'Dr. Emily Rodriguez',
      'specialty': 'Depression and Mood Disorders',
      'compatibilityScore': 92,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      appBar: AppBar(
        title: const Text('Matchmaking Results'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_therapists.isEmpty)
            const Center(
              child: Text(
                'No therapists available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          else
            ..._therapists.map((therapist) => TherapistCard(
              name: therapist['name'] ?? 'Unknown',
              specialty: therapist['specialty'] ?? 'General Therapy',
              compatibilityScore: therapist['compatibilityScore'] ?? 85,
              imageUrl: 'assets/images/therapist_placeholder.png', // Default image
            )),
        ],
      ),
    );
  }
}

class TherapistCard extends StatelessWidget {
  final String name;
  final String specialty;
  final int compatibilityScore;
  final String imageUrl;

  const TherapistCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.compatibilityScore,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Compatibility Score: $compatibilityScore%',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SessionSchedulePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300], // Pink button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Book Now', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
