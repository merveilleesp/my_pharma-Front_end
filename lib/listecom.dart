
import 'package:flutter/material.dart';
import 'Models/CommandeManager.dart';
import 'commande.dart'; // Importez CommandeManager

class ListeCommandesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final commandes = CommandeManager().commandes; // Récupérer les commandes via le singleton

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Commandes'),
      ),
      body: commandes.isEmpty
          ? Center(
        child: Text('Aucune commande disponible'),
      )
          : ListView.builder(
        itemCount: commandes.length,
        itemBuilder: (context, index) {
          final commande = commandes[index];
          return ListTile(
            title: Text('Commande #${commande.numero}'),
            onTap: () {
              // Naviguer vers les détails de la commande si nécessaire
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommandePage(
                    commande: commande,
                    items: commande.items,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
