
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'Models/CommandeManager.dart';
import 'commande.dart'; // Importez CommandeManager

class ListeCommandesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final commandes = CommandeManager().commandes; // Récupérer les commandes via le singleton

    Future<int> getIdUtilisateurFromSource(String email, String motDePasse) async {
      try {
        // Envoi de la requête POST à l'API
        var response = await http.post(
          Uri.parse('http://192.168.1.195:8080/users/connexion.php'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "mot_de_passe": motDePasse}),
        );

        // Vérification de la réponse
        if (response.statusCode == 200) {
          // Analyse de la réponse JSON pour obtenir l'ID utilisateur
          Map<String, dynamic> data = jsonDecode(response.body);
          int idUtilisateur = data['id_utilisateur'];
          print('ID utilisateur récupéré avec succès: $idUtilisateur');
          return idUtilisateur;
        } else {
          // Gestion des erreurs de réponse
          print('Erreur lors de la récupération de l\'ID utilisateur: ${response.statusCode}');
          return -1; // Retourner une valeur par défaut ou gérer l'erreur selon les besoins
        }
      } catch (e) {
        // Gestion des erreurs d'exception
        print('Exception lors de la récupération de l\'ID utilisateur: $e');
        return -1; // Retourner une valeur par défaut ou gérer l'erreur selon les besoins
      }
    }


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
            onTap: () async {

              String email = 'email_utilisateur';
              String motDePasse = 'mot_de_passe_utilisateur';

              int? idUtilisateur = await getIdUtilisateurFromSource(email , motDePasse);
              // Naviguer vers les détails de la commande si nécessaire
            if (idUtilisateur != null) {
            // Naviguer vers les détails de la commande si nécessaire
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => CommandePage(
                  commande: commande,
                  items: commande.items,
                  idUtilisateur: idUtilisateur,
                ),
               ),
             );
            } else {
                // Afficher un message d'erreur ou gérer la situation où l'ID de l'utilisateur est null
                print('Erreur: Impossible de récupérer l\'ID de l\'utilisateur.');
                }
              },
          );
        },
      ),
    );
  }
}
