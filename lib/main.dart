import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/kkiapays.dart';
import 'package:my_pharma/onboarding.dart';
import 'package:my_pharma/pharmacies.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    verifierConnexion();
  }

  void verifierConnexion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Si l'utilisateur est déjà connecté, redirigez-le vers une autre page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Accueil()), // Remplacez PageAccueil() par la page où vous souhaitez rediriger l'utilisateur
      );
    } else {
      // Si l'utilisateur n'est pas connecté, redirigez-le vers la page de connexion après un délai
      Future.delayed(const Duration(seconds: 6), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Onboarding()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/Bg_lanceur.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/mervo-logo_BLANC.png', // Remplacez par le chemin de votre image
                  width: 300, // Définir la largeur de l'image
                  height: 500, // Définir la hauteur de l'image
                ),
              ],
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
