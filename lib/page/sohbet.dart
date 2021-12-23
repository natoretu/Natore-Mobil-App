import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natore_project/page/home_page.dart';

//import 'package:natore_project/provider/google_sign_in.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
String mesajlasilanKisi = ""; // mesaj atilacak kisinin maili buraya yazilir.
//user = FirebaseAuth.instance.currentUser!;
List<String> imageList = [];
void mesajGondermeEkraniniAc(String mail, BuildContext context) {
  mesajlasilanKisi = mail;
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MesajGondermeEkrani()),
  );
}

Future<void> ImageProcess(List<dynamic> userMessagesList) async {
  for (int i = 0; i < userMessagesList.length;) {
    String mail = userMessagesList[i].get(
        ((userMessagesList[i].get('Receiver') != user!.email.toString())
            ? 'Receiver'
            : 'Sender'));
    await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: mail)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        String imageString = element.get('Image');

        imageList.add(imageString);
      });
    }).whenComplete(() => i++);
  }
}

class Sohbet extends StatefulWidget {
  @override
  State<Sohbet> createState() => _SohbetState();
}

class _SohbetState extends State<Sohbet> {
  final Stream<QuerySnapshot> allMessages =
      FirebaseFirestore.instance.collection('mesajlar').snapshots();

  List<dynamic> userMessagesList = <dynamic>[];

  @override
  Widget build(BuildContext context) {
    TextField textField;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff06D6A0),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Sohbet',
            style: TextStyle(
                fontFamily: 'Zen Antique Soft',
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: 22),
          ),
        ),
        body: Center(
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  //!! arayüz daha once konusulan kısıler,
                  height:
                      300, // bu deger gecmıs sohbetlerın kac piksel asagıya kadar gosterılecegını belırlıyor
                  //padding: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(8),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: allMessages,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return Text('Something went wrong.');
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Text('Loading');
                        final data = snapshot.requireData;
                        var currentMessages = (data.docs.where((element) =>
                            (element.get('Sender') == user!.email.toString()) ||
                            (element.get('Receiver') ==
                                user!.email.toString())));

                        if (currentMessages.isNotEmpty) {
                          userMessagesList = List.from(currentMessages);
                          userMessagesList.sort((b, a) => a
                              .get('Messages')[a.get('Messages').length - 1]
                                  ['Time']
                              .compareTo(b.get(
                                      'Messages')[b.get('Messages').length - 1]
                                  ['Time']));
                          return FutureBuilder(
                              future: ImageProcess(userMessagesList),
                              builder: (_, snap) {
                                switch (snap.connectionState) {
                                  case ConnectionState.waiting:
                                    return Text('Loading....');
                                  default:
                                    if (snap.hasError)
                                      return Text('Error: ${snap.error}');
                                    else {
                                      return ListView.builder(
                                        itemCount: userMessagesList.length,
                                        itemBuilder: (context, index) {
                                          var sohbet = userMessagesList[index];
                                          var messagesWithSpecificUser =
                                              sohbet.get('Messages');
                                          var messageList = List.from(
                                              messagesWithSpecificUser);
                                          var lastMessage = messageList[
                                                  messageList.length - 1]
                                              ['Message'];
                                          var lastMessageTime = messageList[
                                              messageList.length - 1]['Time'];

                                          String konusulanKisi =
                                              userMessagesList[index].get(
                                                  ((userMessagesList[index].get(
                                                              'Receiver') !=
                                                          user!.email
                                                              .toString())
                                                      ? 'Receiver'
                                                      : 'Sender'));
                                          //!!arayüz

                                          return Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: kisiButonu(
                                                index,
                                                konusulanKisi,
                                                lastMessageTime.toDate(),
                                                mailiCikar(lastMessage,
                                                    user!.email, konusulanKisi),
                                                context),
                                          );
                                        },
                                      );
                                    }
                                }
                              });
                        }
                        //!arayüz
                        return const Text(
                            'Gorusmeye Basla'); // daha once konusulmus kımse yoksa bu basiliyor
                      })),
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
        ));
  }

  String timeEdit(DateTime time) {
    String hour, min;
    if (time.hour < 10) {
      hour = '0' + '${time.hour}';
    } else {
      hour = '${time.hour}';
    }

    if (time.minute < 10) {
      min = '0' + '${time.minute}';
    } else {
      min = '${time.minute}';
    }
    return hour + ':' + min;
  }

  SafeArea kisiButonu(int index, String mail, DateTime time, String message,
      BuildContext context) {
    Widget returnWidget;
    return SafeArea(
      child: TextButton(
        style: TextButton.styleFrom(
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(imageList[index]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 10, 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mail,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      message,
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 30,
              child: Text(
                timeEdit(time),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
            ),
          ],
        ),
        onPressed: () {
          mesajlasilanKisi = mail;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MesajGondermeEkrani()),
          );
        },
      ),
    );
  }
}

String mailiCikar(String message, String? email, String konusulanKisi) {
  if (message.length - email!.length > 0 &&
      message.substring(message.length - email.length, message.length) ==
          email) {
    return message.substring(0, message.length - email.length);
  }
  return message.substring(0, message.length - konusulanKisi.length);
}

class MesajGondermeEkrani extends StatefulWidget {
  const MesajGondermeEkrani({Key? key}) : super(key: key);

  @override
  _MesajGondermeEkrani createState() => _MesajGondermeEkrani();
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String messageTime;
  MessageTile(
      {required this.message,
      required this.sendByMe,
      required this.messageTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff90a4ae), const Color(0xff90a4ae)]
                  : [const Color(0xff546e7a), const Color(0xff546e7a)],
            )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //" $messageTime"
            Flexible(
              child: Container(
                child: Text(message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300)),
              ),
            ),
            SizedBox(
              width: 7,
            ),

            Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Container(
                  child: Text('$messageTime',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MesajGondermeEkrani extends State<MesajGondermeEkrani> {
  final Stream<QuerySnapshot> messages =
      FirebaseFirestore.instance.collection('mesajlar').snapshots();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  /*void afterfirst(BuildContext context) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }*/

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 100000);

  @override
  Widget build(BuildContext context) {
    //firebaseVeriAl();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        //!!arayüz
        backgroundColor: Colors.white70, //Color(0xffcfd8dc),
        appBar: AppBar(
          title: Text('$mesajlasilanKisi'),
          backgroundColor: Color(0xff2A9D8F), //Color(0xff37474f),
        ),
        //!!arayüz
        body: Container(
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    135, // burası mesajların gorunecegı kısmın boyu
                //padding: const EdgeInsets.symmetric(vertical: 20),
                child: StreamBuilder<QuerySnapshot>(
                    stream: messages,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong.');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading');
                      }
                      final data = snapshot.requireData;
                      //data.docs.where()
                      var currentMessages = (data.docs.where((element) =>
                          ((element.get('Receiver') == mesajlasilanKisi &&
                                  element.get('Sender') ==
                                      user!.email.toString()) ||
                              (element.get('Sender') == mesajlasilanKisi &&
                                  element.get('Receiver') ==
                                      user!.email.toString()))));
                      if (currentMessages.isNotEmpty) {
                        List<Map<String, dynamic>> messagesAndDates =
                            List.from(currentMessages.first.get('Messages'));

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: messagesAndDates.length,
                          itemBuilder: (context, index) {
                            var messagesTaken =
                                messagesAndDates[index]['Message'];
                            var messageTime = messagesAndDates[index]['Time'];

                            String ekranaBasilacakMesaj = mailiCikar(
                                messagesTaken, user!.email, mesajlasilanKisi);
                            String mesajinZamani =
                                messageTime.toDate().toString().split(' ')[1];
                            mesajinZamani = mesajinZamani.substring(0, 5);

                            // !!Arayüz
                            // mesajı saga mı sola mı yaslayacagız onu belırlıyor

                            return MessageTile(
                              message: ekranaBasilacakMesaj,
                              sendByMe: isItOurMessage(messagesTaken),
                              messageTime: mesajinZamani,
                            );
                          },
                        );
                      }
                      //!! arayüz
                      return const Text(
                          'Gorusmeye Basla2'); // eğer daha önce hiç bu kisiyle konusulmamışsa bu yazıyor
                    }),
              ),
              //!! arayüz mesajın yazıldıgı textFormField

              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffeceff1)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: myController,
                          //style: simpleTextStyle(),
                          decoration: const InputDecoration(
                              hintText: "Message ",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          String message = myController.text;
                          if (message.isNotEmpty) {
                            sendMessage(message);
                          }
                          myController.clear();
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0x36FFFFFF),
                                      Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight),
                                borderRadius: BorderRadius.circular(40)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            child: const Icon(
                              Icons.send,
                              size: 25,
                              color: Color(0xff264653),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        //!! arayüz gonder butonu
        );
  }

  void verilenKisiyeMesajGonder(String mail, String text) {
    mesajlasilanKisi = mail;
    sendMessage(text);
  }

  Future<void> sendMessage(String text) async {
    String kullanici1 = user!.email.toString();
    String kullanici2 = mesajlasilanKisi;
    sonMesajBasariylaGonderildi = false;
    await sohbeteMesajEkle(kullanici1, kullanici2, text);
    if (!sonMesajBasariylaGonderildi) {
      await sohbeteMesajEkle(kullanici2, kullanici1, text);
    }
    if (!sonMesajBasariylaGonderildi) {
      sohbetOlustur(kullanici1, kullanici2, text);
    }
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
        mesajGondermeBasarili = true;
        sonMesajBasariylaGonderildi = true;
      });
    });
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
  }

  bool isItOurMessage(String message) {
    if (message.length - user!.email!.length <= 0) return false;

    return (message.substring(
            message.length - user!.email!.length, message.length) ==
        user!
            .email!); // message holds the mail of sender, if it is from us, it will be on right side
  }
}
