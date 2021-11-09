import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'contact_with_seller.dart';
import 'seller_page.dart';

final String Ali_imran_148 =
    "فَاٰتٰيهُمُ اللّٰهُ ثَوَابَ الدُّنْيَا وَحُسْنَ ثَوَابِ الْاٰخِرَةِؕ وَاللّٰهُ يُحِبُّ الْمُحْسِنٖينَࣖ ";
final String Ali_imran_148_tr =
    "Bu yüzden Allah onlara dünya nimetini ve âhiret nimetinin de güzelini verdi. Allah işini güzel yapanları sever.";
// bunlar silinecek. bunların yerini direkt backendden alınacak getter fonksiyonları  alacak
double fiyat = 20;
String urunAdi = "Doğal Keçi Sütü";
String MarketName = "Doğadan Sofraya";
String resimUrl =
    'https://d2uiaykj5yb3c0.cloudfront.net/tahtakale/img/p/39006c70-bd82-42c0-929d-3c6cacaa31d7.jpg';
double saticiPuani = 3.8;

class ProductsOfSellerPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.white),
      home: MyHomePage(title: 'SATICI BILGILERI'),
    );
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.of(context)
        //       .pop(), //buraya sefanın sayfası eklenecek inşaAllah
        // ),
        actions: [
          Container(
            width: 350,
            margin: EdgeInsets.all(4.0),
            child: InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    //backgroundColor: Colors.white,
                    child: Image(
                      image: NetworkImage(
                          'https://d1hzl1rkxaqvcd.cloudfront.net/contest_entries/1321793/_600px/33f9689616d2c31873e72e65ce2019d1.jpg'), //buraya backenddeki getImage() methodu gelecek
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 25,
                    width: 45,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(5.0),
                      color: Colors.amber,
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1.0,
                            offset: new Offset(5.0, 5.0))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Text(
                      'Sütçü Dede Süt Ürünleri', //getter ile satıcının adı alınacak
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
        bottom: PreferredSize(
          preferredSize: Size.infinite,
          child: InkWell(
            onTap: () {
              //burda basılınca mesajlajma açılacak
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const SecondRoute()), //burası arama butonu
              );
            },
            child: SearchBar(),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          //shrinkWrap: true,
          //physics: NeverScrollableScrollPhysics(),
          itemCount: 6, //buraya ürün sayısı gelecek backendden
          padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              //margin: const EdgeInsets.all(10.0),
              //padding: const EdgeInsets.all(20.0),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(
                  //   height: 0,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlueBox(resimUrl, urunAdi,
                          fiyat), //burdaki argümanların yerine backendin getterleri gelecek
                      BlueBox(resimUrl, urunAdi, fiyat),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: 'Ev',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_sharp),
            label: 'Profilim',
            /*
            ImageIcon(
              AssetImage("assets/hoopoe.png"),
              color: Colors.blueGrey.withOpacity(0.8),
              size: 32,
            ),
            activeIcon: ImageIcon(
              AssetImage("assets/hoopoe.png"),
              color: Color(0xff00ADB5),
              size: 32,
            ),*/
          ),
        ],
        backgroundColor: Colors.white,
        iconSize: 22,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.blueGrey.withOpacity(0.7),
        selectedItemColor: Color(0xff34A0A4), //Color(0xff00ADB5),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 4,
        unselectedFontSize: 14,
        selectedFontSize: 14,
        //showUnselectedLabels: false,
        //showSelectedLabels: false,
      ),
    );
  }
}

class BlueBox extends StatelessWidget {
  /*burdaki url daha sonra direkt Image'e dönecek*/
  BlueBox(String _url, String productName, double price) {
    //unnamed constructor
    this._url = _url;
    this.productName = productName;
    this.price = price;
  }
  //ikinci constructor
  //bu daha sonra databaseden image döndüren fonksiyonu yazdığımızda kullanılacak olan constructor.
  // BlueBox.ImageConstructor(...) şeklinde kullanılır
  BlueBox.ImageConstructor(Image img, String productName, double price) {
    this.img = img;
    this.productName = productName;
    this.price = price;
  }
  //final String title = '';
  String _url = 'BOŞ.ABi';
  String productName = 'BOŞ.ABi';
  double price = 0.0;
  Image img = Image.network("burası geçici");
  //final String message = '';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                //  margin: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  margin: EdgeInsets.all(1.0),
                  width: width / 3,
                  height: width / 2.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(//bu resim databaseden alıncak
                          _url),
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
              Container(
                width: width / 3,
                alignment: Alignment.centerLeft,
                child: Text(
                  price.toString() +
                      " TL\n" +
                      productName
                          .toString(), //burdaki product name ve price will come from database
                  textScaleFactor: 0.9,
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}

// class SellerProducts {
//   SellerProducts(int productNum) {
//     this.productNum = productNum;
//     this.f();
//   }
//   int productNum = -1;
//   void f() {
//     for (int i = 0; i < productNum; ++i) {
//       @override
//       Widget build(BuildContext context) {
//         return SafeArea(
//           child: Row(
//             children: [
//               BlueBox(resimUrl, urunAdi, fiyat),
//             ],
//           ),
//         );
//       }
//     }
//   }
// }
class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Material(
        elevation: 0.8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xff34A0A4), width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
                  child: Icon(
                    Icons.search,
                    color: Color(0xff34A0A4),
                  ),
                ),
                Text(
                  'Satıcıda Ara',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
