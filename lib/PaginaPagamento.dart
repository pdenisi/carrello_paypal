import 'package:carrello_paypal/carrello/Carrello.dart';
import 'package:carrello_paypal/carrello/CarrelloWidget.dart';
import 'package:flutter/cupertino.dart';

class PaginaPagamento extends StatelessWidget {
  const PaginaPagamento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Carrello carrello = Carrello();
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CarrelloWidget(carrello: carrello,)
    );
  }
}
