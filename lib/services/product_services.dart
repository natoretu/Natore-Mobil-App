import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:natore_project/model/product.dart';
import 'package:natore_project/services/storage_services.dart';

class ProductServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageServices _storageServices = StorageServices();
  String mediaUrl = "";
  String collection = "Products";

  Future<Product> addProduct(
      String name,
      double price,
      String properties,
      File pickedFile,
      String mail,
      String category,
      String market,
      int quantity) async {
    var ref = _firestore.collection(collection);
    mediaUrl = await _storageServices.uploadMedia(pickedFile);
    // print(mediaUrl);

    String id = mail + "-" + name;
    var documentRef = await ref.doc(id).set({
      'id': id,
      'name': name,
      'price': price,
      'rate': 0,
      'category': category,
      'market': market,
      'quantity': quantity,
      'properties': properties,
      'image': mediaUrl,
      'mail': mail,
      'comments': <dynamic>[],
      'responses': <dynamic>[],
    });

    return Product(
      id: id,
      name: name,
      price: price,
      rate: 0,
      category: category,
      market: market,
      quantity: quantity,
      properties: properties,
      image: mediaUrl,
      mail: mail,
      commments: <dynamic>[],
      responses: <dynamic>[],
    );
  }

  Stream<QuerySnapshot> getProducts() {
    CollectionReference ref = _firestore.collection(collection);

    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsOfSellerStreamMail(
      String mail) {
    Query<Map<String, dynamic>> ref =
        _firestore.collection(collection).where('mail', isEqualTo: mail);

    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsOfSellerStreamMarket(
      String market) {
    Query<Map<String, dynamic>> ref =
        _firestore.collection(collection).where('market', isEqualTo: market);

    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsOfSellerStreamCategory(
      String category) {
    Query<Map<String, dynamic>> ref = _firestore
        .collection('Products')
        .where('category', isEqualTo: category);

    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getProductsOfSellerStreamMarketCategory(String market, String category) {
    Query<Map<String, dynamic>> ref = _firestore
        .collection(collection)
        .where('market', isEqualTo: market)
        .where('category', isEqualTo: category);

    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getProductsOfSellerStreamGreaterRate(int rate) {
    Query<Map<String, dynamic>> ref = _firestore
        .collection(collection)
        .where('rate', isGreaterThanOrEqualTo: rate);

    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductStream(String id) {
    Query<Map<String, dynamic>> ref = _firestore
        .collection(collection)
        .where('id', isGreaterThanOrEqualTo: id);

    return ref.snapshots();
  }

  Future<List<dynamic>> getProducts2() async {
    CollectionReference ref = _firestore.collection(collection);
    List<Product> productsArray = [];

    await ref.snapshots().first.then((value) => {
          value.docs.forEach((element) {
            print(element.id);
            var p = Product.fromSnapshot(element);
            productsArray.add(p);
          })
        });
    print("size: " + productsArray.length.toString());

    return productsArray;
  }

  Future<List<dynamic>> getProductsOfSeller(String name) async {
    CollectionReference ref = _firestore.collection(collection);
    List<Product> productsArray = [];

    await ref.snapshots().first.then((value) => {
          value.docs.forEach((element) {
            var p = Product.fromSnapshot(element);
            if (p.mail == name) {
              productsArray.add(p);
            }
          })
        });

    return productsArray;
  }

  Future<List<dynamic>> getProductsOfName(String name) async {
    CollectionReference ref = _firestore.collection(collection);
    List<Product> productsArray = [];

    await ref.snapshots().first.then((value) => {
          value.docs.forEach((element) {
            var p = Product.fromSnapshot(element);
            if (p.name == name) {
              productsArray.add(p);
            }
          })
        });

    return productsArray;
  }

  Product getProduct(String name) {
    CollectionReference ref = _firestore.collection(collection);
    DocumentSnapshot? obj = null;

    ref.snapshots().first.then((value) => {
          value.docs.forEach((element) {
            print(element.id);
            if (name == element.get('name')) {
              obj = element;
            }
          })
        });

    return Product.fromSnapshot(obj!);
  }

  Future<void> removeProdut(String id) {
    var ref = _firestore.collection(collection).doc(id).delete();
    return ref;
  }

  Future<void> updateProduct(
      String id,
      String name,
      double price,
      String properties,
      File pickedFile,
      String mail,
      String category,
      String market,
      int quantity) async {
    var ref = _firestore.collection(collection).doc(id);
    mediaUrl = await _storageServices.uploadMedia(pickedFile);
    // print(mediaUrl);

    var documentRef = await ref.update({
      'id': id,
      'name': name,
      'price': price,
      'rate': 0,
      'category': category,
      'market': market,
      'quantity': quantity,
      'properties': properties,
      'image': mediaUrl,
      'mail': mail,
      'commments': <dynamic>[],
      'responses': <dynamic>[],
    });
  }
}
