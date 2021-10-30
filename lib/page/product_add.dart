import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:natore_project/services/product_services.dart';
import 'package:flutter/material.dart'; // new

//Page Must be Stateles
class AddProductPage extends StatefulWidget {
  @override
  AddProductPageState createState() => AddProductPageState();
}

class AddProductPageState extends State<AddProductPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _properties = TextEditingController();

  ProductServices _productServices = ProductServices();

  final ImagePicker _imagePicker = ImagePicker();
  dynamic _pickImage;
  var image;

  Widget imagePlace(context) {
    double height = MediaQuery.of(context).size.height;
    if (image != null) {
      return CircleAvatar(
        backgroundImage: FileImage(File(image!.path)),
        radius: height * 0.08,
      );
    } else {
      if (_pickImage != null) {
        return CircleAvatar(
          // backgroundImage: NetworkImage(_pickImage),
          backgroundImage: NetworkImage(
              "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add product'),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Center(
            child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(hintText: "Product Name"),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _price,
              decoration: InputDecoration(hintText: "Price"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _properties,
              decoration: InputDecoration(hintText: "Properties"),
            ),
            SizedBox(
              height: 50.0,
            ),
            imagePlace(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () => _onImageButtonPressed(
                          ImageSource.camera,
                          context: context,
                        ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: Colors.blue,
                    )),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () => _onImageButtonPressed(ImageSource.gallery,
                        context: context),
                    child: Icon(
                      Icons.image,
                      size: 30,
                      color: Colors.blue,
                    ))
              ],
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                primary: Colors.white60,
                backgroundColor: Colors.black54,
              ),
              onPressed: () {
                print(image);
                _productServices
                    .addProduct(_name.text, double.parse(_price.text),
                        _properties.text, (image))
                    .then((value) {
                  Fluttertoast.showToast(
                    msg: "Durum eklendi!",
                    timeInSecForIosWeb: 2,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey[600],
                    textColor: Colors.white,
                    fontSize: 14,
                  );
                });
              },
              child: const Text('Add product'),
            ),
            const SizedBox(height: 30),
          ],
        )),
      ),
    );
  }

  // FIX PICKING IMAGE setState undefined
  // https://stackoverflow.com/questions/59101356/the-function-setstate-is-not-defined-flutter
  void _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    try {
      final pickedFile = _pickImage.getImage(source: source);
      setState(() {
        image = pickedFile!;
        print("dosyaya geldim: $image");
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
