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
            // Symbole central de résultat (Style minimaliste)
            if (isAdopted != null)
              Positioned(
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isAdopted! ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: width * 0.15,
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
    const int totalSeats = 577;
    const int rows = 11;
    final double centerX = size.width / 2;
    final double centerY = size.height * 0.98;
    final double maxRadius = size.width / 2 * 0.92;
    final double minRadius = maxRadius * 0.4;
    final double seatSize = size.width / 82;

    // 1. Calculer les couleurs exactes pour les 577 sièges
    List<Color> allSeatsColors = _generateFixedSeatsColors();
    
    // 2. Calculer les positions sans allées, parfaitement équilibrées
    List<_SeatPos> positions = [];
    
    // Distribution des 577 sièges sur les 11 rangées
    List<int> seatsPerRow = _calculateSeatsPerRow(totalSeats, rows);
    
    const double baseAngleRange = math.pi * 0.98; // Éventail large mais pas plat

    for (int r = 0; r < rows; r++) {
      double radius = minRadius + (maxRadius - minRadius) * (r / (rows - 1));
      int count = seatsPerRow[r];
      
      // On centre chaque rangée individuellement autour de 1.5 * pi
      double startAngle = (1.5 * math.pi) - (baseAngleRange / 2);
      
      for (int s = 0; s < count; s++) {
        double angle = startAngle + (baseAngleRange * (s / (count - 1)));
        
        double x = centerX + radius * math.cos(angle);
        double y = centerY + radius * math.sin(angle);
        positions.add(_SeatPos(Offset(x, y), angle));
      }
    }

    // On trie par angle (gauche -> droite) pour faire correspondre aux blocs politiques
    positions.sort((a, b) => a.angle.compareTo(b.angle));

    // Dessin
    for (int i = 0; i < totalSeats; i++) {
      if (i >= positions.length || i >= allSeatsColors.length) break;
      
      final Color color = allSeatsColors[i];
      final pos = positions[i];

      final Rect rect = Rect.fromCenter(center: pos.offset, width: seatSize, height: seatSize);
      final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(seatSize * 0.35));

      canvas.drawRRect(rrect, Paint()..color = color..style = PaintingStyle.fill);
    }
  }

  List<int> _calculateSeatsPerRow(int total, int rowsCount) {
    List<int> result = [];
    int remaining = total;
    double totalWeight = 0;
    // Poids basé sur le périmètre (proportionnel au rayon)
    for (int i = 0; i < rowsCount; i++) {
      totalWeight += (0.4 + (0.6 * i / (rowsCount - 1)));
    }

    for (int i = 0; i < rowsCount - 1; i++) {
      double weight = (0.4 + (0.6 * i / (rowsCount - 1)));
      int count = (total * weight / totalWeight).round();
      result.add(count);
      remaining -= count;
    }
    result.add(remaining);
    return result;
  }

  List<Color> _generateFixedSeatsColors() {
    List<Color> colors = [];
    
    final List<_GroupDef> partyBlocks = [
      _GroupDef('gdr', 17),
      _GroupDef('lfi-nfp', 71),
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
      for (var g in groupes) (g['partyId'] ?? g['abreviation'] ?? '').toString().toLowerCase(): g
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

      int totalVoted = pour + contre + abst;
      int absents = math.max(0, def.seats - totalVoted);

      for (int i = 0; i < pour; i++) colors.add(AppTheme.votePour);
      for (int i = 0; i < contre; i++) colors.add(AppTheme.voteContre);
      for (int i = 0; i < abst; i++) colors.add(AppTheme.voteAbstention);
      for (int i = 0; i < absents; i++) colors.add(AppTheme.voteAbsent);
    }

    // On s'assure d'avoir exactement 577 couleurs
    if (colors.length > 577) return colors.sublist(0, 577);
    while (colors.length < 577) colors.add(AppTheme.voteAbsent);
    
    return colors;
  }

  String _normalizeId(String id) {
    if (id == 'lfi-nfp') return 'lfi';
    if (id == 'soc') return 'ps';
    if (id == 'epr') return 'renaissance';
    if (id == 'dr') return 'les-republicains';
    if (id == 'dem') return 'modem';
    if (id == 'udr') return 'uddplr';
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
