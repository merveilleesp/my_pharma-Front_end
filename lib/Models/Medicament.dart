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
}