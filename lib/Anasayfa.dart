// ignore_for_file: file_names

import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natore_project/Search_Bar.dart';
import 'package:natore_project/UserEntrance.dart';
import 'package:natore_project/magazam.dart';
import 'package:natore_project/page/Order/my_orders.dart';
import 'package:natore_project/page/show_in_category.dart';
import 'package:natore_project/page/sohbet.dart';
import 'package:natore_project/products_of_seller_page.dart';
import 'package:natore_project/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

/// Zen fontu 6 mb !

/**
 * TODO: Sütçü dede ikonu ile yazısını degistir. StoreIconList ve StoreNameList.
 * TODO: Add const keyword
 * TODO: UNIT TEST -> 2 tane ternary , 1 tane if else
 * TODO: Color Blindness mod - coloor'da palette kısmında var
 * TODO: Google fonts sayfasindaki gibi üstüne gelince elevation artsin.
 **/
String name = "boş",
    surname = "boş",
    email = "boş",
    TelNo = "boş",
    adress = "booş",
    imagePath = "boş";
final Map<String, Color> SsColorList = {
  "CHARCOAL": Color(0xff264653),
  "PERSIAN_GREEN": Color(0xff2A9D8F),
  "ORANGE_YELLOW_CRAYOLA": Color(0xffE9C46A),
  "SANDY_BROWN": Color(0xffF4A261),
  "BURNT_SIENNA": Color(0xffE76F51),
};

int saticilength = 0;
List saticilar = List.of([]);
List saticilar1 = List.of([]);
List saticilar2 = List.of([]);
var a12;
int index = 0;

class MyApp1 extends StatelessWidget {
  @override
  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  Widget build(BuildContext context) {
    print("dsadasdasdasdsadsadasdasdasdassdasdsa");

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff07cc99), //Color(0xff00ADB5),
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: CupertinoColors.systemGrey6,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarIconBrightness: Brightness.dark,
        //systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Natore',
      /*
      theme: ThemeData(
          primarySwatch: Colors.white,
      ),
      */
      debugShowCheckedModeBanner: false,
      initialRoute: MyHomePage.routeName,
      routes: {
        MyHomePage.routeName: (context) => MyHomePage(),
        UserProfile.routeName: (context) => UserProfile(),
        AboutheApp.routeName: (context) => AboutheApp(),
        MyAdress.routeName: (context) => MyAdress(),
        SellerNotifications.routeName: (context) => SellerNotifications(),
        BuyerNotifications.routeName: (context) => BuyerNotifications(),
        //Location.routeName: (context) => Location(),
      },
      // home: MyHomePage(),  initialRoute var, kullanma!
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> tabs = [
    MainPage(),
    Sohbet(), //chat gelecek
    MyOrders("Sütçü Dede"), //MyStatefulWidget(),
    UserProfile(),
    checksaticioralici == true ? Magazam() : SizedBox.shrink() // TODO:ugur
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("dsadasdasdasdsadsadasdasdasdassdasdsa546565465");
    final user = FirebaseAuth.instance.currentUser!;
    final _firestore = FirebaseFirestore.instance;

    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(user.email!);
    FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: user.email!)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        checksaticioralici = element.get('saticiMi');
      });
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: checksaticioralici == true
          ? BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_sharp),
                  label: 'Ev',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Mesajlar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket),
                  label: 'Sepetim',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_sharp),
                  label: 'Profilim',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.store),
                  label: 'Mağazam',
                ),
              ],
              backgroundColor: Colors.white,
              iconSize: 22,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.blueGrey.withOpacity(0.7),
              selectedItemColor: Color(0xff34A0A4), //Color(0xff00ADB5),
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              unselectedFontSize: 14,
              selectedFontSize: 14,
              //showUnselectedLabels: false,
              //showSelectedLabels: false,
            )
          : BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_sharp),
                  label: 'Ev',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Mesajlar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket),
                  label: 'Sepetim',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_sharp),
                  label: 'Profilim',
                ),
              ],
              backgroundColor: Colors.white,
              iconSize: 22,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.blueGrey.withOpacity(0.7),
              selectedItemColor: Color(0xff34A0A4), //Color(0xff00ADB5),
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              unselectedFontSize: 14,
              selectedFontSize: 14,
              //showUnselectedLabels: false,
              //showSelectedLabels: false,
            ),
      body: SafeArea(
        child: tabs[_selectedIndex],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool selected = false;
  int _seller_num = 14;
  int _campaign_num = 4;

  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;

  final borderWidth = 2.0;
  final kInnerDecoration = BoxDecoration(
    color: Colors.white70,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(7),
  );

  BoxDecoration GradientBoxDecoration(String part, double stop_num) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          (part == "Tanıtımlar")
              ? (Color(0xffef233c))
              : (part == "Kategoriler")
                  ? (Color(0xff118AB2))
                  : (part == "Satıcılar")
                      ? (Color(0xff2A9D8F))
                      : Colors.white, // dummy
          Colors.white,
          // Color(0xffB5179E),
        ],
        stops: [
          0.05,
          stop_num, //0.06 or 0.08,
        ],
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(user.email!);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
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
          backgroundColor: Color(0xff07cc99), // Color(0xff06D6A0),
          centerTitle: true,
          elevation: 1,
          floating: true,
          //pinned: false,
          snap: true,
          /***-------------***/
          /*** USER AVATAR ***/
          toolbarHeight: 48,
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  SellerNotifications.routeName,
                );
              },
            ),
          ),
          /***------------------***/
          /*** APP NAME Or LOGO ***/
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Natore',
                style: GoogleFonts.lemon(
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            /*background: FlutterLogo(),
            background: Image.asset(
            'res/images/material_design_3.png',
            fit: BoxFit.fill,
          ),*/
          ),
        ),
        /***-----***/
        /*** GPS ***/
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyAdress()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    side: BorderSide(width: 0.7, color: Colors.grey),
                    primary: Colors.white,
                    elevation: 1,
                    onPrimary: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Icon(
                          Icons.location_on_sharp,
                          color: Colors.cyan,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Teslimat Adresi',
                              style: GoogleFonts.lato(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                            StreamBuilder<Object>(
                                stream: null,
                                builder: (context, snapshot) {
                                  return StreamBuilder<DocumentSnapshot>(
                                    
                                    stream: babaRef.snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot asyncSnapshot) {
                                          String a =asyncSnapshot.data.data()['Adress'];
                                          String b =  a.split(" ").first;
                                      return Text(
                                        b,
                                        style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      );
                                    },
                                  );
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Colors.cyan,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        /*** MAIN MENU ITEMS ***/
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBar(),
                  /*** Kampanyalar - TEXT ***/
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 0, 2),
                    child: Container(
                      decoration: GradientBoxDecoration("Tanıtımlar", 0.06),
                      child: Padding(
                        padding: EdgeInsets.all(borderWidth),
                        child: DecoratedBox(
                          decoration: kInnerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 4, 2),
                            child: Text(
                              'Tanıtımlar (${_campaign_num})',
                              style: TextStyle(
                                fontFamily: 'Zen Antique Soft',
                                color: Colors.black,
                                fontSize: 17,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CampaignSwiper(campaign_num: _campaign_num),
                  /*** Kategoriler - TEXT ***/
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                    child: Container(
                      decoration: GradientBoxDecoration("Kategoriler", 0.08),
                      child: Padding(
                        padding: EdgeInsets.all(borderWidth),
                        child: DecoratedBox(
                          decoration: kInnerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 4, 2),
                            child: Text(
                              'Kategoriler',
                              style: TextStyle(
                                fontFamily: 'Zen Antique Soft',
                                color: Colors.black,
                                fontSize: 17,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ProductCategories(),
                  /*** Satıcılar - TEXT ***/
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 0, 4),
                    child: Container(
                      decoration: GradientBoxDecoration("Satıcılar", 0.08),
                      child: Padding(
                        padding: EdgeInsets.all(borderWidth),
                        child: DecoratedBox(
                          decoration: kInnerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 4, 2),
                            child: Text(
                              'Satıcılar (${_seller_num})',
                              style: TextStyle(
                                fontFamily: 'Zen Antique Soft',
                                color: Colors.black,
                                fontSize: 17,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (checksaticioralici == false)
                    Store(seller_num: _seller_num),
                ],
              );
            },
            childCount: 1, /*** !!!!! ***/
          ),
        ),
      ],
    );
  }
}

class BuyerNotifications extends StatefulWidget {
  const BuyerNotifications({
    Key? key,
  }) : super(key: key);

  static String routeName = '/BuyerNotifications';

  @override
  State<BuyerNotifications> createState() => _BuyerNotificationsState();
}

class _BuyerNotificationsState extends State<BuyerNotifications> {
  final List<String> ProductNameList = [
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
  ];

  final List<String> ProductSellerList = [
    "~Sütçü Dede",
    "~Sütçü Dede",
    "~Sütçü Dede",
    "~Sütçü Dede",
    "~Sütçü Dede",
    "~Sütçü Dede",
  ];

  final List<String> Date = [
    "1 hafta",
    "3 hafta",
    "1 ay",
    "1 ay",
    "2 ay",
    "3 ay",
  ];

  final List<Widget> Avatar_list = [
    CircleAvatar(
      backgroundColor: Colors.redAccent,
      radius: 35,
      child: Text(
        "+200",
        style: GoogleFonts.lemon(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    CircleAvatar(
      backgroundColor: Colors.orangeAccent,
      radius: 35,
      child: Text(
        "+25",
        style: GoogleFonts.lemon(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    CircleAvatar(
      backgroundColor: Colors.cyan,
      radius: 35,
      child: Image(image: AssetImage("assets/homepageImages/real_milk.png")),
    ),
    CircleAvatar(
      backgroundColor: Colors.orangeAccent,
      radius: 35,
      child: Text(
        "+25",
        style: GoogleFonts.lemon(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    CircleAvatar(
      backgroundColor: Colors.teal,
      radius: 35,
      child: Text(
        "+100",
        style: GoogleFonts.lemon(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    CircleAvatar(
      backgroundColor: Colors.lightGreen,
      radius: 35,
      child: Text(
        "+10",
        style: GoogleFonts.lemon(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0xff06D6A0),
              centerTitle: true,
              elevation: 2,
              floating: true,
              //pinned: false,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                //centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Bildirimler",
                    style: TextStyle(
                        fontFamily: 'Zen Antique Soft',
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 22),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    //onTap: () {},
                                    hoverColor: Colors.greenAccent[700],
                                    tileColor: Colors.white30,
                                    //minLeadingWidth: 30,
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image(
                                          image: AssetImage(
                                              "assets/homepageImages/real_milk.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Siparisiniz onaylandı! ",
                                            maxLines: 1,
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.bold,
                                              //decorationThickness: 3,
                                              color: Colors.white,
                                              /* backgroundColor:
                                                  Colors.deepOrangeAccent,*/
                                              fontSize: 17,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      right:
                                                          Radius.circular(18),
                                                      left: Radius.circular(4)),
                                              color: Colors.deepOrangeAccent),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 6, 0, 3),
                                          child: Text(
                                            ProductNameList[index],
                                            style: GoogleFonts.lato(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 6),
                                          child: Text(
                                            ProductSellerList[index],
                                            style: GoogleFonts.lato(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Bu ürüne puan verin:",
                                          style: GoogleFonts.lato(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          SmoothStarRating(
                                              onRated: (value) {},
                                              allowHalfRating: false,
                                              isReadOnly: false,
                                              starCount: 5,
                                              rating: 0.0,
                                              spacing: 0.0,
                                              size: 32.0,
                                              defaultIconData:
                                                  Icons.star_border,
                                              filledIconData: Icons.star,
                                              //filledIconData: Icons.blur_off,
                                              //halfFilledIconData: Icons.blur_on,
                                              color: Colors.teal,
                                              borderColor: Colors.teal),
                                        ],
                                      ),
                                    ),
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        Date[index],
                                        style: GoogleFonts.lato(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black12,
                                    thickness: 0.85,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1, /*** !!!!! ***/
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerNotifications extends StatefulWidget {
  const SellerNotifications({
    Key? key,
  }) : super(key: key);

  static String routeName = '/SellerNotifications';

  @override
  State<SellerNotifications> createState() => _SellerNotificationsState();
}

class _SellerNotificationsState extends State<SellerNotifications> {
  final List<String> ProductnameList = [
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
    "Doğal Keçi Sütü",
  ];

  final List<String> ProductBuyerList = [
    "~Manzum Nesir",
    "~Manzum Nesir",
    "~Manzum Nesir",
    "~Manzum Nesir",
    "~Manzum Nesir",
    "~Manzum Nesir",
  ];

  final List<String> Date = [
    "1 hafta",
    "3 hafta",
    "1 ay",
    "1 ay",
    "2 ay",
    "3 ay",
  ];

  bool tapped_icon = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0xff06D6A0),
              centerTitle: true,
              elevation: 2,
              floating: true,
              //pinned: false,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                //centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Bildirimler",
                    style: TextStyle(
                        fontFamily: 'Zen Antique Soft',
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 22),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: Date.length, //TODO!!!!!!!!!
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Dismissible(
                                    key: UniqueKey(),
                                    /*
                                    onDismissed: (direction) {
                                      setState(() {
                                        Date.removeAt(index);
                                        ProductnameList.removeAt(index);
                                        ProductBuyerList.removeAt(index);
                                      });
                                    },*/
                                    background: Container(
                                      color: Colors.redAccent,
                                      child: Align(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Sil",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                      color: Colors.redAccent,
                                      child: Align(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Sil",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          //onTap: () {},
                                          hoverColor: Colors.greenAccent[700],
                                          tileColor: Colors.white30,
                                          //minLeadingWidth: 30,
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/homepageImages/real_milk.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  "Siparis onayınız bekleniyor! ",
                                                  style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.bold,
                                                    //decorationThickness: 3,
                                                    color: Colors.white,
                                                    /* backgroundColor:
                                                        Colors.deepOrangeAccent,*/
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.horizontal(
                                                            right:
                                                                Radius.circular(
                                                                    18),
                                                            left:
                                                                Radius.circular(
                                                                    4)),
                                                    color: Colors
                                                        .deepOrangeAccent),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 6, 0, 3),
                                                child: Text(
                                                  ProductnameList[index],
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 4),
                                                child: Text(
                                                  ProductBuyerList[index],
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      tapped_icon
                                                          ? IconButton(
                                                              icon: Icon(Icons
                                                                  .hide_source),
                                                              onPressed: () {},
                                                            )
                                                          : IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color:
                                                                    Colors.teal,
                                                                size: 28,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  tapped_icon =
                                                                      true;
                                                                });
                                                                final snackBar =
                                                                    SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1500),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .teal,
                                                                  content:
                                                                      const Text(
                                                                    'Sipariş onaylandı :)',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);
                                                              },
                                                            ),
                                                      Text(
                                                        "Onayla",
                                                        style: GoogleFonts.lato(
                                                          color: Colors.black
                                                              .withOpacity(1),
                                                          fontSize: 15,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      tapped_icon
                                                          ? IconButton(
                                                              icon: Icon(Icons
                                                                  .hide_source),
                                                              onPressed: () {},
                                                            )
                                                          : IconButton(
                                                              icon: const Icon(
                                                                Icons.cancel,
                                                                color: Colors
                                                                    .redAccent,
                                                                size: 28,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  tapped_icon =
                                                                      true;
                                                                });
                                                                final snackBar =
                                                                    SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          1500),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent,
                                                                  content:
                                                                      const Text(
                                                                    "Sipariş onaylanmadı :(",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);
                                                              },
                                                            ),
                                                      Text(
                                                        "Reddet",
                                                        style: GoogleFonts.lato(
                                                          color: Colors.black
                                                              .withOpacity(1),
                                                          fontSize: 15,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          trailing: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              Date[index],
                                              style: GoogleFonts.lato(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black12,
                                          thickness: 0.85,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1, /*** !!!!! ***/
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({
    Key? key,
  }) : super(key: key);

  static String routeName = '/UserProfile';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final String rateApp_link =
      "https://play.google.com/store/apps/details?id=com.TornavidaGameStudio.TimberFactory&hl=tr&gl=US";

  openEmail(
      {String toEmail = "hsnvn71@gmail.com",
      String subject = "Bug Found"}) async {
    final url =
        'mailto:$toEmail?Subject=${Uri.encodeFull(subject)}'; //devam : &body=${Uri.encodeFull(body)}
    await _launchURLApp(url);
  }

  _launchURLApp(String url) async {
    //const String url = 'https://flutterdevs.com/';
    //TODO: await launch(url);
  }

  final List<IconData> IconList = [
    Icons.location_on_sharp,
    Icons.shopping_bag_outlined,
    Icons.star_border_outlined,
    Icons.info_outlined,
    Icons.share_sharp,
  ];

  // Color(0xff52B69A),
  // Color(0xff168AAD),

  final List<String> TextList = [
    "Adresim",
    "Uygulamayı Değerlendirin",
    "Uygulama Hakkında",
    "Uygulamayı Paylaş",
  ];

  final List<EdgeInsetsGeometry> PaddingList = [
    EdgeInsets.fromLTRB(8, 8, 8, 4),
    EdgeInsets.fromLTRB(8, 8, 8, 4),
    EdgeInsets.fromLTRB(8, 8, 8, 4),
    EdgeInsets.fromLTRB(8, 8, 8, 8),
  ];

  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(user.email!);
    FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: user.email!)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        checksaticioralici = element.get('saticiMi');
      });
    });
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /***----------***/
            /*** Profilim ***/
            SliverAppBar(
              backgroundColor: Color(0xff06D6A0),
              centerTitle: true,
              elevation: 1,
              floating: true,
              //pinned: false,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Profilim",
                    style: TextStyle(
                        fontFamily: 'Zen Antique Soft',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 22),
                  ),
                ),
              ),
            ),
            /***----------***/
            /*** Bilgiler ***/
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              tileColor: Colors.white,
                              leading: StreamBuilder<DocumentSnapshot>(
                                stream: babaRef.snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot asyncSnapshot) {
                                  return CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                   
                                    backgroundImage: NetworkImage(
                                        '${asyncSnapshot.data.data()['Image']}'),
                                  );
                                },
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: babaRef.snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot asyncSnapshot) {
                                    return Text(
                                      '${asyncSnapshot.data.data()['Name']} ${asyncSnapshot.data.data()['Surname']}',
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    );
                                  },
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: /*TODO*/ Text(
                                  user.email!,
                                  style: GoogleFonts.lato(
                                      color: Colors.cyan.shade600,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary:
                                        Colors.teal, // basinca olusan renk
                                    elevation: 2,
                                    //shadowColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FavoriteWidget()),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.pinkAccent,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                        /*** Siparişlerim vs. ***/
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            elevation: 2,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: PaddingList[index],
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 3,
                                    child: ListTile(
                                      onTap: () {
                                        switch (index) {
                                          case 0:
                                            Navigator.pushNamed(
                                              context,
                                              MyAdress.routeName,
                                            );
                                            break;

                                          case 1:
                                            _launchURLApp(rateApp_link);
                                            break;
                                          case 2:
                                            Navigator.pushNamed(
                                              context,
                                              AboutheApp.routeName,
                                            );
                                            break;
                                          case 3:
                                            Share.share(rateApp_link);
                                            break;
                                        }
                                      },
                                      hoverColor: Colors.greenAccent[700],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      tileColor: Colors.white,
                                      leading: Icon(
                                        IconList[index],
                                        color:
                                            Color(0xff52B69A), // cyan.shade600
                                        size: 26,
                                      ),
                                      title: Text(
                                        TextList[index],
                                        style: TextStyle(
                                          fontFamily: "Zen Antique Soft",
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        /*** Çıkış  ***/
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    primary: Colors.white,
                                    onPrimary: Colors.red.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                onPressed: () {
                                  final provider =
                                      Provider.of<GoogleSignInProvider>(context,
                                          listen: false);
                                  provider.logout();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors
                                            .pinkAccent, //Color(0xff52B69A),
                                        size: 28,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Çıkış Yap',
                                          style: TextStyle(
                                            fontFamily: "Zen Antique Soft",
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1, /*** !!!!! ***/
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAdress extends StatefulWidget {
  const MyAdress({
    Key? key,
  }) : super(key: key);

  static String routeName = '/MyAdress';

  @override
  State<MyAdress> createState() => _MyAdressState();
}

class _MyAdressState extends State<MyAdress> {
  // Color(0xff52B69A),
  // Color(0xff168AAD),

  List<String> AdressList = [
    "Ev\nKadıköy (Erenköy Mah.)\n",
    "Market\nKadıköy (Erenköy Mah.)\n",
  ];

  List<String> DetailedAdressList = [
    "Erenköy Mah., Asım Paşa Cad., Huzur Sokak, No:14, Daire: 3\n",
    "Erenköy Mah., Asım Paşa Cad., Leylek Sokak, No:29\n",
  ];
  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');
    var babaRef = updateRef.doc(user.email!);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /***----------***/
            /*** Adresim ***/
            SliverAppBar(
              backgroundColor: Color(0xff06D6A0),
              centerTitle: true,
              elevation: 1,
              floating: true,
              //pinned: false,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Adresim",
                    style: TextStyle(
                        fontFamily: 'Zen Antique Soft',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 22),
                  ),
                ),
              ),
            ),
            /***----------***/
            /*** Bilgiler ***/
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        /*** Mevcut Adresim ***/
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            elevation: 2,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {},
                                  hoverColor: Colors.greenAccent[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  tileColor: Colors.white,
                                  leading: Icon(
                                    Icons.home,
                                    color: Color(0xff52B69A), // cyan.shade600
                                    size: 26,
                                  ),
                                  title: StreamBuilder<DocumentSnapshot>(
                                    stream: babaRef.snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot asyncSnapshot) {
                                      return Text(
                                        '${asyncSnapshot.data.data()['Adress']}',
                                        style: TextStyle(
                                          fontFamily: "Zen Antique Soft",
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    },
                                  ),
                                  /*subtitle: Text(
                                    DetailedAdressList[index],
                                    style: TextStyle(
                                      fontFamily: "Zen Antique Soft",
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),*/
                                  /*trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary:
                                            Colors.teal, // basinca olusan renk
                                        elevation: 1,
                                        shadowColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    onPressed: () {},
                                    child: const Icon(
                                      Icons.edit_location_outlined,
                                      color: Colors.pinkAccent,
                                      size: 24,
                                    ),
                                  ),*/
                                );
                              },
                            ),
                          ),
                        ),
                        /*** Adres Ekleme Butonu ***/
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    primary: Colors.white,
                                    onPrimary: Colors.pinkAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FavoriteWidget()),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit_location_outlined,
                                        color: Colors.pinkAccent,
                                        size: 22,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Adres Değiştir',
                                          style: TextStyle(
                                            fontFamily: "Zen Antique Soft",
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1, /*** !!!!! ***/
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutheApp extends StatefulWidget {
  const AboutheApp({
    Key? key,
  }) : super(key: key);

  static String routeName = '/AboutheApp';

  @override
  State<AboutheApp> createState() => _AboutheAppState();
}

class _AboutheAppState extends State<AboutheApp> {
  final List<String> NameAbbreviation = [
    "MK",
    "HS",
    "MU",
    "AK",
    "UE",
    "SÇ",
  ];

  final List<String> NameList = [
    "Mustafa Karakaş",
    "Hacı Hasan Savan",
    "Muhammed Bedir Uluçay",
    "Ahmet Furkan Kurban",
    "Uğur Er",
    "Sefa Çiçek",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /***----------***/
            /*** Hakkında ***/
            SliverAppBar(
              backgroundColor: Color(0xff06D6A0),
              centerTitle: true,
              elevation: 1,
              floating: true,
              //pinned: false,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                //centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Uygulama Hakkında",
                    style: TextStyle(
                        fontFamily: 'Zen Antique Soft',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 21),
                  ),
                ),
              ),
            ),
            /***--------------------***/
            /*** Kişiler, Sürüm vs. ***/
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          "Geliştiriciler",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 2,
                                    child: ListTile(
                                      hoverColor: Colors.greenAccent[700],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      tileColor: Colors.white,
                                      leading: Material(
                                        elevation: 2,
                                        shape: CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.cyan.shade600,
                                          child: Text(
                                            NameAbbreviation[index],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        NameList[index],
                                        style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  primary: Colors.white,
                                  onPrimary: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )),
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2.0),
                                          child: Text(
                                            'Natore',
                                            style: GoogleFonts.lemon(
                                                color: Color(0xff06D6A0),
                                                fontSize: 26),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        'Sürüm 1.0.0',
                                        style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1, /*** !!!!! ***/
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Material(
        elevation: 0.8,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchAppBar()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xff34A0A4), width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
                    child: Icon(
                      Icons.search,
                      color: Color(0xff34A0A4),
                    ),
                  ),
                  Text('Yakınındaki Satıcılarda Ara',
                      style: GoogleFonts.lato(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CampaignSwiper extends StatefulWidget {
  const CampaignSwiper({
    Key? key,
    required int campaign_num,
  })  : _campaign_num = campaign_num,
        super(key: key);

  final int _campaign_num;

  @override
  State<CampaignSwiper> createState() => _CampaignSwiperState();
}

class _CampaignSwiperState extends State<CampaignSwiper> {
  
  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> allMessages =
      FirebaseFirestore.instance.collection('Users').snapshots();
  @override
  Widget build(BuildContext context) {
     return StreamBuilder<QuerySnapshot>(
                              stream:allMessages,
                              builder:(BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Text('Loading....');
                                  default:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');
                                    else {
                                      final data = snapshot.requireData;
                                      var temp =data.docs.where((element) => (element.get('Adress')==Adress1 && element.get('saticiMi')==true));
                                      var MarketInfo = List.from(temp);
                                    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AspectRatio(
              aspectRatio: 2,
              
              child: Swiper(
                //physics: NeverScrollableScrollPhysics(),
                //layout: SwiperLayout.TINDER,
                onTap: (int index) {},
                itemCount: MarketInfo.length,
                indicatorLayout: PageIndicatorLayout.SCALE,
                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 15),
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.blueGrey,
                    activeColor: Color(0xffef233c),
                    space: 5,
                  ),
                ),
                autoplay: true,
                autoplayDisableOnInteraction: true,
                autoplayDelay: 5000, // 3000 - default - kalma süresi
                duration: 800, // 300 - default - gecis süresi
                //viewportFraction: 0.8, -> genislik
                //scale: 0.82, -> aradaki bosluk
                itemBuilder: (BuildContext context, int index) {
                  var sohbet = MarketInfo[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          sohbet.get('SaticiTanitimImage'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                   
                },
              ),
              
            ),
          ),
        ),
      ],
    );
    }
                                }
                              });
  }
}

class ProductCategories extends StatefulWidget {
  const ProductCategories({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductCategories> createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  final List<Color> Color_list = [
    Colors.redAccent,
    Colors.teal,
    Colors.orangeAccent,
    Colors.cyan,
    Colors.lightGreen
  ];

  final List<ImageProvider> Image_list = [
    AssetImage("assets/homepageImages/real_milk.png"),
    AssetImage("assets/homepageImages/eggs_2.png"),
    AssetImage("assets/homepageImages/butter-toast.png"),
    AssetImage("assets/homepageImages/yogurt.png"),
    AssetImage("assets/homepageImages/cheese.png"),
  ];

  final List<String> ProductName_list = [
    "Süt",
    "Yumurta",
    "Yağ",
    "Yoğurt",
    "Peynir"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 0,
          //childAspectRatio: (2 / 1),
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        //padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Wrap(
            alignment: WrapAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         ShowInCategory(urun: ProductName_list[index])));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowInCategory(urun: ProductName_list[index])),
                    //   ),
                  );
                  print("index: $index");
                },
                style: ElevatedButton.styleFrom(
                  primary: Color_list[index],
                  elevation: 2,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 3),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image(
                          image: Image_list[index],
                          //fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: Text(
                        ProductName_list[index],
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w900,
                            fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Store extends StatefulWidget {
  const Store({
    Key? key,
    required int seller_num,
  })  : _seller_num = seller_num,
        super(key: key);

  final int _seller_num;

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final List<double> RateList = [
    4.8,
    4.5,
    4.2,
    3.8,
    2.9,
    4.2,
    3.6,
    2.7,
    1.4,
    3.5,
    4.5,
    3.8,
    4.6,
    2.9,
  ];

  final List<String> StoreNamesList = [
    "Sütçü Dede Süt Ürünleri",
    "Değirmen Yağ",
    "Milat Peynir",
    "Sütçü Babaanne Süt Ürünleri",
    "Sütçü Anneanne Süt Ürünleri",
    "Sütçü Amca Süt Ürünleri",
    "Sütçü Hala Süt Ürünleri",
    "Sütçü Dayı Süt Ürünleri",
    "Sütçü Teyze Süt Ürünleri",
    "Sütçü Kuzen Süt Ürünleri",
    "Sütçü Yeğen Süt Ürünleri",
    "Sütçü Enişte Süt Ürünleri",
    "Sütçü Bacanak Süt Ürünleri",
    "Sütçü Damat Dede Süt Ürünleri",
  ];

  final List<ImageProvider> StoreIconList = [
    AssetImage("assets/homepageImages/sutcu_dede_f.png"),
    AssetImage("assets/homepageImages/butter-toast.png"),
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/real_milk.png"),
    AssetImage("assets/homepageImages/eggs_2.png"),
    AssetImage("assets/homepageImages/yogurt.png"),
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/cheese.png"),
  ];

  Color? RateColor(double rate) {
    return rate > 4
        ? Colors.greenAccent[400]
        : (rate > 3 && rate < 4)
            ? Colors.amber
            : rate < 3
                ? Colors.redAccent
                : null; //dummy
  }

  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> allMessages =
      FirebaseFirestore.instance.collection('Users').snapshots();
  
  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');
     
                   return FutureBuilder<DocumentSnapshot>(
                      future:  updateRef.doc(user.email!).get(),
                      builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError)
                          return Text('Something went wrong.');
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Text('Loading');

                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                          Adress1 =data['Adress'];
                          checksaticioralici = data['saticiMi'];
                         

                          return StreamBuilder<QuerySnapshot>(
                              stream:allMessages,
                              builder:(BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Text('Loading....');
                                  default:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');
                                    else {
                                      final data = snapshot.requireData;
                                      var temp =data.docs.where((element) => (element.get('Adress')==Adress1 && element.get('saticiMi')==true));
                                      var MarketInfo = List.from(temp);
                                     
                                     return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: MarketInfo.length,
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      itemBuilder: (BuildContext context, int index) {
                                        var sohbet = MarketInfo[index];
                                          
                                              
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              /***--------***/
                                              /*** Tabela ***/
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      //margin: EdgeInsets.all(6),
                                                      //padding: EdgeInsets.only(top: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                          border:
                                                              Border.all(color: Colors.grey.withOpacity(0.2))),
                                                      child: Material(
                                                        color: Color(0xff06EFB1),
                                                        elevation: 4,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(4)),
                                                        child: Text(
                                                          sohbet.get('MarketName'),
                                                          //overflow: TextOverflow.fade,
                                                          //maxLines: 2,
                                                          textAlign: TextAlign.center,
                                                          style: GoogleFonts.goudyBookletter1911(
                                                              fontWeight: FontWeight.w800,
                                                              color: Color(0xff091624),
                                                              letterSpacing: 1.1,
                                                              //wordSpacing: 2,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              /***------***/
                                              /*** Çatı ***/
                                              Opacity(
                                                  opacity: 1,
                                                  child: Image.asset(
                                                    "assets/homepageImages/k2_c.png",
                                                    /** !!!  **/
                                                    fit: BoxFit.fill,
                                                    color: Color(0xff264653),
                                                    alignment: Alignment.topCenter,
                                                    //filterQuality: FilterQuality.high,
                                                  )),
                                              /***----------------***/
                                              /*** Mağaza Gövdesi ***/
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                                child: Material(
                                                  shape: Border(
                                                    left: BorderSide(color: Color(0xff264653), width: 2),
                                                    right: BorderSide(color: Color(0xff264653), width: 2),
                                                    bottom: BorderSide(color: Color(0xff264653), width: 2),
                                                  ),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductsOfSellerPage(sohbet.get('MarketName'),sohbet.get('Email'))),
                                                      );
                                                      //ProductsOfSellerPage("hacia");
                                                    }, // TODO: HACI
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.white,
                                                      onPrimary: Color(0xff06EFB1),
                                                      elevation: 2,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(0),
                                                          bottom: Radius.circular(0),
                                                        ),
                                                      ),
                                                    ),
                                                    //autofocus: true,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        /*** Clock and Door ***/
                                                        Column(
                                                          children: [
                                                            /*** Clock ***/
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(0, 34, 0, 2),
                                                              child: Material(
                                                                elevation: 2,
                                                                borderRadius: BorderRadius.circular(8),
                                                                color: Colors.cyan,
                                                                child: Text(
                                                                 sohbet.get('TimeCont'),
                                                                  //overflow: TextOverflow.fade,
                                                                  //maxLines: 2,
                                                                  textAlign: TextAlign.center,
                                                                  style: GoogleFonts.goudyBookletter1911(
                                                                      fontWeight: FontWeight.w800,
                                                                      color: Color(0xff091624),
                                                                      letterSpacing: 1.1,
                                                                      //wordSpacing: 2,
                                                                      fontSize: 20),
                                                                ),
                                                              ),
                                                            ),
                                                            /*** Door ***/
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 3),
                                                              child: Stack(
                                                                children: [
                                                                  Material(
                                                                    elevation: 2,
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            width: 1.2,
                                                                            color: Color(0xff073B4C)),
                                                                        color: Colors.white,
                                                                      ),
                                                                      width: 45,
                                                                      height: 80,
                                                                      alignment: Alignment.topCenter,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(34, 32, 0, 0),
                                                                    child: Material(
                                                                      borderRadius: BorderRadius.circular(2),
                                                                      elevation: 2.5,
                                                                      child: Container(
                                                                        alignment: Alignment.centerRight,
                                                                        width: 5,
                                                                        height: 13,
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(2),
                                                                          border: Border.all(
                                                                              color: Color(0xff073B4C),
                                                                              width: 1),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        /*** Rate ***/
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 92),
                                                          child: Material(
                                                            color: RateColor(RateList[index]),
                                                            elevation: 2,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8)),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(4.0),
                                                              child: Wrap(
                                                                spacing: 4,
                                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                                children: [
                                                                  Icon(Icons.star_outlined,
                                                                      color: Colors.white, size: 20),
                                                                  Text(
                                                                    RateList[index].toString(),
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        /*** Store logo ***/
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 24),
                                                          child: Row(
                                                            children: [
                                                              Material(
                                                                borderRadius: BorderRadius.circular(8),
                                                                color: Colors.white,
                                                                elevation: 2,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    border: Border.all(
                                                                        color: Colors.cyan.shade800, width: 2),
                                                                  ),
                                                                  child: (index == 0)
                                                                      ? Image.asset(
                                                                          "assets/homepageImages/sutcu_dede_f.png",

                                                                          /** !!!  **/
                                                                          fit: BoxFit.fill,
                                                                          //color: Color(0xff264653),
                                                                          //alignment: Alignment.topCenter,
                                                                          //filterQuality: FilterQuality.high,
                                                                        )
                                                                      : Image.asset(
                                                                          "assets/homepageImages/yogurt.png",
                                                                          fit: BoxFit.fill,
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    }
                                }
                              });//
                        }
                   
                      

            
          
        );
    
  }
}
