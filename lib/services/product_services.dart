import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:natore_project/model/product.dart';
import 'package:natore_project/services/storage_services.dart';

class ProductServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageServices _storageServices = StorageServices();
  String mediaUrl = "";

  Future<Product> addProduct(String name, double price, String properties,
      File pickedFile, String mail) async {
    var ref = _firestore.collection('Products');
    mediaUrl = await _storageServices.uploadMedia(pickedFile);
    // print(mediaUrl);

    String id = mail + "-" + name;
    var documentRef = await ref.doc(id).set({
      'id': id,
      'name': name,
      'price': price,
      'properties': properties,
      'image': mediaUrl,
      'mail': mail,
      'commments': <dynamic>[],
      'responses': <dynamic>[],
    });

    return Product(
      id: id,
      name: name,
      price: price,
      properties: properties,
      image: mediaUrl,
      mail: mail,
      commments: <dynamic>[],
      responses: <dynamic>[],
    );
  }

  Stream<QuerySnapshot> getProducts() {
    CollectionReference ref = _firestore.collection('Products');
    List<dynamic> productsArray = [];

    // print(ref);
    // print(ref.snapshots());
    // print(ref.snapshots().first);
    // ids.first.then((value) => (value.docs.forEach((element) {
    //       print(element.data());
    //     })));

    // ref.snapshots().first.then((value) => (value.docs.forEach((element) {
    //       // var a = Product.fromSnapshot(element);
    //       productsArray.add(element.data());
    //       print(productsArray);
    //     })));

    return ref.snapshots();
  }

  Future<List<dynamic>> getProducts2() async {
    CollectionReference ref = _firestore.collection('Products');
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
    CollectionReference ref = _firestore.collection('Products');
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

  Product getProduct(String name) {
    CollectionReference ref = _firestore.collection('Products');
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
    var ref = _firestore.collection("Products").doc(id).delete();
    return ref;
  }
}
