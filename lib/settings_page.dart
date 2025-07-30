import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapair/providers/auth_provider.dart';
import 'package:therapair/feedback_page.dart';
import 'package:therapair/services/firebase_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await FirebaseService.getCurrentUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                      children: [
                        if (_isLoading)
                          const CircularProgressIndicator(
                            color: Color(0xFFE91E63),
                            strokeWidth: 2,
                          )
                        else ...[
                          Text(
                            _userProfile?['username'] ?? 'User',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            _userProfile?['email'] ?? 'user@example.com',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
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
            SettingsButton(text: 'Log Out', onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              try {
                await authProvider.signOut();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logout failed: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }),
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
