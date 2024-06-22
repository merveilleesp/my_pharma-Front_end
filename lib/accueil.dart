import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/listecom.dart';
import 'package:my_pharma/medicaments.dart';
import 'package:my_pharma/pharmacies.dart';
import 'package:my_pharma/profil.dart';
import 'package:my_pharma/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Functions.dart';
import 'Models/Utilisateur.dart';

import 'API.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}


class _AccueilState extends State<Accueil> {

  Favoris favoris = Favoris();
  dynamic stockclasse;
  bool isOK = false;
  Position? _currentPosition;

  Utilisateur? utilisateur;



  @override
  void initState() {
    super.initState();
    loadUser().then((value) => utilisateur = value);
    getClasse().then((value) {
      setState(() {
        stockclasse = value;
        isOK = true;
      });
    });
    _checkLocationPermission();
  }
  final TextEditingController _controller = TextEditingController();

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog();
      return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Activer la localisation"),
          content: Text("Cette application nécessite l'activation de la localisation pour fonctionner correctement."),
          actions: <Widget>[
            TextButton(
              child: Text("Non merci"),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
            ),
            TextButton(
              child: Text("Activer"),
              onPressed: () async {
                Navigator.of(context).pop(); // Fermer le dialogue avant de vérifier la localisation
                bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                if (!serviceEnabled) {
                  serviceEnabled = await Geolocator.openLocationSettings();
                  if (!serviceEnabled) {
                    _showLocationDialog();
                    return;
                  }
                }
                LocationPermission permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                  if (permission == LocationPermission.denied) {
                    _showLocationDialog();
                    return;
                  }
                }
                if (permission == LocationPermission.deniedForever) {
                  _showLocationDialog();
                  return;
                }
                _getCurrentLocation();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSearchIconTap() {
    if (_controller.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage(nom_medoc: _controller.text,)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Le champ de recherche est vide')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
        return MaterialApp(
              debugShowCheckedModeBanner: false,
            home: Scaffold(
                appBar:AppBar(
                  title: const Text(
                    'Bonjour',
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
                      UserAccountsDrawerHeader(
                        accountName: utilisateur != null
                            ? Text('${utilisateur!.prenom} ${utilisateur!.nom}')
                            : Text('Aucun utilisateur n\'est connecté'),
                        accountEmail: utilisateur != null
                            ? Text('${utilisateur!.email}')
                            : Text(''),
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
                // Fin de la navbar
                //corps de la page la partie scrollable
                body: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        ),
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            /*if (_currentPosition != null)
                              Text('Latitude: ${_currentPosition?.latitude}, Longitude: ${_currentPosition?.longitude}'),
                            const SizedBox(height: 10),*/
                            //input/border de recherche
                             Padding(
                              padding: EdgeInsets.all(16.0),
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black, width: 1.0)),
                                  contentPadding: EdgeInsets.only(left: 20.0),
                                  suffixIcon: GestureDetector(
                                    onTap: _onSearchIconTap,
                                    child: Icon(Icons.search),
                                  ),
                                ),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            // fin input/border de recherche
                            const SizedBox(height: 10),
                            //Titre du scroll des symptômes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Catégories',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF009688)),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: TextButton(
                                    onPressed: () {
                                      // Action lorsque le bouton "Voir Plus" est pressé
                                    },
                                    child: const Text(
                                      'Voir Plus',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF009688),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            //Fin titre du scroll des symptômes
                            const SizedBox(height: 10),
                            //Début du scroll des symptômes
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: !isOK
                                  ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                                  : Row(
                                children: List.generate(
                                  8,
                                      (index) => Column(
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          // Récupérer les médicaments pour la classe thérapeutique cliquée
                                          List<String> medicaments = await getMedicamentsByClasse(stockclasse[index][0]);
                                          // Afficher les médicaments dans un nouveau widget ou une boîte de dialogue
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Médicaments de la classe ${stockclasse[index][0]}'),
                                              content: Container(
                                                width: double.maxFinite,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: medicaments.map((medicament) => ListTile(title: Text(medicament))).toList(),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text('Fermer'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                                          shape: MaterialStateProperty.all(const CircleBorder()),
                                        ),
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          margin: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF009688),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 75, // Limite la largeur du conteneur de texte
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          '${stockclasse[index][0]}',
                                          textAlign: TextAlign.center, // Centre le texte
                                          style: TextStyle(
                                            color: Color(0xFF009688),
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis, // Ajoute des points de suspension si le texte est trop long
                                          maxLines: 2, // Limite à 2 lignes de texte
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //Fin du scroll des symptômes
                            const SizedBox(height: 25),
                            Image.asset('assets/accueil_ip.png',
                                width: constraints.maxWidth, fit: BoxFit.contain),
                            //Début des 4 boutons principaux
                            Container(
                              color: const Color(0xFFF2EFEF), // Couleur de fond du rectangle
                              padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 30), // Espacement intérieur du rectangle
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly, // Alignement des colonnes
                                children: [
                                  Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Medicaments()),
                                          );
                                        },
                                        style: ButtonStyle(
                                          padding:
                                              MaterialStateProperty.all(EdgeInsets.zero),
                                        ),
                                        child: Container(
                                          width: 160,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            shape: BoxShape.rectangle,
                                            color: const Color(0xFF009688),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "MEDICAMENTS",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Rectangle 1
                                      const SizedBox(
                                          height: 20), // Espacement entre les rectangles
                                      // Rectangle 2
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          padding:
                                              MaterialStateProperty.all(EdgeInsets.zero),
                                        ),
                                        child: Container(
                                          width: 160,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            shape: BoxShape.rectangle,
                                            color: const Color(0xFF009688),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "IMPORTER UNE ORDONNANCE",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Deuxième colonne avec deux rectangles
                                  Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Pharmacies()),
                                          );
                                        },
                                        style: ButtonStyle(
                                          padding:
                                              MaterialStateProperty.all(EdgeInsets.zero),
                                        ),
                                        child: Container(
                                          width: 160,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            shape: BoxShape.rectangle,
                                            color: const Color(0xFF009688),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "PHARMACIES",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Rectangle 1
                                      const SizedBox(
                                          height: 20), // Espacement entre les rectangles
                                      // Rectangle 2
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          padding:
                                              MaterialStateProperty.all(EdgeInsets.zero),
                                        ),
                                        child: Container(
                                          width: 160,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            shape: BoxShape.rectangle,
                                            color: const Color(0xFF009688),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "INFRASTRUCTURES MEDICALES",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //Fin des 4 boutons principaux
                            const SizedBox(height: 25),
                            //Titre les produits populaires
                            const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Produits populaires',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF009688)),
                                )),
                            //fin du titre pour les produits populaires
                            //Début du scroll pour les produits populaires
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: List.generate(
                                    8,
                                    (index) => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 91,
                                              height: 91,
                                              margin: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                    color: const Color(0xFF009688), width: 1.0),
                                                borderRadius: BorderRadius.circular(9.5),
                                              ),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(left: 8),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      const Text(
                                                        "Panadol comprimé",
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                      const Text(
                                                        "Prix",
                                                        style: TextStyle(
                                                            color: Color(0xFF009688),
                                                            fontSize: 12),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          // Action à effectuer lors du clic sur le bouton "Ajouter"
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          minimumSize: const Size(25, 16),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    8.0),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Ajouter au panier',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      )
                                                    ]))
                                          ],
                                        )),
                              ),
                            ),
                            //fin du scroll pour les produits populaires
                            const SizedBox(height: 25),
                            //Les Marques
                            Container(
                                color: const Color(0xFFF2EFEF), // Couleur de fond du rectangle
                                padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 30), // Espacement intérieur du rectangle
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Padding(
                                          padding: EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            'Les marques',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF009688)),
                                          )),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Row(
                                          children: List.generate(
                                              8,
                                              (index) => Column(
                                                    children: [
                                                      Container(
                                                        width: 75,
                                                        height: 75,
                                                        margin: const EdgeInsets.all(8),
                                                        decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Color(0xFF009688),
                                                        ),
                                                      ),
                                                      const Text(
                                                        "Traitement",
                                                        style: TextStyle(
                                                            color: Color(0xFF009688),
                                                            fontSize: 12),
                                                      )
                                                    ],
                                                  )),
                                        ),
                                      ),
                                    ])),
                            // Fin de la partie Les Marques
                          ],
                    ),
                      ),
                  );
                }
                )
            ),
    );
  }
}


