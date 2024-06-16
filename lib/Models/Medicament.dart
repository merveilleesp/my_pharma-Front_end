class Medicament {
  final int id;
  final String nom;
  final double prix;
  bool isFavorite;

  Medicament({
    required this.id,
    required this.nom,
    required this.prix,
    this.isFavorite = false,
  });

  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      id: json['id'],
      nom: json['designation'],
      prix: double.parse(json['prix']),
      isFavorite: false, // Vous pouvez initialiser à partir de vos données si nécessaire
    );
  }
}