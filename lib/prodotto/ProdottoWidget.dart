import 'package:carrello_paypal/prodotto/Prodotto.dart';
import 'package:flutter/cupertino.dart';

class ProdottoWidget extends StatelessWidget {
  final Prodotto prodotto;
  const ProdottoWidget({Key? key, required this.prodotto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${prodotto.nome}         "),
          Text(prodotto.prezzo.toStringAsFixed(2))
        ]
    );
  }
}
