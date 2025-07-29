import 'package:flutter/material.dart';
import 'article_detail_page.dart'; // Import the article detail page

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      appBar: AppBar(
        title: const Text('Resources'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                hintText: 'Search resources',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),

            // Filter Buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FilterButton(text: 'All', onPressed: () { /* TODO: Implement filter */ }),
                  FilterButton(text: 'Articles', onPressed: () { /* TODO: Implement filter */ }),
                  FilterButton(text: 'Exercises', onPressed: () { /* TODO: Implement filter */ }),
                  FilterButton(text: 'Audio', onPressed: () { /* TODO: Implement filter */ }),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Featured Section
            const Text(
              'Featured',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ArticleDetailPage()),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Text(
                              'Article',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Understanding Your Emotions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Learn to identify and manage your feelings effectively.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300], // Placeholder for image
                        // TODO: Add image here
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Categories Section
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling
              children: <Widget>[
                CategoryButton(icon: Icons.article, text: 'Articles & Guides', onPressed: () { /* TODO: Implement action */ }),
                CategoryButton(icon: Icons.fitness_center, text: 'Exercises & Activities', onPressed: () { /* TODO: Implement action */ }),
                CategoryButton(icon: Icons.headset, text: 'Audio & Video', onPressed: () { /* TODO: Implement action */ }),
                CategoryButton(icon: Icons.book, text: 'Recommended Readings', onPressed: () { /* TODO: Implement action */ }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FilterButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add spacing between buttons
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100], // Light pink button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
        child: Text(text, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const CategoryButton({super.key, required this.icon, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40, color: Colors.blueAccent), // Example icon color
            const SizedBox(height: 8.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
