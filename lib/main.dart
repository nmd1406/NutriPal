import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/firebase_options.dart';
import 'package:nutripal/views/widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(ProviderScope(child: const NutriPal()));
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
      home: const AuthWrapper(),
    );
  }
}
