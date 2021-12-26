import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:natore_project/main.dart';
import 'package:natore_project/model/order.dart';
import 'package:natore_project/page/home_page.dart';
import 'package:natore_project/page/product_detail.dart';
import 'package:natore_project/provider/google_sign_in.dart';
import 'package:natore_project/services/order_services.dart';
import 'package:natore_project/services/product_services.dart';
import 'package:provider/provider.dart';

import 'Product/product_add.dart';
import 'Product/product_list.dart';

class Bedir_Api_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Welcome to Flutter',
        home: googleLoginPage(),
      ),
    );
  }
}

User? user = null;

class googleLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            print("logged in");
            return LoggedInWidget(); // giris yapılmış
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          } else
            return MainPage();
        },
      )
          //body: MainPage(),
          );
}

class LoggedInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(100, 10, 23, 1),
          title: const Text('Api Test Page'),
          centerTitle: true,
          actions: [
            TextButton(
              child: Text(
                'Logout',
              ),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
            )
          ],
        ),
        body: Container(
          alignment: Alignment.topCenter,
          color: Colors.blueGrey.shade900,
          child: Column(
            children: [
              Text(
                'Profil',
                style: TextStyle(fontSize: 21, color: Colors.white),
              ),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user!.photoURL!),
              ),
              SizedBox(height: 8),
              Text(
                'Isim: ' + user!.displayName!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Email: ' + user!.email!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
              Text(
                'Api Test Buttons',
                style: TextStyle(fontSize: 21, color: Colors.white),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddProductPage())); //TODO: AddProductPage()
                },
                child: const Text('Add product'),
              ),
              const SizedBox(height: 1),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductListPage()));
                },
                child: const Text('Products'),
              ),
              const SizedBox(height: 1),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  OrderServices _orderServices = OrderServices();
                  _orderServices.addOrder(Order(
                      id: "testOrder",
                      productsId: "testID",
                      sellerMail: "seller@g",
                      buyerMail: "buyerMail",
                      quantities: 123,
                      prices: 123));
                },
                child: const Text('Add Order'),
              ),
              const SizedBox(height: 1),
            ],
          ),
        ));
  }
}

void logOut(BuildContext context) {
  final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
  provider.logout();
  user = null;
}
