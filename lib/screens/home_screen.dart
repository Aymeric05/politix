import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/orientation_card.dart';
import 'orientation_screen.dart';
import 'settings_screen.dart';

// Écran d'accueil : logo POLITIX, sous-titre, grille des orientations politiques
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Logo "POLITIX" en dégradé bleu avec une police personnalisée
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: AppTheme.politixGradient,
          ).createShader(bounds),
          child: Text(
            'POLITIX',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white, // remplacé par le dégradé via ShaderMask
              letterSpacing: 1.5,
            ),
          ),
        ),
        actions: [
          // Bouton emoji paramètres
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Text('⚙️', style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Partis se présentant à l'élection présidentielle de 2027",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.05,
              ),
              itemCount: MockData.orientations.length,
              itemBuilder: (context, index) {
                final orientation = MockData.orientations[index];
                return OrientationCard(
                  orientation: orientation,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrientationScreen(orientation: orientation),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}