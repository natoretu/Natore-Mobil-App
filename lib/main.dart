import 'dart:async';

import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natore_project/page/bedir_services_test_page.dart';
import 'package:natore_project/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'UserEntrance.dart';

Future main() async {
  // Modify from here
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(Bedir_Api_Page());

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
        debugShowCheckedModeBanner: false,
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        //statusBarColor: Color(0xff07cc99), //Color(0xff00ADB5),
        //statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.cyan,
        systemNavigationBarContrastEnforced: true,
        //systemNavigationBarIconBrightness: Brightness.dark,
        //systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.8],
                colors: [Color(0xff06D6A0), Colors.cyan])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          /*
          appBar: AppBar(
            elevation: 0,
            backgroundColor:
                Colors.cyan, //Color(0xff07cc99), // Color(0xff06D6A0),
            centerTitle: true,
            title: Text(
              "Natore\'ye Hos Geldiniz",
              style: GoogleFonts.lemon(color: Colors.white, fontSize: 18),
            ),
          ),
           */
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                    //backgroundColor: Color(0xff06D6A0),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Natore',
                    style: GoogleFonts.lemon(color: Colors.white, fontSize: 52),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      "Bir zamanlar saglıksız beslenenlere",
                      style:
                          GoogleFonts.lemon(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        primary: Colors.white,
                        onPrimary: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 8),
                        child: Row(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            FaIcon(FontAwesomeIcons.google, color: Colors.red),
                            Text(
                              "  Giris Yap",
                              style: GoogleFonts.lemon(
                                  color: Colors.red, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
