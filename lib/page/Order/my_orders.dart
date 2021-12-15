import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:natore_project/services/order_services.dart';
import 'package:natore_project/services/product_services.dart';

/*
* NOT:
*     ŞUAN BEN prouduct_of_seller'de OLDUĞU GİBİ ÜRÜNLERİ YAZDIRIYORUM
*     ONUN YERİNE ORDER_PROVİDER API'INI KULLANACAĞIM. BUNU İÇİN CLASSIN
*     CONSTRUCTORUNU ID ALACAK ŞEKİLDE DEĞİŞTİRECEĞİM (Inputun SADECE İSMİNİ)
*     ŞUANDA DATABASE'DE ÖRNEK ORDER YOK!!
* */
String MarketName = ""; //MARKETİD
String eMail = "";

class MyOrders extends StatelessWidget {
  MyOrders(String name) {
    MarketName = name;
  }
  //bu gereksiz olabilir
  MyOrders.withEmailAndName(String name, String e_mail) {
    MarketName = name;
    eMail = e_mail;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.white),

      home: MyHomePage(title: 'Siparişlerim'),
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

  /*prduct serevice*/
  ProductServices _productServices = ProductServices();

  /* AŞŞAĞIDAKİ YUKARIDAKİNİN YERİNE GEÇECEK */
  OrderServices _orderServices = OrderServices();

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
        //toolbarHeight: 120,
        title: Text("Siparişlerim"),
        centerTitle: true,
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
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: OrderCardCreater(
                                  list[index].get('name'),
                                  list[index].get('market'),
                                  /*"Sütçü dede",*/
                                  /*Dükkanın adını almam lazım*/
                                  list[index].get('price'),
                                  list[index].get('image'),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
          ),
        ],
        backgroundColor: Colors.white,
        iconSize: 22,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.blueGrey.withOpacity(0.7),
        selectedItemColor: const Color(0xff34A0A4), //Color(0xff00ADB5),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 4,
        unselectedFontSize: 14,
        selectedFontSize: 14,
      ),
    );
  }
}

/*___________________________________________________________*/
/*_____________________ OrderCardCreater CLASS ______________________*/
//bunu stateful'a çevirmem lazım
class OrderCardCreater extends StatelessWidget {
  //const OrderCardCreater({Key? key}) : super(key: key);
  OrderCardCreater(
      String urunAdi, String dukkanAdi, double fiyat, String urunImage) {
    this.urunAdi = urunAdi;
    this.dukkanAdi = dukkanAdi;
    this.fiyat = fiyat;
    this.urunImage = urunImage;
  }
  String urunAdi = "", dukkanAdi = "";
  double fiyat = 0.0;
  String urunImage = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          //shadowColor: Colors.black,
          //color: Colors.grey,
          //padding: EdgeInsets.all(10),
          borderOnForeground: true, //?
          child: InkWell(
            splashColor: Colors.green.withAlpha(40),
            onTap: () {
              debugPrint('Card tapped.'); //bura başka bir sayfa açabilir belki
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              // width: 400,
              height: 120,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Image.network(
                  //   "https://www.google.com/search?q=manda+s%C3%BCt%C3%BC&rlz=1C1CHBD_trTR918TR918&sxsrf=AOaemvLyU3gY5sBeh_pOT4c-mkyq5Z91yw:1639349111561&source=lnms&tbm=isch&sa=X&sqi=2&ved=2ahUKEwj749Orq9_0AhVrB2MBHWucBP8Q_AUoAnoECAMQBA&biw=1536&bih=731&dpr=1.25#imgrc=muV5w0xcmTQ3TM",
                  //   fit: BoxFit.cover,
                  // ),
                  Container(
                    height: 70,
                    width: 80,
                    //color: Colors.black,
                    child: Image.network(urunImage),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(urunAdi,
                          style: TextStyle(
                              fontSize: 20)), //buraları database'den çekeceğim
                      Text(dukkanAdi, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Text(
                    fiyat.toString() + ' TL',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
