import 'package:digital_eyes/home_for_blind_screen.dart';
import 'package:digital_eyes/recorder.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class CreatePost extends StatefulWidget {
  static String id = 'createPost';
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File _image;
  bool showLoader = false;
  var rng = Random();
  final _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');
  User loggedInUser;
  String loggedInUserPhone;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
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

  Future<void> uploadFile() async {
    setState(() {
      showLoader = true;
    });
    File file = File(_image.path);
    String docId = await _users
        .where('phoneNumber', isEqualTo: loggedInUserPhone)
        .get()
        .then((value) => value.docs[0].id);
    String imageName = '${rng.nextInt(10000)}.jpg';
    var userName = await _users.doc(docId).get();
    var snapshot = await storage
        .ref('images/${userName.data()["username"]}/$imageName')
        .putFile(file);
    if (snapshot.state == firebase_storage.TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("images")
          .add({"url": downloadUrl, "name": imageName, 
          "userName": userName.data()["username"], "reply": ""});
      setState(() {
        showLoader = true;
      });
    } else {
      throw ('This file is not an image');
    }
    Navigator.popAndPushNamed(context, BlindHomePage.id);
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF0275D8),
        title: Center(child: Text('New Post')),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5.0.h,
                        ),
                        child: _image == null
                            ? BlindScreenButton(
                                text: 'Add a Photo',
                                buttonHeight: 28.3.h,
                                icon: Icons.photo,
                                onPressed: getImage,
                              )
                            : Container(
                                child: Image.file(
                                  _image,
                                  height: 58.3.h,
                                  width: 88.8.w,
                                ),
                              ),
                      ),
                      _image == null
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.0.h,
                              ),
                              child: BlindScreenButton(
                                text: 'Add an Audio',
                                buttonHeight: 28.3.h,
                                icon: Icons.mic,
                                onPressed: () {
                                  Navigator.pushNamed(context, Recorder.id);
                                },
                              ),
                            )
                          : SizedBox(
                              height: 1.0,
                            ),
                    ],
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color(0XFF0275D8),
                      ),
                    ),
                    onPressed: () async {
                      await uploadFile();
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          'POST',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 9.0.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class BlindScreenButton extends StatelessWidget {
  BlindScreenButton({this.text, this.buttonHeight, this.onPressed, this.icon});

  final buttonHeight;
  final text;
  final Function onPressed;
  final icon;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10.0.w,
                color: Colors.white,
              ),
            ),
            Icon(
              icon,
              size: 40.0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
