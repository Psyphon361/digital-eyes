import 'package:digital_eyes/index.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

class VideoCallsFeed extends StatefulWidget {
  static String id = 'allVideoCalls';
  @override
  _VideoCallsFeedState createState() => _VideoCallsFeedState();
}

class _VideoCallsFeedState extends State<VideoCallsFeed> {
  final _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('posts');
  User loggedInUser;
  String loggedInUserPhone;

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

  Future<QuerySnapshot> getFeed() {
    return _users.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF0275D8),
        title: Center(child: Text('Video Calls Request')),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color(0XFF181820),
        ),
        padding: EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getFeed(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data =
                        snapshot.data.docs[index].data();
                    var username = data['userName'];
                    var channelName = data['channelName'];
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            height: 60.0,
                            color: Colors.black,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Requsted By: $username',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Code: $channelName',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, IndexPage.id);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.blue,
                            width: 100.0.w,
                            child: Text(
                              'JOIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
