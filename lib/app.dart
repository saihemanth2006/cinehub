import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'features/auth/auth_provider.dart';

class CineHubApp extends StatelessWidget {
  const CineHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Poppins', fontFamilyFallback: const ['Fallback']),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isInitialized) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (authProvider.isAuthenticated) {
            return const MainScreen();
          }

          return LoginScreen(
            onLoggedIn: () {
              // This callback might not be strictly necessary anymore 
              // if Provider state change rebuilds the home.
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
            },
            onSignUpRequested: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignupScreen(onSignedUp: (ctx) {
                    Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
                  })));
            },
          );
        },
      ),
    );
  }
}
