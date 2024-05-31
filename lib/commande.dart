import 'package:flutter/material.dart';
import 'Models/Commande.dart';
import 'Models/MedicamentCartItem.dart';
import 'medicaments.dart';

import 'medicaments.dart';




class CommandePage extends StatelessWidget {
  final Commande commande;
  final List<MedicamentCartItem> items;

  CommandePage({required this.commande, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Commande'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente (Panier)
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commande #${commande.numero}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${commande.date.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Heure: ${commande.date.hour}:${commande.date.minute}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Avec Livraison: ${commande.avecLivraison ? 'Oui' : 'Non'}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Articles commandés:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(commande.pharmacie),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(item.medicament.nom),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantité: ${item.quantity}'),
                          Text('Prix unitaire: ${item.medicament.prix} Fcfa'),
                          Text('Total: ${(item.medicament.prix * item.quantity).toStringAsFixed(2)} Fcfa'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${commande.montant.toStringAsFixed(2)} Fcfa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

