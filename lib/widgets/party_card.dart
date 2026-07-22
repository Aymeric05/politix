import 'package:flutter/material.dart';
import '../models/party.dart';

// Carte représentant un parti dans la liste (une fois une orientation sélectionnée)
class PartyCard extends StatelessWidget {
  final Party party;
  final VoidCallback onTap;

  const PartyCard({
    super.key,
    required this.party,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          party.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(party.shortDescription),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
