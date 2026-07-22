import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

// Écran de démarrage : anime le dépliement du mot "POLITIX" à partir du "P"
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _revealAnimation; // largeur révélée de "OLITIX"
  late final Animation<double> _scaleAnimation; // léger effet de zoom sur le P au départ

  static const String _remainingLetters = 'OLITIX';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Le "P" apparaît d'abord seul (0% -> 25% du temps), puis le mot se déplie (25% -> 100%)
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.0), weight: 25),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 75),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _revealAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    );

    // Attend que le premier frame soit réellement affiché à l'écran avant de démarrer
    // l'animation (évite qu'elle tourne "dans le vide" pendant que le splash natif
    // Android est encore visible lors d'un lancement à froid depuis l'icône)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, anim, secondaryAnim) => const HomeScreen(),
                transitionsBuilder: (context, anim, secondaryAnim, child) =>
                    FadeTransition(opacity: anim, child: child),
              ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
      color: Colors.white, // remplacé par le dégradé via ShaderMask
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: AppTheme.politixGradient).createShader(bounds),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('P', style: textStyle),
                    // Révèle progressivement "OLITIX" en élargissant sa zone visible
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _revealAnimation.value,
                        child: Text(_remainingLetters, style: textStyle),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}