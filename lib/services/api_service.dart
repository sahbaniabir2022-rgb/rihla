import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/destination.dart';

class ApiService {
  static Uri _url(String chemin) {
    return Uri.parse('${ApiConfig.baseUrl}$chemin');
  }

  static Future<List<Destination>> getDestinations() async {
    final reponse = await http
        .get(_url('/destinations'))
        .timeout(ApiConfig.timeout);

    if (reponse.statusCode != 200) {
      throw Exception(
        'Erreur serveur : ${reponse.statusCode}',
      );
    }

    final List<dynamic> liste =
        jsonDecode(utf8.decode(reponse.bodyBytes));

    return liste
        .map((element) => Destination.fromJson(
              element as Map<String, dynamic>,
            ))
        .toList();
  }
}
// Questions de compréhension

// 1. Pourquoi fromJson est-il un constructeur factory ?
// Parce qu'il permet de créer et retourner une nouvelle instance
// de Destination à partir des données JSON.

// 2. Que se passe-t-il si db.json contient "prix": "420" ?
// Une erreur de type se produit, car "420" est une String
// et non un num. Le cast (json['prix'] as num) échoue.

// 3. Pourquoi la méthode renvoie-t-elle un Future<List<Destination>> ?
// Parce que la requête HTTP est asynchrone et prend du temps.
// Future indique que la liste sera disponible après la réponse du serveur.