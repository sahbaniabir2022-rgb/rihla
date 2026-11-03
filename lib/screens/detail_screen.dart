import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../widgets/favorite_button.dart';
/// Devoir TP3 — Écran de détail d'une destination (version du kit TP4).
/// À relier aux cartes au palier 2 du TP4.
class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _voyageurs = 1;

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 340,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(d.image, fit: BoxFit.cover),
                Positioned(
                  top: 48,
                  left: 16,
                  child: _BoutonRond(
                    child: IconButton(
                      tooltip: 'Retour',
                      onPressed: () {}, // TP4 palier 2
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                const Positioned(
                  top: 48,
                  right: 16,
                  child: _BoutonRond(child: FavoriteButton()),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.nom,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.place_outlined,
                                  size: 18, color: cs.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(d.region,
                                  style: TextStyle(color: cs.onSurfaceVariant)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text('${d.note}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                          icone: Icons.schedule, label: 'Durée', valeur: d.duree),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoTile(
                          icone: Icons.category_outlined,
                          label: 'Type',
                          valeur: d.categorie),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: _InfoTile(
                          icone: Icons.groups_outlined,
                          label: 'Groupe',
                          valeur: 'Max 12'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('À propos',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(d.description,
                    style: TextStyle(height: 1.5, color: cs.onSurfaceVariant)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text('Voyageurs',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    IconButton.outlined(
                      onPressed: _voyageurs > 1
                          ? () => setState(() => _voyageurs--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '$_voyageurs',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton.outlined(
                      onPressed: () => setState(() => _voyageurs++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: TextStyle(color: cs.onSurfaceVariant)),
                  Text(
                    '${d.prix * _voyageurs} DT',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FilledButton(
                  onPressed: () {}, // TP4 palier 3 puis 5
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text('Réserver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoutonRond extends StatelessWidget {
  final Widget child;

  const _BoutonRond({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valeur;

  const _InfoTile({
    required this.icone,
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icone, color: cs.primary),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
          Text(valeur, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
