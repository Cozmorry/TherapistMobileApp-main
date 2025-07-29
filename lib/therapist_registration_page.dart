import 'package:flutter/material.dart';
import 'package:therapair/login_page.dart';
import 'package:therapair/widgets/main_layout.dart'; // Import the main layout

class TherapistRegistrationPage extends StatelessWidget {
  const TherapistRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Register',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.left, // Align "Register" to left
            ),
            const SizedBox(height: 40.0),
            _buildTextField('Username'),
            const SizedBox(height: 20.0),
            _buildTextField('Email'),
            const SizedBox(height: 20.0),
            _buildTextField('Password', obscureText: true),
            const SizedBox(height: 20.0),
            _buildTextField('Indicate specialties, approaches and availability', maxLines: 5), // For multi-line input
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement therapist registration logic
                // After successful registration, navigate to the therapist layout
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLayout(isTherapist: true)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63), // Pink button background
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5, // Shadow for the button
              ),
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()),
                    );
                    // Navigate to the login page
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Color(0xFF4A68FF), // Blue color for "Log In"
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0), // Padding at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, {bool obscureText = false, int? maxLines = 1}) {
    return TextField(
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white, // White background for text fields
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0), // Padding inside the text field
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
