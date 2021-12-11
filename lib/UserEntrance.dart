import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natore_project/Anasayfa.dart';
import 'package:natore_project/main.dart';

// ignore_for_file: file_names
SingingCharacter? character;
bool checksaticioralici = false;

String Adress1 = "boş";

class googleLoginPage2 extends StatelessWidget {
  bool check = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              //final user = FirebaseAuth.instance.currentUser! as var; // <-- Your data using 'as'
              final user = FirebaseAuth.instance.currentUser!;
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.email)
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  check = false;
                } else {
                  check = true;
                }
              });
              if (check) {
                return MainPage2();
              } else {
                function();
                return MyApp1();
              }
            } else if (snapshot.hasError) {
              return Center(child: Text('Something went wrong!'));
            } else
              return MainPage1();
          },
        ),
      );
  //body: MainPage(),
}

Future function() async {
  await getProductsOfSeller1();
}

Future getProductsOfSeller1() async {
  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  await FirebaseFirestore.instance
      .collection('Users')
      .where('Email', isEqualTo: user.email!)
      .get()
      .then((value) {
    value.docs.forEach((element) async {
      Adress1 = element.get('Adress');
      checksaticioralici = element.get('saticiMi');
    });
  });

  saticilar = List.of([]);

  String temp;
  await FirebaseFirestore.instance
      .collection('Users')
      .where('Adress', isEqualTo: Adress1)
      .where('saticiMi', isEqualTo: true)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      saticilar.add(element.get('MarketName'));
      saticilar1.add(element.get('TimeCont'));
      saticilar2.add(element.get('Image'));
    });
  });
  saticilength = saticilar.length;
}

enum SingingCharacter { Alici, Satici }

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool check = false;
  bool a = false;

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef =
        FirebaseFirestore.instance.collection('Users');
    var babaRef = updateRef.doc(user.email!);
    File image = File(user.photoURL!);
    File image1 = File(user.photoURL!);
    imagePath = image.path;

    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.shade900,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Profil',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 32),
          StreamBuilder<DocumentSnapshot>(
            stream: babaRef.snapshots(),
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              return CircleAvatar(
                radius: 40,
                //'${asyncSnapshot.data.data()['Image']}'
                backgroundImage:
                    NetworkImage('${asyncSnapshot.data.data()['Image']}'),
              );
            },
          ),
          SizedBox(height: 8),
          Text(
            'Isim: ' + user.displayName!,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Email: ' + user.email!,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return Colors.blue.withOpacity(0.04);
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Colors.blue.withOpacity(0.12);
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              if (character == SingingCharacter.Alici) {
                a = false;
              } else if (character == SingingCharacter.Satici) {
                a = true;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondRoute(a)),
              );
            },
            child: Text('Profile'),
          ),
          ConstrainedBox(
            // ignore: prefer_const_constructors
            constraints: BoxConstraints.tightFor(width: 200, height: 200),
            child: ElevatedButton(
              child: Text(
                'Profil',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteWidget()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SecondRoute extends StatelessWidget {
  SecondRoute(this.check, {Key? key}) : super(key: key);
  final bool check;

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (check == false) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
        ),
        body: Center(
            //child: NewWidget(nameController: nameController, surnameController: surnameController, mailController: mailController)
            ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
        ),
        body: Center(
            //child: NewWidget1(nameController: nameController, surnameController: surnameController, mailController: mailController)
            ),
      );
    }
  }
}

class NewWidget extends StatefulWidget {
  NewWidget({
    Key? key,
    required this.nameController,
    required this.surnameController,
    required this.mailController,
  }) : super(key: key);
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController mailController;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  final user = FirebaseAuth.instance.currentUser!;

  final _firestore = FirebaseFirestore.instance;

  TextEditingController TelNoController = TextEditingController();

  TextEditingController AdressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference UsersRef = _firestore.collection('Users');
    String Filename = user.photoURL!;
    File imagefile = File(user.photoURL!);
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final picker = ImagePicker();

    chooseImage(ImageSource source) async {
      final PickedFile = await picker.getImage(source: source);
      imagefile = await File(PickedFile!.path);
    }

    Future<String> uploadMedia(File file) async {
      var uploadTask = _firebaseStorage
          .ref()
          .child(
              "${DateTime.now().millisecondsSinceEpoch}.${file.path.split(".").last}")
          .putFile(file);

      uploadTask.snapshotEvents.listen((event) {});
      var storageRef = await uploadTask;
      return await storageRef.ref.getDownloadURL();
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            width: 150,
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                child: Column(
              children: [
                TextFormField(
                  controller: widget.nameController,
                  decoration: InputDecoration(hintText: "Adınızı Giriniz"),
                ),
                TextFormField(
                  controller: widget.surnameController,
                  decoration: InputDecoration(hintText: "Soyadınızı Giriniz"),
                ),
                Container(
                  child: imagefile != null
                      ? Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: FileImage(imagefile),
                          )),
                        )
                      : Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(color: Colors.grey),
                        ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ignore: deprecated_member_use
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            chooseImage(ImageSource.camera);
                          },
                          color: Colors.redAccent,
                          child: Text("Camera",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      // ignore: deprecated_member_use
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            chooseImage(ImageSource.gallery);
                          },
                          color: Colors.redAccent,
                          child: Text("Galerry",
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered))
                          return Colors.blue.withOpacity(0.04);
                        if (states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed))
                          return Colors.blue.withOpacity(0.12);
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: () async {
                    String a = await uploadMedia(imagefile);
                    Map<String, dynamic> UsersData = {
                      'Name': widget.nameController.text,
                      'Surname': widget.surnameController.text,
                      'Email': user.email!,
                      'Image': a,
                      'saticiMi': false
                    };
                    await UsersRef.doc(user.email!).set(UsersData);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp1()),
                    );
                  },
                  child: Text('Gönder'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go back!'),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}

class NewWidget1 extends StatefulWidget {
  NewWidget1({
    Key? key,
    required this.nameController,
    required this.surnameController,
    required this.mailController,
    required this.MarketNameController,
    required this.TimeController,
  }) : super(key: key);
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController mailController;
  final TextEditingController MarketNameController;
  final TextEditingController TimeController;
  @override
  State<NewWidget1> createState() => _NewWidget1State();
}

class _NewWidget1State extends State<NewWidget1> {
  final user = FirebaseAuth.instance.currentUser!;

  final _firestore = FirebaseFirestore.instance;

  TextEditingController TelNoController = TextEditingController();

  TextEditingController AdressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference UsersRef = _firestore.collection('Users');
    String Filename = user.photoURL!;
    File imagefile = File(user.photoURL!);
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final picker = ImagePicker();

    chooseImage(ImageSource source) async {
      final PickedFile = await picker.getImage(source: source);
      imagefile = await File(PickedFile!.path);
    }

    Future<String> uploadMedia(File file) async {
      var uploadTask = _firebaseStorage
          .ref()
          .child(
              "${DateTime.now().millisecondsSinceEpoch}.${file.path.split(".").last}")
          .putFile(file);

      uploadTask.snapshotEvents.listen((event) {});
      var storageRef = await uploadTask;
      return await storageRef.ref.getDownloadURL();
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            width: 150,
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                child: Column(
              children: [
                TextFormField(
                  controller: widget.nameController,
                  decoration: InputDecoration(hintText: "Adınızı Giriniz"),
                ),
                TextFormField(
                  controller: widget.surnameController,
                  decoration: InputDecoration(hintText: "Soyadınızı Giriniz"),
                ),
                TextFormField(
                  controller: widget.MarketNameController,
                  decoration: InputDecoration(hintText: "Market Adını Giriniz"),
                ),
                TextFormField(
                  controller: widget.TimeController,
                  decoration: InputDecoration(
                      hintText: "Marketin Açılış Kapanış Saatlerini Giriniz"),
                ),
                TextFormField(
                  controller: TelNoController,
                  decoration: InputDecoration(
                      hintText: "Telefon numaranızı Giriniz(Zorunlu Değil)"),
                ),
                TextFormField(
                  controller: AdressController,
                  decoration: InputDecoration(hintText: "Adresinizi Giriniz"),
                ),
                Container(
                  child: imagefile != null
                      ? Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: FileImage(imagefile),
                          )),
                        )
                      : Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(color: Colors.grey),
                        ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ignore: deprecated_member_use
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            chooseImage(ImageSource.camera);
                          },
                          color: Colors.redAccent,
                          child: Text("Camera",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      // ignore: deprecated_member_use
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            chooseImage(ImageSource.gallery);
                          },
                          color: Colors.redAccent,
                          child: Text("Galerry",
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered))
                          return Colors.blue.withOpacity(0.04);
                        if (states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed))
                          return Colors.blue.withOpacity(0.12);
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: () async {
                    String a = await uploadMedia(imagefile);
                    Map<String, dynamic> UsersData = {
                      'Name': widget.nameController.text,
                      'Surname': widget.surnameController.text,
                      'TelNo': TelNoController.text,
                      'Adress': AdressController.text,
                      'Email': user.email!,
                      'Image': a,
                      'saticiMi': true,
                      'MarketName': widget.MarketNameController.text,
                      'TimeCont': widget.TimeController.text
                    };
                    await UsersRef.doc(user.email!).set(UsersData);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp1()),
                    );
                  },
                  child: Text('Gönder'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go back!'),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}

class MainPage2 extends StatefulWidget {
  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  bool check = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController MarketNameController = TextEditingController();
  TextEditingController TimeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          width: 150,
          height: 30,
        ),
        ListTile(
          title: const Text('Alici'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.Alici,
            groupValue: character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                character = value;
                checksaticioralici = false;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Satici'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.Satici,
            groupValue: character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                character = value;
                checksaticioralici = true;
              });
            },
          ),
        ),
        ElevatedButton(
          child: Text('Bir Sonraki Adım'),
          onPressed: () {
            Navigator.push(
              context,
              character == SingingCharacter.Alici
                  ? MaterialPageRoute(
                      builder: (context) => NewWidget(
                          nameController: nameController,
                          surnameController: surnameController,
                          mailController: mailController))
                  : MaterialPageRoute(
                      builder: (context) => NewWidget1(
                          nameController: nameController,
                          surnameController: surnameController,
                          mailController: mailController,
                          MarketNameController: MarketNameController,
                          TimeController: TimeController)),
            );
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              padding: MaterialStateProperty.all(EdgeInsets.all(50)),
              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30))),
        ),
      ],
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  FavoriteWidget({Key? key}) : super(key: key);
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController textEditingController = TextEditingController();
  late bool check;

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  late File imagefile;
  final picker = ImagePicker();
  chooseImage(ImageSource source) async {
    final PickedFile = await picker.getImage(source: source);
    imagefile = File(PickedFile!.path);
  }

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Future<String> uploadMedia(File file) async {
    var uploadTask = _firebaseStorage
        .ref()
        .child(
            "${DateTime.now().millisecondsSinceEpoch}.${file.path.split(".").last}")
        .putFile(file);

    uploadTask.snapshotEvents.listen((event) {});
    var storageRef = await uploadTask;
    return await storageRef.ref.getDownloadURL();
  }

  @override
  Widget build(context) {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(user.email!);

    if (checksaticioralici == false) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Profil"),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                      hintText:
                          "Degiştirmek istediğiniz değeri girip uygun butona basın!"),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    await updateRef
                        .doc(user.email!)
                        .update({'Name': textEditingController.text});
                  },
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: babaRef.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return Text('${asyncSnapshot.data.data()['Name']}');
                    },
                  ),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    await updateRef
                        .doc(user.email!)
                        .update({'Surname': textEditingController.text});
                  },
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: babaRef.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return Text('${asyncSnapshot.data.data()['Surname']}');
                    },
                  ),
                ),
                checksaticioralici == false
                    ? ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () async {
                          await updateRef
                              .doc(user.email!)
                              .update({'saticiMi': true});
                          FirebaseFirestore.instance
                              .collection('Users')
                              .where('Email', isEqualTo: user.email!)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              checksaticioralici = element.get('saticiMi');
                            });
                          });
                        },
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: babaRef.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            return Text('Satici olmak için basınız');
                          },
                        ),
                      )
                    : ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () async {
                          await updateRef
                              .doc(user.email!)
                              .update({'saticiMi': false});
                          FirebaseFirestore.instance
                              .collection('Users')
                              .where('Email', isEqualTo: user.email!)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              checksaticioralici = element.get('saticiMi');
                            });
                          });
                        },
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: babaRef.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            return Text('Alici olmak için basınız');
                          },
                        ),
                      ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            chooseImage(ImageSource.gallery);
                          },
                          color: Colors.redAccent,
                          child: const Text("Galerry",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    String a = await uploadMedia(imagefile);
                    await updateRef.doc(user.email!).update({'Image': a});
                  },
                  child: Text("Resim guncelle"),
                ),
              ],
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("Profil"),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                      hintText:
                          "Degiştirmek istediğiniz değeri girip uygun butona basın!"),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    await updateRef
                        .doc(user.email!)
                        .update({'Name': textEditingController.text});
                  },
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: babaRef.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return Text('${asyncSnapshot.data.data()['Name']}');
                    },
                  ),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    await updateRef
                        .doc(user.email!)
                        .update({'Surname': textEditingController.text});
                  },
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: babaRef.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return Text('${asyncSnapshot.data.data()['Surname']}');
                    },
                  ),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    await updateRef
                        .doc(user.email!)
                        .update({'MarketName': textEditingController.text});
                  },
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: babaRef.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return Text('${asyncSnapshot.data.data()['MarketName']}');
                    },
                  ),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    await updateRef
                        .doc(user.email!)
                        .update({'TimeCont': textEditingController.text});
                  },
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: babaRef.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return Text('${asyncSnapshot.data.data()['TimeCont']}');
                    },
                  ),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    await updateRef
                        .doc(user.email!)
                        .update({'TelNo': textEditingController.text});
                  },
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: babaRef.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return Text('${asyncSnapshot.data.data()['TelNo']}');
                    },
                  ),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    await updateRef
                        .doc(user.email!)
                        .update({'Adress': textEditingController.text});
                  },
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: babaRef.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return Text('${asyncSnapshot.data.data()['Adress']}');
                    },
                  ),
                ),
                checksaticioralici == false
                    ? ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () async {
                          await updateRef
                              .doc(user.email!)
                              .update({'saticiMi': true});
                          FirebaseFirestore.instance
                              .collection('Users')
                              .where('Email', isEqualTo: user.email!)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              checksaticioralici = element.get('saticiMi');
                            });
                          });
                        },
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: babaRef.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            return Text('Satici olmak için basınız');
                          },
                        ),
                      )
                    : ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () async {
                          await updateRef
                              .doc(user.email!)
                              .update({'saticiMi': false});
                          FirebaseFirestore.instance
                              .collection('Users')
                              .where('Email', isEqualTo: user.email!)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              checksaticioralici = element.get('saticiMi');
                              print(checksaticioralici);
                            });
                          });
                        },
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: babaRef.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            return Text('Alici olmak için basınız');
                          },
                        ),
                      ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            chooseImage(ImageSource.gallery);
                          },
                          color: Colors.redAccent,
                          child: const Text("Galerry",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    String a = await uploadMedia(imagefile);
                    await updateRef.doc(user.email!).update({'Image': a});
                  },
                  child: Text("Resim guncelle"),
                ),
              ],
            ),
          ));
    }
  }
}
