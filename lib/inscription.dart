import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/verification.dart';
import 'package:http/http.dart' as http;


class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  late TextEditingController nom;
  late TextEditingController prenom;
  late TextEditingController email;
  late TextEditingController telephone;
  late TextEditingController motDePasse;
  late TextEditingController confirmationMotDePasse;
  late bool _ismotDePasseVisible;
  late String message;

  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    prenom = TextEditingController();
    email = TextEditingController();
    telephone = TextEditingController();
    motDePasse = TextEditingController();
    confirmationMotDePasse = TextEditingController();
    _ismotDePasseVisible = false;
    message = "";
  }

  Future<void> sInscrire() async {
    Uri url = Uri.parse('http://localhost:5050/mypharma.php');
    try {
      http.Response response = await http.post(url, body: {
        'nom': nom.text,
        'prenom': prenom.text,
        'email': email.text,
        'telephone': telephone.text,
        'mot_de_passe': motDePasse.text,
        'confirmation_mot_de_passe': confirmationMotDePasse.text
      });
      dynamic jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      if (response.statusCode == 200) {
        // Si le serveur retourne une réponse OK, parsez le JSON
        setState(() {
          message = jsonResponse['message'];
        });
      } else {
        // Si le serveur retourne une réponse non-OK, lancez une exception.
        setState(() {
          message = jsonResponse['error'];
        });
      }
      print("I'm here");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                  child: Align(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/bg_connect.png',
                                width: constraints.maxWidth, fit: BoxFit.contain),
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Inscrivez-vous sur",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  //color: HexColor("009688"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    "Nom",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextField(
                                    controller: nom,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.red, width: 2.0))),
                                    style: const TextStyle(),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    "Prénom",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextField(
                                    controller: prenom,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.red, width: 2.0))),
                                    style: const TextStyle(),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    "E-mail",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextField(
                                    controller: email,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.red, width: 2.0))),
                                    style: const TextStyle(),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    "Téléphone",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextField(
                                    controller: telephone,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.red, width: 2.0))),
                                    style: const TextStyle(),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    "Mot de passe",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextField(
                                    controller: motDePasse,
                                    obscureText: !_ismotDePasseVisible,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.red, width: 2.0)),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _ismotDePasseVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24.0),
                                  const Text(
                                    "Confirmer le mot de passe",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextField(
                                    controller: confirmationMotDePasse,
                                    obscureText: !_ismotDePasseVisible,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.red, width: 2.0)),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _ismotDePasseVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24.0),
                                  ElevatedButton(
                                    onPressed: () async {
                                      print("click");
                                      await sInscrire();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: const Text("Info"),
                                                content: Text(message),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => Verification()),
                                                      );
                                                    },
                                                    child: const Text("OK"),
                                                  ),
                                                ]);
                                          });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(600, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: const Text("S'inscrire",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  const SizedBox(height: 24.0),
                                  Container(
                                    alignment: Alignment.center,
                                    child: const Text("Ou"),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    alignment: Alignment.center,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'Vous avez déjà un compte? ',
                                        style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Connectez vous',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.underline,
                                              decorationThickness: 6.0,
                                              decorationColor: Color(0xFF009688),
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                    builder: (context) => Connexion()),
                                                );
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))),
            ],
          );
        }));
  }
}
