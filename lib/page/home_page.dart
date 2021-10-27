import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natore_project/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class googleLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
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
    final user = FirebaseAuth.instance.currentUser!;
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
                backgroundImage: NetworkImage(user.photoURL!),
              ),
              SizedBox(height: 8),
              Text(
                'Isim: ' + user.displayName!,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Email: ' + user.email!,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ));
  }
}
