import 'package:flutter/material.dart';
import '../models/political_orientation.dart';

// Bandeau d'introduction affiché en haut de OrientationScreen
// Affiche un résumé court, dépliable pour voir la description complète + sources
class OrientationIntroCard extends StatefulWidget {
  final PoliticalOrientation orientation;

  const OrientationIntroCard({super.key, required this.orientation});

  @override
  State<OrientationIntroCard> createState() => _OrientationIntroCardState();
}

class _OrientationIntroCardState extends State<OrientationIntroCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.orientation;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: o.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: o.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Résumé court, toujours visible
          Text(
            o.summary,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: o.color,
            ),
          ),

          // Contenu déplié : description complète + sources
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(o.longDescription, style: const TextStyle(fontSize: 13.5, height: 1.4)),
                  const SizedBox(height: 12),
                  Text(
                    'Sources',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: o.color),
                  ),
                  const SizedBox(height: 4),
                  ...o.sources.map(
                        (s) => Text(
                      '• $s',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),

          // Bouton "déplier / replier"
          Center(
            child: IconButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                turns: _expanded ? 0.5 : 0,
                child: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}