import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:natore_project/model/order.dart';
import 'package:natore_project/model/product.dart';

class OrderServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'orders';

  Future<void> addOrder(Order order) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc());

      final Map<String, dynamic> data = order.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return _firestore.runTransaction(createTransaction).then((mapData) {
      print('Transaction complete. Data added to Firestore');
    }).catchError((error) {
      print('error: $error');
    });
  }

  Stream<QuerySnapshot> getOrders() {
    Stream<QuerySnapshot> snapshots = _firestore
        .collection(collection)
        .orderBy('date', descending: true)
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot> getOrdersByUser(String userId) {
    Stream<QuerySnapshot> snapshots = _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .snapshots();
    return snapshots;
  }

  Future<void> addProductToOrder(Order order, Product product) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc());

      final Map<String, dynamic> data = order.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return _firestore.runTransaction(createTransaction).then((mapData) {
      print('Transaction complete. Data added to Firestore');
    }).catchError((error) {
      print('error: $error');
    });
  }

  Future<void> removeProductFromOrder(Order order, Product product) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc());

      final Map<String, dynamic> data = order.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return _firestore.runTransaction(createTransaction).then((mapData) {
      print('Transaction complete. Data added to Firestore');
    }).catchError((error) {
      print('error: $error');
    });
  }

  Future<void> updateProductInOrder(Order order, Product product) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc());

      final Map<String, dynamic> data = order.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return _firestore.runTransaction(createTransaction).then((mapData) {
      print('Transaction complete. Data added to Firestore');
    }).catchError((error) {
      print('error: $error');
    });
  }
}
