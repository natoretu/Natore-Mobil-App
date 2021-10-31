import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:natore_project/page/home_page.dart';

//import 'package:natore_project/provider/google_sign_in.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
String mesajlasilanKisi = ""; // mesaj atilacak kisinin maili buraya yazilir.
//user = FirebaseAuth.instance.currentUser!;
void mesajGondermeEkraniniAc(String mail, BuildContext context) {
  mesajlasilanKisi = mail;
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MesajGondermeEkrani()),
  );
}

class Sohbet extends StatelessWidget {
  final Stream<QuerySnapshot> allMessages =
      FirebaseFirestore.instance.collection('mesajlar').snapshots();
  List<dynamic> userMessagesList = <dynamic>[];
  @override
  Widget build(BuildContext context) {
    TextField textField;
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    //!! arayüz daha once konusulan kısıler,
                    height:
                        300, // bu deger gecmıs sohbetlerın kac piksel asagıya kadar gosterılecegını belırlıyor
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
                          var currentMessages = (data.docs.where((element) =>
                              (element.get('Sender') ==
                                  user!.email.toString()) ||
                              (element.get('Receiver') ==
                                  user!.email.toString())));

                          if (currentMessages.isNotEmpty) {
                            userMessagesList = List.from(currentMessages);
                            userMessagesList.sort((b, a) => a
                                .get('Messages')[a.get('Messages').length - 1]
                                    ['Time']
                                .compareTo(b.get('Messages')[
                                    b.get('Messages').length - 1]['Time']));
                            return ListView.builder(
                              itemCount: userMessagesList.length,
                              itemBuilder: (context, index) {
                                var sohbet = userMessagesList[index];
                                var messagesWithSpecificUser =
                                    sohbet.get('Messages');
                                var messageList =
                                    List.from(messagesWithSpecificUser);
                                var lastMessage =
                                    messageList[messageList.length - 1]
                                        ['Message'];
                                var lastMessageTime =
                                    messageList[messageList.length - 1]['Time'];

                                String konusulanKisi = userMessagesList[index]
                                    .get(((userMessagesList[index]
                                                .get('Receiver') !=
                                            user!.email.toString())
                                        ? 'Receiver'
                                        : 'Sender'));
                                //!!arayüz
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      kisiButonu(
                                          konusulanKisi,
                                          lastMessageTime.toDate(),
                                          mailiCikar(lastMessage, user!.email,
                                              konusulanKisi),
                                          context)
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          //!arayüz
                          return const Text(
                              'Gorusmeye Basla'); // daha once konusulmus kımse yoksa bu basiliyor
                        })),
                // !!arayüz yeni mail girilen yer. burası orijinal programda olmayabilir. sonucta normalde satıcıyı program uzerınden bulcaklar ıletısıme geccekler
                textField = TextField(
                  decoration: new InputDecoration.collapsed(
                      hintText: "Yeni Sohbet için mail"),
                  onSubmitted: (String mail) {
                    mesajGondermeEkraniniAc(mail, context);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  // !!arayüz gecmıs sohbetler ıcın son mesaj zamanını son mesajını ve son konusulan kısıyı gosterıyor
  FlatButton kisiButonu(
      String mail, DateTime time, String message, BuildContext context) {
    return FlatButton(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          const FaIcon(FontAwesomeIcons.facebookMessenger, color: Colors.blue),
          Text("  $mail\n  $message\n  $time"),
        ],
      ),
      onPressed: () {
        mesajlasilanKisi = mail;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MesajGondermeEkrani()),
        );
      },
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

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MesajGondermeEkrani extends State<MesajGondermeEkrani> {
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
      //!!arayüz
      appBar: AppBar(
        title: Text('$mesajlasilanKisi'),
      ),
      //!!arayüz
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //!!arayüz
          Container(
            height: 350, // burası mesajların gorunecegı kısmın boyu
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

                    return ListView.builder(
                      itemCount: messagesAndDates.length,
                      itemBuilder: (context, index) {
                        var messagesTaken = messagesAndDates[index]['Message'];
                        var messageTime = messagesAndDates[index]['Time'];

                        String ekranaBasilacakMesaj = mailiCikar(
                            messagesTaken, user!.email, mesajlasilanKisi);
                        String mesajinZamani = messageTime.toDate().toString();
                        // !!Arayüz
                        // mesajı saga mı sola mı yaslayacagız onu belırlıyor
                        return Padding(
                          padding: (isItOurMessage(
                                  messagesTaken)) // bizim mesaj ise sagda yoksa solda
                              ? const EdgeInsets.only(left: 100)
                              : const EdgeInsets.only(right: 100),
                          child: Row(
                            //!! arayüz mesajın sekli, whatsapp dakı gıbı mesajıns zamanını mesajın sag altında verebilirsek hos olur tabı gunler de gereklı dun 12 de atılan mesajla bugun 12 de atılanı ayırt etmek ıcın
                            children: [
                              Text('$ekranaBasilacakMesaj' +
                                  "\n" +
                                  '$mesajinZamani'),
                            ],
                          ),
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
        ],
      ),
      //!! arayüz gonder butonu
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
