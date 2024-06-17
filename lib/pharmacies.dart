import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/kkiapays.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/detailspharma.dart';
import 'package:my_pharma/favoris.dart';
import 'package:my_pharma/listecom.dart';
import 'package:my_pharma/medicaments.dart';
import 'package:my_pharma/profil.dart'; // Importation de la bibliothèque mathématique pour générer une distance aléatoire

class Pharmacie {
  final String nom;
  bool estDeGarde;
  String localite;
  double latitude; // Latitude de la pharmacie
  double longitude; // Longitude de la pharmacie
  String distance;// Distance de l'utilisateur à la pharmacie
  String contacts;

  Pharmacie({
    required this.nom,
    required this.estDeGarde,
    required this.localite,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.contacts, // Distance initiale
  });

// Méthode pour changer l'état de garde de manière aléatoire
  void genererEtatDeGardeAleatoire() {
    estDeGarde = Random().nextInt(100) < 50; // 50% de chances d'être vrai

  }

  // Mettre à jour la distance en fonction de la position de l'utilisateur
  Future<double> calculateDistance(Position userPosition) async {
    double distanceInKm = calculateDistanceInKm(
      userPosition.latitude,
      userPosition.longitude,
      this.latitude,
      this.longitude,
    );
    return distanceInKm;
  }
}

double calculateDistanceInKm(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
  const int earthRadius = 6371;
  double latDistance = degreesToRadians(endLatitude - startLatitude);
  double lonDistance = degreesToRadians(endLongitude - startLongitude);
  double a = sin(latDistance / 2) * sin(latDistance / 2) +
      cos(degreesToRadians(startLatitude)) * cos(degreesToRadians(endLatitude)) *
          sin(lonDistance / 2) * sin(lonDistance / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;
  return distance;
}

double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

class Pharmacies extends StatefulWidget {
  @override
  _PharmaciesState createState() => _PharmaciesState();
}

Future<dynamic> getPharmacies() async {
  var url = Uri.http('192.168.1.195:8080', 'users/recupdonnees.php');
  try {
    var response = await http.post(url, body: {});
    print('msg: ${response.statusCode}');
    if (response.statusCode == 200) {
      // Si la réponse est correcte, parsez le contenu de la réponse en JSON
      final data = json.decode(response.body);
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



class _PharmaciesState extends State<Pharmacies> {
  bool toggleValue = false;
  List<Pharmacie> pharmacies = [];
  List<Pharmacie> pharmaciesAffichees = [];
  dynamic stockPharmacies;
  dynamic dataPharmacies;
  Position? _currentPosition;

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      if (toggleValue) {
        pharmaciesAffichees = pharmacies.where((pharmacie) => pharmacie.estDeGarde).toList();
      } else {
        pharmaciesAffichees = List.from(pharmacies);
      }
    });
  }


  // Fonction pour générer des données de pharmacies (pour cet exemple)
  List<Pharmacie> genererDonneesPharmacies(dynamic data) {
    return data.map<Pharmacie>((item) {
      return Pharmacie(
        nom: item['pharmacie'],
        estDeGarde: item['estDeGarde'] == 'true',
        localite: item['localite'],
        latitude: double.parse(item['latitude']),
        longitude: double.parse(item['longitude']),
        distance: 'Calculating...',
        contacts: item['contacts'] ?? 'Unknown',// Initialisation
      );
    }).toList();
  }


  // Méthode pour filtrer les pharmacies en fonction du texte de recherche

  void filterPharmacies(String query) {
    query = query.toUpperCase();
    setState(() {
      if (query.isNotEmpty) {
        pharmaciesAffichees = pharmacies.where((pharmacie) {
          return pharmacie.nom.toUpperCase().contains(query) || pharmacie.localite.toUpperCase().contains(query);
        }).toList();
      } else {
        pharmaciesAffichees = List.from(pharmacies);
      }
    });
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog();
      return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      // Mettre à jour les distances pour chaque pharmacie
      await updatePharmaciesDistance(position);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePharmaciesDistance(Position userPosition) async {
    for (var pharmacie in pharmacies) {
      double newDistance = await pharmacie.calculateDistance(userPosition);
      setState(() {
        pharmacie.distance = '${newDistance.toStringAsFixed(2)} km';
      });
    }

    // Trier pharmacies par distance
    pharmacies.sort((a, b) => double.parse(a.distance.split(' ')[0]).compareTo(double.parse(b.distance.split(' ')[0])));

    // Mettre à jour pharmaciesAffichees avec les pharmacies triées
    setState(() {
      pharmaciesAffichees = List.from(pharmacies);
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission().then((_) {
      getPharmacies().then((value) {
        if (value != null) {
          stockPharmacies = value;
          dataPharmacies = value;
          pharmacies = genererDonneesPharmacies(stockPharmacies);
          pharmacies.forEach((pharmacie) {
            pharmacie.genererEtatDeGardeAleatoire(); // Générer l'état de garde aléatoire
          });
          pharmaciesAffichees = List.from(pharmacies);
          _getCurrentLocation();
        }
      });
    });
  }


  void _showLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Activer la localisation"),
          content: Text("Cette application nécessite l'activation de la localisation pour afficher les pharmacies les plus proches."),
          actions: <Widget>[
            TextButton(
              child: Text("Activer"),
              onPressed: () async {
                Navigator.of(context).pop(); // Fermer le dialogue avant de vérifier la localisation
                bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                if (!serviceEnabled) {
                  serviceEnabled = await Geolocator.openLocationSettings();
                  if (!serviceEnabled) {
                    _showLocationDialog();
                    return;
                  }
                }
                LocationPermission permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                  if (permission == LocationPermission.denied) {
                    _showLocationDialog();
                    return;
                  }
                }
                if (permission == LocationPermission.deniedForever) {
                  _showLocationDialog();
                  return;
                }
                _getCurrentLocation();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PHARMACIES',
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
                  Favoris favoris = Favoris();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavorisPage(favoris: favoris,)),
                  );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  // Appeler la méthode de filtrage à chaque modification du texte de recherche
                  filterPharmacies(value);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.only(left: 20.0),
                  hintText: 'Rechercher une pharmacie...',
                ),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.all(16.0),
              child :Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOUTES LES PHARMACIES',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF009688),
                  ),
                ),
                GestureDetector(
                  onTap: toggleButton,
                  child: AnimatedContainer(
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
                ),
              ],
            ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pharmaciesAffichees.length,
                itemBuilder: (context, index) {
                  final pharmacie = pharmaciesAffichees[index];
                  return GestureDetector(
                    onTap: () {
                      // Action à effectuer lorsqu'une pharmacie est sélectionnée
                      // Vous pouvez naviguer vers une autre page ou exécuter une autre action ici
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPharmacies(
                            id: index,
                            nom: pharmacie.nom,
                            latitude: pharmacie.latitude,
                            longitude: pharmacie.longitude,
                            contacts: pharmacie.contacts ?? 'Unknown',
                          ),
                        ),
                      );

                    },
                    child: Card(
                      child: ListTile(
                        title: Text(pharmacie.nom),
                        subtitle: Text(pharmacie.distance),
                        trailing: Transform.rotate(
                          angle: -pi / 4,
                          child: Icon(
                            pharmacie.estDeGarde ? Icons.nightlight_round : null,
                            color: pharmacie.estDeGarde ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
