import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPharmacies extends StatelessWidget {
  final String nomPharmacie = "";
  final String nomDocteur = "";
  final String localisation = "";
  final String assurances = "";
  final String contacts;
  final String heuresOuverture = "";
  final String moyensPaiements = "";
  final int id;
  final double latitude; // Ajout des coordonnées géographiques
  final double longitude;
  final String nom;


  DetailsPharmacies({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.nom,
    required this.contacts,
  });

  void openGoogleMaps() async {
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nom de l\'Appli'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[300],
              width: double.infinity, // Prendre toute la largeur disponible
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                  'assets/Logopharma2.png',
                      width: 100,
                ),
                  SizedBox(height: 8),
                  Text(
                    id.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color :Colors.teal
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                      '$nom',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color :Colors.teal
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Dr. $id',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 16, right:35, bottom: 16),
              child: InformationTile(
                icon: Icons.location_on,
                title: 'Localisation',
                content: localisation,
                titleStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 16, right:35, bottom: 16),
              child: ElevatedButton(
                onPressed: () async {
                  print("click");
                  openGoogleMaps();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(600, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text("Maps",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Divider(height: 0.5, color: Colors.grey[300]),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 16, right:35, bottom: 16),
              child: InformationTile(
                icon: Icons.security,
                title: 'Assurances',
                content: assurances,
                titleStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                ),
              ),
            ),
            Divider(height: 0.5, color: Colors.grey[300]),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 16, right:35, bottom: 16),
              child: InformationTile(
                icon: Icons.phone,
                title: 'Contacts',
                content: contacts,
                titleStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                ),
              ),
            ),
            Divider(height: 0.5, color: Colors.grey[300]),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 16, right:35, bottom: 16),
              child: InformationTile(
                icon: Icons.access_time,
                title: 'Heures d\'ouverture',
                content: heuresOuverture,
                titleStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InformationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final TextStyle titleStyle;

  InformationTile({
    required this.icon,
    required this.title,
    required this.content,
    required this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.teal),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle,
              ),
              SizedBox(height: 5),
              Text(content),
            ],
          ),
        ),
      ],
    );
  }
}
