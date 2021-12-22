import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:natore_project/model/order.dart';

class Cart {
  String id;
  List<Order> orders;
  bool isOrdered;
  String userID;

  Cart({
    required this.id,
    required this.orders,
    required this.isOrdered,
    required this.userID,
  });

  factory Cart.fromSnapshot(DocumentSnapshot snapshot) {
    return Cart(
      id: snapshot['id'],
      orders: List.from(snapshot['orders']),
      isOrdered: snapshot['isOrdered'],
      userID: snapshot['userID'],
    );
  }

  Map<String, dynamic> toCartMap() {
    return {
      'productsIDs': orders,
      'isOrdered': isOrdered,
      'userID': userID,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orders': orders,
      'isOrdered': isOrdered,
      'userID': userID,
    };
  }
}
