import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/inscription.dart';
import 'package:my_pharma/pharmacies.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: const [
                OnboardingPage(
                  title: 'Recherche de Médicaments',
                  description: 'Trouvez facilement les médicaments dont vous avez besoin.',
                  imagePath: 'assets/medoc.png',
                ),
                OnboardingPage(
                  title: 'Localisation des Pharmacies',
                  description: 'Localisez les pharmacies les plus proches de votre position.',
                  imagePath: 'assets/images/image2.png',
                ),
                OnboardingPage(
                  title: 'Commande et livraison Rapide',
                  description: 'Commandez vos médicaments et faites vous livrer en quelques clics.',
                  imagePath: 'assets/images/image3.png',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              );
            }),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (_currentPage < 2) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Inscription()),
                );
              }
            },
            child: const Text('Commencer'),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20.0),
        Image.asset(
          imagePath,
          height: 200.0,
          width: 200.0,
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}