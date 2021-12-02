import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // new
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home_page.dart';

String nameOfProductHardCodedWillBeTakenFromDatabase = "12";

class Yorumlar extends StatefulWidget {
  const Yorumlar({Key? key}) : super(key: key);

  @override
  _Yorumlar createState() => _Yorumlar();
}

class _Yorumlar extends State<Yorumlar> {
  late FocusNode myFocusNode;
  final myController = TextEditingController();

  late Stream<QuerySnapshot> allMessages;
  String productName =
      "ProductName"; // buralar firebase'den veya tıklanılan yerden alıncak

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
    nameOfProductHardCodedWillBeTakenFromDatabase = "nameOfProduct";
    allMessages = FirebaseFirestore.instance
        .collection('Products')
        .where("name", isEqualTo: nameOfProductHardCodedWillBeTakenFromDatabase)
        .snapshots();
    // final productName = allMessages.first;

    return /*Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromRGBO(100, 109, 23, 1),
        backgroundColor: Color.fromRGBO(100, 200, 23, 1),

        title: const Text('Yorumlar'),
        centerTitle: true,
        actions: [],
      ),
      body:*/
        Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // kisiButonu("ProductName", "Price", "Properties", context),

          StreamBuilder<QuerySnapshot>(
              stream: allMessages,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Something went wrong.');
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Text('Loading');
                final data = snapshot.requireData;
                var currentMessages = (data.docs.where((element) => (true)));

                if (currentMessages.isNotEmpty) {
                  List<Map<String, dynamic>> yorumlar =
                      List.from(currentMessages.first.get('comments'));

                  if (firstUpdate) {
                    for (int i = 0; i < yorumlar.length - 1; i++) {
                      selectedArray.add(false);
                      isResponsesShown.add(false);
                    }

                    firstUpdate = false;
                  }

                  if (yorumlar.length == 0) {
                    return Text("Hiç yorum yok");
                  }

                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: yorumlar.length,
                        itemBuilder: (context, index) {
                          List<Map<String, dynamic>> yanitlar =
                              List.from(currentMessages.first.get('responses'));
                          for (int i = yanitlar.length - 1; i >= 0; i--) {
                            if (yanitlar[i]['IndexOfRespondedComment'] != index)
                              yanitlar.removeAt(i);
                          }

                          var messagesTaken = yorumlar[index]['comment'];
                          var messageTime = yorumlar[index]['Time'];
                          var sender = yorumlar[index]['sender'];
                          //var responds = yorumlar[index]['responses'];

                          String mesajinZamani =
                              messageTime.toDate().toString();
                          // !!Arayüz
                          // mesajı saga mı sola mı yaslayacagız onu belırlıyor
                          return Padding(
                            padding: const EdgeInsets.only(left: 100),
                            child: Column(
                              //!!
                              children: [
                                Text('$messagesTaken' +
                                    "\n" +
                                    sender +
                                    "\n"
                                        '$mesajinZamani'),
                                IconButton(
                                  icon: ((selectedArray[index])
                                      ? Icon(Icons.comment)
                                      : Icon(Icons.mode_comment_outlined)),
                                  onPressed: () {
                                    setState(() {
                                      selectedArray[index] =
                                          !selectedArray[index];
                                      if (selectedArray[index] == true) {
                                        indexOfLastRespondAttempt = index;
                                        myFocusNode.requestFocus();
                                        for (int i = 0;
                                            i < yorumlar.length;
                                            i++) {
                                          if (i != index)
                                            selectedArray[i] = false;
                                        }
                                      } else
                                        indexOfLastRespondAttempt = -1;

                                      openTextFieldForRespond(yorumlar, index);
                                      //_volume += 10;
                                    });
                                  },
                                ),
                                (yanitlar.isNotEmpty)
                                    ? yanitlariGosterEnableDisable(
                                        isResponsesShown, index)
                                    : SizedBox(height: 1),
                                ((yanitlar.isNotEmpty &&
                                        isResponsesShown[index])
                                    ? yanitlariGoster(context, yanitlar)
                                    : SizedBox(
                                        height: 1,
                                      ))
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
                //!arayüz
                return const Text(
                    'Hiç yorum yok'); // daha once konusulmus kımse yoksa bu basiliyor
              }),
          TextFormField(
            focusNode: myFocusNode,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Herkese açık bir yorum ekle...'),
            controller: myController,
          ),
          FloatingActionButton(
            onPressed: () async {
              String message = myController.text;
              if (message.isNotEmpty) {
                if (indexOfLastRespondAttempt == -1) {
                  yorumEkle(user!.email, myController.text);
                  selectedArray.add(false);
                  isResponsesShown.add(false);
                } else {
                  yanitEkle(
                      user!.email,
                      myController.text,
                      indexOfLastRespondAttempt,
                      Timestamp.fromDate(DateTime.now()));
                  for (int i = 0; i < selectedArray.length; i++) {
                    selectedArray[i] = false;
                  }
                }
              }
              myController.clear();
              indexOfLastRespondAttempt = -1;
            },
            tooltip: 'Show me the value!',
            child: const Icon(Icons.send),
          ),

          // !!arayüz yeni mail girilen yer. burası orijinal programda olmayabilir. sonucta normalde satıcıyı program uzerınden bulcaklar ıletısıme geccekler
        ],
      ),
    );
  }

  Future<void> yorumEkle(String? Sender, String text) async {
    bool mesajGondermeBasarili = false;
    await FirebaseFirestore.instance
        .collection('Products')
        .where('name', isEqualTo: nameOfProductHardCodedWillBeTakenFromDatabase)
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
        .where('name', isEqualTo: nameOfProductHardCodedWillBeTakenFromDatabase)
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
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 15),
      ),
      onPressed: () {
        setState(() {
          isResponsesShown[index] = !isResponsesShown[index];
        });
      },
      child: Text(
          (isResponsesShown[index]) ? "Yanıtları gizle" : "Yanıtları göster"),
    );
  }
}

Widget yanitlariGoster(
    BuildContext context, List<Map<String, dynamic>> yanitlar) {
  // backing data

  return ListView.builder(
    //shrinkWrap: true,
    //physics: ClampingScrollPhysics(),
    itemCount: yanitlar.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(yanitlar[index]['Response'] +
            "\n" +
            yanitlar[index]['Responser'] +
            "\n" +
            yanitlar[index]['ResponseTime'].toDate().toString()),
      );
    },
  );
}
