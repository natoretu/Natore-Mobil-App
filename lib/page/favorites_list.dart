import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natore_project/Anasayfa.dart';
import 'package:natore_project/page/product_detail.dart';
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
      appBar: AppBar(
        title: const Text(
          'Favoriler',
          style: TextStyle(
              fontFamily: 'Zen Antique Soft',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff07cc99),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              StreamBuilder(
                  stream: _favoriteServices.getFavorites(user.email.toString()),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasError) {
                      return const Center(
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
                                            return const Text("");
                                          case ConnectionState.active:
                                          case ConnectionState.waiting:
                                            return const Text(
                                                ""); //watrıng or actıve
                                          case ConnectionState.done:
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                WideBlueBox(
                                                    asyncSnapshot.data
                                                        .get('image'),
                                                    asyncSnapshot.data
                                                        .get('name'),
                                                    asyncSnapshot.data
                                                        .get('price'),
                                                    asyncSnapshot.data
                                                        .get('id'),
                                                    asyncSnapshot.data
                                                        .get('mail'),
                                                    true),
                                              ],
                                            );

                                          default:
                                            return const Text("default");
                                        }
                                      });
                                }));
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

class WideBlueBox extends StatefulWidget {
  /*burdaki url daha sonra direkt Image'e dönecek*/

  WideBlueBox(String _url, String productName, double price, String id,
      String mail, bool isFavorite) {
    //unnamed constructor

    this._url = _url;
    this.productName = productName;
    this.price = price;
    this.productID = id;
    this.mail = mail;
    this.isFavorite = isFavorite;
  }

  bool s = false;
  String mail = 'MAIL';
  String _url = 'BOŞ.ABi';
  String productName = 'BOŞ.ABi';
  double price = 0.0;
  String productID = "";
  Image img = Image.network("burası geçici");
  bool isFavorite = false;
  @override
  State<WideBlueBox> createState() => _WideBlueBox();
}

class _WideBlueBox extends State<WideBlueBox> {
  Color favoriteColor = Colors.teal.shade700;
  Color notfavoriteColor = Colors.teal.shade100;
  String id = 'ID';

  IconData bosGalp = const IconData(0xe25c, fontFamily: 'MaterialIcons');

  IconData doluGalp = const IconData(0xe25b, fontFamily: 'MaterialIcons');

  IconData galp = const IconData(0xe25c, fontFamily: 'MaterialIcons');

  double rate = 0.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.teal.shade100,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10))),

          height: width / 2.5, //1.5
          width: width - 20, //1.5
          child: InkWell(
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //--------------------resim--------------------
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width / 3,
                      height: width / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget._url)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.teal.shade200,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  //--------------------diğerleri--------------------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: width / 3,
                            child: Text(
                              widget.productName,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),

                          /* ürünün fiyatı ve puanı */
                          SizedBox(
                            width: width / 3,
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  widget.price.toString() + ' ₺',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(4, 0, 1, 0),
                                      child: Icon(
                                        Icons.star,
                                        color: Color(0xff52B69A),
                                        size: 18,
                                      ),
                                    ),
                                    //rate
                                    UrunPuaniGoster(widget.productID),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //--------------------kalp iconu--------------------
                  IconButton(
                    icon: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Favorites')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text('Bir seyler ters gitti!');
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) return Text('');
                          final data = snapshot.requireData;
                          var currentMessages = (data.docs.where((element) =>
                              (element.get('userId') ==
                                  user.email.toString())));
                          var favourities =
                              currentMessages.first.get('productsIds');
                          if (currentMessages.isNotEmpty) {
                            var favouritiesList = List.from(favourities);
                            bool favoriMi =
                                favouritiesList.contains(widget.productID);
                            return Icon(doluGalp,
                                size: 34,
                                color: favoriMi
                                    ? favoriteColor
                                    : notfavoriteColor);
                          }
                          //!arayüz
                          return const Text(
                              ''); // daha once konusulmus kımse yoksa bu basiliyor
                        })
                    /*Icon(doluGalp,
                        size: 34,
                        color: widget.isFavorite
                            ? favoriteColor
                            : notfavoriteColor)*/
                    ,
                    onPressed: () async {
                      //burdan databaseİ dolduracağım inşaAllah

                      // setState(() async {
                      //isFavorite = !isFavorite;
                      widget.isFavorite = await favoritesServices.isFavorite(
                          user.email.toString(), widget.productID);
                      print("-------------------------------");
                      print("userid:" + user.email.toString());
                      print("id:" + widget.productID);
                      print(favoritesServices.isFavorite(
                          user.email.toString(), widget.productID));
                      print(widget.isFavorite);
                      print("-------------------------------");
                      if (widget.isFavorite) {
                        print("111");
                        favoritesServices.removeFromFavorites(
                            user.email.toString(), widget.productID);
                      } else {
                        print("222");
                        favoritesServices.appendToFavorites(
                            user.email.toString(), widget.productID);
                      }
                      widget.isFavorite = !widget.isFavorite;
                      //_MyHomePageState.refreshList();
                      final snackBar = SnackBar(
                        duration: Duration(seconds: 1),
                        backgroundColor: widget.isFavorite
                            ? Colors.teal.withOpacity(0.95)
                            : Colors.redAccent.withOpacity(0.9),
                        content: widget.isFavorite
                            ? const Text(
                                'Ürün favorilere eklendi!',
                                style: TextStyle(fontSize: 16),
                              )
                            : const Text(
                                'Ürün favorilerden çıkarıldı!',
                                style: TextStyle(fontSize: 16),
                              ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // });

                      //burda isFavorite'e göre database update edilecek. Bedirin fonksiyonları kullanılacak
                    },
                  ),
                ],
              ),
              onTap: () {
                print(widget.productName +
                    " bu: " +
                    widget._url +
                    "  " +
                    widget.mail +
                    " IDDDD" +
                    widget.productID);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                          widget.productName,
                          widget._url,
                          widget.price,
                          widget.productID,
                          widget.mail)), //burası arama butonu
                );
              }),
        ),
      ),
    );
  }
}

FutureBuilder SaticiPuaniDondur(String email) {
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('Users')
        .doc((eMail[0] == " ") ? eMail.substring(1, eMail.length) : eMail)
        .get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }

      if (snapshot.hasData && !snapshot.data!.exists) {
        return Text("Document does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Text(
          data['rate'].toStringAsFixed(1),
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        );
      }

      return Text("");
    },
  );
}
