import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/detailsmedocs.dart';
import 'package:my_pharma/kkiapays.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/listecom.dart';
import 'package:my_pharma/pharmacies.dart';
import 'package:my_pharma/profil.dart';
import 'Models/Medicament.dart';
import 'Models/MedicamentCartItem.dart';
import 'detailspharma.dart';
import 'panier.dart';



class Favoris {
  List<Medicament> favorisList = [];

  void toggleFavorite(Medicament medicament) {
    if (favorisList.contains(medicament)) {
      favorisList.remove(medicament);
    } else {
      favorisList.add(medicament);
    }
  }

  bool isFavorite(Medicament medicament) {
    return favorisList.contains(medicament);
  }
}



class Medicaments extends StatefulWidget {
  @override
  _MedicamentsState createState() => _MedicamentsState();
}

Future<List<Medicament>> getMedicaments() async {
  var url = Uri.http('192.168.1.194:8080', 'users/recupdonneesme.php');
  try {
    var response = await http.post(url, body: {});
    print('msg: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Medicament> medicaments = List<Medicament>.from(data.map((item) => Medicament.fromJson(item)));
      return medicaments;
    } else {
      print(response.statusCode);
      Fluttertoast.showToast(msg: "Un problème s'est posé, merci de réessayer");
      return [];
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Échec de connexion vers le serveur de DB");
    Fluttertoast.showToast(msg: "Vérifiez votre connexion");
    print(e);
    return [];
  }
}

class _MedicamentsState extends State<Medicaments> {
  bool isFavorite = false;
  List<Medicament> medicaments = [];
  List<Medicament> medicamentsInitials = []; // Copie de la liste initiale des pharmacies
  dynamic stockMedicaments;
  dynamic dataMedicaments;
  bool medocIsReady = false;
  List<MedicamentCartItem> panier = [];
  Favoris favoris = Favoris();// Ajout du panier


  void loadMedoc() {
    getMedicaments().then((value) {
      stockMedicaments = value;
      dataMedicaments = value;
      setState(() {
        medocIsReady = true;
        print(medocIsReady);
      });
    });
  }

  void filterMedicaments(String query) {
    print(query);
    query = query.toUpperCase();
    setState(() {
      if (query.isNotEmpty) {
        stockMedicaments = dataMedicaments.where((medicament) {
          if (medicament.nom.toUpperCase().contains(query)) {
            return true;
          } else {
            return false;
          }
        }).toList();
      } else {
        stockMedicaments = dataMedicaments;
      }
    });
  }



  List<Medicament> genererDonneesMedicaments() {
    return List.generate(350, (index) {
      // Générez un prix aléatoire pour chaque médicament
      final double prix = (index + 1) * 2.5; // Par exemple, un prix simple
      return Medicament(
        id: index + 1,
        nom: 'designation ${index + 1}',
        prix: prix,
        presentation: 'Présentation du médicament ${index + 1}',
        dosage: 'Dosage du médicament ${index + 1}',
      );
    });
  }

  @override
  void initState() {
    loadMedoc();
    super.initState();
    medicaments = genererDonneesMedicaments();
    medicamentsInitials = List.from(medicaments);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MEDICAMENTS',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF009688),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavorisPage(favoris: favoris)),
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
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) {
                        // Appeler la méthode de filtrage à chaque modification du texte de recherche
                        filterMedicaments(value);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 20.0),
                        hintText: 'Recherche...',
                      ),
                    ),
                  ),
                  Expanded(
                    child: stockMedicaments != null
                        ? ListView.builder(
                      itemCount: stockMedicaments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Medicament medicament = stockMedicaments[index];
                        return GestureDetector(
                          onTap: () {
                            // Action à effectuer lorsqu'une pharmacie est sélectionnée
                            // Vous pouvez naviguer vers une autre page ou exécuter une autre action ici
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsMedocs(
                                  id: index,
                                  nom: medicament.nom,
                                ),
                              ),
                            );

                          },
                          child: Card(
                            // ...
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
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
                                        icon: Icon(
                                          favoris.isFavorite(medicament) ? Icons.favorite : Icons.favorite_border,
                                          color: Colors.teal,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            favoris.toggleFavorite(medicament);
                                          });
                                        },
                                      ),
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
                          ),
                        );
                      },
                    )
                        : Center(
                            child: CircularProgressIndicator(),
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
