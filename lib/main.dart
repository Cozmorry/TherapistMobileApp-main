import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:therapair/firebase_options.dart';
import 'package:therapair/providers/auth_provider.dart';
import 'package:therapair/widgets/main_layout.dart';
import 'package:therapair/welcome_page.dart'; // Import your WelcomePage

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

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
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
          // User is logged in, navigate to main layout based on role
          return MainLayout(isTherapist: authProvider.userRole == 'therapist');
        }

        // User is not logged in, show welcome page
        return const WelcomePage();
      },
    );
  }
}
