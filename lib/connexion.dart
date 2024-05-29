import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/inscription.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  late TextEditingController email;
  late TextEditingController motDePasse;
  late bool _ismotDePasseVisible;
  late String message;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    motDePasse = TextEditingController();
    _ismotDePasseVisible = false;
    message = "";
  }

  Future<void> seConnecter() async {
    Uri url = Uri.parse('http://localhost:5050/users/connexion.php');
    try {
      http.Response response = await http.post(url, body: {
        'email': email.text,
        'mot_de_passe': motDePasse.text,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/bg_connect.png',
                          width: constraints.maxWidth, fit: BoxFit.contain),
                      const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Connectez vous ",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              //color: colo,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text("E-mail"),
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
                              ElevatedButton(
                                onPressed: () async {
                                  print("click");
                                  await seConnecter();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Text("Info"),
                                            content: Text('Informations correctes'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => Accueil()),
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
                                child: const Text("Se connecter",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              const SizedBox(height: 16),
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
                                    text: 'Vous n\'avez pas de compte? ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Inscrivez-vous',
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
                                          MaterialPageRoute(builder: (context) => Inscription()),
                                          );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))),
                  ],
                );
              }));
            }
          }
