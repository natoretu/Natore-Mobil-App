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
  /*Stream<QuerySnapshot> allMessages = FirebaseFirestore.instance
      .collection('Products')
      .where("name", isEqualTo: nameOfProductHardCodedWillBeTakenFromDatabase)
      .snapshots();*/
  late Stream<QuerySnapshot> allMessages;
  String productName =
      "ProductName"; // buralar firebase'den veya tıklanılan yerden alıncak
  /*DocumentReference docRef = FirebaseFirestore.instance
      .collection('Products')
      .firestore
      .doc("LdAE4nEGqGaWtK1s92kv");*/
  /*String productName = "";
  String productPrice = "";
  String productProperties="";*/
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
    /*await docRef.get().then((snapshot){

    }*/
    TextField textField;
    nameOfProductHardCodedWillBeTakenFromDatabase = "nameOfProduct";
    allMessages = FirebaseFirestore.instance
        .collection('Products')
        .where("name", isEqualTo: nameOfProductHardCodedWillBeTakenFromDatabase)
        .snapshots();
    // final productName = allMessages.first;

    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Color.fromRGBO(100, 109, 23, 1),
          backgroundColor: Color.fromRGBO(100, 200, 23, 1),

          title: const Text('Yorumlar'),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.black12,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                kisiButonu("ProductName", "Price", "Properties", context),

                Container(
                    //!! arayüz daha once konusulan kısıler,
                    height: 300,
                    // bu deger gecmıs sohbetlerın kac piksel asagıya kadar gosterılecegını belırlıyor
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: allMessages,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text('Something went wrong.');
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) return Text('Loading');
                          final data = snapshot.requireData;
                          var currentMessages =
                              (data.docs.where((element) => (true)));

                          if (currentMessages.isNotEmpty) {
                            List<Map<String, dynamic>> yorumlar = List.from(
                                currentMessages.first.get('comments'));

                            if (firstUpdate) {
                              for (int i = 0; i < yorumlar.length - 1; i++) {
                                selectedArray.add(false);
                                isResponsesShown.add(false);
                              }

                              firstUpdate = false;
                            }
                            /*userMessagesList.sort((b, a) => a
                                .get('Messages')[a.get('Messages').length - 1]
                            ['Time']
                                .compareTo(b.get('Messages')[
                            b.get('Messages').length - 1]['Time']));*/
                            if (yorumlar.length == 0) {
                              return Text("Hiç yorum yok");
                            }

                            return ListView.builder(
                              //itemCount: userMessagesList.length, // burda item countu alıyoruz ama daha fazlasını bastırıyoruz ekrana gui de sıkıntı olursa goz onunde bulunduralım
                              itemCount: yorumlar.length,
                              itemBuilder: (context, index) {
                                List<Map<String, dynamic>> yanitlar = List.from(
                                    currentMessages.first.get('responses'));
                                for (int i = yanitlar.length - 1; i >= 0; i--) {
                                  if (yanitlar[i]['IndexOfRespondedComment'] !=
                                      index) yanitlar.removeAt(i);
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
                                      /*TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 20),
                                        ),
                                        onPressed: () {},
                                        child: const Text('Yanıtla'),
                                      ),*/
                                      IconButton(
                                        icon: ((selectedArray[index])
                                            ? Icon(Icons.comment)
                                            : Icon(
                                                Icons.mode_comment_outlined)),
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

                                            openTextFieldForRespond(
                                                yorumlar, index);
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
                                      /*ListView.builder(
                                          padding: const EdgeInsets.all(8),
                                          itemCount: yanitlar.length,
                                          itemBuilder: (BuildContext context,
                                              int yanitlarindex) {
                                            return Container(
                                              height: 50,
                                              //color: Colors.amber[colorCodes[index]],
                                              child: Center(
                                                  child: Text(
                                                      'Entry ${yanitlar[yanitlarindex]['Response']}')),
                                            );
                                          })*/
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          //!arayüz
                          return const Text(
                              'Hiç yorum yok'); // daha once konusulmus kımse yoksa bu basiliyor
                        })),
                TextFormField(
                  focusNode: myFocusNode,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Herkese açık bir yorum ekle...'),
                  controller: myController,
                ),
                //yorumlariniListele(userMessagesList),
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
                /*textField = TextField(
                  decoration: new InputDecoration.collapsed(
                      hintText: "Yeni Sohbet için mail"),
                  onSubmitted: (String mail) {
                    mesajGondermeEkraniniAc(mail, context);
                  },
                ),*/
              ],
            ),
          ),
        ));
  }

  //bool sonMesajBasariylaGonderildi = false;
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
      //removeUnnecessaryDoc(value);
      // sadece 1 tane aynı kullanıcılara sahip document bırakıyor her seferınde 1 tane sildiğinden hic bir zaman 2 den fazla olmuyor 1 tane silmesi yetiyor
      value.docs.forEach((element) {
        //print(element.toString() + Sender + " " +  + "qqq");
        element.reference.update({
          // sadece 1 tane var=> first aradigimız
          'comments': FieldValue.arrayUnion([
            {
              'comment': text,
              'Time': Timestamp.fromDate(DateTime.now()),
              'sender': Sender,
              /*'responds': FieldValue.arrayUnion([
                {
                  //'RespondComment':""//yoruma yanıt eklenınce eklencek
                }
              ])*/
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
      onPressed: () {
        /*mesajlasilanKisi = mail;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MesajGondermeEkrani()),
        );*/
      },
    );
  }

  void openTextFieldForRespond(
      List<Map<String, dynamic>> yorumlar, int index) {}

  /*Future<void> yanitEkle(
      String? email, String text, int indexOfLastRespondAttempt) async {
    await FirebaseFirestore.instance
        .collection('Products')
        .where('name', isEqualTo: nameOfProductHardCodedWillBeTakenFromDatabase)
        .get()
        .then((value) {
      if (value.size == 0 || value.docs.isEmpty) {
        return;
      }
      //removeUnnecessaryDoc(value);
      // sadece 1 tane aynı kullanıcılara sahip document bırakıyor her seferınde 1 tane sildiğinden hic bir zaman 2 den fazla olmuyor 1 tane silmesi yetiyor
      value.docs.forEach((element) {
        var temp = FieldValue.arrayUnion([
          {
            'comment': text,
            'Time': Timestamp.fromDate(DateTime.now()),
            'sender': email,
          }
        ]);
        //print(element.toString() + Sender + " " +  + "qqq");
        element.reference.update({
          // sadece 1 tane var=> first aradigimız
          'comments': FieldValue.arrayUnion([
            {'responds': temp}
          ])
        });
        //element.reference.update({'OlmayanField': "deneme123"});
      });
    });
  }*/
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
              /*'responds': FieldValue.arrayUnion([
                {
                  //'RespondComment':""//yoruma yanıt eklenınce eklencek
                }
              ])*/
            }
          ]
              //element.reference.update({'OlmayanField': "deneme123"});
              )
        });
      });

      //String responseSender = email!;
      //String kullanici2 = mesajlasilanKisi;
      /*sonMesajBasariylaGonderildi = false;
    await sohbeteMesajEkle(kullanici1, kullanici2, text);
    if (!sonMesajBasariylaGonderildi) {
      await sohbeteMesajEkle(kullanici2, kullanici1, text);
    }
    if (!sonMesajBasariylaGonderildi) {
      sohbetOlustur(kullanici1, kullanici2, text);
    }*/
      /*

    value.docs.forEach((element) {
        //print(element.toString() + Sender + " " +  + "qqq");
        element.reference.update({
          // sadece 1 tane var=> first aradigimız
          'responses': FieldValue.arrayUnion([
            {
              'Response': text,
              'ResponseTime': Timestamp.fromDate(DateTime.now()),
              'Responser': Sender,
              'IndexOfRespondedComment': indexOfLastRespondAttempt
              /*'responds': FieldValue.arrayUnion([
                {
                  //'RespondComment':""//yoruma yanıt eklenınce eklencek
                }
              ])*/
            }
          ])
        });
        */
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
/*  List<Widget> yorumlariniListele(List userMessagesList) {
    return null;
  }*/
}

Widget yanitlariGoster(
    BuildContext context, List<Map<String, dynamic>> yanitlar) {
  // backing data

  return ListView.builder(
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
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
