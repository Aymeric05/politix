import 'package:flutter/material.dart';
import '../data/mock_data.dart';

// Onglet "Actus" : flux d'actualités mélangeant tous les partis
// Contenu placeholder pour l'instant, à connecter plus tard à de vraies sources
class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: MockData.parties.length,
      itemBuilder: (context, index) {
        final party = MockData.parties[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
              Row(
                children: [
                  const Icon(Icons.newspaper, size: 18, color: Colors.indigo),
                  const SizedBox(width: 6),
                  Text(party.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Actualité à venir concernant ${party.name} — cette section affichera des '
                    'news vérifiées, sourcées, avec le nombre de sources croisées.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }
}