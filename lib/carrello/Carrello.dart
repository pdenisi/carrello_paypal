import 'dart:math';

import 'package:carrello_paypal/prodotto/Prodotto.dart';
import 'package:carrello_paypal/spedizione/Spedizione.dart';
import 'package:carrello_paypal/utente/Utente.dart';

class Carrello{
  List<Prodotto> prodotti = [
    Prodotto(nome: "prodotto 1", descrizione: "descrizione prodotto1", prezzo: 9.99),
    Prodotto(nome: "prodotto 2", descrizione: "descrizione prodotto2", prezzo: 2.50)
  ];
  Utente utente = Utente(userFirstName: "Ciro", userLastName: "Esposito");

  double calcolaSubtotale(){
    double subTotale = 0;
    prodotti.forEach((element) {
      subTotale = subTotale + element.prezzo;
    });
    return subTotale;
  }
}