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
      home: const OnboardingScreen(),
    );
  }
}
