import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:my_pharma/resetPasswordScreen.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/inscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'API.dart';

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

  bool validerFormulaire() {
    if (email.text.isEmpty || motDePasse.text.isEmpty) {
      setState(() {
        message = "Tous les champs sont requis";
      });
      return false;
    }
    return true;
  }

  Future<void> seConnecter() async {
    try {
      Uri url = API.getUri('/users/connexion.php');
      http.Response response = await http.post(url, body: {
        'email': email.text,
        'mot_de_passe': motDePasse.text,
      });
      dynamic data = jsonDecode(response.body);
      print(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> user = [];
      user.add(data["nom_utilisateur"]);
      user.add(data["prenom_utilisateur"]);
      user.add(data["email_utilisateur"]);
      user.add(data["id_utilisateur"].toString());
      prefs.setStringList("User", user);
      if (response.statusCode == 200) {
        setState(() {
          message = data['message'];
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Accueil()),
        );
      } else {
        setState(() {
          message = data['error'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Identifiants incorrects'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
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
                            "Connectez vous ",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
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
                                cursorColor: Colors.teal,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.teal, width: 2.0),
                                  ),
                                ),
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
                                cursorColor: Colors.teal,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.teal, width: 2.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _ismotDePasseVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _ismotDePasseVisible =
                                        !_ismotDePasseVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24.0),
                              ElevatedButton(
                                onPressed: () async {
                                  if (validerFormulaire()) {
                                    print("click");
                                    await seConnecter();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(600, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  primary: Colors.teal,
                                ),
                                child: const Text("Se connecter",
                                    style: TextStyle(
                                      color: Colors.white,
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
                                          decorationThickness: 4.0,
                                          decorationColor: Color(0xFF009688),
                                          height: 2,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Inscription(),
                                              ),
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
