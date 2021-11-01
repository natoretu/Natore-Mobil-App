import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String name;
  double price;
  String properties;
  String image;

  Product({
    required this.name,
    required this.price,
    required this.properties,
    required this.image,
  });

  factory Product.fromSnapshot(DocumentSnapshot snapShot) {
    return Product(
      name: snapShot["name"].toString(),
      price: snapShot["price"],
      properties: snapShot["properties"],
      image: snapShot["image"].toString(),
    );
  }
}
