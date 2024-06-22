import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:my_pharma/code.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/verification.dart';
import 'package:http/http.dart' as http;

import 'API.dart';


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
  late TextEditingController mot_de_passe;
  late TextEditingController confirmation_mot_de_passe;
  late bool _ismotDePasseVisible;
  late String message;

  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    nom = TextEditingController();
    prenom = TextEditingController();
    email = TextEditingController();
    telephone = TextEditingController();
    mot_de_passe = TextEditingController();
    confirmation_mot_de_passe = TextEditingController();
    _ismotDePasseVisible = false;
    message = "";
  }

  String genererCode() {
    final random = Random();
    final String code = String.fromCharCodes(List.generate(4, (_) => random.nextInt(10) + 48));
    return code;
  }

  bool validerFormulaire() {
    if (nom.text.isEmpty ||
        prenom.text.isEmpty ||
        email.text.isEmpty ||
        telephone.text.isEmpty ||
        mot_de_passe.text.isEmpty ||
        confirmation_mot_de_passe.text.isEmpty) {
      // Afficher un message d'erreur si des champs sont vides
      setState(() {
        message = "Tous les champs sont requis";
      });
      return false; // Retourner false si des champs sont vides
    }
    return true; // Retourner true si tous les champs sont remplis
  }


  Future<void> sInscrire() async {
    if (!validerFormulaire()) {
      print('Remplissez les champs');
      return;
    } else {
      try {
        // Générer le code de confirmation
        String confirmationCode = genererCode();

        // Insérer les données de l'utilisateur et le code de confirmation dans la base de données
        Uri uri = API.getUri('/users/mypharma.php');
        http.Response response = await http.post(uri, body: {
          'nom': nom.text,
          'prenom': prenom.text,
          'email': email.text,
          'telephone': telephone.text,
          'mot_de_passe': mot_de_passe.text,
          'confirmation_mot_de_passe':confirmation_mot_de_passe.text,
          'confirmation_code': confirmationCode
        });

        // Vérifier si l'inscription a réussi
        if (response.statusCode == 200) {
          // Envoi de l'e-mail d'invitation avec le code de confirmation
          await sendMailInvitation(email.text, confirmationCode);
          await Future.delayed(Duration(seconds: 3));
          print('Inscription réussie, e-mail envoyé avec succès');
          // Afficher un message de succès ou naviguer vers une autre page
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Verification(email: email.text,)),
          );
        } else {
          dynamic jsonResponse = jsonDecode(response.body);
          print('Erreur lors de l\'inscription : ${jsonResponse['error']}');
          setState(() {
            message = jsonResponse['error'];
          });
        }
      } catch (e) {
        print('Erreur lors de l\'inscription : $e');
        setState(() {
          message = 'Erreur lors de l\'inscription';
        });
      }
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
                                  color: Colors.teal,
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
                                    cursorColor: Colors.teal, // Couleur du curseur
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.teal, width: 2.0), // Bordure teal quand le champ est focalisé
                                      ),
                                    ),
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
                                    cursorColor: Colors.teal, // Couleur du curseur
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.teal, width: 2.0), // Bordure teal quand le champ est focalisé
                                      ),
                                    ),
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
                                    cursorColor: Colors.teal, // Couleur du curseur
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.teal, width: 2.0), // Bordure teal quand le champ est focalisé
                                      ),
                                    ),
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
                                    cursorColor: Colors.teal, // Couleur du curseur
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.teal, width: 2.0), // Bordure teal quand le champ est focalisé
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
                                    controller: mot_de_passe,
                                    obscureText: !_ismotDePasseVisible,
                                    cursorColor: Colors.teal, // Couleur du curseur
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.teal, width: 2.0), // Bordure teal quand le champ est focalisé
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _ismotDePasseVisible ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _ismotDePasseVisible = !_ismotDePasseVisible; // Inversion de l'état
                                          });
                                        },
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
                                    controller: confirmation_mot_de_passe,
                                    obscureText: !_ismotDePasseVisible,
                                    cursorColor: Colors.teal, // Couleur du curseur
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.teal, width: 2.0), // Bordure teal quand le champ est focalisé
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _ismotDePasseVisible ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _ismotDePasseVisible = !_ismotDePasseVisible; // Inversion de l'état
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24.0),
                                  ElevatedButton(
                                    onPressed: isProcessing
                                        ? null
                                        : () async {
                                      setState(() {
                                        isProcessing = true;
                                      });
                                      await sInscrire();
                                      setState(() {
                                        isProcessing = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(600, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      primary: Colors.teal,
                                    ),
                                    child: isProcessing
                                        ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    )
                                        : const Text("S'inscrire",
                                        style: TextStyle(
                                          color: Colors.white,
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
                                                  MaterialPageRoute(builder: (context) => Connexion()),
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
                            )
                          ],
                        ),
                      ))),
            ],
          );
        }));
  }
}
