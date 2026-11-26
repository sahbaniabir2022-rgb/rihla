
import 'package:flutter/material.dart';

import '../models/reservation.dart';
import '../services/api_service.dart';
import '../widgets/erreur_reseau.dart';

class MesReservationsScreen extends StatefulWidget {
  const MesReservationsScreen({super.key});

  @override
  State<MesReservationsScreen> createState() =>
      _MesReservationsScreenState();
}

class _MesReservationsScreenState
    extends State<MesReservationsScreen> {
  late Future<List<Reservation>> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _chargerReservations();
  }

  void _chargerReservations() {
    _reservationsFuture = ApiService.getReservations();
  }

  void _reessayer() {
    setState(() {
      _chargerReservations();
    });
  }

  String _formaterDate(DateTime date) {
    final jour = date.day.toString().padLeft(2, '0');
    final mois = date.month.toString().padLeft(2, '0');
    return '$jour/$mois/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes voyages'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Reservation>>(
        future: _reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return ErreurReseau(
              message: 'Impossible de charger vos voyages.',
              onReessayer: _reessayer,
            );
          }

          final reservations = snapshot.data ?? [];

          if (reservations.isEmpty) {
            return const Center(
              child: Text(
                'Aucune réservation pour le moment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _reessayer();
              await _reservationsFuture;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                final destination = reservation.destination;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        destination.image,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 170,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.nom,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Date de départ : ${_formaterDate(reservation.date)}',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Voyageurs : ${reservation.voyageurs}',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Formule : ${reservation.formule}',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total : ${reservation.total} DT',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
