import 'MedicamentCartItem.dart';

class Commande {
  final int numero;
  final DateTime date;
  final bool avecLivraison;
  final List<MedicamentCartItem> items;
  final double montant;
  final String pharmacie;

  Commande({
    required this.numero,
    required this.date,
    required this.avecLivraison,
    required this.items,
    required this.montant,
    required this.pharmacie,
  });

}
