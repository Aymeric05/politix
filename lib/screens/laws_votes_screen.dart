import 'package:app_politix/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/hemicycle_visualizer.dart';

class LawsVotesScreen extends StatelessWidget {
  const LawsVotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('votes')
          .orderBy('date', descending: true)
          .limit(20)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Erreur lors du chargement des votes :\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final votes = snapshot.data?.docs ?? [];

        if (votes.isEmpty) {
          return const Center(
            child: Text('Aucun scrutin disponible.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: votes.length,
          itemBuilder: (context, index) {
            final data = votes[index].data();

            final groupesRaw = data['groupes'] as List<dynamic>? ?? [];

            final groupes = groupesRaw
                .whereType<Map<String, dynamic>>()
                .where((groupe) => groupe['partyId'] != null)
                .toList();
            
            final String resultat = (data['resultatLibelle'] ?? '').toString().toLowerCase();
            final bool isAdopted = resultat.contains('adopté') || resultat.contains('approuvé') || resultat.contains('accepté');

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['titre'] ?? 'Scrutin',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    data['date'] ?? '',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    data['resultatLibelle'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),
                  
                  // Visualisation graphique de l'hémicycle
                  HemicycleVisualizer(
                    groupes: groupes,
                    isAdopted: isAdopted,
                  ),

                  const SizedBox(height: 12),
                  
                  // Barre de résumé des totaux (Pour / Abst / Contre)
                  _buildVoteSummaryBar(groupes),

                  const SizedBox(height: 20),

                  ...groupes.map((groupe) {
                    final nom =
                        groupe['abreviation'] ??
                        groupe['nom'] ??
                        'Groupe';

                    final position =
                        groupe['positionMajoritaire'] ?? '—';

                    final pour = groupe['pour'] ?? 0;
                    final contre = groupe['contre'] ?? 0;
                    final abstentions = groupe['abstentions'] ?? 0;
                    
                    final Color groupColor = AppTheme.getPartyColor(groupe['partyId']);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 72,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: groupColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: groupColor.withValues(alpha: 0.3), width: 1),
                              ),
                              child: Text(
                                nom.toString().toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10,
                                  color: groupColor,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Position majoritaire : $position',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Pour $pour  •  Contre $contre  •  Abst. $abstentions',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 4),

                  Text(
                    'Source : Assemblée nationale',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVoteSummaryBar(List<Map<String, dynamic>> groupes) {
    int totalPour = 0;
    int totalContre = 0;
    int totalAbst = 0;

    for (var g in groupes) {
      totalPour += (g['pour'] ?? 0) as int;
      totalContre += (g['contre'] ?? 0) as int;
      totalAbst += (g['abstentions'] ?? 0) as int;
    }

    return Row(
      children: [
        _summarySection('POUR', totalPour, AppTheme.votePour),
        const SizedBox(width: 8),
        _summarySection('ABST.', totalAbst, AppTheme.voteAbstention),
        const SizedBox(width: 8),
        _summarySection('CONTRE', totalContre, AppTheme.voteContre),
      ],
    );
  }

  Widget _summarySection(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
