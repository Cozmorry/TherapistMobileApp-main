import 'package:flutter/material.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/feedback_page.dart'; // Added import for FeedbackPage

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = AuthService().currentUser;
      if (currentUser != null) {
        final clientEmail = currentUser.email!;
        final allBookings = LocalStorageService.getAllBookings();
        final clientBookings = allBookings.where((booking) => 
          booking['clientEmail'] == clientEmail
        ).toList();
        
        // Sort bookings by date (latest first)
        clientBookings.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA); // Latest first
        });
        
        setState(() {
          _bookings = clientBookings;
          _isLoading = false;
        });
        
        print('SessionsPage: Loaded ${clientBookings.length} bookings for client: $clientEmail');
      } else {
        setState(() {
          _bookings = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading bookings: $e');
      setState(() {
        _bookings = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('My Sessions'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBookings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
            )
          : _bookings.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadBookings,
                  color: const Color(0xFFE91E63),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
                      return _buildSessionCard(_bookings[index]);
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
              Icons.event_note,
              color: Color(0xFFE91E63),
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Sessions Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Book your first session with a therapist to get started on your wellness journey.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Find My Therapist'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> booking) {
    final date = DateTime.parse(booking['date']);
    final status = booking['status'] ?? 'pending';
    final therapistName = booking['therapistName'] ?? 'Unknown Therapist';
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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFE91E63),
                  child: Text(
                    therapistName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        therapistName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        sessionType,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem(Icons.calendar_today, '${date.day}/${date.month}/${date.year}'),
                const SizedBox(width: 16),
                _buildInfoItem(Icons.access_time, time),
                const SizedBox(width: 16),
                _buildInfoItem(Icons.timer, duration),
              ],
            ),
            if (booking['notes'] != null && booking['notes'].toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking['notes'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (status == 'pending') ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _cancelSession(booking);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ] else if (status == 'completed') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _provideFeedback(booking);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Provide Feedback'),
                    ),
                  ),
                ],
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showSessionDetails(booking);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE91E63),
                      side: const BorderSide(color: Color(0xFFE91E63)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.black54,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  void _cancelSession(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Session'),
          content: const Text('Are you sure you want to cancel this session?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await LocalStorageService.updateBookingStatus(
                  booking['bookedAt'],
                  'cancelled',
                );
                _loadBookings();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _provideFeedback(Map<String, dynamic> booking) {
    // Create therapist data from booking
    final therapistData = {
      'name': booking['therapistName'] ?? 'Unknown Therapist',
      'email': booking['therapistEmail'] ?? '',
      'specialization': 'Therapist', // Default value
    };
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackPage(therapist: therapistData),
      ),
    );
  }

  void _showSessionDetails(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final date = DateTime.parse(booking['date']);
        return AlertDialog(
          title: Text('Session with ${booking['therapistName']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${date.day}/${date.month}/${date.year}'),
              Text('Time: ${booking['time']}'),
              Text('Duration: ${booking['duration']}'),
              Text('Type: ${booking['sessionType']}'),
              Text('Status: ${booking['status']}'),
              if (booking['notes'] != null && booking['notes'].toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(booking['notes']),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
