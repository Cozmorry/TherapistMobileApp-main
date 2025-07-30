import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapair/providers/auth_provider.dart';
import 'package:therapair/widgets/google_sign_in_button.dart';

class TherapistRegistrationPage extends StatefulWidget {
  const TherapistRegistrationPage({super.key});

  @override
  State<TherapistRegistrationPage> createState() => _TherapistRegistrationPageState();
}

class _TherapistRegistrationPageState extends State<TherapistRegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _specialtiesController = TextEditingController();

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
            _buildTextField('Username', controller: _usernameController),
            const SizedBox(height: 20.0),
            _buildTextField('Email', controller: _emailController),
            const SizedBox(height: 20.0),
            _buildTextField('Password', obscureText: true, controller: _passwordController),
            const SizedBox(height: 20.0),
            _buildTextField('Indicate specialties, approaches and availability', maxLines: 5, controller: _specialtiesController), // For multi-line input
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () async {
                // Validate form
                if (_usernameController.text.isEmpty ||
                    _emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Register with Firebase
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                try {
                  await authProvider.signUp(
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                    username: _usernameController.text.trim(),
                    role: 'therapist',
                    specialties: _specialtiesController.text.trim().isEmpty 
                        ? null 
                        : _specialtiesController.text.trim(),
                  );
                  // Registration successful - user will be automatically logged in
                  // and redirected by the AuthWrapper in main.dart
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registration successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Registration failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
            const SizedBox(height: 20.0),
            // Google Sign In Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return GoogleSignInButton(
                  onPressed: () async {
                    try {
                      await authProvider.signInWithGoogle();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Google Sign In failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  isLoading: authProvider.isLoading,
                );
              },
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
                    Navigator.pushReplacementNamed(context, '/login');
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

  Widget _buildTextField(String hintText, {
    bool obscureText = false, 
    int? maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
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

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _specialtiesController.dispose();
    super.dispose();
  }
}
