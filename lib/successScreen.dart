import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final int amount;
  final String transactionId;

  SuccessScreen({required this.amount, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Payment Successful!'),
            SizedBox(height: 20),
            Text('Amount: $amount'),
            Text('Transaction ID: $transactionId'),
            // Autres informations sur la transaction réussie...
          ],
        ),
      ),
    );
  }
}
