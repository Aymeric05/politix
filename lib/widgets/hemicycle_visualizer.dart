import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HemicycleVisualizer extends StatelessWidget {
  final List<Map<String, dynamic>> groupes;
  final bool? isAdopted;

  const HemicycleVisualizer({
    super.key,
    required this.groupes,
    this.isAdopted,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = width / 1.7;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: width,
              height: height,
              padding: const EdgeInsets.only(top: 10),
              child: CustomPaint(
                painter: _HemicyclePainter(groupes: groupes),
              ),
            ),
            if (isAdopted != null)
              Positioned(
                bottom: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Icon(
                    isAdopted! ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: width * 0.16,
                    color: isAdopted! ? AppTheme.votePour : AppTheme.voteContre,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _HemicyclePainter extends CustomPainter {
  final List<Map<String, dynamic>> groupes;

  _HemicyclePainter({required this.groupes});

  @override
  void paint(Canvas canvas, Size size) {
    const int totalSeatsToDraw = 577;
    const int rows = 11;
    final double centerX = size.width / 2;
    final double centerY = size.height * 0.98;
    final double maxRadius = size.width / 2 * 0.95;
    final double minRadius = maxRadius * 0.38;
    final double seatSize = size.width / 78;

    // 1. Calculer les couleurs exactes pour les 577 sièges
    List<Color> allSeatsColors = _generateFixedSeatsColors();
    
    // 2. Calculer les positions avec des allées parfaitement symétriques
    List<_SeatPos> positions = [];
    
    // On définit un nombre de colonnes fixe pour le calcul de l'angle
    const int cols = 56; 
    // Indices des allées (symétriques par rapport au centre 28)
    final List<int> aisles = [6, 14, 21, 28, 35, 42, 50]; 

    for (int r = 0; r < rows; r++) {
      double radius = minRadius + (maxRadius - minRadius) * (r / (rows - 1));
      
      for (int c = 0; c < cols; c++) {
        double aisleOffset = 0;
        for (var aisle in aisles) {
          if (c >= aisle) aisleOffset += 0.07; 
        }

        // Angle calculé pour être parfaitement symétrique
        // Range total approx pi + aisleOffsets
        double totalAisleOffset = aisles.length * 0.07;
        double baseAngleRange = math.pi * 0.88; // Réduit pour laisser place aux allées
        
        // On centre l'arc sur 1.5 * pi
        double startAngle = (1.5 * math.pi) - (baseAngleRange + totalAisleOffset) / 2;
        double angle = startAngle + (baseAngleRange * (c / (cols - 1))) + aisleOffset;

        double x = centerX + radius * math.cos(angle);
        double y = centerY + radius * math.sin(angle);
        positions.add(_SeatPos(Offset(x, y), angle));
      }
    }

    // On trie par angle (gauche -> droite) pour le mapping avec les blocs politiques
    positions.sort((a, b) => a.angle.compareTo(b.angle));

    // Dessin des 577 premiers sièges calculés
    for (int i = 0; i < totalSeatsToDraw; i++) {
      if (i >= positions.length || i >= allSeatsColors.length) break;
      
      final Color color = allSeatsColors[i];
      final pos = positions[i];

      final Rect rect = Rect.fromCenter(center: pos.offset, width: seatSize, height: seatSize);
      final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(seatSize * 0.3));

      canvas.drawRRect(rrect, Paint()..color = color..style = PaintingStyle.fill);
      
      // Structure ultra légère
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.03)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
    }
  }

  List<Color> _generateFixedSeatsColors() {
    List<Color> colors = [];
    
    // Répartition stricte (Total = 577)
    final List<_GroupDef> partyBlocks = [
      _GroupDef('gdr', 17),
      _GroupDef('lfi', 71),
      _GroupDef('ecos', 38),
      _GroupDef('soc', 66),
      _GroupDef('liot', 23),
      _GroupDef('epr', 91),
      _GroupDef('dem', 36),
      _GroupDef('hor', 34),
      _GroupDef('dr', 49),
      _GroupDef('udr', 15),
      _GroupDef('rn', 123),
      _GroupDef('ni', 11),
      _GroupDef('vacant', 3),
    ];

    final Map<String, Map<String, dynamic>> votesMap = {
      for (var g in groupes) (g['partyId'] ?? '').toString().toLowerCase(): g
    };

    for (var def in partyBlocks) {
      final vote = votesMap[def.id] ?? votesMap[_normalizeId(def.id)];
      
      int pour = 0;
      int contre = 0;
      int abst = 0;

      if (vote != null) {
        pour = (vote['pour'] ?? 0) as int;
        contre = (vote['contre'] ?? 0) as int;
        abst = (vote['abstentions'] ?? 0) as int;
      }

      // Respect strict du nombre de sièges du groupe
      int totalVoted = pour + contre + abst;
      int absents = math.max(0, def.seats - totalVoted);

      // On remplit le bloc. Pour le RN (id='rn'), on veut s'assurer que ses 123 sièges
      // reflètent bien ses votes. L'ordre interne : Pour, Contre, Abst, Absent.
      for (int i = 0; i < pour; i++) colors.add(AppTheme.votePour);
      for (int i = 0; i < contre; i++) colors.add(AppTheme.voteContre);
      for (int i = 0; i < abst; i++) colors.add(AppTheme.voteAbstention);
      for (int i = 0; i < absents; i++) colors.add(AppTheme.voteAbsent);
    }

    return colors;
  }

  String _normalizeId(String id) {
    if (id == 'lfi') return 'lfi-nfp';
    if (id == 'dem') return 'modem';
    if (id == 'epr') return 'ensemble';
    if (id == 'dr') return 'les-republicains';
    return id;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GroupDef {
  final String id;
  final int seats;
  _GroupDef(this.id, this.seats);
}

class _SeatPos {
  final Offset offset;
  final double angle;
  _SeatPos(this.offset, this.angle);
}
