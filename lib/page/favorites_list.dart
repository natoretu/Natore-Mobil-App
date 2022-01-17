import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natore_project/Anasayfa.dart';
//import 'package:natore_project/page/show_in_category.dart';
import 'package:natore_project/products_of_seller_page.dart';
import 'package:natore_project/services/favorites_services.dart';
import 'package:natore_project/services/product_services.dart';

String currentUser = currentUserId_forFavoriteList;
ProductServices _productServices = ProductServices();
FavoritesServices favoritesServices = FavoritesServices();
final user = FirebaseAuth.instance.currentUser!;

class FavoriteListPage extends StatefulWidget {
  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  FavoritesServices _favoriteServices = FavoritesServices();

  @override
  Widget build(BuildContext context) {
    var _firebase = FirebaseFirestore.instance;
    var ref = _firebase.collection('Favorites');

    return Scaffold(
      appBar: AppBar(title: Text('Favorites List')),
      body: Center(
        child: Container(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: null,
              ),
              StreamBuilder(
                  stream: _favoriteServices.getFavorites(user.email.toString()),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasError) {
                      return Center(
                        child: Text("Bir hata olustu"),
                      );
                    } else {
                      if (asyncSnapshot.hasData) {
                        List<DocumentSnapshot> list = asyncSnapshot.data.docs;
                        List<dynamic> plist =
                            list.elementAt(0).get('productsIds');
                        print(plist);
                        print(plist.length);
                        print(list);
                        return Flexible(
                            child: ListView.builder(
                                itemCount: plist.length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder(
                                      future: _productServices
                                          .getPr(plist.elementAt(index)),
                                      builder: (BuildContext context,
                                          AsyncSnapshot asyncSnapshot) {
                                        switch (asyncSnapshot.connectionState) {
                                          case ConnectionState.none:
                                            return Text("");
                                          case ConnectionState.active:
                                          case ConnectionState.waiting:
                                            return Text("watrıng or actıve");
                                          case ConnectionState.done:
                                            return BlueBox(
                                                asyncSnapshot.data.get('image'),
                                                asyncSnapshot.data.get('name'),
                                                asyncSnapshot.data.get('price'),
                                                asyncSnapshot.data.get('id'),
                                                asyncSnapshot.data.get('mail'),
                                                true);

                                          default:
                                            return Text("default");
                                        }
                                      });
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
