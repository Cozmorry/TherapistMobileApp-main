import 'package:flutter/material.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/services/notification_service.dart';
import 'dart:io';

class TherapistSessionsPage extends StatefulWidget {
  const TherapistSessionsPage({super.key});

  @override
  State<TherapistSessionsPage> createState() => _TherapistSessionsPageState();
}

class _TherapistSessionsPageState extends State<TherapistSessionsPage> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = AuthService().currentUser;
      if (currentUser != null) {
        final therapistEmail = currentUser.email!;
        final allBookings = LocalStorageService.getAllBookings();
        final therapistBookings = allBookings.where((booking) => 
          booking['therapistEmail'] == therapistEmail
        ).toList();
        
        // Sort bookings by bookedAt timestamp (latest first)
        therapistBookings.sort((a, b) {
          final timestampA = a['bookedAt'] ?? '';
          final timestampB = b['bookedAt'] ?? '';
          return timestampB.compareTo(timestampA); // Latest first
        });
        
        setState(() {
          _bookings = therapistBookings;
          _isLoading = false;
        });
        
        print('TherapistSessionsPage: Loaded ${therapistBookings.length} bookings for therapist: $therapistEmail');
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

  String _formatTimestamp(String timestamp) {
    try {
      final now = DateTime.now();
      final timestampDate = DateTime.parse(timestamp);
      final difference = now.difference(timestampDate);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else {
        return '${timestampDate.day}/${timestampDate.month}/${timestampDate.year}';
      }
    } catch (e) {
      return 'Unknown time';
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
                  onRefresh: () async {
                    _loadBookings();
                  },
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
            'You don\'t have any client sessions scheduled yet.',
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

  Widget _buildSessionCard(Map<String, dynamic> booking) {
    final date = DateTime.parse(booking['date']);
    final status = booking['status'] ?? 'pending';
    final clientName = booking['clientName'] ?? 'Unknown Client';
    final clientEmail = booking['clientEmail'] ?? '';
    final sessionType = booking['sessionType'] ?? 'Individual Therapy';
    final time = booking['time'] ?? 'TBD';
    final duration = booking['duration'] ?? '60 minutes';

    // Get client profile picture
    String? clientProfilePicturePath;
    if (clientEmail.isNotEmpty) {
      final clientData = LocalStorageService.getUserDataByEmail(clientEmail);
      clientProfilePicturePath = clientData?.profilePicturePath;
    }

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
                  child: clientProfilePicturePath != null
                      ? ClipOval(
                          child: Image.file(
                            File(clientProfilePicturePath),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                clientName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          clientName.substring(0, 1).toUpperCase(),
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
                        clientName,
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
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoItem(
                  Icons.schedule,
                  'Booked ${_formatTimestamp(booking['bookedAt'])}',
                ),
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
                      'Client Notes:',
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
                        _confirmSession(booking);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _declineSession(booking);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else if (status == 'confirmed') ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _completeSession(booking);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Complete'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _viewSessionDetails(booking);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
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

  Future<void> _confirmSession(Map<String, dynamic> booking) async {
    try {
      await LocalStorageService.updateBookingStatus(booking['bookedAt'], 'confirmed');
      
      // Send notification to client
      await NotificationService.notifyClientBookingAccepted(
        therapistName: booking['therapistName'],
        sessionType: booking['sessionType'],
        date: booking['date'],
      );
      
      _loadBookings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session confirmed!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error confirming session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _declineSession(Map<String, dynamic> booking) async {
    try {
      await LocalStorageService.updateBookingStatus(booking['bookedAt'], 'cancelled');
      
      // Send notification to client
      await NotificationService.notifyClientBookingDeclined(
        therapistName: booking['therapistName'],
        sessionType: booking['sessionType'],
        date: booking['date'],
      );
      
      _loadBookings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session declined!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error declining session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _completeSession(Map<String, dynamic> booking) async {
    try {
      await LocalStorageService.updateBookingStatus(booking['bookedAt'], 'completed');
      
      // Send notification to client
      await NotificationService.notifyClientSessionCompleted(
        therapistName: booking['therapistName'],
        sessionType: booking['sessionType'],
        date: booking['date'],
      );
      
      _loadBookings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session marked as completed!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewSessionDetails(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final date = DateTime.parse(booking['date']);
        return AlertDialog(
          title: Text('Session with ${booking['clientName']}'),
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
                const Text('Client Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
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