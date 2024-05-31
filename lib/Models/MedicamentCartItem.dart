import 'Medicament.dart';

class MedicamentCartItem {
  final Medicament medicament;
  int quantity;

  MedicamentCartItem({
    required this.medicament,
    this.quantity = 1,
  });
}
