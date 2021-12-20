import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String id;
  List<dynamic> productsIDs;
  bool isOrdered;
  String userID;

  Cart({
    required this.id,
    required this.productsIDs,
    required this.isOrdered,
    required this.userID,
  });

  factory Cart.fromSnapshot(DocumentSnapshot snapshot) {
    return Cart(
      id: snapshot['id'],
      productsIDs: snapshot['productsIDs'],
      isOrdered: snapshot['isOrdered'],
      userID: snapshot['userID'],
    );
  }

  Map<String, dynamic> toCartMap() {
    return {
      'productsIDs': productsIDs,
      'isOrdered': isOrdered,
      'userID': userID,
    };
  }
}
