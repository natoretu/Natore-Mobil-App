import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:natore_project/model/product.dart';
import 'package:natore_project/services/product_services.dart';

class FavoritesServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = 'Favorites';

  Future<void> addToFavorites(String userId) async {
    return await _firestore.collection(collection).doc(userId).set({
      'userId': userId,
      'productsIds': [],
    });
  }

  Future<void> appendToFavorites(String id, String productId) async {
    _firestore.collection(collection).doc(id).update({
      'productsIds': FieldValue.arrayUnion([productId]),
    });
  }

  Future<void> removeFromFavorites(String id, String productId) async {
    _firestore.collection(collection).doc(id).update({
      'productsIds': FieldValue.arrayRemove([productId]),
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getFavoritesAsDocumentSnapshot(
      String userId) {
    return _firestore.collection(collection).doc(userId).snapshots();
  }

  List<Stream<QuerySnapshot<Map<String, dynamic>>>> getProducts(String userId) {
    ProductServices _productServices = ProductServices();

    List<Stream<QuerySnapshot<Map<String, dynamic>>>> products = [];

    _firestore
        .collection(collection)
        .doc(userId)
        .get()
        .then((value) => value['productsIds'].forEach((element) {
              products.add(_productServices.getProductStream(element));
            }));

    return products;
  }

  Future<bool> isFavorite(String userId, String productId) async {
    DocumentSnapshot<Map<String, dynamic>> stream =
        await _firestore.collection(collection).doc(userId).get();

    return false;
  }
}
