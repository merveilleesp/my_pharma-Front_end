import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/code.dart';
import 'package:my_pharma/connexion.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  List<TextEditingController> _controllers = List.generate(
    4,
        (index) => TextEditingController(),
  );

  late TextEditingController email;
  late TextEditingController confirmation_code;
  late String message;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    confirmation_code = TextEditingController();
    message = "";
  }

  /*String genererCode() {
    final random = Random();
    final code = sha1
        .convert(utf8.encode(
        DateTime.now().toString() + random.nextInt(1000000).toString()))
        .toString()
        .substring(0, 4);
    return code;
  }*/

  String genererCode() {
    final random = Random();
    final String code = String.fromCharCodes(List.generate(4, (_) => random.nextInt(10) + 48));
    return code;
  }

  Future<void> renvoyerCode(String email) async {
    String nouveauCode = genererCode();
    try {
      Uri url = Uri.parse('http://192.168.1.195:5050/renvoiecode.php');
      http.Response response = await http.post(url, body: {
        'email': email,
        'confirmation_code': nouveauCode,
      });

      if (response.statusCode == 200) {
        dynamic jsonResponse = jsonDecode(response.body);
        print('Code de confirmation mis à jour : ${jsonResponse['message']}');

        // Envoyer le nouveau code par email
        await sendMailInvitation(email, nouveauCode);
        print('E-mail envoyé avec succès');
      } else {
        dynamic jsonResponse = jsonDecode(response.body);
        print('Erreur lors de la mise à jour du code : ${jsonResponse['error']}');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du code : $e');
    }
  }


   Future<void> validerInscription() async {
    Uri url = Uri.parse('http://192.168.1.195:5050/users/verification.php');
    try {
      http.Response response = await http.post(url, body: {
        'email': email.text,
        'confirmation_code': _controllers.map((controller) => controller.text).join(),
      });

      dynamic jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      if (response.statusCode == 200) {
        // Si le code est correct, affichez un message de succès à l'utilisateur
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Connexion()),
        );
      } else {
        // Si le code est incorrect, affichez un message d'erreur à l'utilisateur
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Code de confirmation incorrect!'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // En cas d'erreur, affichez un message d'erreur générique à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur s\'est produite!'),
        backgroundColor: Colors.red,
      ));
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/Verification.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Code de vérification",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text('Nous avons envoyé un code à 4 chiffres au  51****60',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                          (index) => buildCodeInputField(_controllers[index]),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      validerInscription();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26.0),
                      ),
                    ),
                    child: const Text(
                      'Vérifier',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      renvoyerCode('agbodjogbeesperance@gmail.com');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26.0),
                      ),
                    ),
                    child: const Text(
                      'Renvoyez le code',
                      style:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCodeInputField(TextEditingController controller) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
