import 'package:flutter/material.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/commandes.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/profil.dart';

class Favori {
  final String nom;
  final bool estFavori;

  Favori(this.nom, this.estFavori);
}

class Favoris extends StatefulWidget {
  @override
  _FavorisState createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  List<Favori> favoris = [
    Favori('Élément 1', true),
    Favori('Élément 2', false),
    Favori('Élément 3', true),
    // Ajoutez d'autres éléments de la liste des favoris ici
  ];

  @override
  Widget build(BuildContext context) {
    List<Favori> favorisSelectionnes = favoris.where((favori) => favori.estFavori).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAVORIS',
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
                );
                // Action à effectuer lorsque l'option Assurances est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mes Commandes'),
              leading: const Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Commandes()),
                );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mes Favoris'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                // Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
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
          itemCount: favorisSelectionnes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(favorisSelectionnes[index].nom),
              leading: const Icon(Icons.favorite),
              onTap: () {
                // Action à effectuer lorsque l'utilisateur clique sur un favori
              },
            );
          },
        ),
      ),
    );
  }
}
