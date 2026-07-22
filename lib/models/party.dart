// Modèle représentant un parti politique, avec ses infos de base
// et son contenu pour la rubrique "Histoire"
class Party {
  final String id; // identifiant unique, ex: "rassemblement-national"
  final String name; // nom du parti
  final String orientationId; // lien vers PoliticalOrientation.id
  final String shortDescription; // phrase courte affichée sur la carte
  final String leader; // dirigeant actuel
  final List<String> keyFigures; // personnalités importantes
  final String foundedYear; // année de création

  // --- Contenu de l'onglet "Histoire" ---
  final String historySummary; // résumé en 3-4 lignes : parti + idées
  final String historyRoots; // racines / origine du parti
  final String historyDetails; // histoire détaillée, idées, évolution
  final List<String> sources; // sources citées pour cette fiche

  const Party({
    required this.id,
    required this.name,
    required this.orientationId,
    required this.shortDescription,
    required this.leader,
    required this.keyFigures,
    required this.foundedYear,
    required this.historySummary,
    required this.historyRoots,
    required this.historyDetails,
    required this.sources,
  });
}