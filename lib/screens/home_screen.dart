import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/orientation_card.dart';
import 'orientation_screen.dart';

// Écran d'accueil : affiche la grille des grandes orientations politiques
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Échiquier politique')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
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
    );
  }
}
