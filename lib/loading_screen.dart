import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingScreen extends StatefulWidget {
  static String id = 'loadingScreen';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: LoadingBouncingGrid.circle(
          backgroundColor: Color(0XFFFA6CA9),
        ),
      ),
    );
  }
}
