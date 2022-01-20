import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natore_project/Anasayfa.dart';
import 'package:natore_project/page/home_page.dart';
import 'package:natore_project/page/locpicker.dart';
import 'package:natore_project/services/favorites_services.dart';

import 'main.dart';

// ignore_for_file: file_names

SingingCharacter? character;
bool checksaticioralici = false;
String Ugurunkoddandonenadress = "boş"; //TODO
bool check21 = false; //TODO
String Adress1 = "boş";

class googleLoginPage2 extends StatefulWidget {
  @override
  State<googleLoginPage2> createState() => _googleLoginPage2State();
}

class _googleLoginPage2State extends State<googleLoginPage2> {
  bool check = false;

  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator.adaptive(
              backgroundColor: Color(0xff06D6A0),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
            ));
          } else if (snapshot.hasData) {
            user = FirebaseAuth.instance.currentUser!;
            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user!.email)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading....');
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else {
                        if (snapshot.data!.exists) {
                          check = false;
                        } else {
                          check = true;
                        }
                      }
                      if (check) {
                        return MainPage2();
                      } else {
                        check21 = true;
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        checksaticioralici = data['saticiMi'];

                        return MyApp1();
                      }
                  }
                }); // giris yapılmış
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          } else {
            return MainPage1();
          } //MainPage1();
        },
      )
          //body: MainPage(),
          );
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
    required this.AdressController,
  }) : super(key: key);
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController mailController;
  final TextEditingController AdressController;
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
      final PickedFile =
          await picker.getImage(source: source, imageQuality: 25);
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

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.3, 0.8],
              colors: [Color(0xff06D6A0), Colors.cyan])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: widget.nameController,
                          cursorColor: Color(0xffE76F51),
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(24),
                          ],
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffE76F51), width: 2),
                            ),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Color(0xffE76F51)),
                            ),
                            fillColor: Colors.white.withOpacity(0.97),
                            filled: true, // dont forget this line
                            hintText: "İsim",
                          ),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        TextFormField(
                          controller: widget.surnameController,
                          cursorColor: Color(0xffE76F51),
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(24),
                          ],
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffE76F51), width: 2),
                            ),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xffE76F51)),
                            ),
                            fillColor: Colors.white.withOpacity(0.97),
                            filled: true, // dont forget this line
                            hintText: "Soy isim",
                          ),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                primary: Colors.white,
                                onPrimary: Color(0xffE76F51),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocationPicker()),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Adres',
                                    style: GoogleFonts.lemon(
                                        color: Color(0xffE76F51), fontSize: 16),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child: Icon(Icons.location_on_sharp),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    chooseImage(ImageSource.camera);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    primary: Colors.white,
                                    onPrimary: Colors.cyan,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 29,
                                    color: Color(0xff264653),
                                  ),
                                ),
                              ),
                              // ignore: deprecated_member_use
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    chooseImage(ImageSource.gallery);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    primary: Colors.white,
                                    onPrimary: Colors.cyan,
                                  ),
                                  child: Icon(
                                    Icons.image,
                                    size: 29,
                                    color: Color(0xff264653),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            primary: Colors.white,
                            onPrimary: Color(0xff06D6A0),
                          ),
                          onPressed: () async {
                            String a = await uploadMedia(imagefile);
                            Map<String, dynamic> UsersData = {
                              'Name': widget.nameController.text,
                              'Surname': widget.surnameController.text,
                              'Email': user.email!,
                              'Adress':
                                  Ugurunkoddandonenadress, // TODO:ADRESSSSSSSSSSSSSSSSSSSS
                              'Image': a,
                              'saticiMi': false
                            };
                            await UsersRef.doc(user.email!).set(UsersData);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp1()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Bitir',
                                style: GoogleFonts.lemon(
                                    color: Color(0xff06D6A0), fontSize: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.done_all),
                              ),
                            ],
                          ),
                        ),

                        /*ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Geri Dön'),
                      ),*/
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
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
      final PickedFile =
          await picker.getImage(source: source, imageQuality: 25);
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

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.3, 0.8],
              colors: [Color(0xff06D6A0), Colors.cyan])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                      child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: widget.nameController,
                        cursorColor: Color(0xffE76F51),
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(24),
                        ],
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffE76F51), width: 2),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xffE76F51)),
                          ),
                          fillColor: Colors.white.withOpacity(0.97),
                          filled: true, // dont forget this line
                          hintText: "İsim",
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: widget.surnameController,
                        cursorColor: Color(0xffE76F51),
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(24),
                        ],
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffE76F51), width: 2),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xffE76F51)),
                          ),
                          fillColor: Colors.white.withOpacity(0.97),
                          filled: true, // dont forget this line
                          hintText: "Soy isim",
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: widget.MarketNameController,
                        cursorColor: Color(0xffE76F51),
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(41),
                        ],
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Icon(Icons.store,
                                  color: Colors.cyan, size: 26),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffE76F51), width: 2),
                            ),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xffE76F51)),
                            ),
                            fillColor: Colors.white.withOpacity(0.97),
                            filled: true, // dont forget this line
                            hintText: "Market adı"),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: widget.TimeController,
                        cursorColor: Color(0xffE76F51),
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(13),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Icon(Icons.schedule,
                                color: Colors.cyan, size: 26),
                          ),
                          suffixText: "09.00-18.00",
                          suffixStyle: TextStyle(color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffE76F51), width: 2),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xffE76F51)),
                          ),
                          fillColor: Colors.white.withOpacity(0.97),
                          filled: true, // dont forget this line
                          hintText: "Market çalışma saati",
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.phone,
                        controller: TelNoController,
                        cursorColor: Color(0xffE76F51),
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.phone, color: Colors.cyan, size: 24),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffE76F51), width: 2),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xffE76F51)),
                          ),
                          fillColor: Colors.white.withOpacity(0.97),
                          filled: true, // dont forget this line
                          hintText: "Telefon numarası (Zorunlu değil)",
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              primary: Colors.white,
                              onPrimary: Color(0xffE76F51),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocationPicker()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Adres',
                                  style: GoogleFonts.lemon(
                                      color: Color(0xffE76F51), fontSize: 16),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: Icon(Icons.location_on_sharp),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                              child: ElevatedButton(
                                onPressed: () {
                                  chooseImage(ImageSource.camera);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  primary: Colors.white,
                                  onPrimary: Colors.cyan,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 29,
                                  color: Color(0xff264653),
                                ),
                              ),
                            ),
                            // ignore: deprecated_member_use
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  chooseImage(ImageSource.gallery);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  primary: Colors.white,
                                  onPrimary: Colors.cyan,
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: 29,
                                  color: Color(0xff264653),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          primary: Colors.white,
                          onPrimary: Color(0xff06D6A0),
                        ),
                        onPressed: () async {
                          String a = await uploadMedia(imagefile);
                          Map<String, dynamic> UsersData = {
                            'Name': widget.nameController.text,
                            'Surname': widget.surnameController.text,
                            'TelNo': TelNoController.text,
                            'Email': user.email!,
                            'Adress':
                                Ugurunkoddandonenadress, // TODO:ADRESSSSSSSSSSSSSSSSSSSS
                            'Image': a,
                            'saticiMi': true,
                            'MarketName': widget.MarketNameController.text,
                            'TimeCont': widget.TimeController.text,
                            'SaticiTanitimImage': "",
                            'ratedTimes': 0,
                            'rate': 0.01,
                          };
                          FavoritesServices _favoriteServices =
                              FavoritesServices();
                          _favoriteServices.addToFavorites(user.email!);
                          await UsersRef.doc(user.email!).set(UsersData);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp1()),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Bitir',
                              style: GoogleFonts.lemon(
                                  color: Color(0xff06D6A0), fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.done_all),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                )
              ],
            ),
          ),
        ),
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
  TextEditingController AdressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        //statusBarColor: Color(0xff07cc99), //Color(0xff00ADB5),
        //statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.cyan,
        systemNavigationBarContrastEnforced: true,
        //systemNavigationBarIconBrightness: Brightness.dark,
        //systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.8],
                colors: [Color(0xff06D6A0), Colors.cyan])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                      //backgroundColor: Color(0xff06D6A0),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Natore',
                      style:
                          GoogleFonts.lemon(color: Colors.white, fontSize: 52),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "Bir zamanlar saglıksız beslenenlere",
                        style: GoogleFonts.lemon(
                            color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Icon(
                                Icons.face,
                                color: Color(0xff06D6A0),
                                size: 29,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Color(0xff06D6A0),
                                      disabledColor: Colors.red),
                                  child: Radio<SingingCharacter>(
                                    activeColor: Colors.red,
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
                                Text(
                                  "Alıcı    ",
                                  style: GoogleFonts.lemon(
                                      color: Color(0xff06D6A0), fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Icon(Icons.store,
                                  color: Colors.cyan, size: 29),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.cyan,
                                      disabledColor: Colors.blue),
                                  child: Radio<SingingCharacter>(
                                    activeColor: Colors.red,
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
                                Text(
                                  "Satıcı  ",
                                  style: GoogleFonts.lemon(
                                      color: Colors.cyan, fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      primary: Colors.white,
                      onPrimary: Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          //FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          Text(
                            "  Devam Et",
                            style: GoogleFonts.lemon(
                                color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        character == SingingCharacter.Alici
                            ? MaterialPageRoute(
                                builder: (context) => NewWidget(
                                      nameController: nameController,
                                      surnameController: surnameController,
                                      mailController: mailController,
                                      AdressController: AdressController,
                                    ))
                            : MaterialPageRoute(
                                builder: (context) => NewWidget1(
                                    nameController: nameController,
                                    surnameController: surnameController,
                                    mailController: mailController,
                                    MarketNameController: MarketNameController,
                                    TimeController: TimeController)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
    final PickedFile = await picker.getImage(source: source, imageQuality: 25);
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

  TextEditingController _name = TextEditingController();
  TextEditingController _surname = TextEditingController();
  TextEditingController _adress = TextEditingController();

  TextEditingController _Saticiname = TextEditingController();
  TextEditingController _Saticisurname = TextEditingController();
  TextEditingController _MarketName = TextEditingController();
  TextEditingController _TimeCont = TextEditingController();
  TextEditingController _TelNo = TextEditingController();
  TextEditingController _Adress = TextEditingController();

  @override
  Widget build(context) {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(user.email!);

    if (checksaticioralici == false) {


     return FutureBuilder<DocumentSnapshot>(
        future: updateRef.doc(user.email!).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return Text('Something went wrong.');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator.adaptive(
              backgroundColor: Color(0xff06D6A0),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
            ));
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xff06D6A0),
            title: const Text(
              "Profil Bilgileri",
              style: TextStyle(
                  fontFamily: 'Zen Antique Soft',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  fontSize: 22),
            ),
            elevation: 1,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        TextFormField(
                            controller: _name
                              ..text = '${data['Name']}',
                            cursorColor: Colors.cyan,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(42),
                            ],
                            decoration: const InputDecoration(
                              labelText: "İsim",
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.cyan),
                              ),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        TextFormField(
                            controller: _surname
                              ..text =
                                  '${data['Surname']}',
                            cursorColor: Colors.cyan,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(42),
                            ],
                            decoration: const InputDecoration(
                              labelText: "Soy isim",
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.cyan),
                              ),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                        OutlinedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocationPicker()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              side: BorderSide(
                                  width: 1, color: Color(0xff2A9D8F)),
                              primary: Colors.white,
                              //onPrimary: Colors.cyan,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.edit_location_outlined,
                                    color: Color(0xff2A9D8F),
                                    size: 20,
                                  ),
                                ),
                                Text(
                                  '${data['Adress']}',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff2A9D8F)),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            chooseImage(ImageSource.gallery);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side:
                                BorderSide(width: 1, color: Color(0xff2A9D8F)),
                            primary: Colors.white,
                            //onPrimary: Colors.cyan,
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.image,
                                color: Color(0xff2A9D8F),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Profil Resmi",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff2A9D8F)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /*ElevatedButton(
                      onPressed: () async {
                        String a = await uploadMedia(imagefile);
                        await updateRef.doc(user.email!).update({'Image': a});
                      },
                      child: Text("Resim güncelle"),
                    ),*/
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: const Text(
                                    'Profil bilgileriniz güncellendi.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Tamam'),
                                    child: const Text('Tamam'),
                                  ),
                                ],
                              ),
                            );
                            updateRef
                                .doc(user.email!)
                                .update({'Name': _name.text});
                            await updateRef
                                .doc(user.email!)
                                .update({'Surname': _surname.text});
                            String a = await uploadMedia(imagefile);
                            await updateRef
                                .doc(user.email!)
                                .update({'Image': a});
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            primary: Colors.white,
                            onPrimary: Colors.cyan,
                          ),
                          child: const Text(
                            "Güncelle",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 180,
                    ),
                    checksaticioralici == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  primary: Colors.white,
                                  onPrimary: Colors.deepOrange,
                                ),
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
                                      checksaticioralici =
                                          element.get('saticiMi');
                                    });
                                  });
                                  Navigator.pop(context);
                                },
                                child: StreamBuilder<DocumentSnapshot>(///////////////////////////////
                                  stream: babaRef.snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot asyncSnapshot) {
                                    return Row(
                                      children: const [
                                        Icon(Icons.store),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Satıcı olmak için basınız',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  primary: Colors.white,
                                  onPrimary: Colors.deepOrange,
                                ),
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
                                      checksaticioralici =
                                          element.get('saticiMi');
                                    });
                                  });
                                  Navigator.pop(context);
                                },
                                child: StreamBuilder<DocumentSnapshot>(////////////////////////////////7
                                  stream: babaRef.snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot asyncSnapshot) {
                                    return Row(
                                      children: const [
                                        Icon(Icons.face),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Alıcı olmak için basınız',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ));
           });
    } else {
      return FutureBuilder<DocumentSnapshot>(
        future: updateRef.doc(user.email!).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return Text('Something went wrong.');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator.adaptive(
              backgroundColor: Color(0xff06D6A0),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
            ));
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xff06D6A0),
            title: const Text(
              "Profil Bilgileri",
              style: TextStyle(
                  fontFamily: 'Zen Antique Soft',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  fontSize: 22),
            ),
            centerTitle: true,
            elevation: 1,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(40, 29, 40, 40),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                          TextFormField(
                              controller: _Saticiname
                                ..text = '${data['Name']}',
                              cursorColor: Colors.cyan,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(42),
                              ],
                              decoration: const InputDecoration(
                                labelText: "İsim",
                                labelStyle: TextStyle(color: Colors.black54),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.cyan),
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                        TextFormField(
                              controller: _Saticisurname
                                ..text =
                                    '${data['Surname']}',
                              cursorColor: Colors.cyan,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(42),
                              ],
                              decoration: const InputDecoration(
                                labelText: "Soy isim",
                                labelStyle: TextStyle(color: Colors.black54),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.cyan),
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          TextFormField(
                              controller: _MarketName
                                ..text =
                                    '${data['MarketName']}',
                              cursorColor: Colors.cyan,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(42),
                              ],
                              decoration: const InputDecoration(
                                labelText: "Market adı",
                                labelStyle: TextStyle(color: Colors.black54),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.cyan),
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                        TextFormField(
                              controller: _TimeCont
                                ..text =
                                    '${data['TimeCont']}',
                              cursorColor: Colors.cyan,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(42),
                              ],
                              decoration: const InputDecoration(
                                labelText: "Açılış - Kapanış Saati",
                                labelStyle: TextStyle(color: Colors.black54),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.cyan),
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                        TextFormField(
                              controller: _TelNo
                                ..text =
                                    '${data['TelNo']}',
                              cursorColor: Colors.cyan,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(42),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Telefon Numarası",
                                labelStyle: TextStyle(color: Colors.black54),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.cyan),
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              chooseImage(ImageSource.gallery);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              side: BorderSide(width: 1, color: Colors.cyan),
                              primary: Colors.white,
                              //onPrimary: Colors.cyan,
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.image,
                                  color: Colors.cyan,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Profil Resmi",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.cyan),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                       OutlinedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocationPicker()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(
                                    width: 1, color: Color(0xff2A9D8F)),
                                primary: Colors.white,
                                //onPrimary: Colors.cyan,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.edit_location_outlined,
                                      color: Color(0xff2A9D8F),
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    '${data['Adress']}',
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xff2A9D8F)),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  content: const Text(
                                      'Profil bilgileriniz güncellendi.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Tamam'),
                                      child: const Text('Tamam'),
                                    ),
                                  ],
                                ),
                              );
                              updateRef
                                  .doc(user.email!)
                                  .update({'Name': _Saticiname.text});
                              await updateRef
                                  .doc(user.email!)
                                  .update({'Surname': _Saticisurname.text});
                              await updateRef
                                  .doc(user.email!)
                                  .update({'MarketName': _MarketName.text});
                              await updateRef
                                  .doc(user.email!)
                                  .update({'TimeCont': _TimeCont.text});
                              await updateRef
                                  .doc(user.email!)
                                  .update({'TelNo': _TelNo.text});
                              

                              String a = await uploadMedia(imagefile);
                              await updateRef
                                  .doc(user.email!)
                                  .update({'Image': a});
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              primary: Colors.white,
                              onPrimary: Colors.cyan,
                            ),
                            child: const Text(
                              "Güncelle",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      checksaticioralici == false
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                primary: Colors.white,
                                onPrimary: Colors.deepOrange,
                              ),
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
                                    checksaticioralici =
                                        element.get('saticiMi');
                                  });
                                });
                                Navigator.pop(context);
                              },
                              child: StreamBuilder<DocumentSnapshot>(//////////////////////////
                                stream: babaRef.snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot asyncSnapshot) {
                                  return Row(
                                    children: const [
                                      Icon(Icons.store),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Satıcı olmak için basınız',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    primary: Colors.white,
                                    onPrimary: Colors.deepOrange,
                                  ),
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
                                        checksaticioralici =
                                            element.get('saticiMi');
                                        print(checksaticioralici);
                                      });
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: StreamBuilder<DocumentSnapshot>(///////////////////////////7
                                    stream: babaRef.snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot asyncSnapshot) {
                                      return Row(
                                        children: const [
                                          Icon(Icons.face),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              'Alıcı olmak için basınız',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ));
          });
    }
  }
}
