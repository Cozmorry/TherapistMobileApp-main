import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapair/providers/auth_provider.dart';
import 'package:therapair/services/firebase_service.dart';
import 'package:therapair/client_form_page.dart';
import 'package:therapair/widgets/main_layout.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Welcome to TheraPair!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please select your role to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Client Role Card
              _buildRoleCard(
                title: 'I\'m a Client',
                subtitle: 'Looking for therapy and support',
                icon: Icons.person,
                isSelected: selectedRole == 'client',
                onTap: () => setState(() => selectedRole = 'client'),
              ),
              const SizedBox(height: 20),

              // Therapist Role Card
              _buildRoleCard(
                title: 'I\'m a Therapist',
                subtitle: 'Providing therapy and support',
                icon: Icons.psychology,
                isSelected: selectedRole == 'therapist',
                onTap: () => setState(() => selectedRole = 'therapist'),
              ),
              const SizedBox(height: 50),

              // Continue Button
              ElevatedButton(
                onPressed: selectedRole == null || _isLoading
                    ? null
                    : () => _continueWithRole(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Continue',
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
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE91E63) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFFE91E63) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.white : const Color(0xFFE91E63),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _continueWithRole() async {
    if (selectedRole == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        // Update the user's role in Firestore
        print('Updating user profile with role: $selectedRole'); // Debug log
        await FirebaseService.updateUserProfile(authProvider.user!.uid, {
          'role': selectedRole,
          'onboardingCompleted': selectedRole == 'therapist', // Therapists skip onboarding
        });
        print('User profile updated successfully'); // Debug log

        // Navigate based on role
        print('Navigating based on role: $selectedRole'); // Debug log
        if (selectedRole == 'therapist') {
          print('Navigating to therapist dashboard'); // Debug log
          // Navigate to therapist dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainLayout(isTherapist: true),
            ),
          );
        } else {
          print('Navigating to client onboarding'); // Debug log
          // Navigate to client onboarding
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ClientFormPage(),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set role: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
} 