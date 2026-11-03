import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final bool initial;
  final ValueChanged<bool>? onChanged;

  const FavoriteButton({
    super.key,
    this.initial = false,
    this.onChanged,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _favori = widget.initial;

  void _basculer() {
    setState(() => _favori = !_favori);
    widget.onChanged?.call(_favori);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(_favori ? 'Ajouté aux favoris' : 'Retiré des favoris'),
        duration: const Duration(seconds: 1),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _basculer,
      icon: Icon(
        _favori ? Icons.favorite : Icons.favorite_border,
        color: _favori ? Colors.red : null,
      ),
    );
  }
}