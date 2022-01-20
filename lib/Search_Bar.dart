// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:natore_project/products_of_seller_page.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({
    Key? key,
  }) : super(key: key);

  static String routeName = '/SearchAppBar';

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

List<String> firebaseOzellik = ['name', 'rate', 'price'];
List<String> ozellik = ['Alfabetik', 'Puan', 'Ucret'];
String giveFirebaseField(String text) {
  return firebaseOzellik[ozellik.indexOf(text)];
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool focus = true;
  bool edit_done = false;
  List<String> azalanArtan = ['Azalan', 'Artan'];
  String choice1 = 'Azalan';
  String choice2 = 'Ucret';
  //int selectedIndex = -1;
  bool search = false;
  String searchedText = "ZZZZZZZZZZZZZZ";
  TextEditingController _search = TextEditingController();
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          centerTitle: false,
          leadingWidth: 28,
          title: TextFormField(
            autofocus: focus,
            focusNode: myFocusNode,
            onChanged: (string) {
              if (_search.text != "") edit_done = false;
            },
            onFieldSubmitted: (string) {
              if (_search.text != "")
                setState(() {
                  edit_done = true;
                  myFocusNode.unfocus();
                });
            },
            textInputAction: TextInputAction.done,
            controller: _search,
            cursorColor: Colors.cyan,
            inputFormatters: [
              new LengthLimitingTextInputFormatter(42),
            ],
            textCapitalization: TextCapitalization
                .sentences, // word yapilabilir, ürünlerin isimlendirmesine bagli
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Icon(
                  Icons.search,
                  color: Color(0xff34A0A4),
                ),
              ),
              hintText: "Arama yapınız",
              hintStyle: TextStyle(color: Colors.black54),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 0.2, color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 0.2, color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 0.2, color: Colors.white),
              ),
            ),

            onEditingComplete: () {
              if (_search.text != "")
                setState(() {
                  print("onEditingComplete" + _search.text);
                  searchedText = _search.text;
                  search = true;
                });
            },

            /*{
            print("onEditingComplete" + _search.text);
            searchedText = _search.text;
            search = true;

            //Text("asd");
          },*/
          ),
        ),
        body: Center(
            child: Container(
          child: Column(
            children: [
              /*const SizedBox(
                height: 40,
              ),*/
              (edit_done
                  ? SafeArea(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                side:
                                    BorderSide(width: 0.7, color: Colors.white),
                                primary: Colors.white,
                                elevation: 1,
                                onPrimary: Colors.white,
                              ),
                              onPressed: () => _onButtonPressed(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.import_export_outlined,
                                    color: Colors.black54,
                                  ),
                                  Text("Sırala",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54)),
                                ],
                              ),
                            ),
                            /*ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item: $index'),
                    tileColor: selectedIndex == index ? Colors.blue : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
              ),*/

                            /*Column(
                    /*
                    * var azalanArtan = {'Azalan','Artan'};
  var ozellik = {'Alfabetik','Puan','Ucret'};*/
                    children: <Widget>[
                      ListTile(
                        title: const Text('Azalan'),
                        leading: Radio<String>(
                          value: azalanArtan[0],
                          groupValue: choice1,
                          onChanged: (String? value) {
                            setState(() {
                              choice1 = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Artan'),
                        leading: Radio<String>(
                          value: azalanArtan[1],
                          groupValue: choice1,
                          onChanged: (String? value) {
                            setState(() {
                              choice1 = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),*/
                          ]),
                    )
                  : SizedBox(
                      height: 1,
                    )),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Products')
                      .where('name', isGreaterThanOrEqualTo: searchedText)
                      .where('name', isLessThan: searchedText + 'z')
                      .snapshots(),
                  //stream: searchProducts(searchedText),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    print("BUILDER ICI");
                    if (asyncSnapshot.hasError)
                      return Text('Bir şeyler ters gitti!');
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting)
                      return Text('');
                    else {
                      if (asyncSnapshot.hasData) {
                        List<DocumentSnapshot> list = asyncSnapshot.data.docs;

                        //if(choice2 != ozellik[0]) // alfabetik degilse
                        list.sort((b, a) => (choice1 == 'Azalan' ? a : b)
                            .get(giveFirebaseField(choice2))
                            .compareTo((choice1 == 'Azalan' ? b : a)
                                .get(giveFirebaseField(choice2))));
                        // print(list);
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
                                        false),
                                    if (index * 2 + 1 < list.length)
                                      BlueBox(
                                          list[index * 2 + 1].get('image'),
                                          list[index * 2 + 1].get('name'),
                                          list[index * 2 + 1].get('price'),
                                          list[index * 2 + 1].get('id'),
                                          list[index * 2 + 1].get('mail'),
                                          false),
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
        )));
  }

  searchProducts(String text) {
    Query<Map<String, dynamic>> ref = FirebaseFirestore.instance
        .collection('Products')
        .where('name', isGreaterThanOrEqualTo: text)
        .where('name', isLessThan: text + 'z');

    return ref.snapshots();
  }

/*
  void showSearchedProducts(searchProducts) {
    Center(
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Products')
                    .where('name', isGreaterThanOrEqualTo: searchedText)
                    .where('name', isLessThan: searchedText+ 'z').snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
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
    );
  }
  */
  /*
    Stream<QuerySnapshot<Map<String, dynamic>>> getProductsOfSellerStreamMarket(
      String market) {
    Query<Map<String, dynamic>> ref =
        _firestore.collection(collection).where('market', isEqualTo: market);

    return ref.snapshots();
  }
  */
  void _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            // height: 180,
            child: Container(
              child: _buildBottomNavigationMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.moneyBillWave,
            size: 18,
            color: Colors.green,
          ),
          title: Text('Artan Fiyat'),
          onTap: () {
            setState(() {
              Navigator.pop(context);
              choice1 = azalanArtan[1];
              choice2 = ozellik[2];
            });

            //return ToProjecter(1);
          },
        ),
        Divider(
          height: 0.1,
        ),
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.moneyBillWave,
            size: 18,
            color: Colors.redAccent,
          ),
          title: Text('Azalan Fiyat'),
          onTap: () {
            setState(() {
              Navigator.pop(context);
              choice1 = azalanArtan[0];
              choice2 = ozellik[2];
            });

            // return ToProjecter(2);
          },
        ),
        Divider(
          height: 0.1,
        ),
        ListTile(
          leading: Icon(
            Icons.sort_by_alpha,
          ),
          title: Text('Alfabetik Sıralama'),
          onTap: () {
            setState(() {
              Navigator.pop(context);
              //return ToProjecter(3);
              choice1 = azalanArtan[1];
              choice2 = ozellik[0];
            });
          },
        ),
        Divider(
          height: 0.1,
        ),
        ListTile(
          leading: Icon(
            Icons.star,
            size: 24,
            color: Colors.amber.shade700,
          ),
          title: Text('Ürün Puanı'),
          onTap: () {
            setState(() {
              Navigator.pop(context);
              // return ToProjecter(4);
              choice1 = azalanArtan[0];
              choice2 = ozellik[1];
            });
          },
        ),
      ],
    );
  }
}
