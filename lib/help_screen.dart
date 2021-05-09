import 'package:digital_eyes/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HelpScreen extends StatefulWidget {
  static String id = 'helpPage';
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF0275D8),
        title: Center(child: Text('Learn How To Help')),
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
              padding: EdgeInsets.only(top: 0.98.h),
              child: Image(
                image: AssetImage(
                  'images/logo_large.png',
                ),
                width: 50.4.w,
                height: 30.2.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.98.h, left: 2.6.w, right:  2.6.w),
              child: Text(
                  kHelpPageText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 5.4.w,
                    color: Colors.white,
                  ),
                ),  
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.9.h, left:  2.6.w, right:  2.6.w),
              child: Text(
                kHelpPageTextTwo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 5.4.w,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
