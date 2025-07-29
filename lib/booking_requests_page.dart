import 'package:flutter/material.dart';

class BookingRequestsPage extends StatelessWidget {
  const BookingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      appBar: AppBar(
        title: const Text('Booking Requests'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          BookingRequestCard(
            clientName: 'Jackson',
            date: 'May 22, 2025',
            time: '14:00',
            imageUrl: 'assets/jackson.jpg',
          ),
          BookingRequestCard(
            clientName: 'Anastasia',
            date: 'May 23, 2025',
            time: '10:00',
            imageUrl: 'assets/anastasia.jpg',
          ),
        ],
      ),
    );
  }
}

class BookingRequestCard extends StatelessWidget {
  final String clientName;
  final String date;
  final String time;
  final String imageUrl;

  const BookingRequestCard({
    super.key,
    required this.clientName,
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
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 35, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientName,
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
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement decline action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking request declined'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Decline',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement accept action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking request accepted'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63), // Pink button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(color: Colors.white),
                    ),
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