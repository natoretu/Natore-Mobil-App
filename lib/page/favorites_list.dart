import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natore_project/services/favorites_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                  stream:
                  _favoriteServices.getFavorites("hsnsvn71@gmail.com"),
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
