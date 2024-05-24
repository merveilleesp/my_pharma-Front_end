import 'package:flutter/material.dart';
import 'package:my_pharma/medicaments.dart';
import 'package:my_pharma/panier.dart'; // Assurez-vous d'importer le modèle de médicament

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  late List<Medicament> panier; // Assurez-vous de déclarer la liste avec le mot-clé "late"

  @override
  void initState() {
    super.initState();
    // Initialisez et remplissez la liste panier
    panier = genererDonneesMedicaments(); // Exemple d'initialisation de la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Panier(panier: panier), // Passez la liste panier à la classe Panier
    );
  }

  List<Medicament> genererDonneesMedicaments() {
    // Exemple de fonction pour générer des données de médicaments
    return List.generate(20, (index) {
      return Medicament(nom: 'Médicament ${index + 1}', prix: 10.0 * (index + 1));
    });
  }
}
