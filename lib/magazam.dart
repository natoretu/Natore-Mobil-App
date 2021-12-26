import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natore_project/page/Product/product_add.dart';
import 'package:natore_project/services/product_services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Mağazam"),
            centerTitle: true,
            bottom: TabBar(tabs: [
              Tab(text: "Ürün Ekle"),
              Tab(text: "Ürünlerim"),
              Tab(text: "Kampanyalarım")
            ]),
          ),
          body: TabBarView(
            children: [
              AddProductPage(),
              Center(
                child: Container(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      StreamBuilder(
                          stream: _productServices
                              .getProductsOfSellerStreamMarket("Sütçü Dede"),
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
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Card(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage:
                                                        NetworkImage(list[index]
                                                            .get('image')),
                                                  ),
                                                  Text(list[index].get('name')),
                                                  Text("Adet: " +
                                                      list[index]
                                                          .get('quantity')
                                                          .toString()),
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () {},
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.remove),
                                                    onPressed: () {},
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
                    border: Border.all(color: Colors.cyan, width: 2)),
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
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: InkWell(
                                    onTap: () => _onImageButtonPressed(
                                      ImageSource.camera,
                                      context: context,
                                    ),
                                    child: const Icon(
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
                                  child: const Icon(
                                    Icons.image,
                                    size: 28,
                                    color: Colors.black54,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 20),
                                    primary: Colors.white,
                                    backgroundColor: Colors.cyan,
                                  ),
                                  onPressed: () {},
                                  child: const Text('Kampanya Ekle'),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Text("Aktif Kampanyalarım: "),
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
