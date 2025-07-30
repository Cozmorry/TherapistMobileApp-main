import 'package:flutter/material.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Resources'),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search resources...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFE91E63)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            const SizedBox(height: 24.0),

            // Filter Buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  FilterButton(text: 'All', isSelected: true, onPressed: () {}),
                  const SizedBox(width: 8),
                  FilterButton(text: 'Articles', isSelected: false, onPressed: () {}),
                  const SizedBox(width: 8),
                  FilterButton(text: 'Exercises', isSelected: false, onPressed: () {}),
                  const SizedBox(width: 8),
                  FilterButton(text: 'Audio', isSelected: false, onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Coming Soon Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.library_books,
                      size: 40,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Resources Coming Soon',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We\'re working on bringing you helpful articles, exercises, and audio resources to support your mental health journey.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Categories Section
            const Text(
              'Resource Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16.0),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                CategoryButton(
                  icon: Icons.article,
                  text: 'Articles & Guides',
                  color: const Color(0xFFE91E63),
                  onPressed: () => _showComingSoon(context),
                ),
                CategoryButton(
                  icon: Icons.fitness_center,
                  text: 'Exercises & Activities',
                  color: const Color(0xFF9C27B0),
                  onPressed: () => _showComingSoon(context),
                ),
                CategoryButton(
                  icon: Icons.headset,
                  text: 'Audio & Video',
                  color: const Color(0xFF2196F3),
                  onPressed: () => _showComingSoon(context),
                ),
                CategoryButton(
                  icon: Icons.book,
                  text: 'Recommended Readings',
                  color: const Color(0xFF4CAF50),
                  onPressed: () => _showComingSoon(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        backgroundColor: Color(0xFFE91E63),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFE91E63) : Colors.white,
        foregroundColor: isSelected ? Colors.white : const Color(0xFFE91E63),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: isSelected ? 2 : 0,
        side: isSelected ? null : BorderSide(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
