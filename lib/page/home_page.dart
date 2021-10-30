import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:natore_project/page/sohbet.dart';
import 'package:natore_project/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'product_add.dart';
import '../main.dart';

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
                logOut(context);
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
