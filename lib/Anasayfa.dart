// ignore_for_file: file_names

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natore_project/UserEntrance.dart';
import 'package:natore_project/page/Order/my_orders.dart';
import 'package:natore_project/page/sohbet.dart';
import 'package:natore_project/products_of_seller_page.dart';
import 'package:natore_project/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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
        PreviousOrders.routeName: (context) => PreviousOrders(),
        MyAdress.routeName: (context) => MyAdress(),
        Notifications.routeName: (context) => Notifications(),
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
  /*static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);*/

  List<Widget> tabs = [
    MainPage(),
    Sohbet(), //chat gelecek
    MyOrders("Sütçü Dede"), //MyStatefulWidget(),
    UserProfile(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    print("dsadasdasdasdsadsadasdasdasdassdasdsa546565465");

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
            /*
            ImageIcon(
              AssetImage("assets/hoopoe.png"),
              color: Colors.blueGrey.withOpacity(0.8),
              size: 32,
            ),
            activeIcon: ImageIcon(
              AssetImage("assets/hoopoe.png"),
              color: Color(0xff00ADB5),
              size: 32,
            ),*/
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
                  Notifications.routeName,
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
                  onPressed: () {},
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
                                      return Text(
                                        "Artvin Hopa", //'${asyncSnapshot.data.data()['Adress']}',
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
            childCount: 20, /*** !!!!! ***/
          ),
        ),
      ],
    );
  }
}

class Notifications extends StatefulWidget {
  const Notifications({
    Key? key,
  }) : super(key: key);

  static String routeName = '/Notifications';

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<String> Notifics = [
    "Uygulamamzı paylaşarak bizi onurlandırdınız. Çok teşekkürler. Bu güzel hareketi karşılıksız bırakamayız, +200 puan kazandınız! ",
    "Siparişiniz sayesinde 25 puan kazandınız. Tebrikler!",
    "Satıcıdan alma seçeneği ile alışveriş yaptığınız için 50 puan kazandınız. Her satıcıdan alma işlemi +50 puan kazandırır!",
    "Siparişiniz sayesinde 25 puan kazandınız. Tebrikler!",
    "Natore'den ilk siparişiniz! Siparişlerinizde kullanmak üzere 100 puan kazandınız. Tebrikler!",
    "Satıcılarımızla iletişime geçtiniz! 10 puan kazandınız. Tebrikler!",
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
      child: Text(
        "+50",
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
                                    leading: Avatar_list[index],
                                    title: Text(
                                      Notifics[index],
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        Date[index],
                                        style: GoogleFonts.lato(
                                          color: Colors.grey,
                                          fontSize: 18,
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
    "Adreslerim",
    "Önceki Siparişlerim",
    "Uygulamayı Değerlendirin",
    "Uygulama Hakkında",
    "Uygulamayı Paylaş",
  ];

  final List<EdgeInsetsGeometry> PaddingList = [
    EdgeInsets.fromLTRB(8, 8, 90, 4),
    EdgeInsets.fromLTRB(8, 8, 55, 4),
    EdgeInsets.fromLTRB(8, 8, 20, 4),
    EdgeInsets.fromLTRB(8, 8, 55, 4),
    EdgeInsets.fromLTRB(8, 8, 90, 8),
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
                                    //'${asyncSnapshot.data.data()['Image']}'
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
                              itemCount: 5,
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
                                            Navigator.pushNamed(
                                              context,
                                              PreviousOrders.routeName,
                                            );
                                            break;
                                          case 2:
                                            _launchURLApp(rateApp_link);
                                            break;
                                          case 3:
                                            Navigator.pushNamed(
                                              context,
                                              AboutheApp.routeName,
                                            );
                                            break;
                                          case 4:
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

  List<IconData> IconList = [Icons.home, Icons.store_sharp];

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
            /*** Adreslerim ***/
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
                    "Adreslerim",
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
                        /*** Mevcut Adreslerim ***/
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            elevation: 2,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {},
                                  hoverColor: Colors.greenAccent[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  tileColor: Colors.white,
                                  leading: Icon(
                                    IconList[index],
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
                                  trailing: ElevatedButton(
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
                                  ),
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
                                    onPrimary:
                                        Colors.teal, // basinca olusan renk
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.pinkAccent,
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            AboutheApp
                                                .routeName, //Location.routeName,
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Yeni Adres Ekle',
                                          style: TextStyle(
                                              fontFamily: "Zen Antique Soft",
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

class PreviousOrders extends StatefulWidget {
  const PreviousOrders({
    Key? key,
  }) : super(key: key);

  static String routeName = '/PreviousOrders';

  @override
  State<PreviousOrders> createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  final List<String> Details = [
    "Milat Peynir\n500 gr Süzme Peynir",
    "Değirmen Yağ\n3 kg Tuzsuz Yağ",
    "Sütçü Dede Süt Ürünleri\n5 lt Keçi Sütü",
  ];

  final List<ImageProvider> Image_list = [
    AssetImage("assets/homepageImages/cheese.png"),
    AssetImage("assets/homepageImages/butter-toast.png"),
    AssetImage("assets/homepageImages/real_milk.png"),
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
              elevation: 1,
              floating: true,
              //pinned: false,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                //centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Önceki Siparislerim",
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Material(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                                child: ListTile(
                                  onTap: () {},
                                  hoverColor: Colors.greenAccent[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  tileColor: Colors.white,
                                  leading: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image(
                                      image: Image_list[index],
                                    ),
                                  ),
                                  title: Text(
                                    Details[index],
                                    style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
  @override
  Widget build(BuildContext context) {
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
                itemCount: widget._campaign_num,
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
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          "https://cekkazan.com.tr/wp-content/uploads/2021/05/bardak-bardak-icilecek-sutas-sutler-sut-bardagi-hediyeli.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  } else if (index == 1) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          "https://www.sivilsayfalar.org/wp-content/uploads/2019/04/1554272813_kampanya_4.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  } else if (index == 2) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          "https://cdn.bumudur.com/cmp/img/s/full/6eef73465326c51cdbe23073e86c7e49.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          "https://d3vkdqr0qjxhag.cloudfront.net/AE_Milgo_2lt_Sut_Tikla_Gelsin_800x800px_d0446d5e44.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
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
                onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    CollectionReference updateRef = _firestore.collection('Users');

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: saticilength,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      itemBuilder: (BuildContext context, int index) {
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
                          saticilar[index],
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
                                ProductsOfSellerPage("Sütçü Dede")),
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
                                  saticilar1[index],
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
