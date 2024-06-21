import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_pharma/panier.dart';

import 'API.dart';
import 'Models/Medicament.dart';
import 'Models/MedicamentCartItem.dart';
import 'Models/PharmacieCard.dart';
import 'Models/Pharmacy.dart';
import 'detailspharma.dart';

class PharmaciesWithMedicine extends StatefulWidget {
  final int medicamentId;
  final String medicamentName;

  PharmaciesWithMedicine({required this.medicamentId, required this.medicamentName});

  @override
  _PharmaciesWithMedicineState createState() => _PharmaciesWithMedicineState();
}

class _PharmaciesWithMedicineState extends State<PharmaciesWithMedicine> {
  bool isLoading = true;
  List<Pharmacy> pharmacies = [];
  List<PharmacieCard> panier = [];
  List<dynamic> stockSearch = []; // Initialisez comme une liste vide

  void addToCart(BuildContext context, Medicament medicament, String pharmacie) {
    final existingCartItem = panier.firstWhere(
          (item) => item.pharmacieName == pharmacie,
      orElse: () => PharmacieCard(
          pharmacieName: "",
          medicamentCard: MedicamentCartItem(
              medicament: Medicament(
                  nom: "", prix: 0, id: 0, presentation: '', dosage: ''))),
    );
    final existingMedicamentCard = existingCartItem.medicaments.firstWhere(
            (item) => item.medicament.nom == medicament.nom,
        orElse: () => MedicamentCartItem(
            medicament: Medicament(
                nom: "", prix: 0, id: 0, presentation: '', dosage: '')));
    if (existingCartItem.pharmacieName.isNotEmpty) {
      if (existingMedicamentCard.medicament.nom.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${medicament.nom} est déjà dans le panier de la ${pharmacie}.'),
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
            medicamentCard: MedicamentCartItem(medicament: medicament));
        panier.add(tmp);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${medicament.nom} a été ajouté au panier.'),
        ),
      );
    }
  }

  void navigateToPanier(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PanierPage(panier: panier),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPharmaciesWithMedicine(widget.medicamentName).then((value) => {
      setState(() {
        if (value != null) {
          pharmacies = List<Pharmacy>.from(
              value.map((item) => Pharmacy.fromJson(item)));
          stockSearch = value; // Stockez les données reçues dans stockSearch
        }
        isLoading = false;
      }),
    });
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
                          pharmacy.pharmacie ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.teal,
                          ),
                        ),
                        Text(
                          'Distance: ',
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
