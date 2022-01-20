import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // new
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natore_project/services/product_services.dart';

//Page Must be Stateles
class AddProductPage extends StatefulWidget {
  @override
  AddProductPageState createState() => AddProductPageState();
}

class AddProductPageState extends State<AddProductPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _properties = TextEditingController();
  // TextEditingController _ownermail = TextEditingController();
  TextEditingController _category = TextEditingController();
  // TextEditingController _market = TextEditingController();

  ProductServices _productServices = ProductServices();

  final ImagePicker _imagePicker = ImagePicker();
  dynamic _pickImage;
  var image;

  Widget imagePlace(context) {
    double height = MediaQuery.of(context).size.height;
    if (image != null) {
      return CircleAvatar(
        backgroundImage: FileImage(image),
        radius: height * 0.08,
      );
    } else {
      if (_pickImage != null) {
        return CircleAvatar(
          // backgroundImage: NetworkImage(_pickImage),
          // ignore: avoid_print
          backgroundImage: NetworkImage(
              "https://helpx.adobe.com/content/dam/help/en/stock/how-to/visual-reverse-image-search/jcr_content/main-pars/image/visual-reverse-image-search-v2_intro.jpg"),
          radius: height * 0.08,
        );
      } else {
        return CircleAvatar(
          backgroundImage: AssetImage("assets/images/milk.png"),
          radius: height * 0.08,
        );
      }
    }
  }

  String dropdownValue = 'Süt';

  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
        future: updateRef.doc(user.email!).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return Text('Something went wrong.');
          if (snapshot.connectionState == ConnectionState.waiting)
            return Text('');

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String _ownermail = data['Email'];
          String _market = data['MarketName'];

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text(
                            'Ürün kategorisi:',
                            style:
                                TextStyle(fontSize: 17, color: Colors.black54),
                          ),
                        ),
                        DropdownButton<String>(
                          alignment: Alignment.center,
                          value: dropdownValue,
                          icon: const Icon(
                            Icons.arrow_downward,
                            size: 18,
                          ),
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Color(0xff2A9D8F),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>[
                            'Süt',
                            'Yumurta',
                            'Yağ',
                            'Yoğurt',
                            'Peynir'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _name,
                      cursorColor: Color(0xff2A9D8F),
                      expands: false,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(20),
                      ],
                      decoration: InputDecoration(
                        labelText: "Ürün ismi",
                        labelStyle: TextStyle(color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xff2A9D8F)),
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _price,
                      cursorColor: Color(0xff2A9D8F),
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                        labelText: "Ürün fiyatı",
                        labelStyle: TextStyle(color: Colors.black54),
                        prefixText: '\₺',
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xff2A9D8F)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _quantity,
                      cursorColor: Color(0xff2A9D8F),
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(9),
                      ],
                      decoration: InputDecoration(
                        labelText: "Ürün adeti",
                        labelStyle: TextStyle(color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xff2A9D8F)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // TextFormField(
                    //   controller: _ownermail,
                    //   cursorColor: Color(0xff2A9D8F),
                    //   decoration: InputDecoration(
                    //     labelText: "E-mail adresi",
                    //     labelStyle: TextStyle(color: Colors.black54),
                    //     focusedBorder: UnderlineInputBorder(
                    //       borderSide:
                    //           BorderSide(width: 2, color: Color(0xff2A9D8F)),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    // TextFormField(
                    //   controller: _market,
                    //   cursorColor: Color(0xff2A9D8F),
                    //   inputFormatters: [
                    //     new LengthLimitingTextInputFormatter(42),
                    //   ],
                    //   decoration: InputDecoration(
                    //     labelText: "Market adı",
                    //     labelStyle: TextStyle(color: Colors.black54),
                    //     focusedBorder: UnderlineInputBorder(
                    //       borderSide:
                    //           BorderSide(width: 2, color: Color(0xff2A9D8F)),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    TextFormField(
                      controller: _properties,
                      cursorColor: Color(0xff2A9D8F),
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(42),
                      ],
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Ürün detayları",
                        labelStyle: TextStyle(color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xff2A9D8F)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            imagePlace(context),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: InkWell(
                                          onTap: () => _onImageButtonPressed(
                                            ImageSource.camera,
                                            context: context,
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 30,
                                            color: Color(0xff264653),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => _onImageButtonPressed(
                                            ImageSource.gallery,
                                            context: context),
                                        child: Icon(
                                          Icons.image,
                                          size: 28,
                                          color: Color(0xff264653),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 20),
                                      primary: Colors.white,
                                      backgroundColor: Color(0xff2A9D8F),
                                    ),
                                    onPressed: () {
                                      print(dropdownValue);
                                      setState(() {
                                        final snackBar = SnackBar(
                                            duration: Duration(seconds: 1),
                                            backgroundColor:
                                                Colors.teal.withOpacity(0.95),
                                            content: Text(
                                              'Ürün eklendi!',
                                              style: TextStyle(fontSize: 16),
                                            ));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        print(dropdownValue);
                                        _productServices
                                            .addProduct(
                                          _name.text,
                                          double.parse(_price.text),
                                          _properties.text,
                                          image,
                                          _ownermail,
                                          dropdownValue,
                                          _market,
                                          int.parse(_quantity.text),
                                        )
                                            .then((value) {
                                          Fluttertoast.showToast(
                                            msg: "Product eklendi!",
                                            timeInSecForIosWeb: 2,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.grey[600],
                                            textColor: Colors.white,
                                            fontSize: 14,
                                          );
                                        });
                                      });
                                    },
                                    child: const Text(
                                      'Ürünü Ekle',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: source, imageQuality: 50);
      setState(() {
        image = File(pickedFile!.path);
        print("dosyaya geldim: ${image}");
        if (image != null) {}
      });
    } catch (e) {
      setState(() {
        _pickImage = e;
        print("Image Error: ${_pickImage}");
      });
    }
  }
}
