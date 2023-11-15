import 'dart:core';
import 'package:carrello_paypal/carrello/Carrello.dart';
import 'package:carrello_paypal/pagamenti/CalcolatoreTotale.dart';
import 'package:carrello_paypal/pagamenti/Valute.dart';
import 'package:carrello_paypal/spedizione/Spedizione.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'paypal_services.dart';

class Payment extends StatefulWidget {
  final Function? onFinish;
  final Carrello carrello;
  final Spedizione spedizione;

  const Payment({Key? key, this.onFinish, required this.carrello, required this.spedizione}) : super(key: key);

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

  /* todo
  subtotal
  Price
  Quantity
  shipping
  subtotal

  subtotal has to be Price * Quantity
  Whereas Total has to be Tax + shipping + subtotal
  * */
  Map<String, dynamic> getOrderParams() {
    String itemName = 'telefono cinese';
    int quantity = 1;
    //String shippingCost = '0';
    //String itemPrice = '10';//widget.carrello.calcolaTotale().toStringAsFixed(2);
    //String subTotalAmount =  '10';//widget.carrello.calcolaTotale().toStringAsFixed(2);
    //String totalAmount = '10';//(double.parse(subTotalAmount) + double.parse(shippingCost)).toStringAsFixed(2);
    int shippingDiscountCost = 0;
    String shippingCost = widget.spedizione.calcolaCostiSpedizione().toStringAsFixed(2);
    String itemPrice = widget.carrello.calcolaSubtotale().toStringAsFixed(2);
    String subTotalAmount = (widget.carrello.calcolaSubtotale()*quantity).toStringAsFixed(2);
    String totalAmount = CalcolatoreTotale.calcolaTotale(widget.spedizione, widget.carrello, 0).toStringAsFixed(2);
    String userFirstName = widget.carrello.utente.userFirstName;
    String userLastName = widget.carrello.utente.userLastName;
    String addressCity = widget.spedizione.addressCity;
    String addressStreet = widget.spedizione.addressStreet;
    String addressZipCode = widget.spedizione.addressZipCode;
    String addressCountry = widget.spedizione.addressCountry;
    String addressState = widget.spedizione.addressState;
    String addressPhoneNumber = widget.spedizione.addressPhoneNumber;
    String noteAcquisto = "Contact us for any questions on your order.";
    String descrizione = "The payment transaction description.";
    Map<dynamic,dynamic> valuta = Valuta.euro;

    List items = [];
    items.addAll(widget.carrello.righeCarrello.map((e) => e.toCarrelloItem()).toList());
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": valuta["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": descrizione,
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
      "note_to_payer": noteAcquisto,
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  navigationDelegate(NavigationRequest request){
      if (request.url.contains(returnURL)) {
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
        Navigator.of(context).pop();
      }
      return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
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
