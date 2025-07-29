import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      appBar: AppBar(
        title: const Text('Feedback'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Provide Feedback',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),

            // Feedback Text Area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _feedbackController,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Write your feedback...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Submit Button
            ElevatedButton(
              onPressed: _feedbackController.text.trim().isNotEmpty
                ? () {
                    // TODO: Implement feedback submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feedback submitted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63), // Pink button
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Submit',
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
    );
  }
} 