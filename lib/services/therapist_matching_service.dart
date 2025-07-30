import 'package:therapair/services/local_storage_service.dart';

class TherapistMatchingService {
  static List<Map<String, dynamic>> findMatchingTherapists({
    required Map<String, dynamic> clientPreferences,
    double minMatchPercentage = 50.0,
  }) {
    try {
      final allTherapists = LocalStorageService.getAllTherapists();
      print('TherapistMatchingService: Found ${allTherapists.length} therapists to evaluate');
      
      if (allTherapists.isEmpty) {
        print('TherapistMatchingService: No therapists available');
        return [];
      }
      
      final List<Map<String, dynamic>> matchingTherapists = [];
      
      for (final therapist in allTherapists) {
        final matchPercentage = _calculateMatchPercentage(clientPreferences, therapist);
        
        if (matchPercentage >= minMatchPercentage) {
          final therapistWithMatch = Map<String, dynamic>.from(therapist);
          therapistWithMatch['matchPercentage'] = matchPercentage;
          matchingTherapists.add(therapistWithMatch);
        }
      }
      
      // Sort by match percentage (highest first)
      matchingTherapists.sort((a, b) => 
        (b['matchPercentage'] as double).compareTo(a['matchPercentage'] as double)
      );
      
      print('TherapistMatchingService: Found ${matchingTherapists.length} matching therapists');
      return matchingTherapists;
    } catch (e) {
      print('TherapistMatchingService: Error finding matching therapists: $e');
      return [];
    }
  }
  
  static double _calculateMatchPercentage(
    Map<String, dynamic> clientPreferences,
    Map<String, dynamic> therapistData,
  ) {
    double totalScore = 0.0;
    int totalCriteria = 0;
    
    // 1. Therapeutic Approach Match (30% weight)
    if (clientPreferences['therapeuticApproach'] != null && 
        therapistData['therapeuticApproach'] != null) {
      final clientApproach = clientPreferences['therapeuticApproach'] as String;
      final therapistApproach = therapistData['therapeuticApproach'] as String;
      
      if (clientApproach == therapistApproach) {
        totalScore += 30.0;
      } else {
        // Partial match for similar approaches
        final similarity = _calculateApproachSimilarity(clientApproach, therapistApproach);
        totalScore += 30.0 * similarity;
      }
      totalCriteria++;
    }
    
    // 2. Communication Style Match (25% weight)
    if (clientPreferences['communicationStyle'] != null && 
        therapistData['communicationStyle'] != null) {
      final clientStyle = clientPreferences['communicationStyle'] as String;
      final therapistStyle = therapistData['communicationStyle'] as String;
      
      if (clientStyle == therapistStyle) {
        totalScore += 25.0;
      } else {
        // Partial match for compatible styles
        final similarity = _calculateCommunicationSimilarity(clientStyle, therapistStyle);
        totalScore += 25.0 * similarity;
      }
      totalCriteria++;
    }
    
    // 3. Therapy Needs vs Specialization Match (25% weight)
    if (clientPreferences['therapyNeeds'] != null && 
        therapistData['specialization'] != null) {
      final clientNeeds = clientPreferences['therapyNeeds'] as String;
      final therapistSpecialization = therapistData['specialization'] as String;
      
      if (clientNeeds == therapistSpecialization) {
        totalScore += 25.0;
      } else {
        // Partial match for related specializations
        final similarity = _calculateSpecializationSimilarity(clientNeeds, therapistSpecialization);
        totalScore += 25.0 * similarity;
      }
      totalCriteria++;
    }
    
    // 4. Therapy Type Match (20% weight)
    if (clientPreferences['therapyType'] != null && 
        therapistData['sessionType'] != null) {
      final clientType = clientPreferences['therapyType'] as String;
      final therapistType = therapistData['sessionType'] as String;
      
      if (clientType == therapistType) {
        totalScore += 20.0;
      } else {
        // Partial match for compatible types
        final similarity = _calculateTypeSimilarity(clientType, therapistType);
        totalScore += 20.0 * similarity;
      }
      totalCriteria++;
    }
    
    // Calculate final percentage
    final matchPercentage = totalCriteria > 0 ? totalScore : 0.0;
    
    print('TherapistMatchingService: Match calculation - Score: $totalScore, Criteria: $totalCriteria, Percentage: $matchPercentage%');
    
    return matchPercentage;
  }
  
  static double _calculateApproachSimilarity(String clientApproach, String therapistApproach) {
    // Define approach groups for partial matching
    final approachGroups = {
      'cognitive': ['Cognitive Behavioral Therapy (CBT)', 'Dialectical Behavior Therapy (DBT)'],
      'humanistic': ['Humanistic Therapy', 'Acceptance and Commitment Therapy (ACT)'],
      'psychodynamic': ['Psychodynamic Therapy', 'Interpersonal Therapy'],
      'mindfulness': ['Mindfulness-Based Therapy', 'Acceptance and Commitment Therapy (ACT)'],
      'solution': ['Solution-Focused Therapy', 'Narrative Therapy'],
      'trauma': ['Trauma-Informed Therapy', 'Dialectical Behavior Therapy (DBT)'],
    };
    
    // Check if approaches are in the same group
    for (final group in approachGroups.values) {
      if (group.contains(clientApproach) && group.contains(therapistApproach)) {
        return 0.8; // 80% similarity for same group
      }
    }
    
    return 0.0; // No similarity
  }
  
  static double _calculateCommunicationSimilarity(String clientStyle, String therapistStyle) {
    // Define compatible communication style pairs
    final compatiblePairs = [
      ['Direct and Clear', 'Professional and Clinical'],
      ['Gentle and Supportive', 'Warm and Personal'],
      ['Structured and Goal-Oriented', 'Educational and Informative'],
      ['Flexible and Adaptive', 'Empathetic and Understanding'],
      ['Empathetic and Understanding', 'Gentle and Supportive'],
      ['Professional and Clinical', 'Direct and Clear'],
      ['Warm and Personal', 'Gentle and Supportive'],
      ['Educational and Informative', 'Structured and Goal-Oriented'],
    ];
    
    for (final pair in compatiblePairs) {
      if (pair.contains(clientStyle) && pair.contains(therapistStyle)) {
        return 0.9; // 90% similarity for compatible styles
      }
    }
    
    return 0.0; // No similarity
  }
  
  static double _calculateSpecializationSimilarity(String clientNeeds, String therapistSpecialization) {
    // Define related specialization groups
    final specializationGroups = {
      'anxiety': ['Anxiety and Stress Management', 'Work and Career Stress'],
      'mood': ['Depression and Mood Disorders', 'Self-Esteem and Confidence'],
      'trauma': ['Trauma and PTSD', 'Crisis Intervention'],
      'relationships': ['Relationship Issues', 'Family Conflicts'],
      'life': ['Life Transitions', 'Personal Growth'],
      'behavioral': ['Anger Management', 'Addiction and Recovery'],
      'health': ['Eating Disorders', 'Sleep Problems'],
      'grief': ['Grief and Loss', 'Crisis Intervention'],
    };
    
    // Check if needs and specialization are in the same group
    for (final group in specializationGroups.values) {
      if (group.contains(clientNeeds) && group.contains(therapistSpecialization)) {
        return 0.85; // 85% similarity for same group
      }
    }
    
    return 0.0; // No similarity
  }
  
  static double _calculateTypeSimilarity(String clientType, String therapistType) {
    // Define compatible therapy type pairs
    final compatibleTypes = [
      ['Individual Therapy', 'Individual Therapy'],
      ['Couples Therapy', 'Couples Therapy'],
      ['Family Therapy', 'Family Therapy'],
      ['Group Therapy', 'Group Therapy'],
      ['Online Therapy', 'Online Therapy'],
      ['Individual Therapy', 'Online Therapy'], // Online can be individual
      ['Couples Therapy', 'Individual Therapy'], // Some therapists do both
      ['Family Therapy', 'Individual Therapy'], // Some therapists do both
    ];
    
    for (final pair in compatibleTypes) {
      if (pair.contains(clientType) && pair.contains(therapistType)) {
        return 1.0; // 100% similarity for exact or compatible types
      }
    }
    
    return 0.0; // No similarity
  }
  
  static String getMatchDescription(double matchPercentage) {
    if (matchPercentage >= 90) {
      return 'Excellent Match';
    } else if (matchPercentage >= 80) {
      return 'Very Good Match';
    } else if (matchPercentage >= 70) {
      return 'Good Match';
    } else if (matchPercentage >= 60) {
      return 'Fair Match';
    } else if (matchPercentage >= 50) {
      return 'Basic Match';
    } else {
      return 'Low Match';
    }
  }
  
  static String getMatchColor(double matchPercentage) {
    if (matchPercentage >= 80) {
      return '#4CAF50'; // Green
    } else if (matchPercentage >= 60) {
      return '#FF9800'; // Orange
    } else {
      return '#F44336'; // Red
    }
  }
} 