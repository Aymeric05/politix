import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/orientation_card.dart';
import 'orientation_screen.dart';

// Contenu de l'onglet "Familles politiques" : grille des 6 orientations
class OrientationsTab extends StatelessWidget {
  const OrientationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}