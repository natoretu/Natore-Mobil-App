import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:natore_project/model/cart.dart';
import 'package:natore_project/model/order.dart';
import 'package:natore_project/model/product.dart';

class CartServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'Cart';

  Future<Cart?> addCart(Cart cart) async {
    try {
      await _firestore.collection(collection).doc(cart.id).set(cart.toJson());
      return cart;
    } catch (e) {
      return null;
    }
  }

  Stream<QuerySnapshot> getCart() {
    return _firestore.collection(collection).snapshots();
  }

  Stream<QuerySnapshot> getCartByUserId(String userId) {
    return _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getCartByProductId(String productId) {
    return _firestore
        .collection(collection)
        .where('productId', isEqualTo: productId)
        .snapshots();
  }

  Future<Cart?> updateCart(Cart cart) async {
    try {
      await _firestore
          .collection(collection)
          .doc(cart.id)
          .update(cart.toJson());
      return cart;
    } catch (e) {
      return null;
    }
  }

  Future<void> addToCart(Product product, String userId) async {
    // ignore: prefer_function_declarations_over_variables
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc(userId));

      final List<Product> products = [];
      if (ds.exists) {
        products.addAll(Product.fromMap(ds.data()));
      }

      products.add(product);

      return tx.update(ds.reference, {
        'products': products.map((product) => product.toMap()).toList(),
      });
    };

    return _firestore.runTransaction(createTransaction).catchError((e) {
      print(e);
    });
  }

  Future<void> removeFromCart(Product product, String userId) async {
    // ignore: prefer_function_declarations_over_variables
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc(userId));

      final List<Product> products = [];
      if (ds.exists) {
        products.addAll(Product.fromMap(ds.data()));
      }

      products.remove(product);

      return tx.update(ds.reference, {
        'products': products.map((product) => product.toMap()).toList(),
      });
    };

    return _firestore.runTransaction(createTransaction).catchError((e) {
      print(e);
    });
  }

  Future<void> clearCart(String userId) async {
    // ignore: prefer_function_declarations_over_variables
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc(userId));

      return tx.update(ds.reference, {
        'products': [],
      });
    };

    return _firestore.runTransaction(createTransaction).catchError((e) {
      print(e);
    });
  }

  Future<List<Product>> getCartItems(String userId) async {
    final DocumentSnapshot ds =
        await _firestore.collection(collection).doc(userId).get();

    if (ds.exists) {
      return Product.fromMap(ds.data()).products;
    }

    return [];
  }

  Future<void> addOrder(Order order, String userId) async {
    // ignore: prefer_function_declarations_over_variables
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc(userId));

      final List<Order> orders = [];
      if (ds.exists) {
        orders.addAll(Order.fromMap(ds.data()));
      }

      orders.add(order);

      return tx.update(ds.reference, {
        'orders': orders.map((order) => order.toMap()).toList(),
      });
    };

    return _firestore.runTransaction(createTransaction).catchError((e) {
      print(e);
    });
  }

  Future<List<Order>> getOrders(String userId) async {
    final DocumentSnapshot ds =
        await _firestore.collection(collection).doc(userId).get();

    if (ds.exists) {
      return Order.fromMap(ds.data()).orders;
    }

    return [];
  }

  Future<void> deleteOrder(Order order, String userId) async {
    // ignore: prefer_function_declarations_over_variables
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc(userId));

      final List<Order> orders = [];
      if (ds.exists) {
        orders.addAll(Order.fromMap(ds.data()));
      }

      orders.remove(order);

      return tx.update(ds.reference, {
        'orders': orders.map((order) => order.toMap()).toList(),
      });
    };

    return _firestore.runTransaction(createTransaction).catchError((e) {
      print(e);
    });
  }

  Future<void> deleteAllOrders(String userId) async {
    // ignore: prefer_function_declarations_over_variables
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc(userId));

      return tx.update(ds.reference, {
        'orders': [],
      });
    };

    return _firestore.runTransaction(createTransaction).catchError((e) {
      print(e);
    });
  }

  Future<void> deleteAllCart(String userId) async {
    // ignore: prefer_function_declarations_over_variables
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc(userId));

      return tx.update(ds.reference, {
        'products': [],
      });
    };

    return _firestore.runTransaction(createTransaction).catchError((e) {
      print(e);
    });
  }

  Future<void> deleteAllCartItems(String userId) async {
    // ignore: prefer_function_declarations_over_variables
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firestore.collection(collection).doc(userId));

      final List<Product> products = [];
      if (ds.exists) {
        products.addAll(Product.fromMap(ds.data()));
      }

      products.clear();

      return tx.update(ds.reference, {
        'products': products.map((product) => product.toMap()).toList(),
      });
    };

    return _firestore.runTransaction(createTransaction).catchError((e) {
      print(e);
    });
  }
}
