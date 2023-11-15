import 'dart:math';

import 'package:carrello_paypal/carrello/riga_carrello/RigaCarrello.dart';
import 'package:carrello_paypal/prodotto/Prodotto.dart';
import 'package:carrello_paypal/utente/Utente.dart';

List<Prodotto> prodotti = [
  Prodotto(nome: "prodotto 1", descrizione: "descrizione prodotto1", prezzo: 9.99),
  Prodotto(nome: "prodotto 2", descrizione: "descrizione prodotto2", prezzo: 2.50)
];
class Carrello{
  List<RigaCarrello> righeCarrello = prodotti.map((e) => RigaCarrello(prodotto: e)).toList();
  Utente utente = Utente(userFirstName: "Ciro", userLastName: "Esposito");

  double calcolaSubtotale(){
    double subTotale = 0;
    righeCarrello.forEach((rigaCarrello) {
      subTotale = subTotale + rigaCarrello.prodotto.prezzo * rigaCarrello.quantita;
    });
    return subTotale;
  }
}