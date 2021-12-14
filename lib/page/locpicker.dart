import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    responseText = await rootBundle.loadString('locations/cities.txt');
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
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Bulundugunuz Şehri Seçin"),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
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
                          children: [
                            Text(cities[i]),
                            Selected(check, i),
                          ],
                        ),
                      ))
                  ],
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
                        child: Text("Devam edin")))),
          )
        ],
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
    responseText = await rootBundle.loadString('locations/counties.txt');
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
        list.add(counties[i]);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    int ind, count;
    List<String> counties = takeCounties();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text("Bulundugunuz İlçeyi Seçin"),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
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
                              Text(counties[i]),
                              Selected(check, i),
                            ],
                          ),
                        ))
                    ],
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
                            if (check != -1) {}
                          },
                          child: Text("Devam edin")))),
            )
          ],
        ),
      ),
    );
  }
}
