import 'package:flutter/material.dart';

// Classe statique regroupant les couleurs et le thème de l'app
class AppTheme {
  // Couleurs flashy associées à chaque orientation politique
  static const Color extremeGauche = Color(0xFFE0304B);
  static const Color gauche = Color(0xFFFF5C7A);
  static const Color centre = Color(0xFFFFB020);
  static const Color droite = Color(0xFF3D8BFF);
  static const Color extremeDroite = Color(0xFF1C3FAA);
  static const Color sansEtiquette = Color(0xFF6E7681);

  // Dégradé bleu utilisé pour le logo "POLITIX"
  static const List<Color> politixGradient = [
    Color(0xFF3D8BFF),
    Color(0xFF6C5CE7),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      scaffoldBackgroundColor: const Color(0xFFF3F4F8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  // Renvoie un dégradé de couleur "flashy" à partir d'une couleur de base
  // (utilisé pour donner du relief aux cartes des orientations)
  static LinearGradient cardGradient(Color base) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [base, Color.lerp(base, Colors.black, 0.25)!],
    );
  }
}