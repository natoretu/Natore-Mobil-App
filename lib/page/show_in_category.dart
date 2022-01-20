import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:natore_project/products_of_seller_page.dart';
import 'package:natore_project/services/favorites_services.dart';
import 'package:natore_project/services/product_services.dart';

String UserId = "";
FavoritesServices favoritesServices = FavoritesServices();
final user = FirebaseAuth.instance.currentUser!;
String eMail = "";
String siralanacakUrunAdi = "";

class ShowInCategory extends StatelessWidget {
  ShowInCategory({required String urun}) {
    siralanacakUrunAdi = urun;
  }
  //bu gereksiz olabilir
  ShowInCategory.withEmailAndName(String name, String e_mail) {
    UserId = name;
    eMail = e_mail;
  }
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'SATICI BILGILERI');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*prduct serevice*/

  ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color(0xff06D6A0),
        title: Text("Filtrele: " + siralanacakUrunAdi),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  //Burda:
                  stream: _productServices
                      .getProductsOfSellerStreamCategory(siralanacakUrunAdi),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    print(siralanacakUrunAdi);
                    _productServices
                        .getProductsOfSellerStreamCategory(siralanacakUrunAdi)
                        .first
                        .then((value) => print(value.docs));
                    if (asyncSnapshot.hasError) {
                      return const Center(
                        child: Text("Bir hata olustu"),
                      );
                    } else {
                      if (asyncSnapshot.hasData) {
                        List<DocumentSnapshot> list = asyncSnapshot.data.docs;
                        print(list);
                        return Flexible(
                          child: ListView.builder(
                            //itemCount: list.length,
                            itemCount: list.length % 2 == 0
                                ? list.length ~/ 2
                                : list.length ~/ 2 + 1,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                  future: favoritesServices.isFavorite(
                                      user.email.toString(),
                                      list[index * 2].get('id')),
                                  builder: (BuildContext context,
                                      AsyncSnapshot asyncSnapshot) {
                                    print("asyncSnapshot.data: " +
                                        asyncSnapshot.data.toString());
                                    switch (asyncSnapshot.connectionState) {
                                      case ConnectionState.none:
                                        return Text("");
                                      case ConnectionState.active:
                                      case ConnectionState.waiting:
                                        return Text("");
                                      case ConnectionState.done:
                                        return Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              BlueBox(
                                                  list[index * 2].get('image'),
                                                  list[index * 2].get('name'),
                                                  list[index * 2].get('price'),
                                                  list[index * 2].get('id'),
                                                  list[index * 2].get('mail'),
                                                  asyncSnapshot.data),
                                              if (index * 2 + 1 < list.length)
                                                BlueBox(
                                                    list[index * 2 + 1]
                                                        .get('image'),
                                                    list[index * 2 + 1]
                                                        .get('name'),
                                                    list[index * 2 + 1]
                                                        .get('price'),
                                                    list[index * 2 + 1]
                                                        .get('id'),
                                                    list[index * 2 + 1]
                                                        .get('mail'),
                                                    asyncSnapshot.data),
                                            ],
                                          ),
                                        );

                                      default:
                                        return Text("default");
                                    }
                                  });
                            },
                          ),
                        );
                      } else {
                        return const Center(
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
