import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/commandes.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/listecom.dart';
import 'package:my_pharma/parentwidget.dart';
import 'package:my_pharma/profil.dart';
import 'Models/Medicament.dart';
import 'Models/MedicamentCartItem.dart';
import 'panier.dart';






class Medicaments extends StatefulWidget {
  @override
  _MedicamentsState createState() => _MedicamentsState();
}

Future<dynamic> getMedicaments() async {
  var url = Uri.http('localhost:8080', 'users/recupdonneesme.php');
  url.toString();
  try {
    var response = await http.post(url, body: {});
    print('msg: ${response.statusCode}');
    if (response.statusCode == 200) {
      // Si la réponse est correcte, parsez le contenu de la réponse en JSON
      final data = json.decode(response.body);
      print(data);
      return data;
    } else {
      // Si la réponse est incorrecte, affichez l'erreur
      print(response.statusCode);
      Fluttertoast.showToast(msg: "Un problème s'est posé, merci de réessayer");
      return null;
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Échec de connexion vers le serveur de DB");
    Fluttertoast.showToast(msg: "Vérifiez votre connexion");
    print(e);
    return null;
  }
}

class _MedicamentsState extends State<Medicaments> {
  bool toggleValue = false;
  bool isFavorite = false;
  List<bool> favorites = List.generate(20, (_) => false);
  List<Medicament> medicaments = [];
  List<Medicament> medicamentsInitials = []; // Copie de la liste initiale des pharmacies
  dynamic stockMedicaments;
  dynamic dataMedicaments;
  bool medocIsReady = false;
  List<MedicamentCartItem> panier = []; // Ajout du panier

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

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }

  void toggleFavorite(int index) {
    setState(() {
      favorites[index] = !favorites[index];
    });
  }




  void filterMedicaments(String query) {
    print(query);
    query = query.toUpperCase();
    setState(() {
      if (query.isNotEmpty) {
        stockMedicaments = dataMedicaments.where((item) {
          if (item['designation'].contains(query)) {
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
        nom: 'designation ${index + 1}',
        prix: prix,
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
              /*ListTile(
                        title: const Text('Voir Panier'),
                        leading: const Icon(Icons.shopping_cart),
                        onTap: () {
                          // Passer le panier à la page du panier
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PanierPage(panier: panier)),
                          );
                        },
                      ),*/
              ListTile(
                title: const Text('Mes Commandes'),
                leading: const Icon(Icons.shopping_basket),
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
                        ? GridView.builder(
                      itemCount: stockMedicaments.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final medicament = stockMedicaments[index];
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${medicament['designation']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${medicament['prix']} Fcfa',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      favorites[index]
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: favorites[index]
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      toggleFavorite(index);
                                    },
                                  ),

                                ],
                              ),
                            ],
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
