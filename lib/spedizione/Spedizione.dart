class Spedizione{
  final double shippingCost;
  final int shippingDiscountCost;
  final String addressCity;
  final String addressStreet;
  final String addressZipCode;
  final String addressCountry;
  final String addressState;
  final String addressPhoneNumber;

  Spedizione({
    required this.shippingCost,
    required this.shippingDiscountCost,
    required this.addressCity,
    required this.addressStreet,
    required this.addressZipCode,
    required this.addressCountry,
    required this.addressState,
    required this.addressPhoneNumber,
  });

  double calcolaCostiSpedizione(){
    return shippingCost-(shippingCost*shippingDiscountCost);
  }
}