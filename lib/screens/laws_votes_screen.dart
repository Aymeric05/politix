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

            final groupes = groupesRaw
                .whereType<Map<String, dynamic>>()
                .where((groupe) => groupe['partyId'] != null)
                .toList();

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

                  const SizedBox(height: 14),

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

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 55,
                            child: Text(
                              nom.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
}