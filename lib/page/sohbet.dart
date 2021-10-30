import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:natore_project/page/home_page.dart';
//import 'package:natore_project/provider/google_sign_in.dart';

String mesajlasilanKisi = "";
//user = FirebaseAuth.instance.currentUser!;

class Sohbet extends StatelessWidget {
  @override
  String mustafaEmail = "mustafa.krks.09@gmail.com";
  String grupEmail = "birkacmumingenc@gmail.com";

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(100, 109, 23, 1),
          title: const Text('Sohbet'),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.blueGrey.shade900,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Kişiler',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                      height: 30,
                    ),
                    kisiButonu(mustafaEmail, context),
                    const SizedBox(
                      width: 15,
                      height: 30,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                      height: 30,
                    ),
                    kisiButonu(grupEmail, context),
                    const SizedBox(
                      width: 15,
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  FlatButton kisiButonu(String mail, BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      child: Row(
        // Replace with a Row for horizontal icon + text
        children: <Widget>[
          const FaIcon(FontAwesomeIcons.facebookMessenger, color: Colors.red),
          Text(" $mail'e  mesaj gonder")
        ],
      ),
      //const Text("Login"),
      //icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
      onPressed: () {
        mesajlasilanKisi = mail;

        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => mesajlasmaEkrani()),
        );*/
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCustomForm()),
        );
      },
    );
  }
}

/*
List<Map<String, dynamic>>? firebaseVeriAl() {
  /*
  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: FirebaseFirestore.instance.collection('mesajlar').snapshots(),
    builder: (_, snapshot) {
      if (snapshot.hasError) return Text('Error = ${snapshot.error}');

      if (snapshot.hasData) {
        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final data = docs[i].data();
            return ListTile(
              title: Text(getMessages(data)),
              subtitle: Text(data['phone']),
            );
          },
        );
      }

      return Center(child: CircularProgressIndicator());
    },
  )
  */
  FirebaseFirestore.instance
      .collection('mesajlar')
      .where('Sender', isEqualTo: user!.email.toString())
      .where('Receiver', isEqualTo: mesajlasilanKisi)
      //.where('Sender', isEqualTo: "${user.email}")
      .get()
      .then((value) {
    // sadece 1 tane aynı kullanıcılara sahip document bırakıyor her seferınde 1 tane sildiğinden hic bir zaman 2 den fazla olmuyor 1 tane silmesi yetiyor
    //QuerySnapshot<Map<String, dynamic>> asilCollection = value;
    //value.docs.first.get('Messages')
    List<Map<String, dynamic>> messages =
        List.from(value.docs.first.get('Messages'));

    for (int i = 0; i < messages.length; i++) {
      List<dynamic> messagesValues = messages[i]
          .values
          .toList(); // first message is actual message second is timestamp
      if (messagesValues.length != 2) {
        print("hataaaaa");
        print(messagesValues);
      }
      print("message: " +
          messagesValues[0].toString() +
          "\nzamani: " +
          messagesValues[1].toDate().toString()); // timestamp to date
    }

    //for(int i=0;i<value

    /*for (var element in value.docs) {
          //List<String> pointlist = List.from(element.get('Message'));
          //element.
          if (element.get('Receiver') == Receiver) {
            print("Receiver2 bulundu" + text);
            element.reference.update({
              'Message': FieldValue.arrayUnion([text])
            });

            mesajGondermeBasarili = true; // sohbet bulundu mesaj eklendi
            break;
          }
        }*/
    //print(value.data['Message']);
    //print("???" + value.toString());
    return messages;
  });
  return null;
}
*/
class mesajlasmaEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(100, 109, 23, 1),
          title: Text('${mesajlasilanKisi}'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('mesajlar').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                  children: snapshot.data!.docs.map((document) {
                return Container(
                  child: Column(
                    children: [
                      Center(child: Text(document['Sender'])),
                      Center(child: Text(document['Receiver'])),
                      //Center(child: Text(document['Message'])),
                    ],
                  ),
                );
              }).toList());
              /*Container(
          alignment: Alignment.bottomCenter,
          color: Colors.blueGrey.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'mesajlar burda gozukcek inşaAllah\nbiraz sabır',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 32),
              TextField(
                decoration: InputDecoration(
                    focusColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Mesajınızı yazın'),
              ),
            ],
          ),
        ));
  }
}*/
            }));
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  final Stream<QuerySnapshot> messages =
      FirebaseFirestore.instance.collection('mesajlar').snapshots();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //firebaseVeriAl();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 250,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: StreamBuilder<QuerySnapshot>(
                stream: messages,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) return Text('Something went wrong.');
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Text('Loading');
                  final data = snapshot.requireData;
                  //data.docs.where()
                  var currentMessages = (data.docs.where((element) => ((element
                                  .get('Receiver') ==
                              mesajlasilanKisi &&
                          element.get('Sender') == user!.email.toString()) ||
                      (element.get('Sender') == mesajlasilanKisi &&
                          element.get('Receiver') == user!.email.toString()))));
                  if (currentMessages.isNotEmpty) {
                    List<Map<String, dynamic>> messagesAndDates =
                        List.from(currentMessages.first.get('Messages'));
                    /*
                    for (int i = 0; i < messagesAndDates.length; i++) {
                      List<dynamic> messagesValues = messagesAndDates[i]
                          .values
                          .toList(); // first message is actual message second is timestamp
                      if (messagesValues.length != 2) {
                        print("hataaaaa");
                        print(messagesValues);
                      }
                      print("message: " +
                          messagesValues[0].toString() +
                          "\nzamani: " +
                          messagesValues[1].toDate().toString()); // timestamp to date
                  }
                  //messagesList[0].get('Messages').
                  /*
                  List<Map<String, dynamic>> messages =
        List.from(value.docs.first.get('Messages'));

    for (int i = 0; i < messages.length; i++) {
      List<dynamic> messagesValues = messages[i]
          .values
          .toList(); // first message is actual message second is timestamp
      if (messagesValues.length != 2) {
        print("hataaaaa");
        print(messagesValues);
      }
      print("message: " +
          messagesValues[0].toString() +
          "\nzamani: " +
          messagesValues[1].toDate().toString()); // timestamp to date
    }
*/
                  */
                    print("ne gelmis");
                    if (messagesAndDates.length == 0) {
                      return const Text('Gorusmeye Basla');
                    }
                    return ListView.builder(
                      itemCount: messagesAndDates.length,
                      itemBuilder: (context, index) {
                        var messagesTaken = messagesAndDates[index]['Message'];
                        //List
                        //return Text('${data.docs[index].get('Messages')[0].get('Message')}');
                        //return Text('${data.docs[index].get('Receiver')}');
                        // (bool) ? ((bool) ? asdad: asdsa)
                        return Padding(
                          padding: (index % 2 == 0)
                              ? const EdgeInsets.only(left: 100)
                              : const EdgeInsets.only(right: 100),
                          child: Row(
                            children: [
                              Text('${messagesTaken}'),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const Text('Gorusmeye Basla');
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your message'),
              controller: myController,
            ),
          ),
          SizedBox(width: 30, height: 15),
          /*Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children:
                  _getListings(), // <<<<< Note this change for the return type
            ),
          )*/
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String message = myController.text;
          if (message.isNotEmpty) {
            sendMessage(message);
          }
          myController.clear();
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.send),
      ),
    );
  }

  /*
  List<Widget> _listings = [];

  List<Widget> _getListings() {
    // <<<<< Note this change for the return type
    List<Widget> listings = <Widget>[];
    int i = 0;
    List<Map<String, dynamic>>? messages = firebaseVeriAl();
    /*
    for (int i = 0; i < messages.length; i++) {
      List<dynamic> messagesValues = messages[i]
          .values
          .toList(); // first message is actual message second is timestamp
      if (messagesValues.length != 2) {
        print("hataaaaa");
        print(messagesValues);
      }
      print("message: " +
          messagesValues[0].toString() +
          "\nzamani: " +
          messagesValues[1].toDate().toString()); // timestamp to date
    }
   */
    if (messages == null) {
      List<Widget> temp = [];
      return temp;
    }
    for (i = 0; i < messages!.length; i++) {
      List<dynamic> messagesValues = messages![i].values.toList();
      print("Girdi " + messagesValues[0].toString());
      listings.add(
        RadioListTile<String>(
          title: Text(
              '${messagesValues[0].toString() + messagesValues[1].toDate().toString()}'),
          value: "c",
          groupValue: "x",
          onChanged: (_) {},
        ),
      );
    }
    return listings;
  }
  */
  Future<void> sendMessage(String text) async {
    String kullanici1 = user!.email.toString(); //olcak
    String kullanici2 = mesajlasilanKisi; //'nin maili olcak
    /*bool mesajGonderildi = sohbeteMesajEkle(kullanici1, kullanici2, text);
    if (!mesajGonderildi)
      mesajGonderildi = sohbeteMesajEkle(kullanici2, kullanici1, text);
    if (!mesajGonderildi) {
      // bu iki kişi daha once konusmamıslar, yeni bir sohbet alani acilmali
      sohbetOlustur(kullanici1, kullanici2, text);
    }*/
    sonMesajBasariylaGonderildi = false;
    await sohbeteMesajEkle(kullanici1, kullanici2, text);
    if (!sonMesajBasariylaGonderildi) {
      await sohbeteMesajEkle(kullanici2, kullanici1, text);
    }
    if (!sonMesajBasariylaGonderildi) {
      sohbetOlustur(kullanici1, kullanici2, text);
    }
    /*if (sohbeteMesajEkle(kullanici1, kullanici2, text) == true ||
        sohbeteMesajEkle(kullanici2, kullanici1, text) == true) {
    } else {
      // bu iki kişi daha once konusmamıslar, yeni bir sohbet alani acilmali
      sohbetOlustur(kullanici1, kullanici2, text);
    }*/
    // burdaki element her farklı 2 kişi arasındaki sohbet
    //print(element.get('Message') + "++");
    //element.get('Message').
    // mesajlar arrayini alıyor

    /*for (int i = 0; i < pointlist.length; i++) {
            print("--" + pointlist[i]);
          }*/
    /*pointlist.add(myController.text);
                element.data().update('Message', (pointlist)) add({
                  'Message':FieldValue.arrayUnion(pointlist);
                });*/
    //'Message':FieldValue.arrayUnion(pointlist);
    //element.get('Message')
    /*     });
        //print(value.data['Message']);
        //print("???" + value.toString());
      });
    });*/
    //.add({'text': 'data added through app'});
    //.add({'Message': '15'});
    /*showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );*/
  }

  bool sonMesajBasariylaGonderildi = false;
  Future<void> sohbeteMesajEkle(
      String Sender, String Receiver, String text) async {
    bool mesajGondermeBasarili = false;
    await FirebaseFirestore.instance
        .collection('mesajlar')
        .where('Sender', isEqualTo: Sender)
        .where('Receiver', isEqualTo: Receiver)
        //.where('Sender', isEqualTo: "${user.email}")
        .get()
        .then((value) {
      setState(() {
        print("Ilk bu gelmeli");
        if (value.size == 0 || value.docs.isEmpty) {
          mesajGondermeBasarili = false;
          sonMesajBasariylaGonderildi = false;
          return;
        }
        //removeUnnecessaryDoc(value);
        // sadece 1 tane aynı kullanıcılara sahip document bırakıyor her seferınde 1 tane sildiğinden hic bir zaman 2 den fazla olmuyor 1 tane silmesi yetiyor
        //QuerySnapshot<Map<String, dynamic>> asilCollection = value;
        value.docs.forEach((element) {
          print(element.toString() + Sender + " " + Receiver + "qqq");
          element.reference.update({
            // sadece 1 tane var=> first aradigimız
            'Messages': FieldValue.arrayUnion([
              {
                'Message': text + user!.email.toString(),
                'Time': Timestamp.fromDate(DateTime.now())
              }
            ])
          });
        });
        //removeUnnecessaryDoc(value);

        //for(int i=0;i<value

        mesajGondermeBasarili = true;
        sonMesajBasariylaGonderildi = true;
        /*for (var element in value.docs) {
          //List<String> pointlist = List.from(element.get('Message'));
          //element.
          if (element.get('Receiver') == Receiver) {
            print("Receiver2 bulundu" + text);
            element.reference.update({
              'Message': FieldValue.arrayUnion([text])
            });

            mesajGondermeBasarili = true; // sohbet bulundu mesaj eklendi
            break;
          }
        }*/
        //print(value.data['Message']);
        //print("???" + value.toString());
      });
    });
    print(text + mesajGondermeBasarili.toString());
    //-----------------
    /*FirebaseFirestore.instance
        .collection('mesajlar')
        .where('Sender', isEqualTo: Sender)
    //.where('Sender', isEqualTo: "${user.email}")
        .where('Receiver',isEqualTo: Receiver);*/
    //-----------------
    print("Sonra bu gelmeli");
    //return mesajGondermeBasarili;
  }

  Future<void> sohbetOlustur(
      String kullanici1, String kullanici2, String text) async {
    CollectionReference mesajlar =
        FirebaseFirestore.instance.collection('mesajlar');
    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    mesajlar.add({
      'Sender': kullanici1,
      'Receiver': kullanici2,
      'Messages': [
        {'Message': text + user!.email.toString(), 'Time': myTimeStamp}
      ],
      'DateOfFirstMessage': myTimeStamp
    });
    print('Yeni mesaj olusturuldu');
    /*
    Firestore.instance
        .collection('Mesajlar')
        .document(kullanici1 + kullanici2)
        .setData({
      'map1': {
        'key1': 'value1',
        'key2': 'value2',
      }
    });*/
  }

  void removeUnnecessaryDoc(QuerySnapshot<Map<String, dynamic>> collection) {
    if (collection.size == 0 || collection.docs.length < 2) {
      return;
    }
    int length = collection.docs.length;
    List<DateTime> toRemove = <DateTime>[];
    /*for(int i=length;i>0;i--){ // tersten basladık ki remove edince indexler degismesin
      DateTime dateOfFirst =
      collection.docs[i].get('DateOfFirstMessage').toDate();
      DateTime dateOfSecond =
      collection.docs[i-1].get('DateOfFirstMessage').toDate();
      int indexToRemove = (dateOfFirst.isAfter(dateOfSecond) == true) ? i : i-1;
      //remove the date comes later
      FirebaseFirestore.instance
          .collection('mesajlar')
          .doc(collection.docs[indexToRemove].reference.id)
          .delete();
    }*/
    for (int i = 0; i < length; i++) {
      DateTime dateOfDoc =
          collection.docs[i].get('DateOfFirstMessage').toDate();
      toRemove.add(dateOfDoc);
    }
    int firstDate = 0;
    for (int i = 1; i < length; i++) {
      if (toRemove[firstDate].isAfter(toRemove[i])) {
        firstDate = i;
      }
    }
    for (int i = length - 1; i >= 0; i--) {
      if (i != firstDate) {
        print("Bundan 2 tane olmali");
        // en erken haric tum mesaj documentlerini siliyoruz
        FirebaseFirestore.instance
            .collection('mesajlar')
            .doc(collection.docs[i].reference.id)
            .delete();
      } else {
        print("Bundan 1 tane olmali");
      }
    }
  }
}
