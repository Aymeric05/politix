import 'package:flutter/material.dart';

// Modèle représentant une orientation politique
// (ex: "Gauche", "Droite", "Centre", "Sans étiquette"...)
class PoliticalOrientation {
  final String id; // identifiant unique, ex: "droite"
  final String name; // nom affiché, ex: "Droite"
  final String description; // courte description
  final Color color; // couleur associée pour l'affichage

  const PoliticalOrientation({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
  });
}
