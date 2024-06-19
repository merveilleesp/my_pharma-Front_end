import 'dart:convert';

import 'package:flutter/material.dart';
import 'Models/Commande.dart';
import 'Models/MedicamentCartItem.dart';
import 'package:http/http.dart' as http;
import 'medicaments.dart';



class CommandePage extends StatelessWidget {
  final Commande commande;
  final List<MedicamentCartItem> items;
  final int idUtilisateur;

  CommandePage({required this.commande, required this.items, required this.idUtilisateur});


  Future<void> validerCommande(int idUtilisateur) async {
    print('Pharmacie: ${commande.pharmacie}');
    print('Numero: ${commande.numero}');
    print('ID Utilisateur: $idUtilisateur');
    print('Date: ${commande.date}');

    Map<String, dynamic> data = {
      'id_utilisateur': idUtilisateur,
      'numero': commande.numero,
      'date': commande.date.toIso8601String(),
      'avecLivraison': commande.avecLivraison,
      'pharmacie': commande.pharmacie,
      'montant': commande.montant,
      'details': items.map((item) => {
        'designation': item.medicament.nom,
        'quantite': item.quantity,
        'prix_unitaire': item.medicament.prix,
        'total_produit': item.medicament.prix * item.quantity,
      }).toList(),
    };

    try {
      var response = await http.post(
        Uri.parse('http://192.168.1.194:8080/users/commande.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Commande validée: ${response.body}');
      } else {
        print('Erreur lors de la validation de la commande: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de la validation de la commande: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details de la commande',
          style: TextStyle(
            color: Colors.white, // Texte en blanc
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Icône en blanc
        ),
        backgroundColor: Colors.teal,
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
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  validerCommande(idUtilisateur);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                  primary: Colors.teal,
                ),
                child: Text(
                  'Valider ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

