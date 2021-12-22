import 'dart:io';

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
  TextEditingController _ownermail = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _market = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ürün Ekle',
          style: TextStyle(
              //fontFamily: "Zen Antique Soft",
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.cyan, //Color(0xff06D6A0),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(40, 29, 40, 40),
          child: Center(
            child: Column(
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        'Ürün kategorisini seçiniz : ',
                        style: TextStyle(fontSize: 17, color: Colors.black54),
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
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: Colors.cyan,
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
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _name,
                  cursorColor: Colors.cyan,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(42),
                  ],
                  decoration: InputDecoration(
                    labelText: "Ürün ismi",
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.cyan),
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _price,
                  cursorColor: Colors.cyan,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    labelText: "Ürün fiyatı",
                    labelStyle: TextStyle(color: Colors.black54),
                    prefixText: '\₺',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.cyan),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _quantity,
                  cursorColor: Colors.cyan,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(9),
                  ],
                  decoration: InputDecoration(
                    labelText: "Ürün adeti",
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.cyan),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _ownermail,
                  cursorColor: Colors.cyan,
                  decoration: InputDecoration(
                    labelText: "E-mail adresi",
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.cyan),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _market,
                  cursorColor: Colors.cyan,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(42),
                  ],
                  decoration: InputDecoration(
                    labelText: "Market adı",
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.cyan),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _properties,
                  cursorColor: Colors.cyan,
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
                      borderSide: BorderSide(width: 2, color: Colors.cyan),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.cyan, width: 2)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
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
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: InkWell(
                                      onTap: () => _onImageButtonPressed(
                                        ImageSource.camera,
                                        context: context,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                        color: Colors.black54,
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
                                      color: Colors.black54,
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
                                  backgroundColor: Colors.cyan,
                                ),
                                onPressed: () {
                                  _productServices
                                      .addProduct(
                                    _name.text,
                                    double.parse(_price.text),
                                    _properties.text,
                                    image,
                                    _ownermail.text,
                                    _category.text,
                                    _market.text,
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
                                },
                                child: const Text('Ürünü Ekle'),
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
      ),
    );
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
