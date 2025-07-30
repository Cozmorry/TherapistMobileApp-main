import 'package:flutter/material.dart';
import 'package:therapair/client_registration_page.dart';
import 'package:therapair/therapist_registration_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you looking for therapy or providing therapy?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Client Registration Card
              _buildRegistrationCard(
                context: context,
                title: 'I\'m a Client',
                subtitle: 'Looking for therapy and support',
                icon: Icons.person,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClientRegistrationPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Therapist Registration Card
              _buildRegistrationCard(
                context: context,
                title: 'I\'m a Therapist',
                subtitle: 'Providing therapy and support',
                icon: Icons.psychology,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TherapistRegistrationPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFFE91E63),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFE91E63),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
} 