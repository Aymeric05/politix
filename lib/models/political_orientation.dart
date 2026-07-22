import 'package:flutter/material.dart';

// Modèle représentant une orientation politique
class PoliticalOrientation {
  final String id;
  final String name;
  final String description; // très courte description (cartes de l'écran d'accueil)
  final Color color;
  final String summary; // résumé un peu plus long (bandeau en haut de la liste des partis)
  final String longDescription; // description complète (dépliée)
  final List<String> sources;

  const PoliticalOrientation({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.summary,
    required this.longDescription,
    required this.sources,
  });
}