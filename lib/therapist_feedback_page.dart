import 'package:flutter/material.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/services/auth_service.dart';

class TherapistFeedbackPage extends StatefulWidget {
  const TherapistFeedbackPage({super.key});

  @override
  State<TherapistFeedbackPage> createState() => _TherapistFeedbackPageState();
}

class _TherapistFeedbackPageState extends State<TherapistFeedbackPage> {
  List<Map<String, dynamic>> _feedback = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  void _loadFeedback() {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = AuthService().currentUser;
      if (currentUser != null) {
        final therapistEmail = currentUser.email!;
        final feedback = LocalStorageService.getTherapistFeedback(therapistEmail);
        
        setState(() {
          _feedback = feedback;
          _isLoading = false;
        });
        
        print('TherapistFeedbackPage: Loaded ${feedback.length} feedback entries for therapist: $therapistEmail');
      } else {
        setState(() {
          _feedback = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading feedback: $e');
      setState(() {
        _feedback = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Client Feedback'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFeedback,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
            )
          : _feedback.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    _loadFeedback();
                  },
                  color: const Color(0xFFE91E63),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Feedback List
                        const Text(
                          'Client Reviews',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _feedback.length,
                          itemBuilder: (context, index) {
                            return _buildFeedbackCard(_feedback[index]);
                          },
                        ),
                      ],
                    ),
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
              Icons.rate_review,
              color: Color(0xFFE91E63),
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Feedback Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Client feedback will appear here once they share their experiences.',
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

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    final clientName = feedback['clientName'] ?? 'Anonymous';
    final feedbackText = feedback['feedback'] ?? '';
    final submittedAt = feedback['submittedAt'] ?? '';
    
    DateTime? submittedDate;
    try {
      submittedDate = DateTime.parse(submittedAt);
    } catch (e) {
      submittedDate = null;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE91E63),
                  child: Text(
                    clientName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (submittedDate != null)
                        Text(
                          '${submittedDate.day}/${submittedDate.month}/${submittedDate.year}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              feedbackText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 