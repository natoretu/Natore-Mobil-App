import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natore_project/model/product.dart';
import 'package:natore_project/services/product_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  test('product services api test', () async {
    ProductServices _productServices = ProductServices();
    final Product product = _productServices.getProduct('aaaaaas');
    expect(product.name, "aaaaaas");

/*     //POST
    var image;
    final ImagePicker _imagePicker = ImagePicker();
    final imageFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState() {
      image = File(imageFile!.path);
      if (image != null) {}
    }

    _productServices.addProduct("test name", 10.0, "Test Properties", image);

    //GET
    final Product product = _productServices.getProduct('some Name');
    expect(product.name, "test name");

    //DELETE
    var ref = _productServices.removeProdut("test name");
    print(ref);

    //GET
    final Stream<QuerySnapshot> allProducts = _productServices.getProducts();
    allProducts.first.then((value) => (value.docs.forEach((element) {
          print(element.id);
        })));
 */
  });
}
