import 'package:flutter/material.dart';
import 'package:my_pharma/connexion.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) { // Suppose que vous avez 3 pages
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Connexion()),
      );
    }
  }

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
              children: [
                OnboardingPage(
                  title: '',
                  description: '',
                  imagePath: 'assets/onboarding1.png',
                  fit: BoxFit.cover,
                  onNext: _nextPage,
                ),
                OnboardingPage(
                  title: '',
                  description: '',
                  imagePath: 'assets/onboarding2.png',
                  fit: BoxFit.cover,
                  onNext: _nextPage,
                ),
                OnboardingPage(
                  title: '',
                  description: '',
                  imagePath: 'assets/onboarding3.png',
                  fit: BoxFit.cover,
                  onNext: _nextPage,
                  isLastPage: true,
                ),
              ],
            ),
          ),
          /*Row(
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
          ),*/
        ],
      ),
    );
  }
}


class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final BoxFit fit;
  final VoidCallback onNext;
  final bool isLastPage;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onNext,
    this.fit = BoxFit.cover,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image de fond
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            imagePath,
            fit: fit,
          ),
        ),
        // Bouton superposé à l'image
        Positioned(
          bottom: 20, // Ajustez la position du bouton selon vos besoins
          right: 40,
          child: SizedBox(
            width: 85,
            height: 81,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20), // Ajustez le padding pour centrer le texte
                primary: Colors.white, // Couleur de fond du bouton
              ),
              child: Text(
                isLastPage ? 'Y aller' : 'Suivant',
                style: TextStyle(
                  fontSize: 13, // Ajustez la taille de police si nécessaire
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Positioned(
          top: 30, // Ajustez la position du bouton selon vos besoins
          right: 40,
          child: SizedBox(
            width: 92,
            height: 37,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Connexion()),
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.teal[200],
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                  20.0), // Rayon du bouton
                  ),
              ),
              child: Text(
                'Sauter',
                style: TextStyle(
                  fontSize: 15, // Ajustez la taille de police si nécessaire
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

