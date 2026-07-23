import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'news_feed_screen.dart';
import 'orientations_tab.dart';
import 'laws_votes_screen.dart';
import 'settings_screen.dart';

// Écran principal de l'app : 3 volets accessibles par swipe horizontal
// Page 0 : Actus (toutes les news mélangées)
// Page 1 : Familles politiques (grille des 6 orientations)
// Page 2 : Lois & votes
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  static const List<String> _tabTitles = ['Actus', 'Partis', 'Lois & votes'];

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: AppTheme.politixGradient).createShader(bounds),
          child: Text(
            'POLITIX',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Text('⚙️', style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) => setState(() => _currentPage = page),
        children: const [
          NewsFeedScreen(),
          OrientationsTab(),
          LawsVotesScreen(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_tabTitles.length, (index) {
              final bool active = _currentPage == index;
              return GestureDetector(
                onTap: () => _goToPage(index),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: active ? 16 : 13.5,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: active ? Colors.indigo : Colors.grey.shade400,
                  ),
                  child: Text(_tabTitles[index]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}