
import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../services/api_service.dart';

import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart';
import '../widgets/destination_card.dart';
import '../widgets/section_title.dart';
import '../widgets/erreur_reseau.dart';

import 'mes_reservations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;

  late Future<List<Destination>> _futurDestinations;

  final List<String> _categories = [
    'Tout',
    'Plage',
    'Désert',
    'Patrimoine',
  ];

  @override
  void initState() {
    super.initState();
    _futurDestinations = ApiService.getDestinations();
  }

  // Filtrer les destinations
  List<Destination> _filtrer(List<Destination> toutes) {
    if (_categorie == 'Tout') {
      return toutes;
    }

    return toutes
        .where((d) => d.categorie == _categorie)
        .toList();
  }

  // Recharger les destinations
  Future<void> _recharger() async {
    final futur = ApiService.getDestinations();

    setState(() {
      _futurDestinations = futur;
    });

    try {
      await futur;
    } catch (_) {
      // L'erreur sera affichée par FutureBuilder.
    }
  }

  // Construire la page d'accueil
  Widget _construireAccueil(List<Destination> destinations) {
    final filtrees = _filtrer(destinations);

    return RefreshIndicator(
      onRefresh: _recharger,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          const HomeHeader(prenom: 'Abir'),

          const SizedBox(height: 20),

          const SearchBox(),

          const SizedBox(height: 24),

          if (destinations.isNotEmpty)
            HeroBanner(destination: destinations.first),

          const SizedBox(height: 24),

          const SectionTitle(title: 'Catégories'),

          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((c) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: _categorie == c,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _categorie = c;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          const SectionTitle(
            title: 'Populaires',
            action: 'Voir tout',
          ),

          const SizedBox(height: 12),

          if (destinations.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Aucune destination disponible.'),
              ),
            )
          else if (filtrees.isEmpty)
            const Center(
              child: Text(
                'Aucune destination dans cette catégorie.',
              ),
            )
          else
            ...filtrees.map(
              (d) => DestinationCard(
                key: ValueKey(d.id),
                destination: d,
              ),
            ),
        ],
      ),
    );
  }

  // Charger les destinations
  Widget _construireExplorer() {
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return ErreurReseau(
            message: 'Impossible de charger les destinations.',
            onReessayer: _recharger,
          );
        }

        final destinations = snapshot.data ?? [];

        return _construireAccueil(destinations);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _onglet == 0
            ? _construireExplorer()
            : _onglet == 1
                ? const Center(
                    child: Text('Bientôt disponible'),
                  )
                : const MesReservationsScreen(),
      ),

      // Navigation principale
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (index) {
          setState(() {
            _onglet = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage),
            label: 'Voyages',
          ),
        ],
      ),
    );
  }
}
