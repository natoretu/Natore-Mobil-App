// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:natore_project/page/show_in_category.dart';

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
  List<String> azalanArtan = ['Azalan', 'Artan'];
  String choice1 = 'Azalan';
  String choice2 = 'Ucret';
  //int selectedIndex = -1;
  bool search = false;
  String searchedText = "";
  TextEditingController _search = TextEditingController();
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
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
          controller: _search,
          cursorColor: Colors.cyan,
          autofocus: true,
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
              const SizedBox(
                height: 40,
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

              Column(
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
              ),
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
                      return Text('Something went wrong.');
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting)
                      return Text('Loading');
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
}
