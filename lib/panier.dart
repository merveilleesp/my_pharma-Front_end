import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_pharma/Models/PharmacieCard.dart';
import 'Models/Commande.dart';
import 'Models/CommandeManager.dart';
import 'Models/MedicamentCartItem.dart';
import 'commande.dart';

class PanierPage extends StatefulWidget {
  final List<PharmacieCard> panier;

  PanierPage({required this.panier});

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  void increaseQuantity(int index, List<MedicamentCartItem> medocs) {
    setState(() {
      medocs[index].quantity++;
    });
  }

  void decreaseQuantity(int index, int indexPharmacie) {
    setState(() {
      if (widget.panier[indexPharmacie].medicaments[index].quantity > 1) {
        widget.panier[indexPharmacie].medicaments[index].quantity--;
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      widget.panier.removeAt(index);
    });
  }

  void showValidationOptions(BuildContext context, List<MedicamentCartItem> medocs, int indexPharmacieCard, double montant) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Avec livraison'),
                onTap: () {
                  Navigator.pop(context);
                  createOrder(context, true, indexPharmacieCard, medocs, montant);
                },
              ),
              ListTile(
                title: Text('Sans livraison'),
                onTap: () {
                  Navigator.pop(context);
                  createOrder(context, false, indexPharmacieCard, medocs, montant);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String generateCommandeNumber() {
    // Générer un numéro de commande unique (par exemple, en utilisant la date et un identifiant unique)
    return 'CMD-${DateTime.now().millisecondsSinceEpoch}';
  }

  void createOrder(BuildContext context, bool avecLivraison, int indexPharmacieCard, List<MedicamentCartItem> medocs, double total) {
    final String numero = generateCommandeNumber();
    final DateTime date = DateTime.now();
    final double montant = total;

    final List<PharmacieCard> panierItems = widget.panier.toList();

    final Commande commande = Commande(
      numero: numero,
      date: date,
      montant: montant,
      avecLivraison: avecLivraison,
      items: medocs,
      pharmacie: widget.panier[indexPharmacieCard].pharmacieName,
    );

    // Ajouter la commande à la liste via le singleton
    CommandeManager().ajouterCommande(commande);

    // Réinitialiser le panier
    setState(() {
      widget.panier.remove(widget.panier[indexPharmacieCard]);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommandePage(commande: commande, items: medocs, idUtilisateur: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.panier.isEmpty
                ? Center(
              child: Text('Votre panier est vide'),
            )
                : ListView.builder(
              itemCount: widget.panier.length,
              itemBuilder: (context, index) {
                final item = widget.panier[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.pharmacieName),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: item.medicaments.length,
                          itemBuilder: (context, indexMedoc) {
                            final medoc = item.medicaments[indexMedoc];
                            return Card(
                              margin: EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            medoc.medicament.nom,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              medoc.medicament.isFavorite ? Icons.favorite : Icons.favorite_border,
                                              color: medoc.medicament.isFavorite ? Colors.red : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                medoc.medicament.isFavorite = !medoc.medicament.isFavorite;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        'Prix: ${medoc.medicament.prix} Fcfa',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            decreaseQuantity(indexMedoc, index);
                                          },
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black54),
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            '${medoc.quantity}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            increaseQuantity(indexMedoc, item.medicaments);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: widget.panier.isEmpty
                              ? null
                              : () {
                            showValidationOptions(context, item.medicaments, index, item.prixTotal());
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            primary: Colors.teal,
                          ),
                          child: Text(
                            'Valider ${item.prixTotal().toStringAsFixed(2)} Fcfa',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
