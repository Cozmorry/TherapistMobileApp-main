import 'package:flutter/material.dart';
import 'package:therapair/session_schedule_page.dart';
import 'package:therapair/services/firebase_service.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Map<String, dynamic>> _therapists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTherapists();
  }

  Future<void> _loadTherapists() async {
    try {
      final userProfile = await FirebaseService.getCurrentUserProfile();
      
      // Get all therapists
      final allTherapists = await FirebaseService.getTherapists();
      
      // Filter therapists based on client preferences
      List<Map<String, dynamic>> filteredTherapists = allTherapists;
      
      if (userProfile != null && userProfile['therapyNeeds'] != null) {
        // Filter by therapy needs (specialties)
        filteredTherapists = allTherapists.where((therapist) {
          final specialties = therapist['specialties']?.toString().toLowerCase() ?? '';
          final therapyNeeds = userProfile['therapyNeeds'].toString().toLowerCase();
          return specialties.contains(therapyNeeds) || specialties.contains('general');
        }).toList();
      }
      
      setState(() {
        _therapists = filteredTherapists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load therapists: $e'),
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
        title: const Text('Matchmaking Results'),
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
          else if (_therapists.isEmpty)
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
              name: therapist['username'] ?? 'Unknown',
              specialty: therapist['specialties'] ?? 'General Therapy',
              compatibilityScore: 85, // Default compatibility score
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
