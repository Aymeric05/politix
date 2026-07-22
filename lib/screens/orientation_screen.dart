import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/political_orientation.dart';
import '../widgets/party_card.dart';
import 'party_detail_screen.dart';

// Écran affichant la liste des partis appartenant à une orientation donnée
class OrientationScreen extends StatelessWidget {
  final PoliticalOrientation orientation;

  const OrientationScreen({super.key, required this.orientation});

  @override
  Widget build(BuildContext context) {
    final parties = MockData.getPartiesByOrientation(orientation.id);

    return Scaffold(
      appBar: AppBar(title: Text(orientation.name)),
      body: parties.isEmpty
          ? const Center(child: Text('Aucun parti renseigné pour le moment.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: parties.length,
              itemBuilder: (context, index) {
                final party = parties[index];
                return PartyCard(
                  party: party,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PartyDetailScreen(party: party),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
