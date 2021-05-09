import 'package:digital_eyes/settings_screen.dart';
import 'package:flutter/material.dart';
import 'home_for_blind_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PersonalPosts extends StatefulWidget {
  static String id = 'personalPosts';
  @override
  _PersonalPostsState createState() => _PersonalPostsState();
}

class _PersonalPostsState extends State<PersonalPosts> {
  int index = 1;
  FlutterTts flutterTts = FlutterTts();
  final _users = FirebaseFirestore.instance.collection('images');

  Future<QuerySnapshot> getImages() async {
    return _users.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF0275D8),
        title: Center(child: Text('My Posts')),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color(0XFF181820),
        ),
        padding: EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getImages(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data =
                        snapshot.data.docs[index].data();
                    var name = data['name'];
                    var url = data['url'];
                    var _reply = data["reply"];
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              height: 60.0,
                              color: Colors.black,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '     $name',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Image.network(
                                    url,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return DetailScreen(
                                    url: url);
                              }));
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String reply =
                                _reply;
                            reply == "" ? await flutterTts.speak("No Reply") :
                            await flutterTts.speak(reply);
                          },
                          child: Icon(
                            Icons.play_arrow,
                            size: 70.0,
                          ),
                        )
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

class DetailScreen extends StatelessWidget {
  DetailScreen({this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(url),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
