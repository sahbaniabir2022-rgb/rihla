class Destination {
  final String nom;
  final String region;
  final String image;
  final double note;
  final int prix;
  final String categorie;
  final String duree;
  final String description;

  const Destination({
    required this.nom,
    required this.region,
    required this.image,
    required this.note,
    required this.prix,
    required this.categorie,
    this.duree = '3 jours',
    this.description = 'Description à venir.',
  });
}