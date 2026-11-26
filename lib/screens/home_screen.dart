import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../services/api_service.dart';

import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart';
import '../widgets/destination_card.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;

  // Future qui contient les destinations reçues du serveur
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

    // On lance la requête une seule fois
    _futurDestinations = ApiService.getDestinations();
  }

  // Filtrer les destinations selon la catégorie
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
      // L'erreur sera affichée par FutureBuilder
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

          // Bannière seulement si la liste n'est pas vide
          if (destinations.isNotEmpty)
            HeroBanner(destination: destinations.first),

          const SizedBox(height: 24),

          const SectionTitle(title: 'Catégories'),

          const SizedBox(height: 12),

          // Les catégories
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

          // Aucune destination
          if (destinations.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Aucune destination disponible.'),
              ),
            )

          // Aucune destination dans cette catégorie
          else if (filtrees.isEmpty)
            const Center(
              child: Text(
                'Aucune destination dans cette catégorie.',
              ),
            )

          // Afficher les destinations
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

  // Charger les destinations avec FutureBuilder
  Widget _construireExplorer() {
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,

      builder: (context, snapshot) {

        // État 1 : chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // État 2 : erreur
        if (snapshot.hasError) {
          return ErreurReseau(
            message: 'Impossible de charger les destinations.',
            onReessayer: _recharger,
          );
        }

        // État 3 : données reçues
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
            : const Center(
                child: Text('Bientôt disponible'),
              ),
      ),

      // Garder la navigation existante
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
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Widget affiché en cas d'erreur réseau
class ErreurReseau extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;

  const ErreurReseau({
    super.key,
    required this.message,
    required this.onReessayer,
  });

  @override
  Widget build(BuildContext context) {
    final couleurErreur = Theme.of(context).colorScheme.error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 60,
              color: couleurErreur,
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              'Vérifiez que json-server est lancé.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            FilledButton.tonalIcon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
