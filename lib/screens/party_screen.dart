import 'package:flutter/material.dart';
import '../models/party.dart';
import '../models/party_representation.dart';
import '../widgets/edge_swipe_back.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Écran d'un parti politique : trois volets accessibles par swipe horizontal
// - Page 0 : News (actualités du parti)
// - Page 1 : Représentation (force politique actuelle)
// - Page 2 : Histoire (racines, histoire, idées, sources)
class PartyScreen extends StatefulWidget {
  final Party party;
  final Color accentColor;

  const PartyScreen({super.key, required this.party, required this.accentColor});

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EdgeSwipeBack(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.party.name),
        ),
        body: Column(
          children: [
            // --- Indicateur d'onglets NEWS / Représentation / Histoire ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tabLabel('NEWS', 0),
                  const SizedBox(width: 18),
                  _tabLabel('Représentation', 1),
                  const SizedBox(width: 18),
                  _tabLabel('Histoire', 2),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _NewsTab(party: widget.party, accentColor: widget.accentColor),
                  _RepresentationTab(party: widget.party, accentColor: widget.accentColor),
                  _HistoryTab(party: widget.party, accentColor: widget.accentColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Construit un label d'onglet, en surbrillance si actif, grisé sinon
  Widget _tabLabel(String label, int page) {
    final bool active = _currentPage == page;
    return GestureDetector(
      onTap: () => _goToPage(page),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: active ? 16 : 14,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
          color: active ? widget.accentColor : Colors.grey.shade400,
        ),
        child: Text(label),
      ),
    );
  }
}

// --- Onglet NEWS ---
class _NewsTab extends StatelessWidget {
  final Party party;
  final Color accentColor;

  const _NewsTab({
    required this.party,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('news')
          .where('partyId', isEqualTo: party.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur : ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final articles = snapshot.data?.docs ?? [];

        articles.sort((a, b) {
          final dateA = a.data()['publishedAt']?.toString() ?? '';
          final dateB = b.data()['publishedAt']?.toString() ?? '';
          return dateB.compareTo(dateA);
        });

        if (articles.isEmpty) {
          return Center(
            child: Text(
              'Aucune actualité récente concernant ${party.name}.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index].data();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'] ?? 'Actualité',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if ((article['description'] ?? '').isNotEmpty)
                    Text(
                      article['description'],
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),

                  const SizedBox(height: 10),

                  Text(
                    article['sourceName'] ?? 'Source inconnue',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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

// --- Onglet REPRÉSENTATION ---
class _RepresentationTab extends StatelessWidget {
  final Party party;
  final Color accentColor;

  const _RepresentationTab({required this.party, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final rep = party.representation;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionTitle('Élus nationaux & européens', accentColor),
        _RepresentationBar(
          label: 'Députés',
          current: rep.deputies,
          total: PartyRepresentation.totalDeputies,
          color: accentColor,
        ),
        _RepresentationBar(
          label: 'Sénateurs',
          current: rep.senators,
          total: PartyRepresentation.totalSenators,
          color: accentColor,
        ),
        _RepresentationBar(
          label: 'Députés européens',
          current: rep.euroDeputies,
          total: PartyRepresentation.totalEuroDeputies,
          color: accentColor,
        ),
        const SizedBox(height: 30),
        _sectionTitle('Élus locaux', accentColor),
        _RepresentationBar(
          label: 'Présidents de départements',
          current: rep.deptPresidents,
          total: PartyRepresentation.totalDeptPresidents,
          color: accentColor,
        ),
        _RepresentationBar(
          label: 'Présidents de régions',
          current: rep.regPresidents,
          total: PartyRepresentation.totalRegPresidents,
          color: accentColor,
        ),
        _RepresentationBar(
          label: 'Maires (+30k hab.)',
          current: rep.largeCityMayors,
          total: PartyRepresentation.totalLargeCityMayors,
          color: accentColor,
        ),
        const SizedBox(height: 30),
        Text(
          "Source : Données officielles consolidées. Les chiffres peuvent varier selon les ralliements récents.",
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color, letterSpacing: 1.1),
      ),
    );
  }
}

// Widget de barre de représentation inspiré du visuel fourni
class _RepresentationBar extends StatelessWidget {
  final String label;
  final int current;
  final int total;
  final Color color;

  const _RepresentationBar({
    required this.label,
    required this.current,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = (current / total).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '$current / $total',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              // Fond de la barre
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Partie remplie (avec animation possible plus tard)
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Onglet HISTOIRE ---
class _HistoryTab extends StatelessWidget {
  final Party party;
  final Color accentColor;

  const _HistoryTab({required this.party, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Résumé court en tête (3-4 lignes)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accentColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            party.historySummary,
            style: const TextStyle(fontSize: 14.5, height: 1.4),
          ),
        ),
        const SizedBox(height: 20),

        _sectionTitle('Racines', accentColor),
        Text(party.historyRoots, style: const TextStyle(height: 1.5)),
        const SizedBox(height: 20),

        _sectionTitle('Histoire et idées', accentColor),
        Text(party.historyDetails, style: const TextStyle(height: 1.5)),
        const SizedBox(height: 20),

        _sectionTitle('Fondation', accentColor),
        Text('Fondé en ${party.foundedYear}'),
        const SizedBox(height: 20),

        _sectionTitle('Dirigeant(s)', accentColor),
        Text(party.leader),
        const SizedBox(height: 20),

        _sectionTitle('Personnalités importantes', accentColor),
        ...party.keyFigures.map((f) => Text('• $f')),
        const SizedBox(height: 24),

        _sectionTitle('Sources', accentColor),
        ...party.sources.map(
              (s) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• $s', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
