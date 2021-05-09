import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const kPrimaryLanguageText =
    'When you make a call, you will be connected to an available volunteer who speaks your primary language.';

const kHelpPageText =
    "When a visually impaired person requests for help via a video call, it will show up under the Video  Call Requests section. All other posts will be visible in the Public Feed. You can help them by replying either by typing or by a voice message.";

const kHelpPageTextTwo =
    "Please be really patient and helpful with the people who need help. They hope to see the beautiful world with their “Digital Eyes”";

const kWelcomeMessage = "Welcome to Digital Eyes. There are two buttons on the screen, ";

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter the value',
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
);

var kLoginButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22.0),
    ),
  ),
  backgroundColor: MaterialStateProperty.all(
    Color(0XFFFA6CA9),
  ),
  padding: MaterialStateProperty.all(
    EdgeInsets.symmetric(
      vertical: 1.35.h,
      horizontal: 25.6.w,
    ),
  ),
);

const kSettingsHeadingText = TextStyle(
  color: Color(0XFF7868E6),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const kSettingsText = TextStyle(
  color: Colors.white,
  fontSize: 24.0,
);
