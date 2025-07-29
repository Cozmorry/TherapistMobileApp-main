import 'package:flutter/material.dart';
import 'package:therapair/feedback_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Profile Section
            Card(
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
                      radius: 30,
                      backgroundColor: Colors.grey[300], // Placeholder for image
                      child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'User',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'user@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            SettingsButton(text: 'Profile', onPressed: () { /* TODO: Implement action */ }),
            SettingsButton(text: 'Results', onPressed: () { /* TODO: Implement action */ }),
            SettingsButton(text: 'My Sessions', onPressed: () { /* TODO: Implement action */ }),
            SettingsButton(text: 'Feedback', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()),
              );
            }),
            SettingsButton(text: 'Log Out', onPressed: () { /* TODO: Implement action */ }),
          ],
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SettingsButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0), // Spacing between buttons
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100], // Light pink button color
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
             side: BorderSide(color: Colors.blueAccent), // Blue border
          ),
           elevation: 0, // Remove shadow
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87, // Dark grey text color
          ),
        ),
      ),
    );
  }
}
