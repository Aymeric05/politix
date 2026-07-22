import 'package:flutter/material.dart';
import '../models/political_orientation.dart';

// Carte cliquable représentant une orientation politique (écran d'accueil)
class OrientationCard extends StatelessWidget {
  final PoliticalOrientation orientation;
  final VoidCallback onTap;

  const OrientationCard({
    super.key,
    required this.orientation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: orientation.color.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: orientation.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                orientation.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                orientation.description,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
