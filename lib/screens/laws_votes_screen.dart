import 'package:app_politix/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

            // 1. Filtrage et Tri DYNAMIQUE des groupes présents dans Firestore
            final List<Map<String, dynamic>> sortedGroupes = _sortDynamicGroupes(
              groupesRaw.whereType<Map<String, dynamic>>().toList(),
            );

            final String resultatStatus = (data['resultat'] ?? '').toString().toLowerCase();
            final bool isAdopted = resultatStatus == 'adopté';

            return Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- En-tête : Résultat et Date ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['date'] ?? '',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        isAdopted ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        color: isAdopted ? AppTheme.votePour : AppTheme.voteContre,
                        size: 30,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // --- Titre du scrutin ---
                  Text(
                    data['titre'] ?? 'Scrutin',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      height: 1.25,
                      color: Color(0xFF1A1C1E),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    data['resultatLibelle'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: isAdopted ? AppTheme.votePour : AppTheme.voteContre,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Barre de résumé des totaux (basée sur tous les groupes présents) ---
                  _buildVoteSummaryBar(sortedGroupes),

                  const SizedBox(height: 28),

                  // --- Liste des groupes (uniquement ceux présents dans Firestore) ---
                  ...sortedGroupes.map((groupe) {
                    final String partyId = (groupe['partyId'] ?? '').toString().toLowerCase();
                    final String abbreviation = (groupe['abreviation'] ?? '').toString().toLowerCase();
                    
                    // On privilégie l'abréviation de Firestore, sinon on utilise l'ID en majuscule
                    final String label = (groupe['abreviation'] ?? groupe['nom'] ?? partyId).toString().toUpperCase();
                    final String? fullName = groupe['nom'];

                    final int pour = (groupe['pour'] ?? 0) as int;
                    final int contre = (groupe['contre'] ?? 0) as int;
                    final int abst = (groupe['abstentions'] ?? 0) as int;
                    final int membres = (groupe['nombreMembres'] ?? 0) as int;
                    
                    // On récupère la couleur du thème (alias gérés à l'intérieur de getPartyColor)
                    final Color groupColor = AppTheme.getPartyColor(partyId, abbreviation: abbreviation);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          // Badge stylisé du groupe
                          _buildGroupBadge(label, groupColor, fullName),

                          const SizedBox(width: 16),

                          // Détails des votes alignés (4 colonnes désormais)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _voteMiniStat('POUR', pour, AppTheme.votePour),
                                _voteMiniStat('CONTRE', contre, AppTheme.voteContre),
                                _voteMiniStat('ABS.', abst, AppTheme.voteAbstention),
                                _voteMiniStat('TOTAL', membres, Colors.blueGrey, isTotal: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const Divider(height: 40, thickness: 1),

                  Text(
                    'Source : Assemblée nationale (Données Firestore)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.3,
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

  // Widget pour le badge de parti avec Tooltip
  Widget _buildGroupBadge(String label, Color color, String? fullName) {
    return Tooltip(
      message: fullName ?? label,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      child: Container(
        width: 75,
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 10,
            color: color,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  // Widget pour les statistiques unitaires
  Widget _voteMiniStat(String label, int count, Color color, {bool isTotal = false}) {
    return SizedBox(
      width: 45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: isTotal ? Colors.blueGrey.shade400 : Colors.grey.shade500,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: isTotal ? Colors.blueGrey : (count > 0 ? color : Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }

  // Barre de résumé horizontale
  Widget _buildVoteSummaryBar(List<Map<String, dynamic>> groupes) {
    int totalPour = 0;
    int totalContre = 0;
    int totalAbst = 0;

    for (var g in groupes) {
      totalPour += (g['pour'] ?? 0) as int;
      totalContre += (g['contre'] ?? 0) as int;
      totalAbst += (g['abstentions'] ?? 0) as int;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9ECF1)),
      ),
      child: Row(
        children: [
          _summarySection('POUR', totalPour, AppTheme.votePour),
          Container(width: 1, height: 35, color: const Color(0xFFE9ECF1)),
          _summarySection('ABST.', totalAbst, AppTheme.voteAbstention),
          Container(width: 1, height: 35, color: const Color(0xFFE9ECF1)),
          _summarySection('CONTRE', totalContre, AppTheme.voteContre),
        ],
      ),
    );
  }

  Widget _summarySection(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }

  // Fonction de tri politique dynamique
  List<Map<String, dynamic>> _sortDynamicGroupes(List<Map<String, dynamic>> groups) {
    // Spectre politique de référence pour le tri
    final List<String> spectrum = [
      'gdr', 'lfi-nfp', 'lfi', 'ecos', 'soc', 'gauche',
      'liot', 'epr', 'renaissance', 'ensemble', 'dem', 'modem', 'hor', 'centre',
      'dr', 'les-republicains', 'lr', 'droite',
      'udr', 'uddplr', 'rn', 'extreme-droite',
      'ni', 'non inscrit'
    ];

    List<Map<String, dynamic>> sorted = List.from(groups);
    sorted.sort((a, b) {
      String idA = (a['partyId'] ?? a['abreviation'] ?? '').toString().toLowerCase();
      String idB = (b['partyId'] ?? b['abreviation'] ?? '').toString().toLowerCase();

      int idxA = spectrum.indexOf(idA);
      int idxB = spectrum.indexOf(idB);

      if (idxA == -1) idxA = 999;
      if (idxB == -1) idxB = 999;

      return idxA.compareTo(idxB);
    });
    return sorted;
  }
}
