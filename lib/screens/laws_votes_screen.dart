import 'package:flutter/material.dart';
import '../data/mock_data.dart';

// Onglet "Lois & votes" : dernières lois et le vote de chaque parti sur ces lois
// Contenu placeholder pour l'instant, à connecter plus tard à l'open data de l'Assemblée nationale
class LawsVotesScreen extends StatelessWidget {
  const LawsVotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // exemples de lois factices
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loi à préciser (exemple ${index + 1})', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: MockData.parties.take(4).map((p) {
                  return Chip(
                    label: Text(p.name, style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.grey.shade200,
                  );
                }).toList(),
              ),
              const SizedBox(height: 4),
              Text(
                'Détail des votes par parti à venir (source : data.assemblee-nationale.fr).',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}