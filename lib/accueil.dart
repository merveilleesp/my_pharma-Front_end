import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/commandes.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/medicaments.dart';
import 'package:my_pharma/parentwidget.dart';
import 'package:my_pharma/pharmacies.dart';
import 'package:my_pharma/profil.dart';

class Accueil extends StatelessWidget {
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
                        title: const Text('Voir Panier'),
                        leading: const Icon(Icons.shopping_cart),
                        onTap: () {
                          // Passer le panier à la page du panier
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ParentWidget()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Mes Commandes'),
                        leading: const Icon(Icons.shopping_basket),
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
                // Fin de la navbar
                //corps de la page la partie scrollable
                body: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        //input/border de recherche
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1.0)),
                              contentPadding: EdgeInsets.only(left: 20.0),
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
                          // padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: List.generate(
                                8,
                                (index) => Column(
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.zero),
                                            shape: MaterialStateProperty.all(
                                                const CircleBorder()),
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
                                        const Text(
                                          "Traitement",
                                          style: TextStyle(
                                              color: Color(0xFF009688), fontSize: 12),
                                        )
                                      ],
                                    )),
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
                                          "TELECHARGER UNE ORDONNANCE",
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
                        const SizedBox(height: 25),
                        //titre de la partie Les pharmacies
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Les pharmacies',
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
                        //fin du code titre de la partie Les pharmacies
                        const SizedBox(height: 15),
                        //Début de la partie Les pharmacies
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        elevation: 8,
                                        shadowColor: const Color.fromARGB(255, 64, 63, 63)
                                            .withOpacity(1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/Logopharma2.png',
                                              width: 800,
                                            ),
                                            const Text("S'inscrire",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        elevation: 8,
                                        shadowColor: const Color.fromARGB(255, 64, 63, 63)
                                            .withOpacity(1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/Logopharma2.png',
                                              width: 800,
                                            ),
                                            const Text("S'inscrire",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        elevation: 8,
                                        shadowColor: const Color.fromARGB(255, 64, 63, 63)
                                            .withOpacity(1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/Logopharma2.png',
                                              width: 800,
                                            ),
                                            const Text("S'inscrire",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        elevation: 8,
                                        shadowColor: const Color.fromARGB(255, 64, 63, 63)
                                            .withOpacity(1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/Logopharma2.png',
                                              width: 800,
                                            ),
                                            const Text("S'inscrire",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        elevation: 8,
                                        shadowColor: const Color.fromARGB(255, 64, 63, 63)
                                            .withOpacity(1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/Logopharma2.png',
                                              width: 800,
                                            ),
                                            const Text("S'inscrire",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        elevation: 8,
                                        shadowColor: const Color.fromARGB(255, 93, 89, 89)
                                            .withOpacity(1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/Logopharma2.png',
                                              width: 800,
                                            ),
                                            const Text("S'inscrire",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        //Fin de la partie Les pharmacies
                        const SizedBox(height: 25),
                      ],
                    ),
                  );
                }
                )
            ),
    );
  }
}
