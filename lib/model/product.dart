import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String name;
  double price;
  String properties;
  String image;
  String ownerMail;

  Product({
    required this.name,
    required this.price,
    required this.properties,
    required this.image,
    required this.ownerMail,
  });

  factory Product.fromSnapshot(DocumentSnapshot snapShot) {
    return Product(
      name: snapShot["name"].toString(),
      price: snapShot["price"],
      properties: snapShot["properties"],
      image: snapShot["image"].toString(),
      ownerMail: snapShot["ownerMail"],
    );
  }
}
