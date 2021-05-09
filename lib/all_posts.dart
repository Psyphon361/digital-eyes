import 'package:digital_eyes/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllPosts extends StatefulWidget {
  static String id = 'allPosts';
  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  String reply;
  final _users = FirebaseFirestore.instance.collection('images');

  Future<QuerySnapshot> getImages() {
    return _users.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF0275D8),
        title: Center(child: Text('All Posts')),
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
                    var username = data['userName'];
                    var url = data['url'];
                    var name = data["name"];
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
                                    'Posted by: $username',
                                    style: TextStyle(
                                      fontSize: 16.0,
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
                                return DetailScreen(url: url);
                              }));
                            },
                          ),
                        ),
                        Container(
                          height: 50.0,
                          child: TextField(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  String docId = await _users
                                      .where('name',
                                          isEqualTo: name)
                                      .get()
                                      .then((value) => value.docs[0].id);
                                  _users.doc(docId).update({'reply': reply});
                                  Navigator.popAndPushNamed(
                                      context, HomePage.id);
                                },
                              ),
                              fillColor: Colors.grey,
                              hintText: "Reply",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              reply = value;
                            },
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
