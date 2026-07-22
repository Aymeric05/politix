import 'package:flutter/material.dart';
import '../models/political_orientation.dart';
import '../models/party.dart';
import '../theme/app_theme.dart';

// Données factices pour développer le frontend sans backend.
// À remplacer plus tard par de vraies données (API Assemblée nationale, etc.)
class MockData {
  static const List<PoliticalOrientation> orientations = [
    PoliticalOrientation(
      id: 'extreme-gauche',
      name: 'Extrême gauche',
      description: 'Courants anticapitalistes et révolutionnaires',
      color: AppTheme.extremeGauche,
    ),
    PoliticalOrientation(
      id: 'gauche',
      name: 'Gauche',
      description: 'Courants sociaux-démocrates et écologistes',
      color: AppTheme.gauche,
    ),
    PoliticalOrientation(
      id: 'centre',
      name: 'Centre',
      description: 'Courants centristes et libéraux',
      color: AppTheme.centre,
    ),
    PoliticalOrientation(
      id: 'droite',
      name: 'Droite',
      description: 'Courants conservateurs et libéraux-conservateurs',
      color: AppTheme.droite,
    ),
    PoliticalOrientation(
      id: 'extreme-droite',
      name: 'Extrême droite',
      description: 'Courants nationalistes',
      color: AppTheme.extremeDroite,
    ),
    PoliticalOrientation(
      id: 'sans-etiquette',
      name: 'Sans étiquette',
      description: 'Partis divers ou non classés',
      color: AppTheme.sansEtiquette,
    ),
  ];

  static const List<Party> parties = [
    Party(
      id: 'les-republicains',
      name: 'Les Républicains',
      orientationId: 'droite',
      shortDescription: 'Parti de droite issu du gaullisme et du libéralisme.',
      leader: 'À compléter',
      keyFigures: ['À compléter'],
      roots: "Héritier de l'UMP, lui-même issu du RPR fondé par Jacques Chirac.",
      detailedDescription: 'Description approfondie à compléter avec des sources vérifiées.',
    ),
    Party(
      id: 'renaissance',
      name: 'Renaissance',
      orientationId: 'centre',
      shortDescription: 'Parti centriste fondé par Emmanuel Macron.',
      leader: 'À compléter',
      keyFigures: ['À compléter'],
      roots: 'Fondé en 2016 sous le nom "En Marche".',
      detailedDescription: 'Description approfondie à compléter avec des sources vérifiées.',
    ),
    // Ajoute les autres partis de la même façon...
  ];

  // Récupère tous les partis d'une orientation donnée
  static List<Party> getPartiesByOrientation(String orientationId) {
    return parties.where((p) => p.orientationId == orientationId).toList();
  }
}
