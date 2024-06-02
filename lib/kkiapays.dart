import 'package:flutter/material.dart';
//import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import 'package:http/http.dart' as http; // Import pour les requêtes HTTP
import 'package:kkiapay_flutter_sdk/kkiapay/view/widget_builder_view.dart';
import 'package:kkiapay_flutter_sdk/utils/kkiapayConf.sample.dart';
import 'dart:convert'; // Pour décoder les réponses JSON
import './successScreen.dart';


// Fonction successCallback combinée
void successCallback(response, context) async {
  switch (response['status']) {
    case PAYMENT_CANCELLED:
      debugPrint(PAYMENT_CANCELLED);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(PAYMENT_CANCELLED),
      ));
      break;

    case PENDING_PAYMENT:
      debugPrint(PENDING_PAYMENT);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(PENDING_PAYMENT),
      ));
      break;

    case PAYMENT_INIT:
      debugPrint(PAYMENT_INIT);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(PAYMENT_INIT),
      ));
      break;

    case PAYMENT_SUCCESS:
      debugPrint(PAYMENT_SUCCESS);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(PAYMENT_SUCCESS),
      ));
      // Envoyer l'identifiant de transaction au backend pour vérification
      await sendPaymentData(response['transactionId'], context);
      break;

    case PAYMENT_FAILED:
      debugPrint(PAYMENT_FAILED);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(PAYMENT_FAILED),
      ));
      break;

    default:
      debugPrint("Unknown payment status");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Unknown payment status'),
      ));
      break;
  }
}

// Fonction pour envoyer les données de paiement au backend et traiter la réponse
Future<void> sendPaymentData(String transactionId, BuildContext context) async {
  final response = await http.post(
    Uri.parse('https://votre-backend.com/verify-payment.php'),
    body: {
      'transaction_id': transactionId,
    },
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessScreen(
          amount: responseData['amount'],
          transactionId: responseData['transactionId'],
        ),
      ),
    );
  } else {
    // Gérer les erreurs de vérification
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erreur'),
        content: Text('Erreur lors de la vérification du paiement.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Configuration de l'instance KKiaPay avec les détails nécessaires pour le paiement
  final kkiapay = KKiaPay(
  amount: 100, // Montant que l'utilisateur veut payer
  countries: ["BJ"], // Pays supportés (uniquement le Bénin)
  phone: "51243660", // Numéro de téléphone de l'utilisateur
  name: "espérance", // Nom du payeur (utilisateur)
  email: "agbodjogbeesperance@mail.com", // Adresse e-mail du payeur (utilisateur)
  reason: 'achat', // Raison du paiement (achat)
  data: 'Fake data', // Données supplémentaires (peut être laissé vide ou rempli avec des données supplémentaires pertinentes)
  sandbox: true, // Utilisation de l'environnement de test (pour effectuer des tests sans traiter de vraies transactions)
  apikey: 'fca1c44d658ce42f7a700753cdaa89f42d575998', // Clé API publique pour l'authentification
  callback: successCallback, // Fonction de rappel pour gérer la réponse du paiement
  theme: '#2ba359', // Thème de l'interface de paiement (peut être personnalisé selon les besoins)
  partnerId: '665b1bfe692cdc08d0150350', // ID du partenaire (votre identifiant KKiaPay)
  paymentMethods: ["momo", "card"], // Méthodes de paiement supportées (par exemple, mobile money et carte bancaire)
);

// Classe principale de l'application qui étend StatelessWidget
class Paiement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Désactiver le bandeau de debug
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal, // Couleur de fond de la barre d'application
          title: Text('Kkiapay Sample'), // Titre de la barre d'application
          centerTitle: true, // Centrer le titre
        ),
        body: KkiapaySample(), // Corps de l'application, ici un widget personnalisé
      ),
    );
  }
}

// Widget personnalisé pour l'interface de paiement KKiaPay
class KkiapaySample extends StatelessWidget {
  const KkiapaySample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Aligner le contenu au centre horizontalement
        mainAxisAlignment: MainAxisAlignment.center, // Aligner le contenu au centre verticalement
        children: [
          ButtonTheme(
            minWidth: 500.0, // Largeur minimale du bouton
            height: 100.0, // Hauteur du bouton
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff222F5A)), // Couleur de fond du bouton
                foregroundColor: MaterialStateProperty.all(Colors.white), // Couleur du texte du bouton
              ),
              child: const Text(
                'Pay Now', // Texte du bouton
                style: TextStyle(color: Colors.white), // Style du texte
              ),
              onPressed: () {
                // Action à effectuer lorsque le bouton est pressé
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => kkiapay), // Naviguer vers l'interface de paiement KKiaPay
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
