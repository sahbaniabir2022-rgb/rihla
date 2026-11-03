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
  final _dateCtrl = TextEditingController(); // P4

  DateTime? _date; // P4 : null tant qu'aucune date n'est choisie
  String _formule = 'Essentiel'; // P4
  bool _conditions = false; // P4
  AutovalidateMode _autoValidation = AutovalidateMode.disabled; // P4

  int get _prixParPersonne => _formule == 'Confort'
      ? (widget.destination.prix * 1.3).round()
      : widget.destination.prix; // P4
  int get _total => _prixParPersonne * widget.voyageurs; // P4

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _dateCtrl.dispose(); // P4
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
    if (v == null || v.trim().isEmpty) return 'Indiquez votre e-mail';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!regex.hasMatch(v.trim())) return 'E-mail invalide (ex. : nom@mail.tn)';
    return null;
  }

  String? _validerTel(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indiquez votre téléphone';
    if (v.trim().length != 8) return '8 chiffres attendus';
    return null;
  }

  // P4 : 4.1 la date de départ
  Future<void> _choisirDate() async {
    final demain = DateTime.now().add(const Duration(days: 1));
    final choisie = await showDatePicker(
      context: context,
      initialDate: _date ?? demain,
      firstDate: demain,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Date de départ',
    );
    // TODO 1 : annulation -> ne rien faire
    if (choisie == null) return;
    // TODO 2 : mémoriser la date et l'afficher en jj/mm/aaaa
    setState(() {
      _date = choisie;
      _dateCtrl.text = '${choisie.day.toString().padLeft(2, '0')}/'
          '${choisie.month.toString().padLeft(2, '0')}/'
          '${choisie.year}';
    });
  }

  void _valider() {
    if (!_formKey.currentState!.validate()) {
      // P4 : après un premier échec, les erreurs se mettent à jour pendant la saisie
      setState(() => _autoValidation = AutovalidateMode.onUserInteraction);
      return;
    }
    // Provisoire : sera remplacé au palier 5
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulaire valide')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Réserver')),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidation, // P4
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Text('Vos coordonnées',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nomCtrl,
                decoration: _deco('Nom complet', Icons.person_outline),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validerNom,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: _deco('E-mail', Icons.mail_outline),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validerEmail,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              // P4 : titre + date
              Text('Votre voyage',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateCtrl,
                readOnly: true, // pas de clavier
                onTap: _choisirDate, // on ouvre le calendrier
                decoration:
                    _deco('Date de départ', Icons.calendar_month_outlined),
                validator: (_) => _date == null ? 'Choisissez une date' : null,
              ),
              const SizedBox(height: 16),
              // P4 : 4.2 la formule
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                      value: 'Essentiel',
                      label: Text('Essentiel'),
                      icon: Icon(Icons.backpack_outlined)),
                  ButtonSegment(
                      value: 'Confort',
                      label: Text('Confort +30 %'),
                      icon: Icon(Icons.hotel_outlined)),
                ],
                selected: {_formule}, // un Set : ici un seul élément
                onSelectionChanged: (choix) {
                  // TODO 3
                  setState(() => _formule = choix.first);
                },
              ),
              const SizedBox(height: 8),
              // P4 : les conditions
              CheckboxListTile(
                value: _conditions,
                onChanged: (v) => setState(() => _conditions = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text("J'accepte les conditions d'annulation"),
                subtitle: const Text("Annulation gratuite jusqu'à 48 h avant"),
              ),
            ],
          ),
        ),
      ),
      // P4 : barre du bas avec le prix et le bouton désactivable
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_prixParPersonne DT × ${widget.voyageurs}',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                  Text(
                    '$_total DT',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _conditions ? _valider : null, // null = grisé
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmer'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Q1 (palier 3). validate() parcourt tous les FormField présents dans la Form
//     (retrouvée via _formKey), appelle le validator de chacun et affiche les
//     messages d'erreur. Elle renvoie un bool : true si tous les validators ont
//     renvoyé null, false sinon. Elle ne vérifie que les champs qui existent :
//     d'où Column + SingleChildScrollView (une ListView ne construit que les
//     éléments visibles).
// Q2 (palier 3). inputFormatters agit pendant la frappe : il bloque les
//     caractères non voulus. validator juge la valeur finale à la validation
//     (ex. 5 chiffres : acceptés par le formatter, refusés par le validator).
// Q3 (palier 3). Un TextEditingController garde des ressources et des
//     écouteurs en mémoire. Sans dispose(), ils restent alloués : fuite mémoire.
//
// Q1 (palier 4). Le champ date est en readOnly pour que l'utilisateur ne puisse
//     pas taper du texte libre : il doit passer par le calendrier, qui garantit
//     une date valide, au bon format et comprise entre demain et un an (firstDate
//     / lastDate). Sinon on pourrait saisir « abc » ou une date passée, et le
//     texte affiché ne correspondrait plus à _date (resté null), donc le
//     validator et le champ se contrediraient. De plus, le clavier s'ouvrirait
//     pour rien.
// Q2 (palier 4). _total est un getter : il n'a pas de valeur stockée, il
//     recalcule _prixParPersonne * voyageurs à chaque lecture à partir de
//     _formule. Quand setState change _formule, build() est rappelé et lit
//     de nouveau le getter, donc le prix affiché est toujours à jour, sans
//     variable à synchroniser (pas de risque d'oublier de la mettre à jour).