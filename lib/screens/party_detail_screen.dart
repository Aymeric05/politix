import 'package:flutter/material.dart';
import '../models/party.dart';

// Écran affichant le détail complet d'un parti politique
class PartyDetailScreen extends StatelessWidget {
  final Party party;

  const PartyDetailScreen({super.key, required this.party});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(party.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Description'),
          Text(party.shortDescription),
          const SizedBox(height: 16),

          _sectionTitle('Dirigeant'),
          Text(party.leader),
          const SizedBox(height: 16),

          _sectionTitle('Personnalités importantes'),
          ...party.keyFigures.map((figure) => Text('• $figure')),
          const SizedBox(height: 16),

          _sectionTitle('Racines'),
          Text(party.roots),
          const SizedBox(height: 16),

          _sectionTitle('En savoir plus'),
          Text(party.detailedDescription),
          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.gavel),
            label: const Text('Lois votées (à venir)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.newspaper),
            label: const Text('Actualités (à venir)'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
