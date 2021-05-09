import 'package:digital_eyes/select_role_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetUsername extends StatefulWidget {
  static String id = 'usernameScreen';
  @override
  _GetUsernameState createState() => _GetUsernameState();
}

class _GetUsernameState extends State<GetUsername> {
  final usernameController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;
  User loggedInUser;
  String loggedInUserPhone;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 300,
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SmallLogo(),
              LoginScreenText(
                text: 'Let\'s Get Started',
                sizeFont: 30.0,
                topPadding: 4.4.h,
                bottomPadding: 5.0,
              ),
              LoginScreenText(
                text: 'Enter your Username',
                sizeFont: 16.0,
                topPadding: 4.0,
                bottomPadding: 0.0,
              ),
              LoginTextField(
                text: 'Username',
                controller: usernameController,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 9.33.w,
                  right: 9.33.w,
                  top: 6.5.h,
                ),
                child: TextButton(
                  style: kLoginButtonStyle,
                  onPressed: () async {
                    await _firebase.collection('users').add({
                      'phoneNumber': loggedInUserPhone,
                      'isBlind': null,
                      'username': usernameController.text,
                      'date': DateTime.now(),
                      'language': 'English',
                    });
                    Navigator.popAndPushNamed(context, GetRole.id);
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
          padding: EdgeInsets.only(
            right: 68.0.w,
            left: 9.06.w,
            top: 17.4.h,
          ),
          child: Container(
            height: 10.2.h,
            width: 22.66.w,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/logo.png'),
              fit: BoxFit.fill,
            )),
          )),
    );
  }
}

class LoginScreenText extends StatelessWidget {
  LoginScreenText(
      {this.text, this.sizeFont, this.topPadding, this.bottomPadding});

  final text;
  final sizeFont;
  final topPadding;
  final bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          bottom: bottomPadding,
          left: 10.6.w,
        ),
        child: Text(
          text,
          // textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: sizeFont,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({@required this.controller, this.text});

  final text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 9.0.w,
        right: 9.0.w,
        top: 6.1.h,
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: kTextFieldDecoration.copyWith(
          hintText: text,
          suffixIcon: Icon(
            Icons.arrow_right_alt_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
