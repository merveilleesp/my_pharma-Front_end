import 'package:flutter/material.dart';

class DetailsPharma extends StatelessWidget {
  final String nom;
  final bool estDeGarde;
  final double distance;

  DetailsPharma({
    required this.nom,
    required this.estDeGarde,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nom),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom de la pharmacie : $nom',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Est de garde : ${estDeGarde ? 'Oui' : 'Non'}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Distance : $distance km',
              style: TextStyle(fontSize: 18),
            ),
            // Ajoutez d'autres détails de la pharmacie si nécessaire
          ],
        ),
      ),
    );
  }
}
