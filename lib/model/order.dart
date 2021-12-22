import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String buyerMail;
  String sellerMail;
  String productsId;
  int quantities;
  double prices;

  Order({
    required this.id,
    required this.productsId,
    required this.sellerMail,
    required this.buyerMail,
    required this.quantities,
    required this.prices,
  });

  @override
  String toString() {
    return 'Order{id: $id, buyerMail: $buyerMail, sellerMail: $sellerMail, productsId: $productsId, quantities: $quantities, prices: $prices}';
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      buyerMail: json['buyerMail'],
      sellerMail: json['sellerMail'],
      productsId: json['productsId'],
      quantities: json['quantities'],
      prices: json['prices'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerMail': buyerMail,
      'sellerMail': sellerMail,
      'productsId': productsId,
      'quantities': quantities,
      'prices': prices,
    };
  }

  static fromMap(Object? data) {
    if (data is Map<String, dynamic>) {
      return Order(
        id: data['id'],
        buyerMail: data['buyerMail'],
        sellerMail: data['sellerMail'],
        productsId: data['productsId'],
        quantities: data['quantities'],
        prices: data['prices'],
      );
    }
    return null;
  }
}
