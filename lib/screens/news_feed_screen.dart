import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Onglet "Actus" : flux d'actualités regroupées par sujet, triées par popularité
// (nombre de sources différentes qui en parlent), alimenté par buildNewsClusters
class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('newsClusters')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Erreur : ${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final docs = snapshot.data?.docs ?? [];
        
        if (docs.isEmpty) {
          return const Center(child: Text('Aucune actualité pour le moment.'));
        }

        // Tri manuel en Dart pour éviter de dépendre d'un index Firestore composite
        final sortedDocs = List.from(docs);
        sortedDocs.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;

          // 1. Tri par nombre de sources (popularité)
          final int countA = (dataA['sourceCount'] as num?)?.toInt() ?? 0;
          final int countB = (dataB['sourceCount'] as num?)?.toInt() ?? 0;
          if (countB != countA) return countB.compareTo(countA);

          // 2. Tri par date (si égalité de sources)
          final dateA = dataA['publishedAt'];
          final dateB = dataB['publishedAt'];
          
          DateTime dtA = (dateA is Timestamp) ? dateA.toDate() : DateTime.tryParse(dateA?.toString() ?? '') ?? DateTime(0);
          DateTime dtB = (dateB is Timestamp) ? dateB.toDate() : DateTime.tryParse(dateB?.toString() ?? '') ?? DateTime(0);
          
          return dtB.compareTo(dtA);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedDocs.length,
          itemBuilder: (context, index) {
            final data = sortedDocs[index].data() as Map<String, dynamic>;
            final sourceCount = (data['sourceCount'] as num?)?.toInt() ?? 1;
            final sources = (data['sources'] as List?) ?? [];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 6),
                  Text(data['description'] ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Étoiles = nombre de sources (plafonné à 5 pour l'affichage)
                      Row(
                        children: List.generate(
                          sourceCount.clamp(1, 5),
                              (i) => const Icon(Icons.star, size: 15, color: Colors.amber),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('$sourceCount source${sourceCount > 1 ? 's' : ''}',
                          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500)),
                      const Spacer(),
                      // Bouton info : ouvre la liste des sources
                      GestureDetector(
                        onTap: () => _showSourcesDialog(context, sources),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.info_outline, size: 16, color: Colors.indigo),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Affiche la liste des sources dans une feuille modale
  void _showSourcesDialog(BuildContext context, List sources) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sources de cette actualité', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ...sources.map((s) {
                final source = s as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text('• ${source['name'] ?? 'Source inconnue'}', style: const TextStyle(fontSize: 14)),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}