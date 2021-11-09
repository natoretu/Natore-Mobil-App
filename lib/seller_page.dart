import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'contact_with_seller.dart';

/*
* sıkıntılar:
* sıkıntı1
*
* */
double saticiPuani =
    3.8; //bunu getter ile backenden çağıracağımızdan şuanlık sıkıntı yok

// satıcıyla iletişime geç butonuna basılınca bu sayfaya gelecek
class SellerPage extends StatelessWidget {
  const SellerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightGreen[300],
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Color.fromRGBO(6, 219, 162, 10),
          //leading: CircleAvatar(),
          title: const Text('Sütçü Dede Süt Ürünleri'),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: 15),
              Column(
                children: [
                  //en üstteki kısım:
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    height: 220,

                    //width: Size.fromWidth(),

                    decoration: BoxDecoration(
                      color: Color.fromRGBO(6, 219, 162, 10),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //satıcının fotoğrafı
                          Container(
                            //buraya image gelecek
                            height: 130,
                            width: 130,

                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Container(
                              //width: 120,
                              //height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://d1hzl1rkxaqvcd.cloudfront.net/contest_entries/1321793/_600px/33f9689616d2c31873e72e65ce2019d1.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Ahmet Bekir Sütsüz", // sıkıntı1: çok uzun olursa sıkıntı oluyor buna daha sonra bakacağım inşaAllah
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 15,
                                      // ),
                                      Container(
                                        //satıcı puanı
                                        height: 25,
                                        width: 45,
                                        margin: EdgeInsets.all(5.0),
                                        decoration: new BoxDecoration(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          color: Colors.amber,
                                          boxShadow: [
                                            new BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 1.0,
                                                offset: new Offset(5.0, 5.0))
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.star_rate,
                                              size: 17,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              saticiPuani.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Icon(Icons.location_on_outlined),
                                  Text(
                                    'Sakarya Mahallesi Sütçü Baba bulvarı no:46',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Wrap(
                                    // mainAxisAlignment:
                                    //   MainAxisAlignment.spaceEvenly,

                                    alignment: WrapAlignment.spaceAround,
                                    children: [
                                      PuanKutucuklari(
                                          metin: "Lezzet",
                                          puan:
                                              4.6), //burası getterlar ile alınacak
                                      PuanKutucuklari(
                                          metin: "Güven", puan: 3.9),
                                      PuanKutucuklari(
                                        metin: "iletişim",
                                        puan: 2.9,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //En çok sattığı ürünler:
                  Container(
                    color: Colors.grey[50],
                    height: 75,
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
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  EnCokTercihEdilenUrunler(
                    name: "Köy Yumurtası",
                    imageOfProduct: Image.network(
                      "https://i4.hurimg.com/i/hurriyet/75/750x422/5efd65bc45d2a04258b8487d.jpg",
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ), //bunu image alacak şekilde değiştirceğim
                  EnCokTercihEdilenUrunler(
                    name: "Köy Yumurtası",
                    imageOfProduct: Image.network(
                      "https://i4.hurimg.com/i/hurriyet/75/750x422/5efd65bc45d2a04258b8487d.jpg",
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  //comments
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SecondRoute()),
                      );
                    },
                    child: Container(
                      //buraya yorumlar butonu koyacam inşaAllah

                      height: 50,
                      child: Text("buraya comments gelecek"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
*  Container(
              height: 170.0,
              color: Colors.amber,
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Text("en çok tercih edilen ürün1")),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        "https://i4.hurimg.com/i/hurriyet/75/750x422/5efd65bc45d2a04258b8487d.jpg",
                        height: 100.0,
                        width: 50.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),


* */

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

class EnCokTercihEdilenUrunler extends StatelessWidget {
  final String name;
  final Image imageOfProduct;
  EnCokTercihEdilenUrunler({
    required this.name,
    required this.imageOfProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(6, 219, 162, 10),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Text(name)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: imageOfProduct,
            ),
          ),
          //imageOfProduct,
        ],
      ),
    );
  }
}
