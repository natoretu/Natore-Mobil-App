import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:natore_project/model/order.dart';
import 'package:natore_project/model/product.dart';

class CartServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'Cart';
}
