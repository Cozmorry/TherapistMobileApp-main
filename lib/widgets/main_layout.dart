import 'package:flutter/material.dart';
import 'package:therapair/widgets/persistent_navbar.dart';
import 'package:therapair/home_page.dart';
import 'package:therapair/sessions_page.dart';
import 'package:therapair/resources_page.dart';
import 'package:therapair/settings_page.dart';
import 'package:therapair/therapist_home_page.dart';
import 'package:therapair/booking_requests_page.dart';
import 'package:therapair/therapist_sessions_page.dart';

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

  @override
  void initState() {
    super.initState();
    _pages = widget.isTherapist
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

  @override
  Widget build(BuildContext context) {
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
        isTherapist: widget.isTherapist,
      ),
    );
  }
} 