/*import 'package:flutter/material.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/profil.dart';

class Commande {
  final String numero;
  final String etat;

  Commande(this.numero, this.etat);
}

class Commandes extends StatelessWidget {
  final List<Commande> commandes = [
    Commande('123', 'En cours'),
    Commande('456', 'Annulée'),
    Commande('789', 'Réceptionnée'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'COMMANDES',
          style: TextStyle(
            color: Colors.white, // Texte en blanc
          ),
        ),
        backgroundColor: const Color(0xFF009688), // Arrière-plan vert
        iconTheme: const IconThemeData(
          color: Colors.white, // Icône en blanc
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        centerTitle: true,
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
              title: const Text('Accueil'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Accueil()),
                );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mon Profil'),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profil()),
                );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Assurances'), // Ajout de l'élément "Assurances"
              leading: const Icon(Icons.security), // Icône pour "Assurances"
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Assurance()),
                );// Action à effectuer lorsque l'option Assurances est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mes Commandes'),
              leading: const Icon(Icons.shopping_cart),
              onTap: () {
               // Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mes Favoris'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favoris()),
                );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Suggérer un Produit'),
              leading: const Icon(Icons.lightbulb),
              onTap: () {
                // Action à effectuer lorsque l'option Suggérer un Produit est sélectionnée
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
              title: const Text('Mentions Légales'),
              leading: const Icon(Icons.gavel),
              onTap: () {
                // Action à effectuer lorsque l'option Mentions Légales est sélectionnée
              },
            ),
            ListTile(
              title: const Text('A Propos de Nous'),
              leading: const Icon(Icons.info),
              onTap: () {
                // Action à effectuer lorsque l'option A Propos de Nous est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Se Déconnecter'),
              leading: const Icon(Icons.logout),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Connexion()),
                );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0), // Ajoute un espacement de 16 pixels en haut
        child: ListView.builder(
          itemCount: commandes.length,
          itemBuilder: (context, index) {
          return ListTile(
            title: Text('Commande #${commandes[index].numero}'),
            subtitle: Text(commandes[index].etat),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProduitsCommandesPage(commande: commandes[index])),
              );
            },
          );
        },
      ),
      ),
    );
  }
}

class ProduitsCommandesPage extends StatelessWidget {
  final Commande commande;

  const ProduitsCommandesPage({required this.commande});

  @override
  Widget build(BuildContext context) {
    // Implémentez l'affichage des produits commandés pour la commande sélectionnée ici
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits de la Commande ${commande.numero}'),
      ),
      body: Center(
        child: Text('Liste des produits pour la commande ${commande.numero}'),
      ),
    );
  }
}
*/