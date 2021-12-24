import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:natore_project/page/product_detail.dart';
import 'package:natore_project/services/product_services.dart';

/*
*   Bedir abi bu classı çağırdığın yerde filtrelemek
*   istenilen ürünün adıyla çağıracaksın. Değiştirmen gereken yer:
*   Burda: --> bunu ctrl f ile arat
*
* */

String UserId = "";

String eMail = "";
String siralanacakUrunAdi = "";

class ShowInCategory extends StatelessWidget {
  ShowInCategory(String urun) {
    siralanacakUrunAdi = urun;
  }
  //bu gereksiz olabilir
  ShowInCategory.withEmailAndName(String name, String e_mail) {
    UserId = name;
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
  /*prduct serevice*/

  ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff06D6A0),
        title: Text("Filtrele: " + siralanacakUrunAdi),
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
                  //Burda:
                  stream: _productServices
                      .getProductsOfSellerStreamMarket(siralanacakUrunAdi),
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
  BlueBox(
      String _url, String productName, double price, String id, String mail) {
    //unnamed constructor
    this._url = _url;
    this.productName = productName;
    this.price = price;
    this.productID = id;
    this.mail = mail;
  }

  String id = 'ID';
  String mail = 'MAIL';
  IconData bosGalp = const IconData(0xe25c, fontFamily: 'MaterialIcons');
  IconData doluGalp = const IconData(0xe25b, fontFamily: 'MaterialIcons');
  String _url = 'BOŞ.ABi'; //image url
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
                            image: NetworkImage(
                                _url), //AssetImage(//bu resim databaseden alıncak
                            //     "assets/milk128.png"),
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
                                productID,
                                mail)), //burası arama butonu
                      );
                    }),
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: InkWell(
                  child: Icon(
                    doluGalp,
                    size: 40,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    //burdan databaseİ dolduracağım inşaAllah

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Ürün favorilere eklendi: ' + productName,
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
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text(
                      rate.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
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
