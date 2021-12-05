import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natore_project/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    var _firebase = FirebaseFirestore.instance;
    var ref = _firebase.collection('Products');

    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: Center(
        child: Container(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: null,
              ),
              StreamBuilder(
                  stream:
                      _productServices.getProductsOfSellerStreamMail("tavsan@"),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasError) {
                      return Center(
                        child: Text("Bir hata olustu"),
                      );
                    } else {
                      if (asyncSnapshot.hasData) {
                        List<DocumentSnapshot> list = asyncSnapshot.data.docs;
                        return Flexible(
                            child: ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      child: ListTile(
                                          title: Text(
                                              '${list.elementAt(index).data().toString()}'),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              await list
                                                  .elementAt(index)
                                                  .reference
                                                  .delete();
                                            },
                                          )));
                                }));
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
