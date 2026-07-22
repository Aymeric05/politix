import 'package:flutter/material.dart';
import '../models/party.dart';
import '../widgets/edge_swipe_back.dart';

// Écran d'un parti politique : deux volets accessibles par swipe horizontal
// - Page 0 : News (actualités du parti) — affichée par défaut
// - Page 1 : Histoire (racines, histoire, idées, sources)
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
            // --- Indicateur d'onglets NEWS / Histoire ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tabLabel('NEWS', 0),
                  const SizedBox(width: 24),
                  _tabLabel('Histoire', 1),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _NewsTab(party: widget.party, accentColor: widget.accentColor),
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
      child: Text(
        label,
        style: TextStyle(
          fontSize: active ? 17 : 15,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
          color: active ? widget.accentColor : Colors.grey.shade400,
        ),
      ),
    );
  }
}

// --- Onglet NEWS (placeholder pour l'instant) ---
class _NewsTab extends StatelessWidget {
  final Party party;
  final Color accentColor;

  const _NewsTab({required this.party, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: 48, color: accentColor),
            const SizedBox(height: 12),
            Text(
              "Actualités de ${party.name} — à venir.\n"
                  "Cette section affichera les news vérifiées, sourcées, "
                  "avec le nombre de sources croisées pour chaque info.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
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