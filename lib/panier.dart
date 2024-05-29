import 'package:flutter/material.dart';
import 'medicaments.dart';
import 'commande.dart';


class PanierPage extends StatefulWidget {
  final List<MedicamentCartItem> panier;

  PanierPage({required this.panier});

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  void increaseQuantity(int index) {
    setState(() {
      widget.panier[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (widget.panier[index].quantity > 1) {
        widget.panier[index].quantity--;
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      widget.panier.removeAt(index);
    });
  }

  void toggleFavorite(int index) {
    setState(() {
      widget.panier[index].medicament.isFavorite = !widget.panier[index].medicament.isFavorite;
    });
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in widget.panier) {
      total += item.medicament.prix * item.quantity;
    }
    return total;
  }

  void showValidationOptions(BuildContext context) {
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
                  createOrder(context, true);
                },
              ),
              ListTile(
                title: Text('Sans livraison'),
                onTap: () {
                  Navigator.pop(context);
                  createOrder(context, false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void createOrder(BuildContext context, bool avecLivraison) {
    final int numero = DateTime.now().millisecondsSinceEpoch.toInt();
    final DateTime date = DateTime.now();
    final double montant = getTotalPrice();

    final List<MedicamentCartItem> panierItems = widget.panier.toList();

    final Commande commande = Commande(
      numero: numero,
      date: date,
      montant: montant,
      avecLivraison: avecLivraison,
      items: panierItems,
    );

    // Ajouter la commande à la liste via le singleton
    CommandeManager().ajouterCommande(commande);

    // Réinitialiser le panier
    setState(() {
      widget.panier.clear();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommandePage(commande: commande, items: panierItems),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                item.medicament.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: item.medicament.isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                toggleFavorite(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                removeFromCart(index);
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            item.medicament.nom,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Prix: ${item.medicament.prix} Fcfa',
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
                                decreaseQuantity(index);
                              },
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                increaseQuantity(index);
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
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showValidationOptions(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                primary: Colors.teal,
              ),
              child: Text(
                'Valider ${getTotalPrice().toStringAsFixed(2)} Fcfa',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
