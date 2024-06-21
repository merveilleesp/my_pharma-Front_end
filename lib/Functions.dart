import 'package:shared_preferences/shared_preferences.dart';

import 'Models/Utilisateur.dart';

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