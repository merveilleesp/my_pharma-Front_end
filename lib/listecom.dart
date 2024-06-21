
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/medicaments.dart';
import 'package:my_pharma/pharmacies.dart';
import 'package:my_pharma/profil.dart';
import 'API.dart';
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
          Uri.parse(API.url+'/users/connexion.php'),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Nom Utilisateur'),
              accountEmail: Text('email@example.com'),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF009688),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Accueil()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_pharmacy),
              title: const Text('Pharmacies'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Pharmacies()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.healing),
              title: const Text('Medicaments'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Medicaments()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoris'),
              onTap: () {
                Favoris favoris = Favoris();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavorisPage(favoris: favoris,)),
                );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Liste de courses'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListeCommandesPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Assurances'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Assurance()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profil'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profil()));
              },
            ),
            ListTile(
              title: const Text('Inviter un Ami'),
              leading: const Icon(Icons.person_add),
              onTap: () {
                // Action à effectuer lorsque l'option Inviter un Ami est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Nous Contacter'),
              leading: const Icon(Icons.contact_mail),
              onTap: () {
                // Action à effectuer lorsque l'option Nous Contacter est sélectionnée
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Connexion()));
              },
            ),
          ],
        ),
      ),
      body: commandes.isEmpty
          ? Center(
        child: Text('Aucune commande disponible'),
      )
          : ListView.builder(
        itemCount: commandes.length,
        itemBuilder: (context, index) {
          final commande = commandes[index];
          return Card (
            child: ListTile(
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
            ),
          );
        },
      ),
    );
  }
}
