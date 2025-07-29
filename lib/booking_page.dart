import 'package:flutter/material.dart';
import 'package:therapair/session_schedule_page.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

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
        children: const [
          TherapistCard(
            name: 'Mariam Musa',
            specialty: 'Cognitive Behavioral Therapy',
            compatibilityScore: 87,
            imageUrl: 'assets/mariam.jpg', // Placeholder for image
          ),
          TherapistCard(
            name: 'Jonathan Moore',
            specialty: 'Psychodynamic Therapy',
            compatibilityScore: 72,
            imageUrl: 'assets/jonathan.jpg', // Placeholder for image
          ),
          TherapistCard(
            name: 'Jenelle Davinport',
            specialty: 'Dialectical Behavior Therapy',
            compatibilityScore: 65,
            imageUrl: 'assets/jenelle.jpg', // Placeholder for image
          ),
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
              backgroundImage: AssetImage(imageUrl), // Use AssetImage for local images
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
            // TODO: Add star icon and rating if needed
          ],
        ),
      ),
    );
  }
}
