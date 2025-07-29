import 'package:flutter/material.dart';
import 'package:therapair/welcome_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Heart icon
            Icon(
              Icons.favorite,
              color: const Color(0xFFE91E63), // Pink heart
              size: 120.0,
            ),
            const SizedBox(height: 30),
            const Text(
              'TheraPair',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tailoring therapy to your needs',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63), // Pink button
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 