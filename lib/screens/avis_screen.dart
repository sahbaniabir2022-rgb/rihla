import 'package:flutter/material.dart';
import '../models/avis.dart';
import '../models/destination.dart';
class AvisScreen extends StatefulWidget {
  final Destination destination;
  const AvisScreen({super.key, required this.destination});

  @override
  State<AvisScreen> createState() => _AvisScreenState();
}

class _AvisScreenState extends State<AvisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomCtrl = TextEditingController();
  final _commentaireCtrl = TextEditingController();

  int _note = 0;
  bool _noteErreur = false;
  bool _dejaEnvoye = false;

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _commentaireCtrl.dispose();
    super.dispose();
  }

  void _publier() {
    final formOk = _formKey.currentState!.validate();
    final noteOk = _note > 0;

    setState(() {
      _dejaEnvoye = true;
      _noteErreur = !noteOk;
    });

    if (!formOk || !noteOk) return;

    Navigator.pop(
      context,
      Avis(
        auteur: _prenomCtrl.text.trim(),
        note: _note,
        commentaire: _commentaireCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final couleurErreur = Theme.of(context).colorScheme.error;

    return Scaffold(
      appBar: AppBar(title: Text('Avis sur ${widget.destination.nom}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: _dejaEnvoye
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Votre note',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < _note ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setState(() {
                      _note = i + 1;
                      _noteErreur = false;
                    }),
                  );
                }),
              ),
              if (_noteErreur)
                Text('Choisissez une note de 1 à 5 étoiles',
                    style: TextStyle(color: couleurErreur, fontSize: 12)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prenomCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().length < 2)
                    ? 'Entrez au moins 2 caractères'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentaireCtrl,
                maxLines: 4,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Commentaire',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.comment_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().length < 20)
                    ? 'Entrez au moins 20 caractères'
                    : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _publier,
                  child: const Text('Publier'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}