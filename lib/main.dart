import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:therapair/login_page.dart';
import 'package:therapair/widgets/main_layout.dart';
import 'package:therapair/services/auth_service.dart';
import 'package:therapair/services/local_storage_service.dart';
import 'package:therapair/role_selection_page.dart';
import 'package:therapair/client_onboarding_page.dart';
import 'package:therapair/therapist_home_page.dart';

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

        // User is authenticated - check if they have a role
        final hasRole = LocalStorageService.hasRole();
        final isOnboardingCompleted = LocalStorageService.isOnboardingCompleted();
        final currentUser = LocalStorageService.getCurrentUser();
        
        print('- Has role: $hasRole');
        print('- Is onboarding completed: $isOnboardingCompleted');
        print('- User role: ${LocalStorageService.getUserRole()}');
        print('- Is therapist: ${LocalStorageService.isTherapist()}');
        print('- Is client: ${LocalStorageService.isClient()}');
        print('- Local user: ${currentUser?.email ?? 'none'}');
        
        if (!hasRole) {
          // User needs to select a role
          print('Redirecting to role selection');
          return const RoleSelectionPage();
        } else if (LocalStorageService.isClient() && !isOnboardingCompleted) {
          // Client needs to complete onboarding
          print('Redirecting to client onboarding');
          return const ClientOnboardingPage();
        } else if (LocalStorageService.isTherapist()) {
          // Therapist goes to therapist dashboard
          print('Redirecting to therapist dashboard');
          return const TherapistHomePage();
        } else {
          // Client goes to main layout
          print('Redirecting to client main layout');
          return const MainLayout(isTherapist: false);
        }
      },
    );
  }
}
