import 'package:flutter/material.dart';

class PersistentNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isTherapist;

  const PersistentNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isTherapist = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: isTherapist ? 'Schedule' : 'Sessions',
                index: 1,
              ),
              _buildNavItem(
                icon: isTherapist ? Icons.people_outline : Icons.bookmark_outline,
                activeIcon: isTherapist ? Icons.people : Icons.bookmark,
                label: isTherapist ? 'Clients' : 'Resources',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Settings',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE91E63).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? const Color(0xFFE91E63) : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? const Color(0xFFE91E63) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 