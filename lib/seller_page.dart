import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natore_project/products_of_seller_page.dart';
import 'package:natore_project/services/product_services.dart';

/*
* sıkıntılar:
* sıkıntı1
*
* */

double saticiPuani =
    3.8; //bunu getter ile backenden çağıracağımızdan şuanlık sıkıntı yok

// satıcıyla iletişime geç butonuna basılınca bu sayfaya gelecek
class SellerPage extends StatelessWidget {
  late CollectionReference updateRef;
  SellerPage({Key? key}) : super(key: key);
  //sefadan alınan market ismi buraya alınır. burdan bu isim ile ahmedin
  //ilgili fonksiyonu ile gerekli bilgiler çekilir:
  /* ahmette bulunması gereken fonksiyonlar:
  *   String getName(marketName); satıcının adı
  *   String getAddress(marketName);
  *   Image getProfilePhoto(marketName);
  *   String getSellerName(marketName);
  *   double
  * */
  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  String marketName = MarketName; // products_of_seller dan alındı
  SellerPage.withMarketName(String _name) {
    marketName = _name;
  }
  Future<DocumentSnapshot> getDocumentSeller(String sellerMail) async {
    print("1111112" + sellerMail);
    return _firestore.collection('Users').doc(sellerMail).get();
  }

  // market name gibi verileri alan constructer
  @override
  void initState() {
    updateRef = _firestore.collection('Users');
    //var babaRef = updateRef.doc(eMail);
  }

  ProductServices _productServices = ProductServices();
  @override
  Widget build(BuildContext context) {
    //CollectionReference updateRef = _firestore.collection('Users');
    //var babaRef = updateRef.doc(eMail);
    print("email:" + eMail.toString());
    print("MarketName--" + MarketName + "--");
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color.fromRGBO(6, 219, 162, 10),
        //leading: CircleAvatar(),
        title: Text(
          MarketName, //'${asyncSnapshot.data.data()['MarketName']}',
          maxLines: 1,
          style: GoogleFonts.goudyBookletter1911(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.1,
              //wordSpacing: 2,
              fontSize: 20),
        ),
        /*StreamBuilder<DocumentSnapshot>(
          stream: babaRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            return Text(
              MarketName, //'${asyncSnapshot.data.data()['MarketName']}',
              maxLines: 1,
              style: GoogleFonts.goudyBookletter1911(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.1,
                  //wordSpacing: 2,
                  fontSize: 20),
            );
          },
        ),*/
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //en üstteki kısım:
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 110,
                          height: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                                'https://d1hzl1rkxaqvcd.cloudfront.net/contest_entries/1321793/_600px/33f9689616d2c31873e72e65ce2019d1.jpg'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: getDocumentSeller((eMail[0] == " ")
                                    ? eMail.substring(1, eMail.length)
                                    : eMail),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    print("has no data");
                                    var isim = snapshot.data!.get('Name');
                                    var soyisim = snapshot.data!.get('Surname');
                                    String adres = snapshot.data!.get('Adress');
                                    String ekranaBasilanAdres = adres[0];
                                    for (int i = 1; i < adres.length; i++) {
                                      if (adres[i].compareTo('A') >= 0 &&
                                          adres[i].compareTo('Z') <= 0) {
                                        ekranaBasilanAdres =
                                            ekranaBasilanAdres +
                                                " / " +
                                                adres[i];
                                      } else if (adres[i].compareTo('0') >= 0 &&
                                          adres[i].compareTo('9') <= 0) {
                                      } else {
                                        ekranaBasilanAdres += adres[i];
                                      }
                                    }
                                    return RichText(
                                      text: TextSpan(
                                        text: isim +
                                            " " +
                                            soyisim +
                                            "\n" +
                                            ekranaBasilanAdres,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        /*children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(Icons.star),
                  ),
                ),
              ],*/
                                      ),
                                    );
                                    //print("It is not Exist");

                                    //return Text(snapshot.data["name"].toString());
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.none) {
                                    return Text("No data");
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  //en çok sevilen ürünler
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.volunteer_activism,
                        ),
                        const Text(
                          "En Çok Sevilen Ürünü",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //ürün 1
                  /*
                  StreamBuilder(
                      stream: _productServices.getProductsOfSellerStreamMarket(
                          "hsnsvn71@gmail.com"),
                      builder:
                          (BuildContext context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasError) {
                          return const Center(
                            child: Text("Bir hata olustu"),
                          );
                        } else {
                          if (asyncSnapshot.hasData) {
                            List<DocumentSnapshot> list =
                                asyncSnapshot.data.docs;
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
                                  print(list[index].get('id') +
                                      " name:" +
                                      list[index].get('name') +
                                      "WWWW-" +
                                      eMail +
                                      "-");
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
                                        ),
                                        if (index * 2 + 1 < list.length)
                                          BlueBox(
                                            list[index * 2 + 1].get('image'),
                                            list[index * 2 + 1].get('name'),
                                            list[index * 2 + 1].get('price'),
                                            list[index * 2 + 1].get('id'),
                                            list[index * 2 + 1].get('mail'),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                      }),
                */
                  Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      StreamBuilder(
                          stream: _productServices
                              .getProductsOfSellerStreamMarket(MarketName),
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            if (asyncSnapshot.hasError) {
                              return const Center(
                                child: Text("Bir hata olustu"),
                              );
                            } else {
                              if (asyncSnapshot.hasData) {
                                List<DocumentSnapshot> list =
                                    asyncSnapshot.data.docs;
                                list.sort((b, a) =>
                                    a.get('rate').compareTo(b.get('rate')));
                                for (int i = 0; i < list.length; i++) {
                                  print(list[i].get('id') +
                                      " name:" +
                                      list[i].get('name'));
                                }
                                return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 16, 8, 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            list[0].get('image'),
                                            fit: BoxFit.fill,
                                            height: 130,
                                            width: 110,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    list[0].get(
                                                        'name'), //productName,
                                                    maxLines: 1,

                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        list[0]
                                                                .get('price')
                                                                .toStringAsFixed(
                                                                    2)
                                                                .toString() +
                                                            ' ₺', // price.toString() +
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    4, 0, 1, 0),
                                                            child: Icon(
                                                              Icons.star,
                                                              color: Color(
                                                                  0xff52B69A),
                                                              size: 18,
                                                            ),
                                                          ),

                                                          Text(list[0]
                                                              .get('rate')
                                                              .toStringAsFixed(
                                                                  1)
                                                              .toString()),
                                                          // Paunı gösterirken direkt bunu çağır. product_of_seller_page'de kullanıldı bakabilirsin
                                                          /*Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text(
                      rate.toString(),
                      style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),*/
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ));
                                /*Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      BlueBox(
                                        list[0].get('image'),
                                        list[0].get('name'),
                                        list[0].get('price'),
                                        list[0].get('id'),
                                        list[0].get('mail'),
                                      ),
                                    ],
                                  ),
                                );*/
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                          })
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PuanKutucuklari extends StatelessWidget {
  final String metin;
  final double puan;
  PuanKutucuklari({
    required this.metin,
    required this.puan,
  });
  // const PuanKutucuklari({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(4.0),
      height: 50,
      width: 60,
      decoration: BoxDecoration(
        color: getColor(puan),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            metin,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            puan.toString(), //bura getterla alınacak,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color getColor(double score) {
  if (score < 3.0)
    return Colors.redAccent;
  else if (score < 4.0)
    return Colors.amber;
  else if (score > 4.0 && score <= 5.0)
    return Colors.green; //sefa bunu yap :D greenAccent[400] değil
  return Colors.black; //error
}
