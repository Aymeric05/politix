// Modèle représentant un parti politique
class Party {
  final String id; // identifiant unique, ex: "les-republicains"
  final String name; // nom du parti
  final String orientationId; // lien vers PoliticalOrientation.id
  final String shortDescription; // phrase courte de présentation
  final String leader; // dirigeant actuel
  final List<String> keyFigures; // personnalités importantes
  final String roots; // racines / origine historique
  final String detailedDescription; // description approfondie

  const Party({
    required this.id,
    required this.name,
    required this.orientationId,
    required this.shortDescription,
    required this.leader,
    required this.keyFigures,
    required this.roots,
    required this.detailedDescription,
  });
}
