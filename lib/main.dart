import 'dart:async';

import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:natore_project/UserEntrance.dart';
import 'package:natore_project/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

Future main() async {
  // Modify from here
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
  // to here.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Welcome to Flutter',
        home: googleLoginPage2(), // TODO: googleLoginPage()
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Center(child: Text('Login')),
            const Text('Hello World'),
            Row(
              children: [
                const SizedBox(
                  width: 150,
                  height: 30,
                ),
                Center(
                  child: FlatButton(
                    color: Colors.blue,
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.google, color: Colors.red),
                        Text("Login")
                      ],
                    ),
                    //const Text("Login"),
                    //icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//TODO: DUZENLEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
class MainPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Center(child: Text('Login')),
            const Text('Hello World'),
            Row(
              children: [
                const SizedBox(
                  width: 150,
                  height: 30,
                ),
                Center(
                  child: FlatButton(
                    color: Colors.blue,
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.google, color: Colors.red),
                        Text("  Login"),
                      ],
                    ),
                    //const Text("Login"),
                    //icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
