class Medicament {
  final String nom;
  final double prix;
  bool isFavorite;

  Medicament({
    required this.nom,
    required this.prix,
    this.isFavorite = false,
  });
}