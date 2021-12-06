import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:natore_project/services/order_services.dart';
import 'package:flutter/material.dart'; // new

class AddOrderPage extends StatefulWidget {
  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  var _firebase = FirebaseFirestore.instance;
  var _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
      ),
    );
  }
}
