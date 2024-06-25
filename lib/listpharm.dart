import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_pharma/panier.dart';

import 'API.dart';
import 'Models/Medicament.dart';
import 'Models/MedicamentCartItem.dart';
import 'Models/PharmacieCard.dart';
import 'Models/Pharmacy.dart';
import 'detailspharma.dart';

class Pharmacie {
  final String nom;
  bool estDeGarde;
  String localite;
  double latitude; // Latitude de la pharmacie
  double longitude; // Longitude de la pharmacie
  String distance; // Distance de l'utilisateur à la pharmacie
  String contacts;

  Pharmacie({
    required this.nom,
    required this.estDeGarde,
    required this.localite,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.contacts,
  });

  // Méthode pour créer une instance de Pharmacie à partir de JSON
  factory Pharmacie.fromJson(Map<String, dynamic> json) {
    return Pharmacie(
      nom: json['pharmacie'] ?? '',
      estDeGarde: json['estDeGarde'] == 'true',
      localite: json['localite'] ?? '',
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
      distance: 'Calculating...',
      contacts: json['contacts'] ?? 'Unknown',
    );
  }

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
}

class PharmaciesWithMedicine extends StatefulWidget {
  final int medicamentId;
  final String medicamentName;

  PharmaciesWithMedicine({required this.medicamentId, required this.medicamentName});

  @override
  _PharmaciesWithMedicineState createState() => _PharmaciesWithMedicineState();
}

class _PharmaciesWithMedicineState extends State<PharmaciesWithMedicine> {
  bool isLoading = true;
  List<Pharmacie> pharmacies = [];
  List<PharmacieCard> panier = [];
  List<dynamic> stockSearch = []; // Initialisez comme une liste vide
  Position? _currentPosition; // Ajout de cette ligne pour définir _currentPosition
  List<Pharmacie> pharmaciesAffichees = []; // Ajout de cette ligne pour définir pharmaciesAffichees

  void addToCart(BuildContext context, Medicament medicament, String pharmacie) {
    final existingCartItem = panier.firstWhere(
          (item) => item.pharmacieName == pharmacie,
      orElse: () => PharmacieCard(
          pharmacieName: "",
          medicamentCard: MedicamentCartItem(
              medicament: Medicament(
                  nom: "", prix: 0, id: 0, presentation: '', dosage: ''
              )
          )
      ),
    );
    final existingMedicamentCard = existingCartItem.medicaments.firstWhere(
            (item) => item.medicament.nom == medicament.nom,
        orElse: () => MedicamentCartItem(
            medicament: Medicament(
                nom: "", prix: 0, id: 0, presentation: '', dosage: ''
            )
        )
    );
    if (existingCartItem.pharmacieName.isNotEmpty) {
      if (existingMedicamentCard.medicament.nom.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${medicament.nom} est déjà dans le panier de la ${pharmacie}.'
            ),
          ),
        );
      } else {
        setState(() {
          existingCartItem.medicaments
              .add(MedicamentCartItem(medicament: medicament));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${medicament.nom} a été ajouté au panier.'),
          ),
        );
      }
    } else {
      setState(() {
        PharmacieCard tmp = PharmacieCard(
            pharmacieName: pharmacie,
            medicamentCard: MedicamentCartItem(medicament: medicament)
        );
        panier.add(tmp);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${medicament.nom} a été ajouté au panier.'),
        ),
      );
    }
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

  void navigateToPanier(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PanierPage(panier: panier),
      ),
    );
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
  void initState() {
    super.initState();
    fetchPharmaciesWithMedicine(widget.medicamentName).then((value) => {
      setState(() {
        if (value != null) {
          pharmacies = List<Pharmacie>.from(
              value.map((item) => Pharmacie.fromJson(item)));
          stockSearch = value; // Stockez les données reçues dans stockSearch
        }
        isLoading = false;
      }),
    });
    _checkLocationPermission();
  }

  Future<dynamic> fetchPharmaciesWithMedicine(String medicamentName) async {
    var url = Uri.http(API.url, 'users/dispomedinpharma.php');
    try {
      var response = await http.post(url, body: {'medicament_name': medicamentName});
      print('msg: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        return data;
      } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacies avec ${widget.medicamentName}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : (stockSearch.isEmpty
          ? Center(child: Text("Aucune pharmacie trouvée"))
          : ListView.builder(
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          final pharmacy = pharmacies[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                print('Pharmacie ${index + 1} sélectionnée');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                foregroundColor: Colors.white,
                shadowColor: Colors.white.withOpacity(0.5),
                minimumSize: const Size(100, 20),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pharmacy.nom ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.teal,
                          ),
                        ),
                        Text(
                          'Distance: ${pharmacy.distance}', // Correction ici
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.teal),
                    onPressed: () {
                      addToCart(
                          context,
                          Medicament(
                            id: stockSearch[index]["id"] ?? 0,
                            nom: stockSearch[index]["medicament"] ?? '',
                            presentation: stockSearch[index]["presentation"] ?? '',
                            dosage: stockSearch[index]["dosage"] ?? '',
                            prix: double.parse(stockSearch[index]['prix']?.toString() ?? '0'),
                          ),
                          stockSearch[index]["pharmacie"] ?? ''
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToPanier(context);
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
