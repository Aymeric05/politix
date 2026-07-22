import 'package:flutter/material.dart';
import '../models/party.dart';

// Carte représentant un parti dans la liste (une fois une orientation sélectionnée)
class PartyCard extends StatelessWidget {
  final Party party;
  final Color accentColor;
  final VoidCallback onTap;

  const PartyCard({
    super.key,
    required this.party,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: accentColor, width: 5)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          party.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5),
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