import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:natore_project/page/product_detail.dart';
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
    'https://d2uiaykj5yb3c0.cloudfront.net/tahtakale/img/p/39006c70-bd82-42c0-929d-3c6cacaa31d7.jpg';
double saticiPuani = 3.8;
String eMail = "";
String image_pr = "";

class ProductsOfSellerPage extends StatelessWidget {
  ProductsOfSellerPage(String name) {
    print(name);
    MarketName = name;
  }
  //bu gereksiz olabilir
  ProductsOfSellerPage.withEmailAndName(String name, String e_mail) {
    MarketName = name;
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
  int _selectedIndex = 0;

  /*prduct serevice*/
  ProductServices _productServices = ProductServices();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff06D6A0),
        toolbarHeight: 80,

        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.of(context)
        //       .pop(), //buraya sefanın sayfası eklenecek inşaAllah
        // ),
        actions: [
          Container(
            width: 280,
            margin: const EdgeInsets.all(16.0),
            child: InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    //buraya image gelecek
                    height: 80,
                    width: 100,

                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Container(
                      //width: 120,
                      //height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          //bura ahmetten alınacak
                          image: NetworkImage(
                              'https://d1hzl1rkxaqvcd.cloudfront.net/contest_entries/1321793/_600px/33f9689616d2c31873e72e65ce2019d1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  //puan kısmı
                  Container(
                    height: 25,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.amber,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1.0,
                            offset: Offset(5.0, 5.0))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.star_rate,
                          size: 17,
                          color: Colors.white,
                        ),
                        Text(
                          saticiPuani.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  //marketin ismi
                  Expanded(
                    //bura const olmayacak!!!
                    child: Text(
                      MarketName, //getter ile satıcının adı alınacak
                      style: const TextStyle(
                          //fontFamily: "Zen Antique Soft",
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SellerPage() /*CustomTabs()*/), //seller's page
                );
              },
            ),
          ),
        ],
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

                        return Flexible(
                          child: ListView.builder(
                            //itemCount: list.length,
                            itemCount: list.length % 2 == 0
                                ? list.length ~/ 2
                                : list.length ~/ 2 + 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // BlueBox(
                                    //     list[index].get('image'),
                                    //     list[index].get('name'),
                                    //     list[index].get(
                                    //         'price') /*,
                                    //     list[index].get('id')*/
                                    //     ),
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
                                        list[index * 2].get('id'),
                                        list[index * 2].get('mail'),
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
/*___________________________________________________________*/
/*_____________________ BLUEBOX CLASS ______________________*/

class BlueBox extends StatelessWidget {
  /*burdaki url daha sonra direkt Image'e dönecek*/
  BlueBox(
      String _url, String productName, double price, String id, String mail) {
    //unnamed constructor
    this._url = _url;
    this.productName = productName;
    this.price = price;
    this.productID = id;
    this.mail = mail;
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
  //final String title = '';
  String id = 'ID';
  String mail = 'MAIL';

  String _url = 'BOŞ.ABi';
  String productName = 'BOŞ.ABi';
  double price = 0.0;
  double rate = 0.0;
  String productID = "";
  Image img = Image.network("burası geçici");
  //final String message = '';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          Stack(
            //alignment: AlignmentDirectional.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                    child: Container(
                      //margin: EdgeInsets.all(width / 20),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(1.0),
                        width: width / 3, //1.5
                        height: width / 2.5, //1.9
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(//bu resim databaseden alıncak
                                "assets/milk128.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 0.3),
                        ),
                      ),
                    ),
                    onTap: () {
                      print(productName + _url + mail);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetail(
                                productName,
                                _url,
                                price,
                                this.productID,
                                mail)), //burası arama butonu
                      );
                    }),
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: InkWell(
                  child: const Icon(
                    Icons.add_circle_outline,
                    size: 40,
                    color: Color(0xffE76F51),
                  ),
                  onTap: () {
                    //burdan databaseİ dolduracağım inşaAllah

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Ürün Sepete eklendi: ' + productName,
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.white,
                    ));
                  },
                ),
              ),
            ],
          ),
          //text
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    productName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    price.toString() + ' ₺',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              //const SizedBox(width: 5),

              //star icon and rate
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
                    child: Icon(
                      Icons.star,
                      color: Color(0xff52B69A),
                      size: 18,
                    ),
                  ),
                  //rate
                  /*Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text(
                      //rate.toString(),
                      UrunPuaniDondur(this.productID),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),*/
                  UrunPuaniGoster(this.productID),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
