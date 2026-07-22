import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

// Point d'entrée : Flutter démarre toujours par la fonction main()
void main() {
  runApp(const PolitiqueFranceApp());
}

// Widget racine de l'application
class PolitiqueFranceApp extends StatelessWidget {
  const PolitiqueFranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Politique France',
      debugShowCheckedModeBanner: false, // enlève le bandeau "DEBUG"
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
