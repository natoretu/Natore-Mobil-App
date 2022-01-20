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
  String _userId = eMail;

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
    updateRef = _firestore.collection('Users');
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
                        SizedBox(height: 5),
                        Container(
                          width: 90,
                          height: 100,
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
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
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
                          ), /*ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                                'https://d1hzl1rkxaqvcd.cloudfront.net/contest_entries/1321793/_600px/33f9689616d2c31873e72e65ce2019d1.jpg'),
                          ),*/
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
                                  return Center(
                                      child: CircularProgressIndicator.adaptive(
                                    backgroundColor: Color(0xff06D6A0),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.cyan),
                                  ));
                                },
                              ),
                              Material(
                                color: Colors.greenAccent[400],
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Wrap(
                                    spacing: 4,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(4, 0, 1, 0),
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          //rate
                                          // e mail basında bosluk oldugundan boyle bır yola gıdıldı, email basındakı bosluk bazısında olur bazısında olmaz dıye kontrol eklendı
                                          SaticiPuaniDondur((eMail[0] == " ")
                                              ? eMail.substring(1, eMail.length)
                                              : eMail),

                                          /*saticiPuaniGoster((eMail[0] == " ")
                                        ? eMail.substring(1, eMail.length)
                                        : eMail),*/
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  //en çok sevilen ürünler
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.volunteer_activism,
                        ),
                        SizedBox(height: 1, width: 20),
                        const Text(
                          "En Çok Sevilen Ürünler",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      const SizedBox(
                        height: 5,
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

                                // burda row şeklinde ve urunlere tıklanabiliniyor
                                return (list.length == 0)
                                    ? Text(
                                        "Hiç ürün yok",
                                        style: TextStyle(fontSize: 16),
                                      )
                                    : Row(
                                        children: [
                                          Padding(
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
                                                    false),
                                              ],
                                            ),
                                          ),
                                          (list.length == 1)
                                              ? SizedBox(height: 1)
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      BlueBox(
                                                          list[1].get('image'),
                                                          list[1].get('name'),
                                                          list[1].get('price'),
                                                          list[1].get('id'),
                                                          list[1].get('mail'),
                                                          false),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Color(0xff06D6A0),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.cyan),
                                ));
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
