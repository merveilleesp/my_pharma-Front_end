import 'package:flutter/material.dart';
//import 'dart:convert';
import 'dart:math';

import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/commandes.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/profil.dart'; // Importation de la bibliothèque mathématique pour générer une distance aléatoire

class Pharmacie {
  final String nom;
  bool estDeGarde;
  String distance;

  Pharmacie({
    required this.nom,
    required this.estDeGarde,
    required this.distance,
  });

  // Méthode pour changer l'état de garde chaque semaine
  void changerEtatDeGarde() {
    estDeGarde = !estDeGarde;
  }

  // Méthode pour mettre à jour la distance
  void mettreAJourDistance() {
    // Simulation de la mise à jour de la distance avec une valeur aléatoire pour cet exemple
    distance = '${(Random().nextDouble() * 10).toStringAsFixed(2)} km';
  }
}

class Pharmacies extends StatefulWidget {
  @override
  _PharmaciesState createState() => _PharmaciesState();
}

class _PharmaciesState extends State<Pharmacies> {
  bool toggleValue = false;
  List<Pharmacie> pharmacies = [];
  List<Pharmacie> pharmaciesInitiales = []; // Copie de la liste initiale des pharmacies

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }

  // Méthode pour mettre à jour l'état de garde chaque semaine
  void mettreAJourEtatDeGarde() {
    for (var pharmacie in pharmacies) {
      pharmacie.changerEtatDeGarde();
    }
  }

  // Méthode pour mettre à jour les distances chaque fois que nécessaire
  void mettreAJourDistances() {
    for (var pharmacie in pharmacies) {
      pharmacie.mettreAJourDistance();
    }
  }

  // Fonction pour générer des données de pharmacies (pour cet exemple)
  List<Pharmacie> genererDonneesPharmacies() {
    return List.generate(20, (index) {
      return Pharmacie(
        nom: 'Pharmacie ${index + 1}',
        estDeGarde: Random().nextBool(), // Etat de garde aléatoire pour cet exemple
        distance: '${(Random().nextDouble() * 10).toStringAsFixed(2)} km', // Distance aléatoire pour cet exemple
      );
    });
  }

  @override
  void initState() {
    super.initState();
    pharmacies = genererDonneesPharmacies();
    pharmaciesInitiales = List.from(pharmacies);// Générer les données initiales des pharmacies
  }

  @override
  Widget build(BuildContext context) {
    List<Pharmacie> pharmaciesAffichees = toggleValue
        ? pharmaciesInitiales.where((pharmacie) => pharmacie.estDeGarde).toList()
        : pharmacies;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PHARMACIES',
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
                  );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
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
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 20.0),
                      ),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOUTES LES PHARMACIES',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF009688),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: toggleValue
                              ? Colors.greenAccent[100]
                              : Colors.grey.withOpacity(0.5),
                        ),
                        child: Stack(
                          children: <Widget>[
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeIn,
                              top: 2,
                              left: toggleValue ? 50.0 : 0.0,
                              right: toggleValue ? 0.0 : 50.0,
                              child: InkWell(
                                onTap: toggleButton,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 1000),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                      child: child,
                                      scale: animation,
                                    );
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: toggleValue
                                          ? null
                                          : Border.all(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      itemCount: pharmaciesAffichees.length,
                      itemBuilder: (BuildContext context, int index) {
                        Pharmacie pharmacie = pharmaciesAffichees[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              print('Pharmacie ${index + 1} sélectionnée');
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 3,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.white.withOpacity(0.5),
                              minimumSize: const Size(100, 20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pharmacie.nom,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      Text(
                                        'Distance: ${pharmacie.distance}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  pharmacie.estDeGarde
                                      ? Icons.nightlight_round
                                      : null,
                                  color: pharmacie.estDeGarde
                                      ? Colors.green
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
