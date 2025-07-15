import 'package:flutter/material.dart';
import 'package:nutripal/views/screens/onboarding.dart';

void main() {
  runApp(const NutriPal());
}

class NutriPal extends StatelessWidget {
  const NutriPal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriPal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF92A3FD, {
          50: Color(0xFFE8ECFE),
          100: Color(0xFFD1D9FD),
          200: Color(0xFFB9C6FC),
          300: Color(0xFFA2B3FB),
          400: Color(0xFF9AA9FA),
          500: Color(0xFF92A3FD), // Primary color
          600: Color(0xFF7B8EFC),
          700: Color(0xFF6479FB),
          800: Color(0xFF4D64FA),
          900: Color(0xFF364FF9),
        }),
        primaryColor: Color(0xFF92A3FD), // Brand color
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF92A3FD),
          secondary: Color(0xFFC58BF2), // Secondary color
        ),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}
