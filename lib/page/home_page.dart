import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:natore_project/page/sohbet.dart';
import 'package:natore_project/provider/google_sign_in.dart';
import 'package:natore_project/services/product_services.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'Product/product_add.dart';
import 'Product/product_list.dart';

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
          title: const Text('Hosgeldin'),
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
          alignment: Alignment.center,
          color: Colors.blueGrey.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Profil',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 32),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user!.photoURL!),
              ),
              SizedBox(height: 8),
              Text(
                'Isim: ' + user!.displayName!,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Email: ' + user!.email!,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              FlatButton(
                color: Colors.blue,
                child: Row(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.mailBulk, color: Colors.red),
                    Text("  Sohbet")
                  ],
                ),
                //const Text("Login"),
                //icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sohbet()),
                  );
                },
              ),
              /* FlatButton(
                color: Colors.blue,
                child: Row(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.mailBulk, color: Colors.red),
                    Text("  Urune yorum ekle")
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetail()),
                  );
                },
              ),*/
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddProductPage())); //TODO: ProductDetail()
                },
                child: const Text('Product Detail'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddProductPage()));
                },
                child: const Text('Add product'),
              ),
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
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MainPage())); //TODO!!!!!!!!!
                },
                child: const Text('Ana sayfa'),
              ),
              const SizedBox(height: 30),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  print("========entered");
                  ProductServices _productServives = ProductServices();
                  List plist =
                      await _productServives.getProductsOfSeller("tavsan@");
                  plist.forEach((value) {
                    print("--");
                    print(value);
                  });
                  print("========existed");
                },
                child: const Text('test api'),
              ),
              const SizedBox(height: 30),
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
