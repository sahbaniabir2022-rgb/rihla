import 'package:flutter/material.dart';

class ErreurReseau extends StatelessWidget {
  final String message;
  final VoidCallback? onReessayer;

  const ErreurReseau({
    super.key,
    this.message = 'Impossible de contacter le serveur.',
    this.onReessayer,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (onReessayer != null)
              ElevatedButton(
                onPressed: onReessayer,
                child: const Text('Réessayer'),
              ),
          ],
        ),
      ),
    );
  }
}