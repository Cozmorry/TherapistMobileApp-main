import 'package:flutter/material.dart';
import 'article_detail_page.dart';

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
                    'Mental Health Resources',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore articles, exercises, and recommended readings to support your mental health journey. Audio and video resources coming soon!',
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
                  onPressed: () => _showArticles(context),
                ),
                CategoryButton(
                  icon: Icons.fitness_center,
                  text: 'Exercises & Activities',
                  color: const Color(0xFF9C27B0),
                  onPressed: () => _showExercises(context),
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
                  onPressed: () => _showBooks(context),
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

  void _showArticles(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Articles & Guides'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailPage(
                          article: {
                            'title': 'Understanding Anxiety: A Complete Guide',
                            'excerpt': 'Learn about different types of anxiety, their symptoms, and effective coping strategies.',
                            'category': 'anxiety',
                            'readTime': 8,
                            'content': 'Anxiety is a natural response to stress, but when it becomes overwhelming, it can significantly impact your daily life. This comprehensive guide covers the various types of anxiety disorders, common symptoms, and evidence-based strategies for managing anxiety effectively. From breathing exercises to cognitive behavioral techniques, discover practical tools to help you navigate anxious thoughts and feelings.\n\nUnderstanding the different types of anxiety disorders is crucial for effective management. Generalized Anxiety Disorder (GAD) involves persistent worry about everyday situations, while Panic Disorder is characterized by sudden, intense episodes of fear. Social Anxiety Disorder causes extreme fear of social situations, and Specific Phobias involve intense fear of particular objects or situations.\n\nCommon symptoms of anxiety include rapid heartbeat, sweating, trembling, shortness of breath, and difficulty concentrating. Physical symptoms often accompany psychological symptoms like excessive worry, restlessness, and irritability. Recognizing these symptoms is the first step toward effective management.\n\nEvidence-based strategies for managing anxiety include cognitive behavioral therapy (CBT), which helps identify and challenge negative thought patterns. Relaxation techniques such as deep breathing, progressive muscle relaxation, and mindfulness meditation can help calm the nervous system. Regular exercise, adequate sleep, and a balanced diet also play crucial roles in anxiety management.\n\nBuilding a support network and seeking professional help when needed are essential components of anxiety management. Remember that anxiety is treatable, and with the right tools and support, you can learn to manage it effectively and improve your quality of life.',
                          },
                        ),
                      ),
                    );
                  },
                  child: _buildArticleCard({
                    'title': 'Understanding Anxiety: A Complete Guide',
                    'excerpt': 'Learn about different types of anxiety, their symptoms, and effective coping strategies.',
                    'category': 'anxiety',
                    'readTime': 8,
                    'content': 'Anxiety is a natural response to stress, but when it becomes overwhelming, it can significantly impact your daily life. This comprehensive guide covers the various types of anxiety disorders, common symptoms, and evidence-based strategies for managing anxiety effectively.',
                  }),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailPage(
                          article: {
                            'title': 'Mindfulness Meditation for Beginners',
                            'excerpt': 'Start your mindfulness journey with simple meditation techniques and daily practices.',
                            'category': 'mindfulness',
                            'readTime': 6,
                            'content': 'Mindfulness meditation is a powerful tool for reducing stress and improving mental clarity. This beginner-friendly guide introduces you to the fundamentals of mindfulness, including breathing techniques, body scans, and daily meditation practices. Learn how to incorporate mindfulness into your routine and experience the benefits of present-moment awareness.\n\nMindfulness is the practice of paying attention to the present moment without judgment. It involves observing your thoughts, feelings, and sensations as they arise, without getting caught up in them. This practice helps you develop a greater awareness of your inner experiences and the world around you.\n\nGetting started with mindfulness meditation is simple. Find a quiet, comfortable place where you won\'t be disturbed. Sit in a comfortable position with your back straight but not rigid. Close your eyes or soften your gaze. Begin by focusing on your breath, noticing the sensation of each inhale and exhale.\n\nWhen your mind wanders (which it will), gently bring your attention back to your breath without judgment. This is normal and expected. The key is to notice when your mind has wandered and gently return to your breath. With practice, you\'ll find it easier to maintain focus.\n\nIncorporate mindfulness into your daily routine by practicing for just 5-10 minutes each day. You can also practice mindfulness during everyday activities like eating, walking, or washing dishes. Pay attention to the sensations, sounds, and experiences of each moment.\n\nThe benefits of mindfulness meditation include reduced stress and anxiety, improved focus and concentration, better emotional regulation, and increased self-awareness. Regular practice can also help improve sleep quality and overall well-being.',
                          },
                        ),
                      ),
                    );
                  },
                  child: _buildArticleCard({
                    'title': 'Mindfulness Meditation for Beginners',
                    'excerpt': 'Start your mindfulness journey with simple meditation techniques and daily practices.',
                    'category': 'mindfulness',
                    'readTime': 6,
                    'content': 'Mindfulness meditation is a powerful tool for reducing stress and improving mental clarity. This beginner-friendly guide introduces you to the fundamentals of mindfulness.',
                  }),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailPage(
                          article: {
                            'title': 'Building Healthy Relationships',
                            'excerpt': 'Explore communication skills, boundaries, and strategies for maintaining healthy relationships.',
                            'category': 'relationships',
                            'readTime': 10,
                            'content': 'Healthy relationships are fundamental to our well-being. This guide explores essential communication skills, setting and maintaining boundaries, conflict resolution strategies, and building trust. Whether with family, friends, or romantic partners, learn how to create and nurture meaningful connections that support your mental health.\n\nEffective communication is the foundation of healthy relationships. This involves both speaking and listening with intention. When communicating, use "I" statements to express your feelings and needs without blaming others. For example, say "I feel hurt when..." instead of "You always..."\n\nActive listening is equally important. Give your full attention to the speaker, maintain eye contact, and avoid interrupting. Reflect back what you hear to ensure understanding. Ask clarifying questions when needed.\n\nSetting and maintaining boundaries is crucial for healthy relationships. Boundaries define what is acceptable and what is not in your relationships. They help protect your emotional and physical well-being while respecting others\' needs. Communicate your boundaries clearly and respectfully.\n\nConflict is a natural part of any relationship. Healthy conflict resolution involves addressing issues directly, focusing on the problem rather than the person, and working together to find solutions. Avoid using hurtful language or bringing up past issues.\n\nBuilding trust takes time and consistency. Be reliable, keep your promises, and be honest in your communications. Trust is built through small actions over time, not grand gestures.\n\nRemember that healthy relationships require effort from both parties. They involve mutual respect, understanding, and a willingness to grow together. Don\'t be afraid to seek professional help if you\'re struggling with relationship issues.',
                          },
                        ),
                      ),
                    );
                  },
                  child: _buildArticleCard({
                    'title': 'Building Healthy Relationships',
                    'excerpt': 'Explore communication skills, boundaries, and strategies for maintaining healthy relationships.',
                    'category': 'relationships',
                    'readTime': 10,
                    'content': 'Healthy relationships are fundamental to our well-being. This guide explores essential communication skills, setting and maintaining boundaries.',
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showExercises(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exercises & Activities'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildExerciseCard({
                  'title': 'Progressive Muscle Relaxation',
                  'description': 'A step-by-step guide to releasing physical tension and reducing stress.',
                  'duration': '10-15 minutes',
                  'difficulty': 'Beginner',
                  'instructions': 'Find a comfortable position and systematically tense and relax each muscle group. Start with your toes and work your way up to your head.',
                }),
                _buildExerciseCard({
                  'title': 'Gratitude Journaling',
                  'description': 'Daily practice to cultivate positive thinking and improve mental well-being.',
                  'duration': '5-10 minutes',
                  'difficulty': 'Beginner',
                  'instructions': 'Set aside time each day to write down three things you\'re grateful for. Be specific and reflect on why each item brings you joy.',
                }),
                _buildExerciseCard({
                  'title': 'Deep Breathing Exercise',
                  'description': 'Simple breathing technique to calm your nervous system and reduce anxiety.',
                  'duration': '5 minutes',
                  'difficulty': 'Beginner',
                  'instructions': 'Sit comfortably and place one hand on your chest, the other on your belly. Breathe in slowly through your nose for 4 counts.',
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showBooks(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recommended Readings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBookCard({
                  'title': 'The Anxiety and Phobia Workbook',
                  'author': 'Edmund J. Bourne',
                  'description': 'A comprehensive self-help guide with practical exercises for managing anxiety.',
                  'rating': 4.5,
                }),
                _buildBookCard({
                  'title': 'Mindfulness in Plain English',
                  'author': 'Bhante Henepola Gunaratana',
                  'description': 'Clear and accessible introduction to mindfulness meditation practices.',
                  'rating': 4.7,
                }),
                _buildBookCard({
                  'title': 'The Body Keeps the Score',
                  'author': 'Bessel van der Kolk',
                  'description': 'Understanding trauma and its effects on the mind and body.',
                  'rating': 4.6,
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Art
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFE91E63).withOpacity(0.8),
                  const Color(0xFF9C27B0).withOpacity(0.8),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                _getArticleIcon(article['category']),
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          // Article Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(article['category']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article['category'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getCategoryColor(article['category']),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${article['readTime']} min read',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  article['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article['excerpt'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getArticleIcon(String category) {
    switch (category.toLowerCase()) {
      case 'anxiety':
        return Icons.psychology;
      case 'depression':
        return Icons.sentiment_dissatisfied;
      case 'stress':
        return Icons.trending_down;
      case 'mindfulness':
        return Icons.spa;
      case 'relationships':
        return Icons.favorite;
      case 'self-care':
        return Icons.healing;
      default:
        return Icons.article;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'anxiety':
        return Colors.orange;
      case 'depression':
        return Colors.blue;
      case 'stress':
        return Colors.red;
      case 'mindfulness':
        return Colors.green;
      case 'relationships':
        return Colors.pink;
      case 'self-care':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              exercise['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Duration: ${exercise['duration']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Difficulty: ${exercise['difficulty']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              exercise['instructions'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Author: ${book['author']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Rating: ${book['rating']}/5',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
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
