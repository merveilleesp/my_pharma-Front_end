import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';
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
                      // Action lorsque le bouton est pressé (vérifier le code de vérification)
                      String verificationCode = '';
                      for (var controller in _controllers) {
                        verificationCode += controller.text;
                      }
                      if (verificationCode.length == 4) {
                        // Vérifier le code de vérification
                        print('Code de vérification: $verificationCode');

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Connexion()),
                        );

                      } else {
                        // Afficher un message d'erreur si le code de vérification est incorrect
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Erreur'),
                              content: const Text(
                                'Le code de vérification doit contenir 4 chiffres.',
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
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
                      // Action lorsque le bouton est pressé (vérifier le code de vérification)
                      String verificationCode = '';
                      for (var controller in _controllers) {
                        verificationCode += controller.text;
                      }
                      if (verificationCode.length == 4) {
                        // Vérifier le code de vérification
                        print('Code de vérification: $verificationCode');
                      } else {
                        // Afficher un message d'erreur si le code de vérification est incorrect
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Erreur'),
                              content: const Text(
                                  'Le code de vérification doit contenir 4 chiffres.'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Ferme le dialogue actuel ou le menu contextuel
                                    Navigator.pushNamed(context,
                                        '/connexion'); // Navigue vers une nouvelle page nommée '/nouvelle_page'
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
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
