import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../screens/detail_screen.dart';
import 'favorite_button.dart';

// Q1 : Oui, le filtre « Désert » est conservé. Navigator.push ajoute
//      DetailScreen au-dessus de l'accueil dans la pile, sans détruire
//      l'accueil. Son State (donc le filtre) reste en vie dessous.
//      pop() retire seulement l'écran du dessus.
// Q2 : DetailScreen reçoit la destination par son constructeur (paramètre
//      required destination), comme au TP 3.
// Q3 : Sans clipBehavior, l'effet d'encre déborde des coins arrondis :
//      on voit un carré qui dépasse de la carte.

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(destination: destination),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  destination.image,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      destination.nom,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 16,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            destination.region,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text('${destination.note}'),
                        const Spacer(),
                        Text(
                          '${destination.prix} DT',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Palier 6 : le bouton favori (son état est local)
              const FavoriteButton(),
            ],
          ),
        ),
      ),
    );
  }
}