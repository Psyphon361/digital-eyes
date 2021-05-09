import 'package:digital_eyes/all_posts.dart';
import 'package:digital_eyes/help_screen.dart';
import 'package:digital_eyes/settings_screen.dart';
import 'package:digital_eyes/video_call_posts.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  static String id = 'homePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');
  User loggedInUser;
  String loggedInUserPhone;
  String userName;
  bool showLoader = false;
  int index = 0;

  @override
  void initState() {
    getCurrentUser();
    getUsername();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        loggedInUserPhone = loggedInUser.phoneNumber;
      }
    } catch (e) {
      print(e);
    }
  }

  void getUsername() async {
    setState(() {
      showLoader = true;
    });
    String docId = await _users
        .where('phoneNumber', isEqualTo: loggedInUserPhone)
        .get()
        .then((value) => value.docs[0].id);
    var doc = await _users.doc(docId).get();
    setState(() {
      userName = doc.data()["username"];
    });
    setState(() {
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF0275D8),
        title: Center(child: Text('Digital Eyes')),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color(0XFF181820),
        ),
        child: showLoader == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HomeScreenButton(
                    buttonHeight: 16.0.h,
                    text: 'Hi $userName',
                  ),
                  HomeScreenButton(
                    buttonHeight: 16.0.h,
                    text: 'Public Feeds Post',
                    onPressed: () {
                      Navigator.pushNamed(context, AllPosts.id);
                    },
                  ),
                  HomeScreenButton(
                    buttonHeight: 16.0.h,
                    text: 'Video Call Requests',
                    onPressed: () {
                      Navigator.pushNamed(context, VideoCallsFeed.id);
                    },
                  ),
                  HomeScreenButton(
                    buttonHeight: 16.0.h,
                    text: 'Learn How To Help',
                    onPressed: () {
                      Navigator.pushNamed(context, HelpScreen.id);
                    },
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) {
          if (index == 0 && this.index == 0) {
          } else if (index == 0) {
            setState(() {
              this.index = index;
            });
            Navigator.pushNamed(context, HomePage.id);
          } else if (index == 1 && this.index == 1) {
          } else if (index == 1) {
            setState(() {
              this.index = index;
            });
            Navigator.pushNamed(context, SettingScreen.id);
          }
        },
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeScreenButton extends StatelessWidget {
  HomeScreenButton({this.text, this.buttonHeight, this.onPressed});

  final buttonHeight;
  final text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          Color(0XFF0275D8),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        height: buttonHeight,
        width: 88.8.w,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 10.0.w,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
