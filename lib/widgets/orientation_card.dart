import 'package:flutter/material.dart';
import '../models/political_orientation.dart';
import '../theme/app_theme.dart';

// Carte cliquable représentant une orientation politique (écran d'accueil)
// Avec dégradé de couleur, ombre portée pour donner du relief
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.cardGradient(orientation.color),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: orientation.color.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              orientation.name,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              orientation.description,
              style: TextStyle(fontSize: 12.5, color: Colors.white.withValues(alpha: 0.9)),
            ),
          ],
        ),
      ),
    );
  }
}