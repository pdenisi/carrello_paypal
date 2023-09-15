import 'package:carrello_paypal/carrello/Carrello.dart';
import 'package:carrello_paypal/carrello/riga_carrello/RigaCarrello.dart';
import 'package:carrello_paypal/carrello/riga_carrello/RigaCarrelloWidget.dart';
import 'package:carrello_paypal/pagamenti/payment.dart';
import 'package:carrello_paypal/spedizione/SpedizioneWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarrelloWidget extends StatefulWidget {
  final Carrello carrello;
  const CarrelloWidget({Key? key, required this.carrello}) : super(key: key);


  @override
  CarrelloWidgetState createState() {
    return CarrelloWidgetState();
  }
}

class CarrelloWidgetState extends State<CarrelloWidget> {
  @override
  Widget build(BuildContext context) {
      return
        Column(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: widget.carrello.prodotti.map
                ((prodotto) => RigaCarrelloWidget(rigaCarrello : RigaCarrello(prodotto: prodotto))).toList(),
              //children: widget.carrello.prodotti!.map((prodotto) => ProdottoWidget(prodotto: prodotto,) ).toList(),
            ),
            const Divider(),
            SpedizioneWidget(spedizione: widget.carrello.spedizione),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotale:"),
                Text("€ ${widget.carrello.calcolaSubtotale().toStringAsFixed(2)}")
              ]
            ),
            const Divider(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Totale:"),
                  Text("€ ${widget.carrello.calcolaTotale().toStringAsFixed(2)}")
                ]
            ),
            const Divider(),


            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () { effettuaPagamento(context); },
              child: const Text('Paga'),
            )
          ],
        );
  }

  void effettuaPagamento(BuildContext context){
      // make PayPal payment
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Payment(
            onFinish: (number) async {
              // payment done
              final snackBar = SnackBar(
                content: const Text("Payment done Successfully"),
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            carrello: widget.carrello,
          ),
        ),
      );
  }

}

