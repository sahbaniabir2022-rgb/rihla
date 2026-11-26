import 'destination.dart';

class Reservation {
  final String? id;
  final Destination destination;
  final String nom;
  final String email;
  final String telephone;
  final DateTime date;
  final int voyageurs;
  final String formule;

  const Reservation({
    this.id,
    required this.destination,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.date,
    required this.voyageurs,
    required this.formule,
  });

  int get prixParPersonne => formule == 'Confort'
      ? (destination.prix * 1.3).round()
      : destination.prix;

  int get total => prixParPersonne * voyageurs;
  // Créer une réservation à partir des données JSON
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id']?.toString(),
      destination: Destination.fromJson(
        json['destination'] as Map<String, dynamic>,
      ),
      nom: json['nom'],
      email: json['email'],
      telephone: json['telephone'],
      date: DateTime.parse(json['dateDepart']),
      voyageurs: (json['voyageurs'] as num).toInt(),
      formule: json['formule'],
    );
  }
  // Convertir la réservation en JSON
  Map<String, dynamic> toJson() {
    return {
      'destinationId': destination.id,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'voyageurs': voyageurs,
      'formule': formule,
      'total': total,
      'dateDepart': date.toIso8601String(),
    };
  }
}
