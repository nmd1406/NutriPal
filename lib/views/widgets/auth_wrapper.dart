import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/services/auth_service.dart';
import 'package:nutripal/views/screens/home_screen.dart';
import 'package:nutripal/views/screens/onboarding_screen.dart';
import 'package:nutripal/views/screens/profile_setup_screen.dart';
import 'package:nutripal/views/screens/splash_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        final user = snapshot.data;

        if (user == null) {
          return const OnboardingScreen();
        }

        return FutureBuilder<bool>(
          future: AuthService().hasProfile(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            bool hasProfile = snapshot.data ?? false;
            return hasProfile ? const HomeScreen() : const ProfileSetupScreen();
          },
        );
      },
    );
  }
}
