import 'package:flutter/material.dart';
import 'package:therapair/client_onboarding_page.dart';
import 'package:therapair/therapist_onboarding_page.dart';
import 'package:therapair/services/local_storage_service.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final displayName = LocalStorageService.getUserDisplayName();
    
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Text
              Text(
                'Welcome, $displayName!',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'How would you like to use TheraPair?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              // Client Card
              _buildRoleCard(
                title: 'I\'m a Client',
                subtitle: 'Looking for therapy and support',
                icon: Icons.person,
                color: const Color(0xFFE91E63),
                onTap: () => _selectRole('client'),
              ),
              const SizedBox(height: 24),
              
              // Therapist Card
              _buildRoleCard(
                title: 'I\'m a Therapist',
                subtitle: 'Providing therapy and support',
                icon: Icons.psychology,
                color: const Color(0xFF9C27B0),
                onTap: () => _selectRole('therapist'),
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectRole(String role) async {
    print('RoleSelectionPage: Selecting role: $role');
    
    try {
      await LocalStorageService.updateUserRole(role);
      print('RoleSelectionPage: Role saved successfully');
      
      if (mounted) {
        if (role == 'client') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ClientOnboardingPage(),
            ),
          );
        } else if (role == 'therapist') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TherapistOnboardingPage(),
            ),
          );
        }
      }
    } catch (e) {
      print('RoleSelectionPage: Error saving role: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving role: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 