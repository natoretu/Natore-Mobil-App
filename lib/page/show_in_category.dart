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
  ShowInCategory({required String urun}) {
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
        elevation: 1,
        backgroundColor: Color(0xff06D6A0),
        title: Text("Filtrele: " + siralanacakUrunAdi),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  //Burda:
                  stream: _productServices
                      .getProductsOfSellerStreamCategory(siralanacakUrunAdi),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    print(siralanacakUrunAdi);
                    _productServices
                        .getProductsOfSellerStreamCategory(siralanacakUrunAdi)
                        .first
                        .then((value) => print(value.docs));
                    if (asyncSnapshot.hasError) {
                      return const Center(
                        child: Text("Bir hata olustu"),
                      );
                    } else {
                      if (asyncSnapshot.hasData) {
                        List<DocumentSnapshot> list = asyncSnapshot.data.docs;
                        print(list);
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

  String id = 'ID';
  String mail = 'MAIL';
  IconData bosGalp = const IconData(0xe25c, fontFamily: 'MaterialIcons');
  IconData doluGalp = const IconData(0xe25b, fontFamily: 'MaterialIcons');
  IconData galp = const IconData(0xe25c, fontFamily: 'MaterialIcons');
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
                                image: NetworkImage(_url),
                                //AssetImage(//bu resim databaseden alıncak
                                //  "assets/milk128.png"),
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
                              /*ürünün adı*/
                              SizedBox(
                                width: width / 3,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    productName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
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
                                      price.toString() + ' ₺',
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
                                        UrunPuaniGoster(productID),
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
                        ],
                      ),
                      onTap: () {
                        print(productName +
                            " bu: " +
                            _url +
                            "  " +
                            mail +
                            " IDDDD" +
                            productID);
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
                  child: IconButton(
                    icon: Icon(doluGalp, size: 34, color: Colors.teal.shade100),
                    onPressed: () {
                      //burdan databaseİ dolduracağım inşaAllah

                      final snackBar = SnackBar(
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.redAccent.withOpacity(0.95),
                        content: const Text(
                          'Ürün favorilere eklendi!',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
