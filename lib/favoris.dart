import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/listecom.dart';
import 'package:my_pharma/medicaments.dart';
import 'package:my_pharma/pharmacies.dart';
import 'package:my_pharma/profil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Functions.dart';
import 'Models/Medicament.dart';
import 'Models/Utilisateur.dart';

class FavorisPage extends StatefulWidget {
  final Favoris favoris;

  FavorisPage({required this.favoris});

  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {

  List<Medicament> _favorisList = [];

  Utilisateur? utilisateur;

  @override
  void initState() {
    super.initState();
    _loadFavoris();
    loadUser().then((value) => utilisateur = value);
  }

  void _loadFavoris() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorisStringList = prefs.getStringList('favoris');
    print(favorisStringList);
    if (favorisStringList != null) {
      setState(() {
        _favorisList = favorisStringList
            .map((item) => Medicament.fromJson(json.decode(item)))
            .toList();
        print(_favorisList);
      });
    }
  }

  void _addFavori(Medicament medicament) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorisStringList = prefs.getStringList('favoris');

    if (favorisStringList == null) {
      favorisStringList = [];
    }

    favorisStringList.add(json.encode(medicament.toJson()));

    await prefs.setStringList('favoris', favorisStringList);

    setState(() {
      _favorisList.add(medicament);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoris',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(
          color: Colors.white,
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
                  MaterialPageRoute(builder: (context) => FavorisPage(favoris: widget.favoris)),
                );
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
      body: _favorisList.isEmpty
          ? Center(
        child: Text(
          "Aucun médicament n'a été ajouté",
          style: TextStyle(fontSize: 20.0),
        ),
      )
          : ListView.builder(
        itemCount: _favorisList.length,
        itemBuilder: (BuildContext context, int index) {
          final Medicament medicament = _favorisList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${medicament.nom}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Présentation: ${medicament.presentation}',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Dosage: ${medicament.dosage}',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${medicament.prix} Fcfa',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(width: 100),
                      IconButton(
                        icon: Icon(Icons.shopping_cart, color: Colors.teal),
                        onPressed: () {
                          // Action lorsque l'utilisateur appuie sur l'icône du panier
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
