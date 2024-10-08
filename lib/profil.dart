import 'package:flutter/material.dart';
import 'package:my_pharma/Models/Utilisateur.dart';
import 'package:my_pharma/accueil.dart';
import 'package:my_pharma/assurance.dart';
import 'package:my_pharma/kkiapays.dart';
import 'package:my_pharma/connexion.dart';
import 'package:my_pharma/favoris.dart';
import 'package:http/http.dart' as http;
import 'package:my_pharma/listecom.dart';
import 'package:my_pharma/medicaments.dart';
import 'package:my_pharma/pharmacies.dart';

import 'Functions.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State <Profil> {

  Utilisateur? utilisateur;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser().then((value) {
      setState(() {
        utilisateur = value;
        isLoading = false;
      });
    });
  }


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
              UserAccountsDrawerHeader(
                accountName: utilisateur != null
                    ? Text('${utilisateur!.prenom} ${utilisateur!.nom}')
                    : Text('Aucun utilisateur n\'est connecté'),
                accountEmail: utilisateur != null
                    ? Text('${utilisateur!.email}')
                    : Text(''),
                currentAccountPicture: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF009688),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Accueil'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Accueil()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_pharmacy),
                title: const Text('Pharmacies'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Pharmacies()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.healing),
                title: const Text('Medicaments'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Medicaments()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favoris'),
                onTap: () {
                  Favoris favoris = Favoris();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavorisPage(favoris: favoris,)),
                  );// Action à effectuer lorsque l'option Se Déconnecter est sélectionnée
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Liste de courses'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListeCommandesPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('Assurances'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Assurance()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profil'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profil()));
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
                leading: const Icon(Icons.logout),
                title: const Text('Déconnexion'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Connexion()));
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
