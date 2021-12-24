import 'package:cloud_firestore/cloud_firestore.dart';

class Favorites {
  String userId;
  List<dynamic> productsIds;

  Favorites({
    required this.productsIds,
    required this.userId,
  });

  factory Favorites.fromsnapshot(DocumentSnapshot snapshot) {
    return Favorites(
      userId: snapshot['userId'],
      productsIds: List.from(snapshot['productsIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productsIds': productsIds,
    };
  }

  @override
  String toString() {
    return 'Favorites{userId: $userId, productsIds: $productsIds}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['productsIds'] = this.productsIds;
    return data;
  }
}
