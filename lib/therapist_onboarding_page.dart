import 'package:flutter/material.dart';
import 'package:therapair/therapist_home_page.dart';
import 'package:therapair/services/local_storage_service.dart';

class TherapistOnboardingPage extends StatefulWidget {
  const TherapistOnboardingPage({super.key});

  @override
  State<TherapistOnboardingPage> createState() => _TherapistOnboardingPageState();
}

class _TherapistOnboardingPageState extends State<TherapistOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _licenseController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();
  
  String _selectedGender = 'Prefer not to say';
  String _selectedTherapeuticApproach = 'Cognitive Behavioral Therapy (CBT)';
  String _selectedCommunicationStyle = 'Direct and Clear';
  String _selectedSpecialization = 'Anxiety and Stress Management';
  String _selectedSessionType = 'Individual Therapy';
  String _selectedExperienceLevel = '3-5 years';
  bool _isLoading = false;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
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

  final List<String> _specializations = [
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

  final List<String> _sessionTypes = [
    'Individual Therapy',
    'Couples Therapy',
    'Family Therapy',
    'Group Therapy',
    'Online Therapy',
  ];

  final List<String> _experienceLevels = [
    '1-2 years',
    '3-5 years',
    '6-10 years',
    '11-15 years',
    '15+ years',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _licenseController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
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
                'Tell us about your practice',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This helps clients find the right therapist for their needs',
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
                  labelText: 'Professional Username',
                  hintText: 'Choose a professional username',
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
              
              // License Field
              TextFormField(
                controller: _licenseController,
                decoration: InputDecoration(
                  labelText: 'License Number',
                  hintText: 'Enter your professional license number',
                  prefixIcon: const Icon(Icons.verified, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your license number';
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
              
              // Experience Level Dropdown
              DropdownButtonFormField<String>(
                value: _selectedExperienceLevel,
                decoration: InputDecoration(
                  labelText: 'Years of Experience',
                  prefixIcon: const Icon(Icons.work, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _experienceLevels.map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(
                      level,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedExperienceLevel = newValue!;
                  });
                },
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE91E63)),
              ),
              const SizedBox(height: 20),
              
              // Session Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSessionType,
                decoration: InputDecoration(
                  labelText: 'Session Types Offered',
                  prefixIcon: const Icon(Icons.psychology, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _sessionTypes.map((String type) {
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
                    _selectedSessionType = newValue!;
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
                  labelText: 'Primary Therapeutic Approach',
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
                  labelText: 'Communication Style',
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
              
              // Specialization Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSpecialization,
                decoration: InputDecoration(
                  labelText: 'Primary Specialization',
                  prefixIcon: const Icon(Icons.favorite, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _specializations.map((String specialization) {
                  return DropdownMenuItem<String>(
                    value: specialization,
                    child: Text(
                      specialization,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSpecialization = newValue!;
                  });
                },
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE91E63)),
              ),
              const SizedBox(height: 20),
              
              // Bio Field
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Professional Bio',
                  hintText: 'Tell clients about your approach and experience...',
                  prefixIcon: const Icon(Icons.description, color: Color(0xFFE91E63)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your professional bio';
                  }
                  if (value.length < 50) {
                    return 'Bio must be at least 50 characters';
                  }
                  return null;
                },
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
      // Save therapist onboarding data to local storage
      final onboardingData = {
        'username': _usernameController.text,
        'name': _nameController.text,
        'license': _licenseController.text,
        'gender': _selectedGender,
        'experienceLevel': _selectedExperienceLevel,
        'sessionType': _selectedSessionType,
        'therapeuticApproach': _selectedTherapeuticApproach,
        'communicationStyle': _selectedCommunicationStyle,
        'specialization': _selectedSpecialization,
        'bio': _bioController.text,
        'completedAt': DateTime.now().toIso8601String(),
      };
      
      await LocalStorageService.completeUserOnboarding(onboardingData);
      
      // Add therapist to the global therapists list for matching
      await LocalStorageService.addTherapistToList(onboardingData);
      
      // Update user's username in the user model
      final currentUser = LocalStorageService.getCurrentUser();
      if (currentUser != null) {
        currentUser.username = _usernameController.text;
        await LocalStorageService.saveCurrentUser(currentUser);
      }
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TherapistHomePage(),
          ),
        );
      }
    } catch (e) {
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