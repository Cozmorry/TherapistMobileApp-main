import 'package:flutter/material.dart';
import 'package:therapair/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // A light pink color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Heart icon with two people
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: const Color(0xFFE91E63), // A darker pink for the heart
                  size: 150.0,
                ),
                Positioned(
                  top: 50,
                  left: 45,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 45,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'TheraPair',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tailoring therapy to your needs',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63), // Pink button background
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5, // Shadow for the button
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
