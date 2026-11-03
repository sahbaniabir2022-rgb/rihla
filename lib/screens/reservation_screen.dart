import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // pour inputFormatters
import '../models/destination.dart';
import '../models/reservation.dart';

class ReservationScreen extends StatefulWidget {
  final Destination destination;
  final int voyageurs;

  const ReservationScreen({
    super.key,
    required this.destination,
    required this.voyageurs,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();

  @override
  void dispose() {
    // TODO 1
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    super.dispose();
  }

  InputDecoration _deco(String label, IconData icone, {String? aide}) {
    return InputDecoration(
      labelText: label,
      helperText: aide,
      prefixIcon: Icon(icone),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  String? _validerNom(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indiquez votre nom';
    if (v.trim().length < 3) return 'Au moins 3 caractères';
    return null;
  }

  String? _validerEmail(String? v) {
    // TODO 2
    if (v == null || v.trim().isEmpty) return 'Indiquez votre e-mail';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!regex.hasMatch(v.trim())) return 'E-mail invalide (ex. : nom@mail.tn)';
    return null;
  }

  String? _validerTel(String? v) {
    // TODO 3
    if (v == null || v.trim().isEmpty) return 'Indiquez votre téléphone';
    if (v.trim().length != 8) return '8 chiffres attendus';
    return null;
  }

  void _valider() {
    if (!_formKey.currentState!.validate()) return;
    // Provisoire : sera remplacé au palier 5
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulaire valide')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    return Scaffold(
      appBar: AppBar(title: const Text('Réserver')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TODO 4 : récapitulatif
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      d.image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.nom,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('${d.duree} · ${widget.voyageurs} voyageur(s)'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nomCtrl,
                decoration: _deco('Nom complet', Icons.person_outline),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validerNom,
              ),
              const SizedBox(height: 16),
              // TODO 5 : E-mail
              TextFormField(
                controller: _emailCtrl,
                decoration: _deco('E-mail', Icons.mail_outline),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validerEmail,
              ),
              const SizedBox(height: 16),
              // TODO 6 : Téléphone
              TextFormField(
                controller: _telCtrl,
                decoration: _deco(
                  'Téléphone',
                  Icons.phone_outlined,
                  aide: '8 chiffres, sans indicatif',
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                validator: _validerTel,
              ),
            ],
          ),
        ),
      ),
      // TODO 7
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _valider,
            icon: const Icon(Icons.check),
            label: const Text('Confirmer'),
          ),
        ),
      ),
    );
  }
}

// Q1. validate() parcourt tous les FormField de la Form (via _formKey), appelle
//     le validator de chacun et affiche les messages d'erreur. Elle renvoie un
//     bool : true si tous les validators ont renvoyé null, false sinon.
// Q2. inputFormatters agit pendant la frappe (il bloque les caractères non
//     voulus : lettres, au-delà de 8 chiffres). validator agit à la validation
//     et juge la valeur finale (ex. 5 chiffres tapés : acceptés par le
//     formatter, refusés par le validator).
// Q3. Un TextEditingController garde des ressources et des écouteurs en
//     mémoire. Sans dispose() quand l'écran est détruit, ils restent alloués
//     : fuite de mémoire.