// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({
    Key? key,
  }) : super(key: key);

  static String routeName = '/SearchAppBar';

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: false,
        leadingWidth: 28,
        title: TextFormField(
          controller: _search,
          cursorColor: Colors.cyan,
          autofocus: true,
          inputFormatters: [
            new LengthLimitingTextInputFormatter(42),
          ],
          textCapitalization: TextCapitalization
              .sentences, // word yapilabilir, ürünlerin isimlendirmesine bagli
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Icon(
                Icons.search,
                color: Color(0xff34A0A4),
              ),
            ),
            hintText: "Arama yapınız",
            hintStyle: TextStyle(color: Colors.black54),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 0.2, color: Colors.white),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 0.2, color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 0.2, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
