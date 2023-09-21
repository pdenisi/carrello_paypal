import 'dart:core';
import 'dart:ffi';
import 'package:carrello_paypal/carrello/Carrello.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'paypal_services.dart';

class Payment extends StatefulWidget {
  final Function? onFinish;
  final Carrello carrello;

  const Payment({Key? key, this.onFinish, required this.carrello}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentState();
  }
}

class PaymentState extends State<Payment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices services = PaypalServices();

  late final WebViewController _controller;

  /* you can change default value according to your desired
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };*/
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "EUR ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "EUR"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        print(transactions);
        final res =
        await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (ex) {
        final snackBar = SnackBar(
          content: Text(ex.toString()),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  String itemName = 'telefono cinese';
  String itemPrice = '2';
  int quantity = 1;

  /* todo
  subtotal has to be Price * Quantity
  Whereas Total has to be Tax + shipping + subtotal
  * */

  /*
  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": itemPrice,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.carrello.totale,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": widget.carrello.subTotale,
              "shipping": widget.carrello.spedizione.shippingCost,
              "shipping_discount": ((-1.0) * widget.carrello.spedizione.shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": widget.carrello.utente.userFirstName + " " + widget.carrello.utente.userLastName,
                "line1": widget.carrello.spedizione.addressStreet,
                "line2": "",
                "city": widget.carrello.spedizione.addressCity,
                "country_code": widget.carrello.spedizione.addressCountry,
                "postal_code": widget.carrello.spedizione.addressZipCode,
                "phone": widget.carrello.spedizione.addressPhoneNumber,
                "state": widget.carrello.spedizione.addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }
  */
  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": widget.carrello.calcolaTotale().toStringAsFixed(2),
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String subTotalAmount = widget.carrello.calcolaTotale().toStringAsFixed(2);
    String shippingCost = '0';
    String totalAmount = (double.parse(subTotalAmount) + double.parse(shippingCost)).toStringAsFixed(2);
    int shippingDiscountCost = 0;
    String userFirstName = widget.carrello.utente.userFirstName;
    String userLastName = widget.carrello.utente.userLastName;
    String addressCity = widget.carrello.spedizione.addressCity;
    String addressStreet = widget.carrello.spedizione.addressStreet;
    String addressZipCode = widget.carrello.spedizione.addressZipCode;
    String addressCountry = widget.carrello.spedizione.addressCountry;
    String addressState = widget.carrello.spedizione.addressState;
    String addressPhoneNumber = widget.carrello.spedizione.addressPhoneNumber;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  navigationDelegate(NavigationRequest request){
      if (request.url.contains(returnURL)) {
        print("caso1");
        final uri = Uri.parse(request.url);
        final payerID = uri.queryParameters['PayerID'];
        if (payerID != null) {
          services
              .executePayment(executeUrl, payerID, accessToken)
              .then((id) {
            widget.onFinish!(id);
            Navigator.of(context).pop();
          });
        } else {
          Navigator.of(context).pop();
        }
        //Navigator.of(context).pop();
      }
      if (request.url.contains(cancelURL)) {
        print("caso2");
        Navigator.of(context).pop();
      }
      print("arrivo alla return");
      return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {

      _controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return navigationDelegate(request);
          },
        ));


      _controller.loadRequest(Uri.parse(checkoutUrl!));

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebViewWidget(
          controller: _controller,
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
  }
}
