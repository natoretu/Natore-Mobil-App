import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  double price;
  double rate;
  double ratedTimes;
  String category;
  String market;
  int quantity;
  String properties;
  String image;
  String mail;
  List<dynamic> commments;
  List<dynamic> responses;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rate,
    required this.ratedTimes,
    required this.category,
    required this.market,
    required this.quantity,
    required this.properties,
    required this.image,
    required this.mail,
    required this.commments,
    required this.responses,
  });

  @override
  String toString() {
    return id + " - " + name;
  }

  factory Product.fromSnapshot(DocumentSnapshot snapShot) {
    return Product(
      id: snapShot["id"].toString(),
      name: snapShot["name"].toString(),
      price: snapShot["price"],
      rate: snapShot["rate"],
      ratedTimes: snapShot["ratedTimes"],
      category: snapShot["category"],
      market: snapShot["market"],
      quantity: snapShot["quantity"],
      properties: snapShot["properties"],
      image: snapShot["image"].toString(),
      mail: snapShot["mail"],
      commments: [],
      responses: [],
      // commments: List.from(snapShot["commments"]),
      // responses: List.from(snapShot["responses"]),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "rate": rate,
      "category": category,
      "market": market,
      "quantity": quantity,
      "properties": properties,
      "image": image,
      "mail": mail,
      "commments": commments,
      "responses": responses,
    };
  }

  static fromMap(Object? data) {
    if (data is Map<String, dynamic>) {
      return Product(
        id: data["id"],
        name: data["name"],
        price: data["price"],
        rate: data["rate"],
        ratedTimes: data["ratedTimes"],
        category: data["category"],
        market: data["market"],
        quantity: data["quantity"],
        properties: data["properties"],
        image: data["image"],
        mail: data["mail"],
        commments: data["commments"],
        responses: data["responses"],
      );
    }
    return null;
  }
}
