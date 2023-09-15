
import 'package:carrello_paypal/prodotto/Prodotto.dart';

Map<dynamic, dynamic> defaultCurrency = {
  "symbol": "USD ",
  "decimalDigits": 2,
  "symbolBeforeTheNumber": true,
  "currency": "USD"
};

class RigaCarrello {
  final Prodotto prodotto;
  final int quantita = 1;

  RigaCarrello({
    required this.prodotto,
  });

  double calcolaTotalePrezzoProdotto(){
    return this.prodotto.prezzo*quantita;
  }

  Map<String, dynamic> toCarrelloItem(){
    return {
      "name": prodotto.nome,
      "quantity": quantita,
      "price": prodotto.prezzo,
      "currency": defaultCurrency["currency"]
    };
  }
}