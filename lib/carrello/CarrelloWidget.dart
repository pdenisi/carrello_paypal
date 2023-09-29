import 'package:carrello_paypal/carrello/Carrello.dart';
import 'package:carrello_paypal/carrello/riga_carrello/RigaCarrello.dart';
import 'package:carrello_paypal/carrello/riga_carrello/RigaCarrelloWidget.dart';
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
            ),
          ],
        );
  }
}

