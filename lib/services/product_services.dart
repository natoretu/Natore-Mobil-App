import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:natore_project/model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natore_project/page/product_add.dart';
import 'package:natore_project/services/storage_services.dart';

class ProductServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageServices _storageServices = StorageServices();
  String mediaUrl = "";

  Future<Product> addProduct(
      String name, double price, String properties, XFile pickedFile) async {
    var ref = _firestore.collection('Products');
    mediaUrl = await _storageServices.uploadMedia(File(pickedFile.path));
    print(mediaUrl);
    var documentRef = await ref.add({
      'name': name,
      'price': price,
      'properties': properties,
      'image': mediaUrl,
    });

    return Product(
      id: documentRef.id,
      name: name,
      price: price,
      properties: properties,
      image: mediaUrl,
    );
  }
}
