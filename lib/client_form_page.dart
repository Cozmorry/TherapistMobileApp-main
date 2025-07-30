import 'package:flutter/material.dart';
import 'package:therapair/booking_page.dart';
import 'package:provider/provider.dart';
import 'package:therapair/providers/auth_provider.dart';
import 'package:therapair/services/firebase_service.dart';

class ClientFormPage extends StatefulWidget {
  const ClientFormPage({super.key});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  String? selectedApproach;
  String? selectedCommunicationStyle;
  String? selectedTherapyNeeds;

  final List<String> therapeuticApproaches = [
    'Cognitive Behavioral Therapy (CBT)',
    'Psychodynamic Therapy',
    'Dialectical Behavior Therapy (DBT)',
    'Humanistic Therapy',
    'Mindfulness-Based Therapy',
    'Family Therapy',
    'Group Therapy',
    'Other'
  ];

  final List<String> communicationStyles = [
    'Direct and Solution-Focused',
    'Gentle and Supportive',
    'Analytical and Insight-Oriented',
    'Collaborative and Interactive',
    'Structured and Goal-Oriented',
    'Flexible and Adaptive'
  ];

  final List<String> therapyNeeds = [
    'Anxiety and Stress Management',
    'Depression and Mood Disorders',
    'Relationship Issues',
    'Trauma and PTSD',
    'Self-Esteem and Confidence',
    'Life Transitions',
    'Grief and Loss',
    'Addiction Recovery',
    'Work-Life Balance',
    'Personal Growth'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      appBar: AppBar(
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
              'Client Form',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please provide your preferences to help us find the best therapist for you',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            // Therapeutic Approach Section
            const Text(
              'Therapeutic Approach',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedApproach,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  hintText: 'Select your preferred approach',
                ),
                items: therapeuticApproaches.map((String approach) {
                  return DropdownMenuItem<String>(
                    value: approach,
                    child: Text(approach),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedApproach = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),

            // Communication Style Section
            const Text(
              'Communication Style',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedCommunicationStyle,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  hintText: 'Select your preferred communication style',
                ),
                items: communicationStyles.map((String style) {
                  return DropdownMenuItem<String>(
                    value: style,
                    child: Text(style),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCommunicationStyle = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),

            // Therapy Needs Section
            const Text(
              'Therapy Needs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedTherapyNeeds,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  hintText: 'Select your primary therapy need',
                ),
                items: therapyNeeds.map((String need) {
                  return DropdownMenuItem<String>(
                    value: need,
                    child: Text(need),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTherapyNeeds = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 50),

                         // Find My Therapist Button
             ElevatedButton(
               onPressed: () async {
                 // Save client preferences to Firestore
                 try {
                   final authProvider = Provider.of<AuthProvider>(context, listen: false);
                   if (authProvider.user != null) {
                     await FirebaseService.updateUserProfile(authProvider.user!.uid, {
                       'therapeuticApproach': selectedApproach,
                       'communicationStyle': selectedCommunicationStyle,
                       'therapyNeeds': selectedTherapyNeeds,
                       'onboardingCompleted': true,
                     });
                   }
                   
                   // Navigate to booking page with preferences
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const BookingPage()),
                   );
                 } catch (e) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text('Failed to save preferences: $e'),
                       backgroundColor: Colors.red,
                     ),
                   );
                 }
               },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63), // Pink button
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Find My Therapist',
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