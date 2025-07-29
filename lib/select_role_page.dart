import 'package:flutter/material.dart';
import 'package:therapair/client_registration_page.dart'; // Import your ClientRegistrationPage
import 'package:therapair/therapist_registration_page.dart'; // Import your TherapistRegistrationPage

class SelectRolePage extends StatelessWidget {
  const SelectRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 80.0), // Adjust spacing from top
              child: Text(
                'Select Your Role',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _buildRoleButton(context, 'Client'),
            const SizedBox(height: 30), // Space between buttons
            _buildRoleButton(context, 'Therapist'),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String role) {
    return ElevatedButton(
      onPressed: () {
        if (role == 'Client') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClientRegistrationPage()),
          );
        } else if (role == 'Therapist') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TherapistRegistrationPage()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE91E63), // Pink button background
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20), // Larger padding for fatter buttons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5, // Shadow for the button
      ),
      child: Text(
        role,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
