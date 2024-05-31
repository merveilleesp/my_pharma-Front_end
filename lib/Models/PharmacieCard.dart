import 'package:my_pharma/Models/MedicamentCartItem.dart';

class PharmacieCard{
  final String pharmacieName;
  final MedicamentCartItem medicamentCard;
  List<MedicamentCartItem> medicaments = [];
  PharmacieCard({required this.pharmacieName, required this.medicamentCard}){
    medicaments.add(medicamentCard);
  }

  double prixTotal(){
    double tmp = 0;
    medicaments.forEach((item) {
      tmp +=  (item.quantity * item.medicament.prix).toDouble();
    });
    return tmp;
  }

}