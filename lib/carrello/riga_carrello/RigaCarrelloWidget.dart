

import 'package:carrello_paypal/carrello/riga_carrello/RigaCarrello.dart';
import 'package:carrello_paypal/prodotto/ProdottoWidget.dart';
import 'package:flutter/cupertino.dart';


class RigaCarrelloWidget extends StatefulWidget {

  final RigaCarrello rigaCarrello;
  const RigaCarrelloWidget({Key? key, required this.rigaCarrello}) : super(key: key);


  @override
  _RigaCarrelloWidgetState createState() {
    return _RigaCarrelloWidgetState();
  }

}

class _RigaCarrelloWidgetState extends State<RigaCarrelloWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${widget.rigaCarrello.prodotto!.nome}, ${widget.rigaCarrello.prodotto!.prezzo} x${widget.rigaCarrello.quantita} = "+ (widget.rigaCarrello.calcolaTotalePrezzoProdotto()).toStringAsFixed(2)),
      ],
    );
  }
}
