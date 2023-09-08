import 'package:carrello_paypal/prodotto/Prodotto.dart';

class Carrello{
  List<Prodotto>? prodotti = [
    Prodotto(nome: "prodotto 1", descrizione: "descrizione prodotto1", prezzo: 9.90),
    Prodotto(nome: "prodotto 2", descrizione: "descrizione prodotto2", prezzo: 1.50)
  ];
  double? totale = 0;
  
  double? calcolaTotale(){
    if (prodotti != null) {
      prodotti!.forEach((element) {
        totale = totale! + element.prezzo!;
      });
    }
    return totale;
  }
}