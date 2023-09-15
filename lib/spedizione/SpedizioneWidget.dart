import 'package:carrello_paypal/spedizione/Spedizione.dart';
import 'package:flutter/cupertino.dart';

class SpedizioneWidget extends StatelessWidget {
  final Spedizione spedizione;
  const SpedizioneWidget({Key? key, required this.spedizione}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(spedizione.addressStreet),
              Text(spedizione.addressCity),
              Text(spedizione.addressCountry),
              Text(spedizione.addressState),
              Text(spedizione.addressZipCode),
              Text(spedizione.addressPhoneNumber),
            ],
          ),
          Column(
            children: [
              Text("€ ${spedizione.shippingCost.toStringAsFixed(2)}"),
              Text("Sconto: ${spedizione.shippingDiscountCost.toString()}%"),
              Text("€ ${spedizione.calcolaCostiSpedizione().toStringAsFixed(2)}")
            ],
          ),
        ],
      );
  }
}