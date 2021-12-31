import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natore_project/products_of_seller_page.dart';

/*
* sıkıntılar:
* sıkıntı1
*
* */
double saticiPuani =
    3.8; //bunu getter ile backenden çağıracağımızdan şuanlık sıkıntı yok

// satıcıyla iletişime geç butonuna basılınca bu sayfaya gelecek
class SellerPage extends StatelessWidget {
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
  String marketName = "empty";
  SellerPage.withMarketName(String _name) {
    marketName = _name;
  }
  @override
  void initState() {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(eMail);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(eMail);
    print(eMail);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color.fromRGBO(6, 219, 162, 10),
        //leading: CircleAvatar(),
        title: StreamBuilder<DocumentSnapshot>(
          stream: babaRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            return Text(
              'Sütçü Dedeeeeeeeeeeeeee', //'${asyncSnapshot.data.data()['MarketName']}',
              maxLines: 1,
              style: GoogleFonts.goudyBookletter1911(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.1,
                  //wordSpacing: 2,
                  fontSize: 20),
            );
          },
        ),
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
                              Text(
                                "Ahmet Bekir Sütsüz", // sıkıntı1: çok uzun olursa sıkıntı oluyor buna daha sonra bakacağım inşaAllah
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Atasehir / İstanbul',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.volunteer_activism,
                        ),
                        const Text(
                          "En Çok Tercih Edilen Ürünleri",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://i4.hurimg.com/i/hurriyet/75/750x422/5efd65bc45d2a04258b8487d.jpg",
                            fit: BoxFit.fill,
                            height: 130,
                            width: 110,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "bbbbbbbbbbbbbb", //productName,
                                    maxLines: 1,

                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "2000 ₺", // price.toString() + ' ₺',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
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
                                  // UrunPuaniGoster(productID),
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://i4.hurimg.com/i/hurriyet/75/750x422/5efd65bc45d2a04258b8487d.jpg",
                            fit: BoxFit.fill,
                            height: 130,
                            width: 110,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "asdsadsaddsadasdasd", //productName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "1000 ₺", // price.toString() + ' ₺',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
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
                                  // UrunPuaniGoster(productID),
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
                        ),
                      ],
                    ),
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
