import 'package:flutter/material.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/commandes.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:http/http.dart' as http;

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PROFIL',
            style: TextStyle(
              color: Colors.white, // Texte en blanc
            ),
          ),
          backgroundColor: const Color(0xFF009688), // Arrière-plan vert
          iconTheme: const IconThemeData(
            color: Colors.white, // Icône en blanc
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const UserAccountsDrawerHeader(
                accountName: Text('Nom Utilisateur'),
                accountEmail: Text('email@example.com'),
                currentAccountPicture: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF009688),
                ),
              ),
              ListTile(
                title: const Text('Accueil'),
                leading: const Icon(Icons.home),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Accueil()),
                  );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Mon Profil'),
                leading: const Icon(Icons.person),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profil()),
                  );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Assurances'), // Ajout de l'élément "Assurances"
                leading: const Icon(Icons.security), // Icône pour "Assurances"
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Assurance()),
                  );
                  // Action à effectuer lorsque l'option Assurances est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Mes Commandes'),
                leading: const Icon(Icons.shopping_cart),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Commandes()),
                  );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Mes Favoris'),
                leading: const Icon(Icons.favorite),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favoris()),
                  );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Suggérer un Produit'),
                leading: const Icon(Icons.lightbulb),
                onTap: () {
                  // Action à effectuer lorsque l'option Suggérer un Produit est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Inviter un Ami'),
                leading: const Icon(Icons.person_add),
                onTap: () {
                  // Action à effectuer lorsque l'option Inviter un Ami est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Nous Contacter'),
                leading: const Icon(Icons.contact_mail),
                onTap: () {
                  // Action à effectuer lorsque l'option Nous Contacter est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Mentions Légales'),
                leading: const Icon(Icons.gavel),
                onTap: () {
                  // Action à effectuer lorsque l'option Mentions Légales est sélectionnée
                },
              ),
              ListTile(
                title: const Text('A Propos de Nous'),
                leading: const Icon(Icons.info),
                onTap: () {
                  // Action à effectuer lorsque l'option A Propos de Nous est sélectionnée
                },
              ),
              ListTile(
                title: const Text('Se Déconnecter'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Connexion()),
                  );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
                },
              ),
            ],
          ),
        ),
        body: ProfileForm(),
      ),
    );
  }
}

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _firstName = '';
  String _address = '';
  String _profession = '';
  String _birthdate = '';
  String _gender = '';
  String _phoneNumber = '';
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            'Nom',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nom',
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Prénom',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Prénom',
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: (value) {
              setState(() {
                _firstName = value;
              });
            },
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Numéro de Téléphone',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Numéro de Téléphone',
              prefixIcon: Icon(Icons.phone),
            ),
            onChanged: (value) {
              setState(() {
                _phoneNumber = value;
              });
            },
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Adresse',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Adresse',
              prefixIcon: Icon(Icons.location_on),
            ),
            onChanged: (value) {
              setState(() {
                _address = value;
              });
            },
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Profession',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Profession',
              prefixIcon: Icon(Icons.work),
            ),
            onChanged: (value) {
              setState(() {
                _profession = value;
              });
            },
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Date de Naissance',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Date de Naissance',
              prefixIcon: Icon(Icons.calendar_today),
            ),
            onChanged: (value) {
              setState(() {
                _birthdate = value;
              });
            },
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Sexe',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Sexe',
            ),
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
          ),
          const SizedBox(height: 20.0),
          GestureDetector(
            onTap: () {
              // Afficher le popup de réinitialisation du mot de passe
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ResetPasswordPopup();
                },
              );
            },
            child: const Text(
              'Réinitialiser votre mot de passe',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Traiter les données du formulaire
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enregistrement des modifications...'),
                  ),
                );
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}

class ResetPasswordPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Réinitialiser le Mot de Passe'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Ancien Mot de Passe'),
            obscureText: true,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nouveau Mot de Passe'),
            obscureText: true,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirmer le Nouveau Mot de Passe'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Logique pour réinitialiser le mot de passe
            Navigator.of(context).pop();
          },
          child: const Text('Réinitialiser'),
        ),
      ],
    );
  }
}
