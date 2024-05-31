import 'Commande.dart';

class CommandeManager {
  // Singleton
  static final CommandeManager _instance = CommandeManager._internal();

  factory CommandeManager() {
    return _instance;
  }

  CommandeManager._internal();

  // Liste des commandes
  List<Commande> commandes = [];

  // Ajouter une commande
  void ajouterCommande(Commande commande) {
    commandes.add(commande);
  }
}

