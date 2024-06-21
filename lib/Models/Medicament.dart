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


  // Méthode pour convertir un objet Médicament en format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': nom,
      'presentation': presentation,
      'dosage': dosage,
      'prix': prix,
      'isFavorite': isFavorite,
    };
  }


  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      id: json['id'] ?? 0,
      nom: json['designation'] ?? '',
      presentation: json['presentation'] ?? '',
      dosage: json['dosage'] ?? '',
      prix: json['prix'] != null ? double.parse(json['prix'].toString()) : 0.0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Medicament &&
        other.id == id &&
        other.nom == nom &&
        other.presentation == presentation &&
        other.dosage == dosage &&
        other.prix == prix;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    nom.hashCode ^
    presentation.hashCode ^
    dosage.hashCode ^
    prix.hashCode;
  }

}