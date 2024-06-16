import 'package:flutter/material.dart';
import 'package:my_pharma/medicaments.dart';
import 'Models/Medicament.dart';
import 'favoris.dart';

class FavorisPage extends StatelessWidget {
  final Favoris favoris;

  FavorisPage({required this.favoris});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: ListView.builder(
        itemCount: favoris.favorisList.length,
        itemBuilder: (BuildContext context, int index) {
          final Medicament medicament = favoris.favorisList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    medicament.nom,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
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
                      IconButton(
                        icon: Icon(Icons.shopping_cart, color: Colors.teal),
                            onPressed: () {
                              // Action lorsque l'utilisateur appuie sur l'icône du panier
                            },
                       ),
                      ],
                  ),
                  // Ajoutez d'autres informations si nécessaire
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
