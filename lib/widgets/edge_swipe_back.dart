import 'package:flutter/material.dart';

// Enveloppe n'importe quel écran pour ajouter le "swipe pour revenir en arrière"
// en glissant depuis le bord gauche de l'écran vers la droite.
// N'interfère pas avec les gestes du contenu (ex: PageView) car la zone
// sensible est une fine bande de 24px sur le bord gauche.
class EdgeSwipeBack extends StatelessWidget {
  final Widget child;

  const EdgeSwipeBack({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 24, // largeur de la zone sensible au swipe, sur le bord
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              // Si le geste va vers la droite avec une vitesse suffisante, on revient en arrière
              if ((details.primaryVelocity ?? 0) > 200) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}