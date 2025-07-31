import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:therapair/login_page.dart';
import 'package:therapair/widgets/main_layout.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/role_selection_page.dart';
import 'package:therapair/client_onboarding_page.dart';
import 'package:therapair/therapist_home_page.dart';
import 'package:therapair/therapist_onboarding_page.dart';
import 'package:therapair/models/user_model.dart';

// Global key to force app refresh
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    print('Main: Firebase initialized successfully');
    
    await LocalStorageService.init();
    await LocalStorageService.testStorage(); // Test storage functionality
    
    // Test Firebase connection
    final authService = AuthService();
    final firebaseConnected = await authService.testFirebaseConnection();
    print('Main: Firebase connection test result: $firebaseConnected');
    
  } catch (e) {
    print('Initialization error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheraPair',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Add navigator key for global navigation
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63)),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFCE4EC),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
            ),
          );
        }

        // If there's an error, show login page
        if (snapshot.hasError) {
          print('Auth error: ${snapshot.error}');
          return const LoginPage();
        }

        // Check if user is authenticated with Firebase
        final isFirebaseAuthenticated = snapshot.hasData && snapshot.data != null;
        final firebaseUser = snapshot.data;
        
        print('AuthWrapper Debug:');
        print('- Firebase authenticated: $isFirebaseAuthenticated');
        print('- Firebase user: ${firebaseUser?.email ?? 'none'}');
        print('- Firebase user UID: ${firebaseUser?.uid ?? 'none'}');
        
        // User is not authenticated with Firebase
        if (!isFirebaseAuthenticated) {
          print('User not authenticated - showing login page');
          return const LoginPage();
        }

        // User is authenticated - load their data by email
        final userEmail = firebaseUser!.email!;
        final userData = LocalStorageService.getUserDataByEmail(userEmail);
        final currentUserData = LocalStorageService.getCurrentUser();
        
        print('AuthWrapper Debug:');
        print('- Firebase authenticated: $isFirebaseAuthenticated');
        print('- Firebase user email: $userEmail');
        print('- Firebase user UID: ${firebaseUser.uid}');
        print('- User data found by email: ${userData != null}');
        print('- Current user data found: ${currentUserData != null}');
        
        // Check both storage locations
        UserModel? finalUserData = userData ?? currentUserData;
        
        if (finalUserData == null) {
          // New user - needs to select a role
          print('No user data found for $userEmail - redirecting to role selection');
          return const RoleSelectionPage();
        }
        
        print('- User role: ${finalUserData.role}');
        print('- Is onboarding completed: ${finalUserData.isOnboardingCompleted}');
        print('- Is therapist: ${finalUserData.isTherapist}');
        print('- Is client: ${finalUserData.isClient}');
        print('- User onboarding data: ${finalUserData.onboardingData}');
        
        // Check if user has completed role selection and onboarding
        final hasRole = finalUserData.role != null && finalUserData.role!.isNotEmpty;
        final isOnboardingCompleted = finalUserData.isOnboardingCompleted;
        
        if (!hasRole) {
          // User needs to select a role
          print('User has no role - redirecting to role selection');
          return const RoleSelectionPage();
        } else if (finalUserData.isClient && !isOnboardingCompleted) {
          // Client needs to complete onboarding
          print('Client needs onboarding - redirecting to client onboarding');
          return const ClientOnboardingPage();
        } else if (finalUserData.isTherapist && !isOnboardingCompleted) {
          // Therapist needs to complete onboarding
          print('Therapist needs onboarding - redirecting to therapist onboarding');
          return const TherapistOnboardingPage();
        } else if (finalUserData.isTherapist) {
          // Therapist goes to therapist dashboard
          print('Therapist onboarding completed - redirecting to therapist dashboard');
          return const TherapistHomePage();
        } else {
          // Client goes to main layout
          print('Client onboarding completed - redirecting to client main layout');
          return const MainLayout(isTherapist: false);
        }
      },
    );
  }
}
