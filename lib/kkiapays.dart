import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kkiapay_flutter_sdk/kkiapay/view/widget_builder_view.dart';
import 'package:kkiapay_flutter_sdk/utils/kkiapayConf.sample.dart';
import 'dart:convert';
import './successScreen.dart';

void successCallback(response, context) async {
  switch (response['status']) {
    case PAYMENT_CANCELLED:
      debugPrint(PAYMENT_CANCELLED);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(PAYMENT_CANCELLED),
      ));
      break;

    case PENDING_PAYMENT:
      debugPrint(PENDING_PAYMENT);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(PENDING_PAYMENT),
      ));
      break;

    case PAYMENT_INIT:
      debugPrint(PAYMENT_INIT);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(PAYMENT_INIT),
      ));
      break;

    case PAYMENT_SUCCESS:
      debugPrint(PAYMENT_SUCCESS);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(PAYMENT_SUCCESS),
      ));
      await sendPaymentData(response['transactionId'], context);
      break;

    case PAYMENT_FAILED:
      debugPrint(PAYMENT_FAILED);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(PAYMENT_FAILED),
      ));
      break;

    default:
      debugPrint("Unknown payment status");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unknown payment status'),
      ));
      break;
  }
}

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

class Paiement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Kkiapay Sample'),
          centerTitle: true,
        ),
        body: KkiapaySample(),
      ),
    );
  }
}

class KkiapaySample extends StatelessWidget {
  const KkiapaySample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
            minWidth: 500.0,
            height: 100.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff222F5A)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KKiaPay(
                      amount: 100,
                      countries: ["BJ"],
                      phone: "22961000000",
                      name: "espérance",
                      email: "agbodjogbeesperance@mail.com",
                      reason: 'achat',
                      sandbox: true,
                      apikey: 'fca1c44d658ce42f7a700753cdaa89f42d575998',
                      callback: successCallback,
                      paymentMethods: ["momo", "card"],
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

