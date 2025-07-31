
import 'package:flutter/material.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Resources'), // App bar title as seen in the image
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.bookmark_border), // Bookmark icon
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'The Power of Mindfulness in Daily Life', // Article Title
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'By Dr. Amelia Harper | Published on July 15, 2024', // Author and date
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 200, // Placeholder height for the image
                color: Colors.grey[300], // Placeholder color for the image
                // TODO: Add article main image here
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Mindfulness, the practice of paying attention to the present moment without judgment, has gained significant attention for its potential to enhance mental well-being. This article explores how incorporating mindfulness into your daily routine can reduce stress, improve focus, and foster a greater sense of calm and contentment.', // Placeholder article text
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),

              // Understanding Mindfulness Section
              const Text(
                'Understanding Mindfulness',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Mindfulness involves observing your thoughts, feelings, and sensations without getting carried away by them. Its about being fully present in whatever youre doing, whether its eating, walking, or interacting with others. This practice helps you become more aware of your inner experiences and the world around you, allowing you to respond more thoughtfully rather than react impulsively.', // Placeholder text
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),

              // Benefits of Mindfulness Section
              const Text(
                'Benefits of Mindfulness',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Column(
                children: <Widget>[
                  BenefitItem(text: 'Stress Reduction'),
                  BenefitItem(text: 'Improved Focus'),
                  BenefitItem(text: 'Emotional Regulation'),
                  BenefitItem(text: 'Increased Self-Awareness'),
                ],
              ),
              const SizedBox(height: 16.0),

              // Practical Mindfulness Exercises Section
              const Text(
                'Practical Mindfulness Exercises',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Column(
                children: <Widget>[
                  ExerciseItem(
                    text: 'Mindful Breathing Focus on your breath, noticing the sensation of each inhale and exhale.',
                    icon: Icons.timer,
                  ),
                  ExerciseItem(
                    text: 'Mindful Eating Pay attention to the taste, texture, and smell of your food without distractions.',
                    icon: Icons.timer,
                  ),
                  ExerciseItem(
                    text: 'Mindful Walking Engage all your senses while walking, noticing the sights, sounds, and sensations.',
                    icon: Icons.timer,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Integrating Mindfulness into Your Day Section
              const Text(
                'Integrating Mindfulness into Your Day',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Start small by incorporating a few minutes of mindfulness each day and gradually increase the duration as you become more comfortable. Consistency is key to experiencing the long-term benefits of mindfulness. Remember, mindfulness is a practice, and its okay if your mind wanders. Simply redirect your attention back to the present moment with kindness and patience.', // Placeholder text
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),

              // Related Resources Section
              const Text(
                'Related Resources',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Column(
                children: <Widget>[
                  RelatedResourceItem(
                    text: 'Anxiety Management Strategies Techniques for managing anxiety and promoting relaxation.',
                    icon: Icons.article,
                  ),
                  RelatedResourceItem(
                    text: 'Building Resilience and Positivity Tips for cultivating a positive mindset and enhancing overall well-being.',
                    icon: Icons.article,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BenefitItem extends StatelessWidget {
  final String text;

  const BenefitItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.check_box, color: Colors.blueAccent), // Checkbox icon
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseItem extends StatelessWidget {
  final String text;
  final IconData icon;

  const ExerciseItem({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 30, color: Colors.blueAccent), // Icon
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RelatedResourceItem extends StatelessWidget {
  final String text;
  final IconData icon;

  const RelatedResourceItem({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 30, color: Colors.blueAccent), // Icon
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
