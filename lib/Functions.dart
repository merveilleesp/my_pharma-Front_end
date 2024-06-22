import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'API.dart';
import 'Models/Utilisateur.dart';
import 'package:http/http.dart' as http;

Future<Utilisateur> loadUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? user = prefs.getStringList("User");

  if(user != null){
    print(user[3]);
    return Utilisateur(id: int.parse(user[3]), nom: user[0], prenom: user[1], email: user[2]);
  }else {
    return Utilisateur(id: 0, nom: "", prenom: "", email: "");
  }
}

Future<dynamic> getClasse() async {
  Uri uri = API.getUri('users/classethera.php');
  uri.toString();
  try {
    var response = await http.post(uri, body: {});
    print('msg: ${response.statusCode}');
    if (response.statusCode == 200) {
      // Si la réponse est correcte, parsez le contenu de la réponse en JSON
      final data = json.decode(response.body);
      print(data);
      return data;
    } else {
      // Si la réponse est incorrecte, affichez l'erreur
      print(response.statusCode);
      Fluttertoast.showToast(msg: "Un problème s'est posé, merci de réessayer");
      return null;
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Échec de connexion vers le serveur de DB");
    Fluttertoast.showToast(msg: "Vérifiez votre connexion");
    print(e);
    return null;
  }
}

Future<List<String>> getMedicamentsByClasse(String classe) async {
  Uri uri = API.getUri('users/listeclassethera.php');

  try {
    var response = await http.post(uri, body: {
      "classe_therapeutique": classe,
    });
    print('Réponse du serveur: ${response.body}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        return data.map<String>((item) => item['nom_medicament'] ?? 'Nom manquant').toList();
      } else {
        Fluttertoast.showToast(msg: "Erreur: ${data['error']}");
        return [];
      }
    } else {
      Fluttertoast.showToast(msg: "Erreur du serveur: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Erreur de connexion: $e");
    print('Erreur de connexion: $e');
    return [];
  }
}
