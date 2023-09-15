
class Transazione {

  List items;
  // checkout invoice details
  String totalAmount;
  String subTotalAmount;
  String shippingCost;
  int shippingDiscountCost;
  String userFirstName;
  String userLastName;
  String addressCity;
  String addressStreet;
  String addressZipCode;
  String addressCountry;
  String addressState;
  String addressPhoneNumber;
  bool isEnableShipping = false;
  bool isEnableAddress = false;
  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  Transazione({
    required this.items,
    required this.totalAmount,
    required this.subTotalAmount,
    required this.shippingCost,
    required this.shippingDiscountCost,
    required this.userFirstName,
    required this.userLastName,
    required this.addressCity,
    required this.addressStreet,
    required this.addressZipCode,
    required this.addressCountry,
    required this.addressState,
    required this.addressPhoneNumber,
  });

  Map<String, dynamic> getTemp(){
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

}