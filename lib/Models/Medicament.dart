class Medicament {
  final int id;
  final String nom;
  final double prix;
  final String presentation; // Champ pour la présentation du médicament
  final String dosage; // Champ pour le dosage du médicament
  bool isFavorite;

  Medicament({
    required this.id,
    required this.nom,
    required this.prix,
    required this.presentation,
    required this.dosage,
    this.isFavorite = false,
  });

  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      id: json['id'],
      nom: json['designation'],
      prix: double.parse(json['prix']),
      presentation: json['presentation'], // Assurez-vous que ces clés existent dans votre JSON
      dosage: json['dosage'],
      isFavorite: false, // Vous pouvez initialiser à partir de vos données si nécessaire
    );
  }
}