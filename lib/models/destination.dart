
class Destination {
  final String id;
  final String nom;
  final String region;
  final String categorie;
  final String image;
  final double note;
  final int prix;
  final String duree;
  final String description;

  const Destination({
    required this.id,
    required this.nom,
    required this.region,
    required this.categorie,
    required this.image,
    required this.note,
    required this.prix,
    this.duree = '3 jours',
    this.description = 'Description à venir',
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'].toString(),
      nom: json['nom'] as String,
      region: json['region'] as String,
      categorie: json['categorie'] as String,
      image: json['image'] as String,
      note: (json['note'] as num).toDouble(),
      prix: (json['prix'] as num).toInt(),
      duree: json['duree']?.toString() ?? '3 jours',
      description:
          json['description']?.toString() ?? 'Description à venir',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'region': region,
      'categorie': categorie,
      'image': image,
      'note': note,
      'prix': prix,
      'duree': duree,
      'description': description,
    };
  }
}
