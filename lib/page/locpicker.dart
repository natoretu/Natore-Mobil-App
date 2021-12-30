import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;
import 'package:google_fonts/google_fonts.dart';

import '../UserEntrance.dart';
String temp="";
class Selected extends StatelessWidget {
  final int check;
  final int i;
  Selected(this.check, this.i);

  @override
  Widget build(BuildContext context) {
    if (check != -1 && check == i) {
      return Icon(Icons.done);
    } else {
      return Text("");
    }
  }
}

class LocationPicker extends StatelessWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CitySelector();
  }
}

class CitySelector extends StatefulWidget {
  CitySelector();

  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  String citiesText = '';

  readFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('assets/locations/cities.txt');
    if (this.mounted) {
      setState(() {
        citiesText = responseText;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    readFileData();
  }

  int check = -1;
  @override
  Widget build(BuildContext context) {
    List<String> cities = citiesText.split('\n');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff06D6A0),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xff06D6A0),
          title: Text(
            "Bulundugunuz Sehir",
            style: GoogleFonts.lemon(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 180,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < cities.length; i++)
                          Card(
                            child: TextButton(
                              onPressed: () {
                                if (this.mounted) {
                                  setState(() {
                                    check = i;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    cities[i],
                                    style: TextStyle(color: Color(0xff264653)),
                                  ),
                                  Selected(check, i),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  width: 410,
                  child: Card(
                      child: TextButton(
                    onPressed: () {
                      if (check != -1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountiesSelector(
                                    "Türkiye", cities[check], check)));
                      }
                    },
                    child: Text(
                      "Devam et",
                      style: GoogleFonts.lemon(
                          color: Color(0xff06D6A0), fontSize: 18),
                    ),
                  ))),
            ),
          ],
        ),
      ),
    );
  }
}

class CountiesSelector extends StatefulWidget {
  int index;
  String countryName;
  String cityName;
  CountiesSelector(this.countryName, this.cityName, this.index);
  @override
  _CountiesSelectorState createState() =>
      _CountiesSelectorState(countryName, cityName, index);
}

class _CountiesSelectorState extends State<CountiesSelector> {
  int index;
  String countryName;
  String cityName;
  int check = -1;
  _CountiesSelectorState(this.countryName, this.cityName, this.index);
  String countiesText = "";
  readFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('assets/locations/counties.txt');
    if (this.mounted) {
      setState(() {
        countiesText = responseText;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    readFileData();
  }

  List<String> takeCounties() {
    List<String> list = [];
    List<String> counties = countiesText.split('\n');
    for (int i = 0; i < counties.length - 1; i++) {
      if (int.parse(counties[i].substring(counties[i].length - 3)) - 1 ==
          index) {
        list.add(counties[i].substring(0, counties[i].length - 2));
      }
    }
    return list;
  }

  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;

  TextEditingController _adress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(user.email!);
    int ind, count;
    List<String> counties = takeCounties();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff06D6A0),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff06D6A0),
          centerTitle: true,
          title: Text(
            "Bulundugunuz Ilçe",
            style: GoogleFonts.lemon(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 180,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < counties.length; i++)
                          Card(
                              child: TextButton(
                            onPressed: () {
                              if (this.mounted) {
                                setState(() {
                                  check = i;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  counties[i],
                                  style: TextStyle(color: Color(0xff264653)),
                                ),
                                Selected(check, i),
                              ],
                            ),
                          ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 410,
                child: Card(
                  child: TextButton(
                    onPressed: () async {
                      if (check != -1) {
                        if (check21 == true) {
                          updateRef //TODO
                              .doc(user.email!)
                              .update({'Adress':counties[check]+" "+cityName});
                             
                        }
                        Ugurunkoddandonenadress =
                            cityName + counties[check]; //TODO
                        int count = 0; // silmee
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                      }
                    },
                    child: Text(
                      "Tamamla",
                      style: GoogleFonts.lemon(
                          color: Color(0xff06D6A0), fontSize: 18),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
