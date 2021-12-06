import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natore_project/services/order_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderListPage> {
  OrderServices _orderServices = OrderServices();

  List<DocumentSnapshot> _orders = [];
  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  _getOrders() async {
    Stream<QuerySnapshot<Object?>> _orders = _orderServices.getOrders();
    setState(() {
      this._orders = _orders as List<DocumentSnapshot<Object?>>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (BuildContext context, int index) {
          return _orderListItem(_orders[index]);
        },
      ),
    );
  }

  Widget _orderListItem(DocumentSnapshot order) {
    return Container();
  }
}
