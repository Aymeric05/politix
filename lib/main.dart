import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PolitiqueFranceApp());
}

class PolitiqueFranceApp extends StatelessWidget {
  const PolitiqueFranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Politix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(), // écran de démarrage animé, puis redirige vers HomeScreen
    );
  }
}