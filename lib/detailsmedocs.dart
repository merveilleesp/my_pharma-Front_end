import 'package:flutter/material.dart';


class Pharmacie {
  final String nom;
  final String adresse;
  final String telephone;

  Pharmacie(this.nom, this.adresse, this.telephone);
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste de Pharmacies',
      initialRoute: '/',
      routes: {
        '/': (context) => PharmaciesListPage(),
        '/details': (context) => PharmacieDetailsPage(),
      },
    );
  }
}

class PharmaciesListPage extends StatelessWidget {
  final List<Pharmacie> pharmacies = [
    Pharmacie('Pharmacie A', 'Adresse A', '111-111-1111'),
    Pharmacie('Pharmacie B', 'Adresse B', '222-222-2222'),
    Pharmacie('Pharmacie C', 'Adresse C', '333-333-3333'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de Pharmacies'),
      ),
      body: ListView.builder(
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pharmacies[index].nom),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/details',
                arguments: pharmacies[index],
              );
            },
          );
        },
      ),
    );
  }
}

class PharmacieDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pharmacie pharmacie = ModalRoute.of(context)!.settings.arguments as Pharmacie;

    return Scaffold(
      appBar: AppBar(
        title: Text(pharmacie.nom),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Adresse: ${pharmacie.adresse}'),
          ),
          ListTile(
            title: Text('Téléphone: ${pharmacie.telephone}'),
          ),
          // Ajoutez d'autres détails de la pharmacie ici
        ],
      ),
    );
  }
}
