import 'package:flutter/material.dart';
import 'package:therapair/widgets/main_layout.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/models/user_model.dart';

class ClientOnboardingPage extends StatefulWidget {
  const ClientOnboardingPage({super.key});

  @override
  State<ClientOnboardingPage> createState() => _ClientOnboardingPageState();
}

class _ClientOnboardingPageState extends State<ClientOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(); // Add username controller
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedGender = 'Prefer not to say';
  String _selectedTherapyType = 'Individual Therapy';
  String _selectedTherapeuticApproach = 'Cognitive Behavioral Therapy (CBT)';
  String _selectedCommunicationStyle = 'Direct and Clear';
  String _selectedTherapyNeeds = 'Anxiety and Stress Management';
  bool _isLoading = false;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  final List<String> _therapyTypes = [
    'Individual Therapy',
    'Couples Therapy',
    'Family Therapy',
    'Group Therapy',
    'Online Therapy',
  ];

  final List<String> _therapeuticApproaches = [
    'Cognitive Behavioral Therapy (CBT)',
    'Dialectical Behavior Therapy (DBT)',
    'Psychodynamic Therapy',
    'Humanistic Therapy',
    'Acceptance and Commitment Therapy (ACT)',
    'Mindfulness-Based Therapy',
    'Solution-Focused Therapy',
    'Trauma-Informed Therapy',
    'Interpersonal Therapy',
    'Narrative Therapy',
  ];

  final List<String> _communicationStyles = [
    'Direct and Clear',
    'Gentle and Supportive',
    'Structured and Goal-Oriented',
    'Flexible and Adaptive',
    'Empathetic and Understanding',
    'Professional and Clinical',
    'Warm and Personal',
    'Educational and Informative',
  ];

  final List<String> _therapyNeeds = [
    'Anxiety and Stress Management',
    'Depression and Mood Disorders',
    'Trauma and PTSD',
    'Relationship Issues',
    'Family Conflicts',
    'Grief and Loss',
    'Self-Esteem and Confidence',
    'Work and Career Stress',
    'Addiction and Recovery',
    'Eating Disorders',
    'Sleep Problems',
    'Anger Management',
    'Life Transitions',
    'Personal Growth',
    'Crisis Intervention',
  ];

  @override
  void dispose() {
    _usernameController.dispose(); // Dispose username controller
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This helps us match you with the right therapist',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              
              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Choose a unique username',
                  prefixIcon: const Icon(Icons.alternate_email, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (value.length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                    return 'Username can only contain letters, numbers, and underscores';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Age Field
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                  prefixIcon: const Icon(Icons.cake, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 13 || age > 120) {
                    return 'Please enter a valid age (13-120)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(
                      gender,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE91E63)),
              ),
              const SizedBox(height: 20),
              
              // Phone Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Therapy Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTherapyType,
                decoration: InputDecoration(
                  labelText: 'Preferred Therapy Type',
                  prefixIcon: const Icon(Icons.psychology, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _therapyTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTherapyType = newValue!;
                  });
                },
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE91E63)),
              ),
              const SizedBox(height: 20),
              
              // Therapeutic Approach Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTherapeuticApproach,
                decoration: InputDecoration(
                  labelText: 'Preferred Therapeutic Approach',
                  prefixIcon: const Icon(Icons.healing, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _therapeuticApproaches.map((String approach) {
                  return DropdownMenuItem<String>(
                    value: approach,
                    child: Text(
                      approach,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTherapeuticApproach = newValue!;
                  });
                },
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE91E63)),
              ),
              const SizedBox(height: 20),
              
              // Communication Style Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCommunicationStyle,
                decoration: InputDecoration(
                  labelText: 'Preferred Communication Style',
                  prefixIcon: const Icon(Icons.chat, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _communicationStyles.map((String style) {
                  return DropdownMenuItem<String>(
                    value: style,
                    child: Text(
                      style,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCommunicationStyle = newValue!;
                  });
                },
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE91E63)),
              ),
              const SizedBox(height: 20),
              
              // Therapy Needs Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTherapyNeeds,
                decoration: InputDecoration(
                  labelText: 'Primary Therapy Needs',
                  prefixIcon: const Icon(Icons.favorite, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _therapyNeeds.map((String need) {
                  return DropdownMenuItem<String>(
                    value: need,
                    child: Text(
                      need,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTherapyNeeds = newValue!;
                  });
                },
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE91E63)),
              ),
              const SizedBox(height: 40),
              
              // Complete Profile Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Complete Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user from Firebase
      final currentUser = AuthService().currentUser;
      if (currentUser == null) {
        print('ClientOnboardingPage: No current user found');
        return;
      }
      
      final userEmail = currentUser.email!;
      print('ClientOnboardingPage: Completing onboarding for user: $userEmail');
      
      // Load existing user data
      var userData = LocalStorageService.getUserDataByEmail(userEmail);
      if (userData == null) {
        print('ClientOnboardingPage: No user data found for $userEmail, creating new');
        userData = UserModel.fromFirebaseUser(currentUser);
      }
      
      // Save onboarding data
      final onboardingData = {
        'username': _usernameController.text,
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'gender': _selectedGender,
        'phone': _phoneController.text,
        'therapyType': _selectedTherapyType,
        'therapeuticApproach': _selectedTherapeuticApproach,
        'communicationStyle': _selectedCommunicationStyle,
        'therapyNeeds': _selectedTherapyNeeds,
        'completedAt': DateTime.now().toIso8601String(),
      };
      
      // Update user data
      userData.completeOnboarding(onboardingData);
      userData.username = _usernameController.text;
      
      // Save user data by email
      await LocalStorageService.saveUserDataByEmail(userEmail, userData);
      await LocalStorageService.saveCurrentUser(userData); // For backward compatibility
      
      print('ClientOnboardingPage: Onboarding completed successfully for $userEmail');
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainLayout(isTherapist: false),
          ),
        );
      }
    } catch (e) {
      print('ClientOnboardingPage: Error completing onboarding: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing onboarding: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 