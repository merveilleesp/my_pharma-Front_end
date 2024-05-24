import 'package:flutter/material.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/commandes.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/medicaments.dart';
import 'package:my_pharma/profil.dart';


class Panier extends StatelessWidget {
  final List<Medicament> panier;

  const Panier({required this.panier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading : IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'PANIER',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF009688),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        /*shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),*/
        centerTitle: true,
      ),
      /*drawer: Drawer(
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
                );
                // Action à effectuer lorsque l'option Accueil est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mon Profil'),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profil()),
                ); // Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Assurances'), // Ajout de l'élément "Assurances"
              leading: const Icon(Icons.security), // Icône pour "Assurances"
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Assurance()),
                ); // Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mes Commandes'),
              leading: const Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Commandes()),
                ); // Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mes Favoris'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favoris()),
                ); // Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
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
                ); // Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
          ],
        ),
      ),*/
      body: ListView.builder(
        itemCount: panier.length,
        itemBuilder: (BuildContext context, int index) {
          final medicament = panier[index];
          return Card(
            child: ListTile(
              title: Text(medicament.nom),
              subtitle: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      // Implémentez la logique pour diminuer la quantité du médicament
                    },
                  ),
                  Text('1'), // Remplacer par la quantité réelle
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Implémentez la logique pour augmenter la quantité du médicament
                    },
                  ),
                ],
              ),
              trailing: Text('${medicament.prix} Fcfa'),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Implémentez la logique pour valider le panier
            },
            child: Text('Valider le panier'),
          ),
        ),
      ),
      /*bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Total: ${_calculateTotal()} Fcfa',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),*/
    );
  }

  double _calculateTotal() {
    double total = 0;
    for (var medicament in panier) {
      total += medicament.prix; // Utilisez la propriété prix du médicament
    }
    return total;
  }

  String _formatPrix(Medicament medicament) {
    return medicament.prix.toStringAsFixed(2); // Formatez le prix
  }
}
