import 'package:flutter/material.dart';
import 'package:therapair/widgets/main_layout.dart'; // Import the main layout

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100], // Light pink background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Log In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 48.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withAlpha((0.8 * 255).round()),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withAlpha((0.8 * 255).round()),
                ),
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5.0,
                  color: Colors.blueAccent, // Example button color
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () {
                      // Navigate to the main layout on login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainLayout(isTherapist: false)),
                      );
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}