import 'package:flutter/material.dart';
import 'package:therapair/services/therapist_matching_service.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/booking_page.dart'; // Added import for BookingPage

class TherapistSearchResultsPage extends StatefulWidget {
  const TherapistSearchResultsPage({super.key});

  @override
  State<TherapistSearchResultsPage> createState() => _TherapistSearchResultsPageState();
}

class _TherapistSearchResultsPageState extends State<TherapistSearchResultsPage> {
  List<Map<String, dynamic>> _matchingTherapists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _findMatchingTherapists();
  }

  Future<void> _findMatchingTherapists() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final clientPreferences = LocalStorageService.getUserOnboardingData();
      
      if (clientPreferences == null) {
        setState(() {
          _matchingTherapists = [];
          _isLoading = false;
        });
        return;
      }

      final matchingTherapists = TherapistMatchingService.findMatchingTherapists(
        clientPreferences: clientPreferences,
        minMatchPercentage: 50.0,
      );

      setState(() {
        _matchingTherapists = matchingTherapists;
        _isLoading = false;
      });
    } catch (e) {
      print('Error finding matching therapists: $e');
      setState(() {
        _matchingTherapists = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Find My Therapist'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _findMatchingTherapists,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
            )
          : _matchingTherapists.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _findMatchingTherapists,
                  color: const Color(0xFFE91E63),
                  child: _buildResultsList(),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No matching therapists found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your preferences to find more therapists',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFE91E63),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Matching Therapists',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Found ${_matchingTherapists.length} therapist${_matchingTherapists.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        
        // Results List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _matchingTherapists.length,
            itemBuilder: (context, index) {
              final therapist = _matchingTherapists[index];
              final matchPercentage = therapist['matchPercentage'] as double;
              
              return _buildTherapistCard(therapist, matchPercentage);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTherapistCard(Map<String, dynamic> therapist, double matchPercentage) {
    final matchDescription = TherapistMatchingService.getMatchDescription(matchPercentage);
    final matchColor = _parseColor(TherapistMatchingService.getMatchColor(matchPercentage));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        children: [
          // Header with match percentage
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: matchColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: matchColor,
                  child: Text(
                    therapist['name']?.toString().substring(0, 1).toUpperCase() ?? 'T',
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
                        therapist['name'] ?? 'Therapist',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        therapist['therapeuticApproach'] ?? 'Therapist',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: matchColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${matchPercentage.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      matchDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: matchColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Experience', therapist['experienceLevel'] ?? 'Not specified'),
                const SizedBox(height: 8),
                _buildDetailRow('Specialization', therapist['specialization'] ?? 'Not specified'),
                const SizedBox(height: 8),
                _buildDetailRow('Communication Style', therapist['communicationStyle'] ?? 'Not specified'),
                const SizedBox(height: 8),
                _buildDetailRow('Session Type', therapist['sessionType'] ?? 'Not specified'),
                if (therapist['bio'] != null) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    therapist['bio'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showTherapistDetails(therapist, matchPercentage);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE91E63),
                      side: const BorderSide(color: Color(0xFFE91E63)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(therapist: therapist),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Book Session'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  void _showTherapistDetails(Map<String, dynamic> therapist, double matchPercentage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(therapist['name'] ?? 'Therapist'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Match: ${matchPercentage.toInt()}%'),
                const SizedBox(height: 16),
                Text('License: ${therapist['license'] ?? 'Not specified'}'),
                const SizedBox(height: 8),
                Text('Experience: ${therapist['experienceLevel'] ?? 'Not specified'}'),
                const SizedBox(height: 8),
                Text('Approach: ${therapist['therapeuticApproach'] ?? 'Not specified'}'),
                const SizedBox(height: 8),
                Text('Specialization: ${therapist['specialization'] ?? 'Not specified'}'),
                const SizedBox(height: 8),
                Text('Communication: ${therapist['communicationStyle'] ?? 'Not specified'}'),
                const SizedBox(height: 8),
                Text('Session Type: ${therapist['sessionType'] ?? 'Not specified'}'),
                if (therapist['bio'] != null) ...[
                  const SizedBox(height: 16),
                  const Text('Bio:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(therapist['bio']),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _bookSession(therapist);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
              ),
              child: const Text('Book Session'),
            ),
          ],
        );
      },
    );
  }

  void _bookSession(Map<String, dynamic> therapist) {
    Navigator.pop(context); // Close the modal first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingPage(therapist: therapist),
      ),
    );
  }
} 