import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:natore_project/page/sohbet.dart';

import 'home_page.dart';

String nameOfProductHardCodedWillBeTakenFromDatabase = "normal";
String prName = "";
String prImage = "";
String prId = "";
String prEmail = "";
double prPrice = 0.0;

class ProductDetail extends StatefulWidget {
  // const ProductDetail({
  //   Key? key,
  // }) : super(key: key);
  ProductDetail(
      String nameX, String imageX, double priceX, String id, String emailX) {
    prName = nameX;
    prImage = imageX;
    prPrice = priceX;
    prId = id;
    prEmail = emailX;
    print(prEmail + "sadasdnakdjnasdnasdasda");
  }

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // Color(0xff52B69A),
  // Color(0xff168AAD),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* persistentFooterButtons: <Widget>[
        Row(
          children: <Widget>[
            SendMessageWidget(
                myFocusNode: myFocusNode, myController: myController),
            // buildFloatingActionButton(),
          ],
        ),
      ],*/
      // bottomSheet: SendMessageWidget(
      //  myFocusNode: myFocusNode, myController: myController),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /***----------***/
            /*** App Bar ***/
            const SliverAppBar(
              backgroundColor: Color(0xff06D6A0),
              centerTitle: true,
              elevation: 1,
              floating: true,
              pinned: true,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Ürün Bilgisi',
                  style: TextStyle(
                      //fontFamily: "Zen Antique Soft",
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            /***-------------------------***/
            /*** Product Image and Info ***/
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        /*** Product Image ***/
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            elevation: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 16.0),
                                      child: Image(
                                        image: AssetImage("assets/milk128.png"),
                                        //fit: BoxFit.fill,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 24.0),
                                          child: Text(
                                            prName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            prPrice.toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        /*** Contact With Seller ***/
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    primary: Colors.white,
                                    onPrimary:
                                        Colors.teal, // basinca olusan renk
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                onPressed: () {
                                  mesajGondermeEkraniniAc(prEmail, context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.phone,
                                        color: Color(0xff52B69A),
                                        size: 28,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Satıcıyla İletişime Geç',
                                          style: TextStyle(
                                              fontFamily: "Zen Antique Soft",
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Yorumlar(),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1, /*** !!!!! ***/
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Yorumlar extends StatefulWidget {
  const Yorumlar({Key? key}) : super(key: key);

  @override
  _Yorumlar createState() => _Yorumlar();
}

class _Yorumlar extends State<Yorumlar> {
  late FocusNode myFocusNode;
  final myController = TextEditingController();

  late Stream<QuerySnapshot> allMessages;
  String productName = prName;
  //"ProductName"; // buralar firebase'den veya tıklanılan yerden alıncak

  bool firstUpdate = true;
  List<dynamic> userMessagesList = <dynamic>[];
  var selectedArray = [false];
  var isResponsesShown = [false];
  int indexOfLastRespondAttempt = -1;
  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextField textField;

    allMessages = FirebaseFirestore.instance
        .collection('Products')
        .where('name', isEqualTo: prName)
        .snapshots();
    // final productName = allMessages.first;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // kisiButonu("ProductName", "Price", "Properties", context),
        SendMessageWidget(myFocusNode: myFocusNode, myController: myController),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
          child: buildFloatingActionButton(),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: allMessages,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return const Text('Something went wrong.');
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Text('Loading');
              final data = snapshot.requireData;
              var currentMessages = (data.docs.where((element) => (true)));

              if (currentMessages.isNotEmpty) {
                List<Map<String, dynamic>> yorumlar =
                    List.from(currentMessages.first.get('comments'));

                if (firstUpdate) {
                  for (int i = 0; i < yorumlar.length; i++) {
                    selectedArray.add(false);
                    isResponsesShown.add(false);
                  }

                  firstUpdate = false;
                }
/*
                if (yorumlar.length == 0) {
                  return const Text(
                    "Hiç yorum yok",
                  );
                }
*/
                return Column(
                  children: [
                    SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: yorumlar.length,
                        itemBuilder: (context, index) {
                          List<Map<String, dynamic>> yanitlar =
                              List.from(currentMessages.first.get('responses'));
                          for (int i = yanitlar.length - 1; i >= 0; i--) {
                            if (yanitlar[i]['IndexOfRespondedComment'] !=
                                yorumlar.length - 1 - index)
                              yanitlar.removeAt(i);
                          }

                          var messagesTaken =
                              yorumlar[yorumlar.length - 1 - index]['comment'];
                          var messageTime =
                              yorumlar[yorumlar.length - 1 - index]['Time'];
                          var sender =
                              yorumlar[yorumlar.length - 1 - index]['sender'];
                          //var responds = yorumlar[yorumlar.length-1-index]['responses'];

                          String mesajinZamani =
                              messageTime.toDate().toString().substring(0, 10);
                          // !!Arayüz
                          // mesajı saga mı sola mı yaslayacagız onu belırlıyor
                          return Padding(
                            padding: EdgeInsets.all(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //!!
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Material(
                                    elevation: 0.5,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text.rich(
                                            TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: '$messagesTaken\n',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              TextSpan(
                                                  text: sender,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey)),
                                              TextSpan(
                                                  text: '\n$mesajinZamani',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey)),
                                            ]),
                                          ),
                                        ),
                                        IconButton(
                                          icon: ((selectedArray[
                                                  yorumlar.length - 1 - index])
                                              ? Icon(Icons.comment,
                                                  semanticLabel: "Yanıt ekle")
                                              : Icon(
                                                  Icons.mode_comment_outlined)),
                                          onPressed: () {
                                            setState(() {
                                              selectedArray[
                                                  yorumlar.length -
                                                      1 -
                                                      index] = !selectedArray[
                                                  yorumlar.length - 1 - index];
                                              if (selectedArray[
                                                      yorumlar.length -
                                                          1 -
                                                          index] ==
                                                  true) {
                                                indexOfLastRespondAttempt =
                                                    yorumlar.length - 1 - index;
                                                myFocusNode.requestFocus();
                                                for (int i = 0;
                                                    i < yorumlar.length;
                                                    i++) {
                                                  if (i !=
                                                      yorumlar.length -
                                                          1 -
                                                          index) {
                                                    selectedArray[i] = false;
                                                  }
                                                }
                                              } else {
                                                indexOfLastRespondAttempt = -1;
                                              }
                                              openTextFieldForRespond(yorumlar,
                                                  yorumlar.length - 1 - index);
                                              //_volume += 10;
                                            });
                                          },
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                                (yanitlar.isNotEmpty)
                                    ? yanitlariGosterEnableDisable(
                                        isResponsesShown,
                                        yorumlar.length - 1 - index)
                                    : SizedBox(height: 1),
                                ((yanitlar.isNotEmpty &&
                                        isResponsesShown[
                                            yorumlar.length - 1 - index])
                                    ? yanitlariGoster(context, yanitlar)
                                    : SizedBox(
                                        height: 1,
                                      )),
                                Divider(),
                              ],
                            ),
                          ); //yorum 0
                        },
                      ),
                    ),
                  ],
                );
              }
              //!arayüz
              return const Text(
                  'Hiç yorum yok'); // daha once konusulmus kımse yoksa bu basiliyor
            }),

        // !!arayüz yeni mail girilen yer. burası orijinal programda olmayabilir. sonucta normalde satıcıyı program uzerınden bulcaklar ıletısıme geccekler
      ],
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      mini: true,
      elevation: 2,
      onPressed: () async {
        String message = myController.text;
        if (message.isNotEmpty) {
          if (indexOfLastRespondAttempt == -1) {
            yorumEkle(user!.email, myController.text);
            selectedArray.add(false);
            isResponsesShown.add(false);
          } else {
            yanitEkle(user!.email, myController.text, indexOfLastRespondAttempt,
                Timestamp.fromDate(DateTime.now()));
            for (int i = 0; i < selectedArray.length; i++) {
              selectedArray[i] = false;
            }
          }
        }
        myController.clear();
        indexOfLastRespondAttempt = -1;
      },
      backgroundColor: Colors.cyan,
      splashColor: Colors.white,
      tooltip: 'Show me the value!',
      child: const Icon(
        Icons.send,
        size: 24,
      ),
    );
  }

  Future<void> yorumEkle(String? Sender, String text) async {
    bool mesajGondermeBasarili = false;
    await FirebaseFirestore.instance
        .collection('Products')
        .where('name', isEqualTo: prName)
        .get()
        .then((value) {
      print("Ilk bu gelmeli");
      if (value.size == 0 || value.docs.isEmpty) {
        mesajGondermeBasarili = false;
        return;
      }
      value.docs.forEach((element) {
        //print(element.toString() + Sender + " " +  + "qqq");
        element.reference.update({
          // sadece 1 tane var=> first aradigimız
          'comments': FieldValue.arrayUnion([
            {
              'comment': text,
              'Time': Timestamp.fromDate(DateTime.now()),
              'sender': Sender,
            }
          ])
        });
        //element.reference.update({'OlmayanField': "deneme123"});
      });
      mesajGondermeBasarili = true;
    });
  }

  FlatButton kisiButonu(
      String name, String text3, String message, BuildContext context) {
    return FlatButton(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          const FaIcon(FontAwesomeIcons.facebookMessenger, color: Colors.blue),
          Text("  $name\n  $message\n  $text3"),
        ],
      ),
      onPressed: () {},
    );
  }

  void openTextFieldForRespond(
      List<Map<String, dynamic>> yorumlar, int index) {}

  Future<void> yanitEkle(String? emailOfResponder, String text,
      int indexOfLastRespondAttempt, Timestamp time) async {
    await FirebaseFirestore.instance
        .collection('Products')
        .where('name', isEqualTo: prName)
        .get()
        .then((value) {
      print("Ilk bu gelmeli");
      if (value.size == 0 || value.docs.isEmpty) {
        return;
      }
      //removeUnnecessaryDoc(value);
      // sadece 1 tane aynı kullanıcılara sahip document bırakıyor her seferınde 1 tane sildiğinden hic bir zaman 2 den fazla olmuyor 1 tane silmesi yetiyor
      value.docs.forEach((element) {
        //print(element.toString() + Sender + " " +  + "qqq");
        element.reference.update({
          // sadece 1 tane var=> first aradigimız
          'responses': FieldValue.arrayUnion([
            {
              'Response': text,
              'ResponseTime': Timestamp.fromDate(DateTime.now()),
              'Responser': emailOfResponder,
              'IndexOfRespondedComment': indexOfLastRespondAttempt
            }
          ]
              //element.reference.update({'OlmayanField': "deneme123"});
              )
        });
      });
    });
  }

  Widget yanitlariGosterEnableDisable(List<bool> isResponsesShown, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 1,
              onPrimary: Colors.cyan, // basinca olusan renk
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          onPressed: () {
            setState(() {
              isResponsesShown[index] = !isResponsesShown[index];
            });
          },
          child: Text(
              (isResponsesShown[index])
                  ? "Yanıtları gizle"
                  : "Yanıtları göster",
              style: TextStyle(fontSize: 15, color: Colors.cyan))),
    );
  }
}

class SendMessageWidget extends StatelessWidget {
  const SendMessageWidget({
    Key? key,
    required this.myFocusNode,
    required this.myController,
  }) : super(key: key);

  final FocusNode myFocusNode;
  final TextEditingController myController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      cursorColor: Colors.cyan,
      textCapitalization: TextCapitalization.sentences,
      focusNode: myFocusNode,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.cyan),
          //borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xff06D6A0)),
          //borderRadius: BorderRadius.circular(8),
        ),
        //fillColor: Colors.white,
        //filled: true, // dont forget this line
        // border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        labelText: ' Herkese açık bir yorum ekle...',
        labelStyle: TextStyle(color: Colors.grey),
      ),
      controller: myController,
    );
  }
}

Widget yanitlariGoster(
    BuildContext context, List<Map<String, dynamic>> yanitlar) {
  // backing data

  return SingleChildScrollView(
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: yanitlar.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(41, 6, 6, 6),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            //contentPadding: EdgeInsets.only(left: 61),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: yanitlar[index]['Response'] + '\n',
                      style: TextStyle(fontSize: 16)),
                  TextSpan(
                      text: yanitlar[index]['Responser'] + '\n',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  TextSpan(
                      text: yanitlar[index]['ResponseTime']
                          .toDate()
                          .toString()
                          .substring(0, 10),
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ]),
              ),
            ),
          ),
        );
      },
    ),
  );
}
