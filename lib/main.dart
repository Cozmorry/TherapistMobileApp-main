import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:therapair/firebase_options.dart';
import 'package:therapair/providers/auth_provider.dart';
import 'package:therapair/widgets/main_layout.dart';
import 'package:therapair/welcome_page.dart'; // Import your WelcomePage
import 'package:therapair/role_selection_page.dart'; // Import RoleSelectionPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'TheraPair',
        debugShowCheckedModeBanner: false, // Remove debug banner
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isCheckingProfile = false;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated && authProvider.userProfile == null) {
      setState(() {
        _isCheckingProfile = true;
      });
      
      // Wait for profile to be loaded
      await authProvider.loadUserProfile();
      
      setState(() {
        _isCheckingProfile = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-check profile when dependencies change (like auth state)
    _checkProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print('AuthWrapper: Building with authProvider.isAuthenticated: ${authProvider.isAuthenticated}'); // Debug log
        print('AuthWrapper: Building with authProvider.userProfile: ${authProvider.userProfile}'); // Debug log
        print('AuthWrapper: Building with authProvider.user: ${authProvider.user?.uid}'); // Debug log
        
        if (authProvider.isLoading || _isCheckingProfile) {
          print('AuthWrapper: Showing loading indicator'); // Debug log
          return const Scaffold(
            backgroundColor: Color(0xFFFCE4EC),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE91E63),
              ),
            ),
          );
        }

        if (authProvider.isAuthenticated) {
          print('AuthWrapper: User is authenticated'); // Debug log
          print('AuthWrapper: User profile: ${authProvider.userProfile}'); // Debug log
          
          // For new Google users, always show role selection first
          if (authProvider.userProfile == null || 
              authProvider.userProfile!.isEmpty || 
              authProvider.userProfile!['role'] == null) {
            print('AuthWrapper: No role found, showing role selection'); // Debug log
            // User is authenticated but doesn't have a role, show role selection
            return const RoleSelectionPage();
          }
          print('AuthWrapper: Role found, navigating to main layout'); // Debug log
          // User is logged in and has a role, navigate to main layout
          // MainLayout will handle role checking and onboarding
          return const MainLayout(isTherapist: false);
        }

        print('AuthWrapper: User not authenticated, showing welcome page'); // Debug log
        // User is not logged in, show welcome page
        return const WelcomePage();
      },
    );
  }
}
