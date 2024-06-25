import 'dart:math';

import 'package:geolocator_platform_interface/src/models/position.dart';

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

  double calculateDistanceInKm(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    const int earthRadius = 6371;
    double latDistance = degreesToRadians(endLatitude - startLatitude);
    double lonDistance = degreesToRadians(endLongitude - startLongitude);
    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(degreesToRadians(startLatitude)) * cos(degreesToRadians(endLatitude)) *
            sin(lonDistance / 2) * sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}