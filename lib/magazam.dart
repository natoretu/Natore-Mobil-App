import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natore_project/page/Product/product_add.dart';
import 'package:natore_project/services/product_services.dart';

class Magazam extends StatefulWidget {
  const Magazam({Key? key}) : super(key: key);
  static String routeName = '/MyProducts';
  @override
  _MagazamState createState() => _MagazamState();
}

class _MagazamState extends State<Magazam> {
  final ImagePicker _imagePicker = ImagePicker();
  dynamic _pickImage;
  var image;

  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
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

  Widget imagePlace(context) {
    double height = MediaQuery.of(context).size.height;
    if (image != null) {
      return Container(
        height: height * 0.2,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        )),
      );
    } else {
      if (_pickImage != null) {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(
                "https://helpx.adobe.com/content/dam/help/en/stock/how-to/visual-reverse-image-search/jcr_content/main-pars/image/visual-reverse-image-search-v2_intro.jpg"),
          )),
        );
      } else {
        //AssetImage("assets/images/milk.png"),
        return Container(
          height: height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/empty.jpg"),
            fit: BoxFit.cover,
          )),
        );
      }
    }
  }

  ProductServices _productServices = ProductServices();
  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(user.email!);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              "Mağazam",
              style: TextStyle(
                  fontFamily: 'Zen Antique Soft',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                  fontSize: 22),
            ),
            centerTitle: true,
            backgroundColor: Color(0xff2A9D8F),
            elevation: 2,
            bottom: TabBar(
              tabs: [
                Tab(text: "Ürün Ekle"),
                Tab(text: "Ürünlerim"),
                Tab(text: "Tanıtımlarım")
              ],
              indicatorColor: Colors.white,
            ),
          ),
          body: TabBarView(
            children: [
              AddProductPage(),
              Center(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      StreamBuilder(
                          stream:
                              _productServices.getProductsOfSellerStreamMail(
                                  FirebaseAuth.instance.currentUser!.email
                                      .toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot asyncSnapshot) {
                            if (asyncSnapshot.hasError) {
                              return const Center(
                                child: Text("Bir hata olustu"),
                              );
                            } else {
                              if (asyncSnapshot.hasData) {
                                List<DocumentSnapshot> list =
                                    asyncSnapshot.data.docs;

                                return Flexible(
                                  child: ListView.builder(
                                    //itemCount: list.length,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              tileColor: Colors.white,
                                              leading: CircleAvatar(
                                                radius: 24,
                                                backgroundImage: NetworkImage(
                                                    list[index].get('image')),
                                              ),
                                              title: Text(
                                                list[index].get('name'),
                                              ),
                                              subtitle: Text(
                                                "Adet: " +
                                                    list[index]
                                                        .get('quantity')
                                                        .toString(),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.add,
                                                        color:
                                                            Color(0xff2A9D8F)),
                                                    onPressed: () {
                                                      _productServices
                                                          .increaseQuantity(
                                                              list[index]
                                                                  .get('id'));
                                                      print(list[index]
                                                          .get('quantity')
                                                          .toString());
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.remove,
                                                        color:
                                                            Color(0xff2A9D8F)),
                                                    onPressed: () {
                                                      _productServices
                                                          .decraseQuantity(
                                                              list[index]
                                                                  .get('id'));
                                                      print(list[index]
                                                          .get('quantity')
                                                          .toString());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                          })
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: Column(
                    children: [
                      imagePlace(context),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: InkWell(
                                    onTap: () => _onImageButtonPressed(
                                      ImageSource.camera,
                                      context: context,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                      color: Color(0xff264653),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await chooseImage(ImageSource.gallery);
                                    String a = await uploadMedia(imagefile);
                                    await updateRef
                                        .doc(user.email!)
                                        .update({'SaticiTanitimImage': a});
                                  },
                                  child: const Icon(
                                    Icons.image,
                                    size: 28,
                                    color: Color(0xff264653),
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 20),
                                    primary: Colors.white,
                                    backgroundColor: Color(0xff2A9D8F),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Tanıtım Ekle',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
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
