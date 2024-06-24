class Pharmacy {
  final String pharmacie;
  final String medicament;
  final int idPharmacie;
  final double prix;
  final double longitude;
  final double latitude;

  Pharmacy({required this.pharmacie, required this.medicament, required this.idPharmacie, required this.prix, required this.longitude, required this.latitude});

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      pharmacie: json['pharmacie'],
      medicament: json['medicament'],
      idPharmacie: json['id_pharmacie'],
      prix: double.parse(json['prix']),
      longitude: double.parse(json['longitude']),
      latitude: double.parse(json['latitude']),
    );
  }
}