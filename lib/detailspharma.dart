import 'package:flutter/material.dart';

class DetailsPharmacies extends StatelessWidget {
  final String nomPharmacie;
  final String nomDocteur;
  final String localisation;
  final String assurances;
  final String contacts;
  final String heuresOuverture;
  final String moyensPaiements;

  DetailsPharmacies({
    required this.nomPharmacie,
    required this.nomDocteur,
    required this.localisation,
    required this.assurances,
    required this.contacts,
    required this.heuresOuverture,
    required this.moyensPaiements,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nom de l\'Appli'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomPharmacie,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Dr. $nomDocteur',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              InformationTile(
                icon: Icons.location_on,
                title: 'Localisation',
                content: localisation,
              ),
              InformationTile(
                icon: Icons.security,
                title: 'Assurances',
                content: assurances,
              ),
              InformationTile(
                icon: Icons.phone,
                title: 'Contacts',
                content: contacts,
              ),
              InformationTile(
                icon: Icons.access_time,
                title: 'Heures d\'ouverture',
                content: heuresOuverture,
              ),
              InformationTile(
                icon: Icons.payment,
                title: 'Moyens de paiements',
                content: moyensPaiements,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InformationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  InformationTile({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
