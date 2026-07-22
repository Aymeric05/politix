import 'package:flutter/material.dart';

// Classe statique regroupant les couleurs et le thème de l'app
class AppTheme {
  // Couleurs associées à chaque orientation politique
  static const Color extremeGauche = Color(0xFFD32F2F);
  static const Color gauche = Color(0xFFEF5350);
  static const Color centre = Color(0xFFFFA726);
  static const Color droite = Color(0xFF42A5F5);
  static const Color extremeDroite = Color(0xFF1565C0);
  static const Color sansEtiquette = Color(0xFF9E9E9E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
