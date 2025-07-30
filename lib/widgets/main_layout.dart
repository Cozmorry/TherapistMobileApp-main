import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapair/providers/auth_provider.dart';
import 'package:therapair/services/firebase_service.dart';
import 'package:therapair/widgets/persistent_navbar.dart';
import 'package:therapair/home_page.dart';
import 'package:therapair/sessions_page.dart';
import 'package:therapair/resources_page.dart';
import 'package:therapair/settings_page.dart';
import 'package:therapair/therapist_home_page.dart';
import 'package:therapair/booking_requests_page.dart';
import 'package:therapair/therapist_sessions_page.dart';
import 'package:therapair/client_form_page.dart';

import 'package:therapair/welcome_page.dart';

class MainLayout extends StatefulWidget {
  final bool isTherapist;

  const MainLayout({
    super.key,
    this.isTherapist = false,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  bool _isLoading = true;
  bool _showOnboarding = false;


  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _updatePages(bool isTherapist) {
    _pages = isTherapist
        ? [
            const TherapistHomePage(),
            const TherapistSessionsPage(),
            const BookingRequestsPage(),
            const SettingsPage(),
          ]
        : [
            const HomePage(),
            const SessionsPage(),
            const ResourcesPage(),
            const SettingsPage(),
          ];
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        // Wait for user profile to be loaded
        await authProvider.loadUserProfile();
        
        final userProfile = await FirebaseService.getCurrentUserProfile();
        print('User profile: $userProfile'); // Debug log
        
        if (userProfile != null && userProfile.isNotEmpty) {
          // Check if client needs onboarding
          if (userProfile['role'] == 'client' && userProfile['onboardingCompleted'] != true) {
            print('Client needs onboarding'); // Debug log
            setState(() {
              _showOnboarding = true;
              _isLoading = false;
            });
            return;
          }
          
          print('User is ready - showing main app'); // Debug log
          // Set the correct pages based on user role
          final isTherapist = userProfile['role'] == 'therapist';
          _updatePages(isTherapist);
        } else {
          print('No user profile found - redirecting to signup'); // Debug log
          // No user profile found - redirect to signup
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WelcomePage(),
            ),
          );
          return;
        }
      }
    } catch (e) {
      print('Error checking onboarding status: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFCE4EC),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE91E63),
          ),
        ),
      );
    }



    if (_showOnboarding) {
      return const ClientFormPage();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: PersistentNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        isTherapist: _pages.isNotEmpty && _pages.first is TherapistHomePage,
      ),
    );
  }
} 