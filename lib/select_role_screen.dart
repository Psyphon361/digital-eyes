import 'package:digital_eyes/primary_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetRole extends StatefulWidget {
  static String id = 'selectRole';
  @override
  _GetRoleState createState() => _GetRoleState();
}

class _GetRoleState extends State<GetRole> {
  final _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');
  User loggedInUser;
  String loggedInUserPhone;

  @override
  void initState() {
    getCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: Color(0XFF181820),
          ),
          child: Column(
            children: [
              Flexible(
                child: Padding(
                    padding: EdgeInsets.only(
                      right: 9.06.w,
                      left: 9.06.w,
                      top: 3.5.h,
                    ),
                    child: Container(
                      height: 30.2.h,
                      width: 81.06.w,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('images/logo_large.png'),
                        fit: BoxFit.fill,
                      )),
                    )),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 3.5.h,
                  ),
                  child: Text(
                    'What is your role?',
                    // textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 18.13.w,
                  left: 18.13.w,
                  top: 6.15.h,
                ),
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0XFF181820),
                    ),
                  ),
                  onPressed: () async {
                    String docId = await _users
                        .where('phoneNumber', isEqualTo: loggedInUserPhone)
                        .get()
                        .then((value) => value.docs[0].id);
                    _users.doc(docId).update({'isBlind': true});
                    Navigator.popAndPushNamed(context, PrimaryLanguage.id);
                  },
                  child: Container(
                    height: 15.0.h,
                    width: 69.06.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                          size: 14.0.w,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'I Am Visually Impaired',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 18.13.w,
                  left: 18.13.w,
                  top: 6.15.h,
                ),
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0XFF181820),
                    ),
                  ),
                  onPressed: () async {
                    String docId = await _users
                        .where('phoneNumber', isEqualTo: loggedInUserPhone)
                        .get()
                        .then((value) => value.docs[0].id);
                    _users.doc(docId).update({'isBlind': false});
                    Navigator.popAndPushNamed(context, PrimaryLanguage.id);
                  },
                  child: Container(
                    height: 15.0.h,
                    width: 69.06.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                          size: 14.0.w,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'I Am Sighted',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
