import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_pharma/accueil.dart';
//import 'package:flutter/gestures.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/commandes.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/profil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Medicament {
  final String nom;

  Medicament({
    required this.nom,
  });
}

class Medicaments extends StatefulWidget {
  @override
  _MedicamentsState createState() => _MedicamentsState();
}

Future<dynamic> getMedicaments() async {
  var url = Uri.http('localhost:8080', '/recupdonneesme.php');
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
  bool medocIsReady = false;

  void loadMedoc(){
    getMedicaments().then((value) {
      stockMedicaments = value;
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
      favorites[index] = !favorites[index]; // Inversez l'état du favori pour l'icône spécifique à l'index donné
    });
  }

  List<Medicament> genererDonneesMedicaments() {


    return List.generate(350, (index) {
      return Medicament(
        nom: 'designation ${index + 1}',
      );
    });
  }

  @override
  void initState() {
    loadMedoc();
    super.initState();
    medicaments = genererDonneesMedicaments();
    medicamentsInitials = List.from(medicaments);// Générer les données initiales des pharmacies
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
                        'TOUS LES MEDICAMENTS',
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
                  const SizedBox(height: 10),
                  Expanded(
                    child: !medocIsReady ?
                    const Center(child: CircularProgressIndicator()) :
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      /*gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 4, // Ratio de largeur/hauteur des boutons
                        mainAxisSpacing: 13.0, // Espace vertical entre les boutons
                      ),*/
                      itemCount: 15,
                      itemBuilder: (BuildContext context, int index) {
                        //Medicament medicament = medicaments[index];
                        print(stockMedicaments[index]["designation"]);
                        return
                          Column(
                            children: <Widget>[
                              Container(
                                height: 100.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10.0), // Rayon du bouton
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF8A8383).withOpacity(
                                          0.5), // Couleur et opacité de l'ombre
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2), // Position de l'ombre
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    // Couleur du texte du bouton
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Rayon du bouton
                                    ),
                                    elevation: 8,
                                    shadowColor: Colors.white.withOpacity(0.5),
                                    minimumSize: const Size(100,
                                        20), // Pas d'élévation supplémentaire, car l'élévation est gérée par le Container
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              stockMedicaments[index]["designation"],
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            Text(
                                              'boite de 10',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              'Prix Fcfa',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            ListTile(
                                              trailing: IconButton(
                                                icon: Icon(
                                                  favorites[index] ? Icons.favorite : Icons.favorite_border, // Utilisez l'état du favori pour déterminer quelle icône afficher
                                                  color: favorites[index] ? Colors.green : null, // Mettez à jour la couleur en fonction de l'état du favori
                                                ),
                                                onPressed: () => toggleFavorite(index), // Inversez l'état du favori lorsque l'utilisateur appuie sur l'icône
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12,)
                            ],
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
