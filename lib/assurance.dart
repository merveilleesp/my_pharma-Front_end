import 'package:flutter/material.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/commandes.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/listecom.dart';
import 'package:my_pharma/profil.dart';

class Assurance extends StatefulWidget {
  @override
  _AssuranceState createState() => _AssuranceState();
}

class _AssuranceState extends State<Assurance> {
  List<String> assurances = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Assurance',
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
                  // Action à effectuer lorsque l'option Assurances est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Mes Commandes'),
                leading: const Icon(Icons.shopping_cart),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListeCommandesPage()),
                  );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
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
        body: _buildAssuranceList(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToAddAssurancePage(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAssuranceList(BuildContext context) {
    return assurances.isEmpty
        ? const Center(
          child: Text(
            'Aucune assurance disponible',
            style: TextStyle(fontSize: 20.0),
          ),
        )
        : ListView.builder(
          itemCount: assurances.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(assurances[index]),
            );
          },
        );
  }

  void _navigateToAddAssurancePage(BuildContext context) async {
    final newAssurance = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAssurance()),
    );
    if (newAssurance != null) {
      setState(() {
        assurances.add(newAssurance);
      });
    }
  }
  void _navigateToAddAssurance(BuildContext context) async {
    final assuranceChoisie = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAssurance()),
    );
    if (assuranceChoisie != null) {
      setState(() {
        assurances.add(assuranceChoisie);
      });
    }
  }
}

class AddAssurance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter une assurance',
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
                // Action à effectuer lorsque l'option Accueil est sélectionnée
                Navigator.pop(
                    context); // Pour fermer le Drawer après la sélection
                Navigator.pushNamed(context,
                    '/Accueil'); // Pour naviguer vers une nouvelle page nommée '/accueil'
              },
            ),
            ListTile(
              title: const Text('Mon Profil'),
              leading: const Icon(Icons.person),
              onTap: () {
                // Action à effectuer lorsque l'option Mon Profil est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Assurances'), // Ajout de l'élément "Assurances"
              leading: const Icon(Icons.security), // Icône pour "Assurances"
              onTap: () {
                // Action à effectuer lorsque l'option Assurances est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mes Commandes'),
              leading: const Icon(Icons.shopping_cart),
              onTap: () {
                // Action à effectuer lorsque l'option Mes Commandes est sélectionnée
              },
            ),
            ListTile(
              title: const Text('Mes Favoris'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                // Action à effectuer lorsque l'option Mes Favoris est sélectionnée
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
                // Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Sélectionnez votre assurance dans la liste ci-dessous :',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Remplacez 5 par le nombre d'assurances dans votre liste
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.local_offer),
                    title: Text('Assurance ${index + 1}'),
                    onTap: () {
                      // Action à effectuer lorsqu'une assurance est sélectionnée
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action à effectuer lorsqu'on appuie sur le bouton Valider
          String assuranceChoisie = "Nom de l'assurance choisie"/* Ajoutez ici le nom de l'assurance choisie */;
          Navigator.pop(context, assuranceChoisie); // Retourner à la page Assurance avec le nom de l'assurance choisie
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}


