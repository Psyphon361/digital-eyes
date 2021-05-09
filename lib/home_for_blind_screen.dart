import 'package:digital_eyes/all_personal_posts.dart';
import 'package:digital_eyes/index.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'create_post_screen.dart';
import 'settings_screen.dart';

class BlindHomePage extends StatefulWidget {
  static String id = 'homeForBlind';
  @override
  _BlindHomePageState createState() => _BlindHomePageState();
}

class _BlindHomePageState extends State<BlindHomePage> {
  int index = 0;

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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 5.0.h,
              ),
              child: BlindScreenButton(
                text: 'Request Video Call',
                buttonHeight: 36.2.h,
                onPressed: () {
                  Navigator.pushNamed(context, IndexPage.id);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 4.0.h,
              ),
              child: BlindScreenButton(
                text: 'New Post',
                buttonHeight: 24.3.h,
                onPressed: () {
                  Navigator.pushNamed(context, CreatePost.id);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) {
          if (index == 2 && this.index == 2) {
          } else if (index == 2) {
            setState(() {
              this.index = index;
            });
            Navigator.pushNamed(context, SettingScreen.id);
          } else if (index == 0 && this.index == 0) {
          } else if (index == 0) {
            setState(() {
              this.index = index;
            });
            Navigator.pushNamed(context, BlindHomePage.id);
          } else if (index == 1 && this.index == 1) {
          } else if (index == 1) {
            setState(() {
              this.index = index;
            });
            Navigator.pushNamed(context, PersonalPosts.id);
          }
        },
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Posts',
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

class BlindScreenButton extends StatelessWidget {
  BlindScreenButton({this.text, this.buttonHeight, this.onPressed});

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
          ),
        ),
      ),
    );
  }
}
