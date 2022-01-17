import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = 'Favorites';
  //yeni bir hesap oluştuğunda o hesabın favori dökünamı database oluşması lazım. onun için bu çağırılacak
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getFavorites(String userId) {
    return _firestore
        .collection(collection)
        .where("userId", isEqualTo: userId)
        .snapshots();
  }

  Future<List<QuerySnapshot<Map<String, dynamic>>>> getProducts(
      String userId) async {
    List<QuerySnapshot<Map<String, dynamic>>> products = [];
    await _firestore
        .collection(collection)
        .doc(userId)
        .snapshots()
        .first
        .then((element) {
      List<dynamic> ll = element['productsIds'];
      ll.forEach((prdct) {
        products.add(prdct);
      });
    });
    return products;
  }

  Future<DocumentSnapshot> getProduct(String productId) async {
    return _firestore.collection(collection).doc(productId).get();
  }

  Future<bool> isFavorite(String userId, String productId) async {
    Query<Map<String, dynamic>> stream = await _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .where('productsIds', arrayContains: productId);
    // stream.snapshots().forEach((element) {
    //   print(element.docs.first.data());
    // });
    return stream.snapshots().first.then((value) => value.size != 0);
    // return  (await stream.snapshots().isEmpty);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> isFav(
      String userId, String productId) {
    Query<Map<String, dynamic>> stream = _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .where('productsIds', arrayContains: productId);
    return stream.snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> isFav2(
      String userId, String productId) async {
    Query<Map<String, dynamic>> stream = await _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .where('productsIds', arrayContains: productId);
    return stream.snapshots();
  }
}
