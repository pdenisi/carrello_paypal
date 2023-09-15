import 'dart:math';

import 'package:carrello_paypal/prodotto/Prodotto.dart';
import 'package:carrello_paypal/spedizione/Spedizione.dart';
import 'package:carrello_paypal/utente/Utente.dart';

class Carrello{
  double subTotale = 0;
  double costiSpedizione = 0;
  double totale = 0;
  List<Prodotto> prodotti = [
    Prodotto(nome: "prodotto 1", descrizione: "descrizione prodotto1", prezzo: 9.99),
    Prodotto(nome: "prodotto 2", descrizione: "descrizione prodotto2", prezzo: 1.50)
  ];
  Spedizione spedizione = Spedizione(
    shippingCost: 4.99,
    shippingDiscountCost: 0,
    addressCity: "Scampia",
    addressStreet: "Vele",
    addressZipCode: "80013",
    addressCountry: "Italia",
    addressState: "Napoli",
    addressPhoneNumber: "+1 223 6161 789",
  );
  Utente utente = Utente(userFirstName: "Ciro", userLastName: "Esposito");

  double calcolaSubtotale(){
    prodotti.forEach((element) {
      subTotale = subTotale + element.prezzo;
    });
    return subTotale;
  }

  double calcolaTotale(){
    totale = subTotale + spedizione.calcolaCostiSpedizione();
    return totale;
  }

}