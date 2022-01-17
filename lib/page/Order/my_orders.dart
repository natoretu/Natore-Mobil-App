import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:natore_project/services/favorites_services.dart';
import 'package:natore_project/services/product_services.dart';

import '../../Anasayfa.dart';

/*
* NOT:
*     ŞUAN BEN prouduct_of_seller'de OLDUĞU GİBİ ÜRÜNLERİ YAZDIRIYORUM
*     ONUN YERİNE ORDER_PROVİDER API'INI KULLANACAĞIM. BUNU İÇİN CLASSIN
*     CONSTRUCTORUNU ID ALACAK ŞEKİLDE DEĞİŞTİRECEĞİM (Inputun SADECE İSMİNİ)
*     ŞUANDA DATABASE'DE ÖRNEK ORDER YOK!!
* */

String MarketName = ""; //MARKETİD
String eMail_eski = "";
String userId = email;

class MyOrders extends StatelessWidget {
  MyOrders() {}
  //bu gereksiz olabilir
  MyOrders.withEmailAndName(String name, String e_mail) {
    MarketName = name;
    eMail_eski = e_mail;
  }
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Favoriler');
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
  FavoritesServices favorites_services = FavoritesServices();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff06D6A0),
        //toolbarHeight: 120,
        title: Text(
          "Favoriler",
          style: TextStyle(
              fontFamily: 'Zen Antique Soft',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: favorites_services.getProducts("hsnsvn71@gmail.com"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("");
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Text("watrıng or actıve");
                      case ConnectionState.done:
                        List<DocumentSnapshot> list = snapshot.data;

                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Text(
                                '${_productServices.getPr(list[index].toString())}');
                          },
                        );

                      default:
                        return Text("default");
                    }
                  }),
            ],
          ),
        ),
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
        padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
        child: Card(
          //shadowColor: Colors.black,
          //color: Colors.grey,
          //padding: EdgeInsets.all(10),
          borderOnForeground: true, //?
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.green.withAlpha(40),
            onTap: () {
              debugPrint('Card tapped.'); //bura başka bir sayfa açabilir belki
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              // width: 400,
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  //mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Image.network(
                    //   "https://www.google.com/search?q=manda+s%C3%BCt%C3%BC&rlz=1C1CHBD_trTR918TR918&sxsrf=AOaemvLyU3gY5sBeh_pOT4c-mkyq5Z91yw:1639349111561&source=lnms&tbm=isch&sa=X&sqi=2&ved=2ahUKEwj749Orq9_0AhVrB2MBHWucBP8Q_AUoAnoECAMQBA&biw=1536&bih=731&dpr=1.25#imgrc=muV5w0xcmTQ3TM",
                    //   fit: BoxFit.cover,
                    // ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                            aspectRatio: 0.7,
                            child: Image.network(
                              urunImage,
                              fit: BoxFit.fill,
                            ))),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(urunAdi,
                            style: TextStyle(
                                fontSize:
                                    18)), //buraları database'den çekeceğim
                        Text(dukkanAdi, style: TextStyle(fontSize: 19)),
                      ],
                    ),
                    Text(
                      fiyat.toString() + ' ₺',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
