import 'package:carrello_paypal/carrello/Carrello.dart';
import 'package:carrello_paypal/carrello/CarrelloWidget.dart';
import 'package:carrello_paypal/pagamenti/CalcolatoreTotale.dart';
import 'package:carrello_paypal/pagamenti/payment.dart';
import 'package:carrello_paypal/spedizione/Spedizione.dart';
import 'package:carrello_paypal/spedizione/SpedizioneWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaginaPagamento extends StatelessWidget {
  final Carrello carrello;
  final Spedizione spedizione;
  final double tasse = 0;
  const PaginaPagamento({Key? key, required this.carrello, required this.spedizione}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
           child: CarrelloWidget(carrello: carrello,),
        ),
        const Divider(),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotale:"),
              Text("€ ${carrello.calcolaSubtotale().toStringAsFixed(2)}")
            ]
        ),
        const Divider(),
        SpedizioneWidget(spedizione: spedizione),
        const Divider(),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Totale:"),
              Text("€ ${CalcolatoreTotale.calcolaTotale(spedizione, carrello, tasse).toStringAsFixed(2)}")
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
          carrello: carrello,
          spedizione: spedizione,
        ),
      ),
    );
  }
}
