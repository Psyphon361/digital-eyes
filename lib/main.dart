import 'package:digital_eyes/all_personal_posts.dart';
import 'package:digital_eyes/all_posts.dart';
import 'package:digital_eyes/create_post_screen.dart';
import 'package:digital_eyes/help_screen.dart';
import 'package:digital_eyes/home_for_blind_screen.dart';
import 'package:digital_eyes/home_screen.dart';
import 'package:digital_eyes/index.dart';
import 'package:digital_eyes/loading_screen.dart';
import 'package:digital_eyes/primary_language_screen.dart';
import 'package:digital_eyes/recorder.dart';
import 'package:digital_eyes/select_role_screen.dart';
import 'package:digital_eyes/settings_screen.dart';
import 'package:digital_eyes/username_screen.dart';
import 'package:digital_eyes/video_call_posts.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget nextScreen = LoadingScreen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _firebase = FirebaseFirestore.instance;
  final _users = FirebaseFirestore.instance.collection('users');

  void showScreen() {
    var instance = FirebaseAuth.instance.authStateChanges();
    instance.listen((User user) async {
      if (user != null) {
        String docId;
        String username;
        try {
          docId = await _firebase
              .collection('users')
              .where('phoneNumber', isEqualTo: user.phoneNumber)
              .get()
              .then((value) => value.docs[0].id);
          username = await _users
              .doc(docId)
              .get()
              .then((value) => value.data()['username'].toString());
        } catch (e) {
          docId = 'null';
        }
        if (username != null) {
          bool isBlind = await _users
              .doc(docId)
              .get()
              .then((value) => value.data()['isBlind']);
          if (isBlind == null) {
            setState(() {
              nextScreen = GetRole();
            });
          } else if (isBlind == true) {
            setState(() {
              nextScreen = BlindHomePage();
            });
          } else {
            setState(() {
              nextScreen = HomePage();
            });
          }
        } else {
          setState(() {
            nextScreen = GetUsername();
          });
        }
      } else {
        setState(() {
          nextScreen = LoginScreen();
        });
      }
    });
  }

  @override
  void initState() {
    showScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color(0XAA181820));
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(
        builder: (context, orientation) {
          SizerUtil().init(constraints, orientation);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Digital Eyes',
            theme: ThemeData.light(),
            initialRoute: LoadingScreen.id,
            routes: {
              LoginScreen.id: (context) => LoginScreen(),
              GetUsername.id: (context) => GetUsername(),
              LoadingScreen.id: (context) => nextScreen,
              GetRole.id: (context) => GetRole(),
              PrimaryLanguage.id: (context) => PrimaryLanguage(),
              BlindHomePage.id: (context) => BlindHomePage(),
              SettingScreen.id: (context) => SettingScreen(),
              CreatePost.id: (context) => CreatePost(),
              Recorder.id: (context) => Recorder(),
              PersonalPosts.id: (context) => PersonalPosts(),
              HomePage.id: (context) => HomePage(),
              HelpScreen.id: (context) => HelpScreen(),
              IndexPage.id: (context) => IndexPage(),
              VideoCallsFeed.id: (context) => VideoCallsFeed(),
              AllPosts.id: (context) => AllPosts(),
            },
          );
        },
      );
    });
  }
}
