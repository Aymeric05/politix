import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    // Ne charger la pub que sur les plateformes supportées (Android/iOS natif)
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
      _initAndLoad();
    }
  }

  Future<void> _initAndLoad() async {
    try {
      // 1. Récupérer la configuration depuis Firestore
      final adsSnapshot = await FirebaseFirestore.instance
          .collection('config')
          .doc('ads')
          .get();

      String adUnitId;
      final Map<String, dynamic>? data = adsSnapshot.data();

      // SÉCURITÉ : Si on est en mode Debug (développement), on force les pubs de TEST
      if (kDebugMode) {
        adUnitId = defaultTargetPlatform == TargetPlatform.android
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716';
        debugPrint('AdMob: Mode développement détecté. Affichage de publicités de TEST par sécurité.');
      } 
      else if (adsSnapshot.exists && data != null && data['showRealAds'] == true) {
        // UTILISER LES PUBS RÉELLES (Uniquement en mode Release)
        if (defaultTargetPlatform == TargetPlatform.android) {
          adUnitId = data['androidBannerId'] ?? 'ca-app-pub-3940256099942544/6300978111';
        } else {
          adUnitId = 'ca-app-pub-3940256099942544/2934735716';
        }
        debugPrint('AdMob: Mode Production détecté. Affichage des publicités RÉELLES.');
      } 
      else {
        // Fallback par défaut (TEST)
        adUnitId = defaultTargetPlatform == TargetPlatform.android
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716';
        debugPrint('AdMob: Configuration Firestore absente ou showRealAds=false. Mode TEST.');
      }

      // 2. Charger la bannière avec l'ID choisi
      _loadAd(adUnitId);
    } catch (e) {
      debugPrint('AdMob: Erreur lors de la récupération de la config Firestore: $e');
      // En cas d'erreur Firestore, on tente quand même de charger une pub de test
      _loadAd('ca-app-pub-3940256099942544/6300978111');
    }
  }

  void _loadAd(String adUnitId) {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _errorMessage = "";
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          if (mounted) {
            setState(() {
              _isLoaded = false;
              _errorMessage = "Erreur: ${err.message}";
            });
          }
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cacher le widget sur les plateformes non supportées
    if (kIsWeb || (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS)) {
      return const SizedBox.shrink();
    }

    if (_isLoaded && _bannerAd != null) {
      return Container(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd!),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Container(
        width: double.infinity,
        height: 50,
        color: Colors.grey.shade50,
        alignment: Alignment.center,
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red.shade300, fontSize: 10),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: const Center(
        child: Text(
          "Chargement...",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
