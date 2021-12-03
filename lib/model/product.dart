import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  double price;
  String properties;
  String image;
  String mail;
  List<dynamic> commments;
  List<dynamic> responses;

  Product({
    required this.id,
    required this.name,
    required this.price,
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
      properties: snapShot["properties"],
      image: snapShot["image"].toString(),
      mail: snapShot["mail"],
      commments: [],
      responses: [],
      // commments: List.from(snapShot["commments"]),
      // responses: List.from(snapShot["responses"]),
    );
  }
}
