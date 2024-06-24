import 'package:flutter/material.dart';
import 'package:my_pharma/medicaments.dart';

class CommandeEnregistreePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commande Enregistrée'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Votre commande a été enregistrée avec succès',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Medicaments(),
                  ),
                );
              },
              child: Text('ok'),
            ),
          ],
        ),
      ),
    );
  }
}
