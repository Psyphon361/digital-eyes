import 'package:digital_eyes/home_for_blind_screen.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrimaryLanguage extends StatefulWidget {
  static String id = 'primaryLanguage';
  @override
  _PrimaryLanguageState createState() => _PrimaryLanguageState();
}

class _PrimaryLanguageState extends State<PrimaryLanguage> {
  final _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');
  User loggedInUser;
  String loggedInUserPhone;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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

  List<String> commonLanguages = ['English', 'Hindi', 'Punjabi'];

  List<String> allLanguages = [
    'English',
    'Hindi',
    'Chinese',
    'English',
    'Spanish',
    'Arabic',
    'Bengali',
    'Portuguese',
    'Russian'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF0275D8),
        title: Text('Primary Language'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color(0XFF181820),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 6.0,
              ),
              child: PrimaryLanguageText(
                size: 24.0,
                text: 'Select Your Primary Language',
              ),
            ),
            PrimaryLanguageText(
              size: 16.0,
              text: kPrimaryLanguageText,
              alignment: TextAlign.center,
            ),
            LanguageHeadings('Common Languages'),
            Flexible(
              child: ListView.builder(
                itemCount: commonLanguages.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      String docId = await _users
                          .where('phoneNumber', isEqualTo: loggedInUserPhone)
                          .get()
                          .then((value) => value.docs[0].id);
                      _users
                          .doc(docId)
                          .update({'language': commonLanguages[index]});
                      Navigator.popAndPushNamed(context, BlindHomePage.id);
                    },
                    title: PrimaryLanguageText(
                      size: 20.0,
                      text: commonLanguages[index],
                    ),
                  );
                },
              ),
            ),
            LanguageHeadings('All Languages'),
            Flexible(
              child: ListView.builder(
                itemCount: allLanguages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      String docId;
                      await _users
                          .where('phoneNumber', isEqualTo: loggedInUserPhone)
                          .get()
                          .then((value) => docId = value.docs[0].id);
                      _users
                          .doc(docId)
                          .update({'language': allLanguages[index]});
                      //TODO change route
                      Navigator.popAndPushNamed(context, BlindHomePage.id);
                    },
                    title: PrimaryLanguageText(
                      size: 20.0,
                      text: allLanguages[index],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageHeadings extends StatelessWidget {
  LanguageHeadings(this.text);

  final text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 6.0,
        left: 12.0,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: TextStyle(
            color: Color(0XFF0275D8),
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
      ),
    );
  }
}

class PrimaryLanguageText extends StatelessWidget {
  PrimaryLanguageText(
      {@required this.size, @required this.text, this.alignment});

  final size;
  final text;
  final alignment;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
