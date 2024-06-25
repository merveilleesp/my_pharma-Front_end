import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_pharma/detailspharma.dart';
import 'package:my_pharma/panier.dart';

import 'API.dart';
import 'Models/Medicament.dart';
import 'Models/MedicamentCartItem.dart';
import 'Models/PharmacieCard.dart';
import 'listpharm.dart';

class SearchPage extends StatefulWidget {
  final String nom_medoc;
  final int id_pharmacie = 0;

  SearchPage({required this.nom_medoc});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<PharmacieCard> panier = [];
  List<dynamic> stockSearch = [];
  String title = '';
  List<Pharmacie> pharmacie = [];
  bool isLoading = true; // To track loading state

  Future<void> getPharm(String query) async {
    var url = Uri.http(API.url, 'users/dispomedinpharm.php');
    try {
      var response = await http.post(url, body: {'query': query});
      print('msg: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        print('Data fetched: $data'); // Debug statement to check fetched data
        setState(() {
          stockSearch = data;
          pharmacie = data.map((json) => Pharmacie.fromJson(json)).toList();
          isLoading = false; // Set loading to false when data is fetched
        });
      } else {
        print('Error: ${response.statusCode}');
        Fluttertoast.showToast(msg: "Un problème s'est posé, merci de réessayer");
        setState(() {
          isLoading = false; // Set loading to false on error
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Échec de connexion vers le serveur de DB");
      Fluttertoast.showToast(msg: "Vérifiez votre connexion");
      print('Exception: $e');
      setState(() {
        isLoading = false; // Set loading to false on exception
      });
    }
  }

  void addToCart(BuildContext context, Medicament medicament, String pharmacie) {
    final existingCartItem = panier.firstWhere(
          (item) => item.pharmacieName == pharmacie,
      orElse: () => PharmacieCard(
        pharmacieName: "",
        medicamentCard: MedicamentCartItem(
          medicament: Medicament(nom: "", prix: 0, id: 0, presentation: '', dosage: ''),
        ),
      ),
    );
    final existingMedicamentCard = existingCartItem.medicaments.firstWhere(
          (item) => item.medicament.nom == medicament.nom,
      orElse: () => MedicamentCartItem(
        medicament: Medicament(nom: "", prix: 0, id: 0, presentation: '', dosage: ''),
      ),
    );
    if (existingCartItem.pharmacieName.isNotEmpty) {
      if (existingMedicamentCard.medicament.nom.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${medicament.nom} est déjà dans le panier de la ${pharmacie}.'),
          ),
        );
      } else {
        setState(() {
          existingCartItem.medicaments.add(MedicamentCartItem(medicament: medicament));
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
          medicamentCard: MedicamentCartItem(medicament: medicament),
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
    title = widget.nom_medoc;
    getPharm(widget.nom_medoc);
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();

  void _onSearchIconTap() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        title = _controller.text;
        isLoading = true; // Set loading to true when a new search is initiated
        stockSearch = [];
        pharmacie = []; // Clear previous results
      });
      getPharm(_controller.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Le champ de recherche est vide')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  contentPadding: EdgeInsets.only(left: 20.0),
                  suffixIcon: GestureDetector(
                    onTap: _onSearchIconTap,
                    child: Icon(Icons.search),
                  ),
                ),
                style: TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : (pharmacie.isEmpty
                  ? Center(child: Text("Aucune pharmacie trouvée"))
                  : ListView.builder(
                itemCount: pharmacie.length,
                itemBuilder: (context, index) {
                  final pharmacy = pharmacie[index];
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
                                  pharmacy.nom,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.teal,
                                  ),
                                ),
                                Text(
                                  'Distance: ${pharmacy.distance}',
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
                                pharmacy.nom,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToPanier(context);
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
