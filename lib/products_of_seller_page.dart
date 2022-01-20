import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natore_project/page/product_detail.dart';
import 'package:natore_project/services/favorites_services.dart';
import 'package:natore_project/services/product_services.dart';

import 'seller_page.dart';

final String Ali_imran_148 =
    "فَاٰتٰيهُمُ اللّٰهُ ثَوَابَ الدُّنْيَا وَحُسْنَ ثَوَابِ الْاٰخِرَةِؕ وَاللّٰهُ يُحِبُّ الْمُحْسِنٖينَࣖ ";
final String Ali_imran_148_tr =
    "Bu yüzden Allah onlara dünya nimetini ve âhiret nimetinin de güzelini verdi. Allah işini güzel yapanları sever.";
// bunlar silinecek. bunların yerini direkt backendden alınacak getter fonksiyonları  alacak
double fiyat = 20;
String urunAdi = "";
String MarketName = "";
String resimUrl =
    'https://d2uiaykj5yb3c0.cloudfront.SellerPagenet/tahtakale/img/p/39006c70-bd82-42c0-929d-3c6cacaa31d7.jpg';
double saticiPuani = 3.8;
String eMail = "";
String image_pr = "";

FavoritesServices favoritesServices = FavoritesServices();
final user = FirebaseAuth.instance.currentUser!;

class ProductsOfSellerPage extends StatefulWidget {
  ProductsOfSellerPage(String name, String Email) {
    print("name :" + name + "---");
    MarketName = name;
    print("--" + Email + "--");
    eMail = Email;
    print("Market Name:" + MarketName);
    print("email: " + eMail);
  }
  //bu gereksiz olabilir
  ProductsOfSellerPage.withEmailAndName(String name, String e_mail) {
    print("---" + name + "---");
    MarketName = name;
    eMail = e_mail;
  }

  @override
  State<ProductsOfSellerPage> createState() => _ProductsOfSellerPageState();
}

class _ProductsOfSellerPageState extends State<ProductsOfSellerPage> {
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
  int _selectedIndex = 0;
  final List<double> RateList = [
    4.8,
    4.5,
    4.2,
    3.8,
    2.9,
    4.2,
    3.6,
    2.7,
    1.4,
    3.5,
    4.5,
    3.8,
    4.6,
    2.9,
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>>? _listStream = null;

  Color? RateColor(double rate) {
    return rate > 4
        ? Colors.greenAccent[400]
        : (rate > 3 && rate < 4)
            ? Colors.amber
            : rate < 3
                ? Colors.redAccent
                : null; //dummy
  }

  /*prduct serevice*/
  ProductServices _productServices = ProductServices();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(eMail);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff06D6A0),
        toolbarHeight: 95,
        actions: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 32),
              margin: const EdgeInsets.all(16.0),
              child: InkWell(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //buraya image gelecek
                      height: 70,
                      width: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: FutureBuilder<DocumentSnapshot>(
                        future: updateRef
                            .doc((eMail[0] == " ")
                                ? eMail.substring(1, eMail.length)
                                : eMail)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Container(
                              //width: 120,
                              //height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  //bura ahmetten alınacak
                                  image: NetworkImage(data['Image']),
                                  // static
                                  //'https://d1hzl1rkxaqvcd.cloudfront.net/contest_entries/1321793/_600px/33f9689616d2c31873e72e65ce2019d1.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }

                          return Text("");
                        },
                      ),
                      /*Container(
                        //width: 120,
                        //height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            //bura ahmetten alınacak
                            image: NetworkImage(
                                // static
                                'https://d1hzl1rkxaqvcd.cloudfront.net/contest_entries/1321793/_600px/33f9689616d2c31873e72e65ce2019d1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),*/
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    //puan kısmı

                    /*** Rate and market name ***/
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          MarketName, //getter ile satıcının adı alınacak
                          maxLines: 1,
                          style: GoogleFonts.goudyBookletter1911(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.1,
                              //wordSpacing: 2,
                              fontSize: 20),
                        ),
                        Material(
                          color: RateColor(RateList[0]),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Wrap(
                              spacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(4, 0, 1, 0),
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    //rate
                                    // e mail basında bosluk oldugundan boyle bır yola gıdıldı, email basındakı bosluk bazısında olur bazısında olmaz dıye kontrol eklendı
                                    saticiPuaniGoster((eMail[0] == " ")
                                        ? eMail.substring(1, eMail.length)
                                        : eMail),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  // gereken bilgiler burda satıcı sayfasına gonderılcek
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SellerPage() /*CustomTabs()*/), //seller's page
                  );
                },
              ),
            ),
          ),
        ],
        //bottom: PreferredSizeWidget(),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              StreamBuilder(
                  stream: _productServices
                      .getProductsOfSellerStreamMarket(MarketName),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasError) {
                      return const Center(
                        child: Text("Bir hata olustu"),
                      );
                    } else {
                      if (asyncSnapshot.hasData) {
                        List<DocumentSnapshot> list = asyncSnapshot.data.docs;
                        for (int i = 0; i < list.length; i++) {
                          print(list[i].get('id') +
                              " name:" +
                              list[i].get('name'));
                        }

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
                        return Center(
                            child: CircularProgressIndicator.adaptive(
                          backgroundColor: Color(0xff06D6A0),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyan),
                        ));
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

//güncellendi
/*___________________________________________________________*/
/*_____________________ BLUEBOX CLASS ______________________*/

class BlueBox extends StatefulWidget {
  /*burdaki url daha sonra direkt Image'e dönecek*/

  BlueBox(String _url, String productName, double price, String id, String mail,
      bool isFavorite) {
    //unnamed constructor

    this._url = _url;
    this.productName = productName;
    this.price = price;
    this.productID = id;
    this.mail = mail;
    this.isFavorite = isFavorite;
  }
  //ikinci constructor
  //bu daha sonra databaseden image döndüren fonksiyonu yazdığımızda kullanılacak olan constructor.
  // BlueBox.ImageConstructor(...) şeklinde kullanılır
  BlueBox.ImageConstructor(
      Image img, String productName, double price, String id, String mail) {
    this.img = img;
    this.productName = productName;
    this.price = price;
    this.productID = id;

    //this.productID = mail;
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
  State<BlueBox> createState() => _BlueBoxState();
}

class _BlueBoxState extends State<BlueBox> {
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
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Stack(
              //alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                      child: Column(
                        children: [
                          /*ÜRÜN RESMİ*/
                          Container(
                            margin: EdgeInsets.all(1.0),
                            width: width / 3, //1.5
                            height: width / 2.5, //1.9
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget._url),
                                //AssetImage(//bu resim databaseden alıncak
                                //     "assets/milk128.png"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white10,
                              border: Border.all(
                                  color: Colors.white10,
                                  style: BorderStyle.solid,
                                  width: 0.3),
                            ),
                          ),
                          /*ÜRÜN ADI - FİYATI - PUANI*/
                          Column(
                            children: [
                              SizedBox(
                                width: width / 3,
                                child: FittedBox(
                                  fit: BoxFit.none,
                                  child: Text(
                                    widget.productName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              /* ürünün fiyatı ve puanı */
                              SizedBox(
                                width: width / 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          padding:
                                              EdgeInsets.fromLTRB(4, 0, 1, 0),
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
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: IconButton(
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
                ),
              ],
            ),
          ],
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
