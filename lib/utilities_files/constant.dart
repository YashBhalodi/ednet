import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/profile/other_user_profile/user_profile_sheet.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Constant {
  static get edgePadding => EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      );

  static get sidePadding => EdgeInsets.symmetric(
        horizontal: 24.0,
      );

  static get cardPadding => EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        bottom: 0.0,
        top: 4.0,
      );

  static get cardMargin => EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 16.0,
      );

  static get formFieldContentPadding => EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 20.0,
      );

  static get zefyrFieldContentPadding => EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 20.0,
      );

  static get myCircularProgressIndicator => SizedBox(
        height: 28.0,
        width: 28.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.green[800]),
          backgroundColor: Colors.green[50],
        ),
      );

  static get raisedButtonPaddingHigh => EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      );

  static get raisedButtonPaddingMedium => EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      );

  static get raisedButtonPaddingLow => EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      );

  static get scrollAnimationDuration => Duration(
        milliseconds: 400,
      );

  static get pageAnimationDuration => Duration(
        milliseconds: 500,
      );

  static get menuButtonTextStyle => TextStyle(
      fontSize: 24.0,
      color: Colors.blue[800],
      fontWeight: FontWeight.w600,
      fontFamily: 'ValeraRound');

  static get primaryCTATextStyle => TextStyle(
        fontSize: 18.0,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      );

  static get secondaryCTATextStyle => TextStyle(
        fontSize: 18.0,
        color: Colors.grey[800],
        fontWeight: FontWeight.w500,
      );

  static get negativeCTATextStyle => TextStyle(
        fontSize: 24.0,
        color: Colors.red[600],
        fontWeight: FontWeight.w600,
      );

  static get secondaryNegativeTextStyle => TextStyle(
        color: Colors.red[500],
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      );

  static get secondaryBlueTextStyle => TextStyle(
        color: Colors.blue[500],
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      );

  static get dropDownMenuTitleStyle => TextStyle(
        color: Colors.grey[700],
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      );

  static get outlineBlueButtonTextStyle => TextStyle(
        color: Colors.blue[600],
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      );

  static get appBarTextStyle => TextStyle(
        fontFamily: 'ValeraRound',
        fontWeight: FontWeight.w700,
      );

  static get questionHeadingStyle => TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      );

  static get questionDescriptionStyle => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      );

  static get dateTimeStyle => TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w300,
      );

  static get dateTimeMediumStyle => TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w300,
      );

  static get usernameStyle => TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      );

  static get usernameMediumStyle => TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      );

  static get topicStyle => TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
      );

  static get articleTitleStyle => TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
      );

  static get articleSubtitleStyle => TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      );

  static get articleContentStyle => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      );

  static get answerThumbContentStyle => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
      );

  static get answerContentStyle => TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
      );

  static get professorUpvoteTextStyle => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Colors.deepOrange,
      );

  static String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Email address is not valid";
    } else if (value.length == 0) {
      return "Please provide valid email";
    } else {
      return null;
    }
  }

  static Future<String> getCurrentUserDocId() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userDoc = await Firestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUser.email)
        .getDocuments();
    return userDoc.documents[0].documentID;
  }

  static Future<User> getCurrentUserObject() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userDoc = await Firestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUser.email)
        .getDocuments();
    User user = User.fromSnapshot(userDoc.documents[0]);
    return user;
  }

  static Future<String> userNameAvailableValidator(String value) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    String currentEmail = currentUser.email;
    final userDoc = await Firestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentEmail)
        .getDocuments();
    if (value.contains(' ')) {
      return "Username can't contain space";
    } else if (userDoc.documents[0]['username'] == value) {
      return null;
    } else {
      final result = await Firestore.instance
          .collection('Users')
          .where('username', isEqualTo: value)
          .getDocuments();
      return result.documents.isEmpty ? null : "Username already in use. Try something else.";
    }
  }

  static Future<String> topicNameValidator(String value) async {
    //TODO add Spamming prevention mechanism
    if (value.length == 0) {
      return "Please provide topic name";
    }
    final topicDoc = await Firestore.instance
        .collection('Topics')
        .where('title', isEqualTo: value.capitalize().trim())
        .getDocuments();
    if (topicDoc.documents.isEmpty) {
      return null;
    } else {
      return "This topic has been created already.";
    }
  }

  static String nameValidator(String value) {
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "We would like to know your name";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Name can only contain alphabets";
    } else {
      return null;
    }
  }

  static String countryValidator(String value) {
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Please provide Country.";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Country name can contain only alphabets.";
    } else {
      return null;
    }
  }

  static String stateValidator(String value) {
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Please provide Region or State.";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Region/State name can contain only alphabets.";
    } else {
      return null;
    }
  }

  static String cityValidator(String value) {
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Please provide City.";
    } else if (!regExp.hasMatch(value.trim())) {
      return "City name can contain only alphabets.";
    } else {
      return null;
    }
  }

  static String mobileNumberValidator(String value) {
    //TODO adapt to handle country code
    Pattern pattern = r'^[0-9]+$';
    RegExp regExp = new RegExp(pattern);
    if (value.trim().length == 0) {
      return "Please provide mobile number";
    } else if (value.trim().length != 10) {
      return "This mobile number is not valid";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Mobile number can only containe numbers";
    } else {
      return null;
    }
  }

  static String questionHeadingValidator(value) {
    if (value.trim().length < 10) {
      Constant.showToastInstruction("Heading needs atleast 10 characters");
      return "Heading needs atleast 10 characters";
    } else {
      return null;
    }
  }

  static String questionDescriptionValidator(value) {
    if (value.length < 20) {
      Constant.showToastInstruction("Question Description should be at least 20 characters.");
      return "Please, describe question in atleast 20 characters";
    } else {
      return null;
    }
  }

  static String articleTitleValidator(value) {
    if (value.trim().length < 10) {
      Constant.showToastInstruction("Article title should be atleast 10 charactes long");
      return "Article title should be atleast 10 charactes long";
    } else {
      return null;
    }
  }

  static String articleSubtitleValidator(value) {
    if (value.trim().length < 20) {
      Constant.showToastInstruction("Article Subtitle should be atleast 20 charactes long");
      return "Article Subtitle should be atleast 20 charactes long";
    } else {
      return null;
    }
  }

  static String articleContentValidator(value) {
    if (value.trim().length < 100) {
      Constant.showToastInstruction("Article content should be atleast 100 charactes long");
      return "Article content should be atleast 100 charactes long";
    } else {
      return null;
    }
  }

  static String answerValidator(value) {
    if (value.length < 100) {
      Constant.showToastInstruction("Answer should be atleast 100 characters long.");
      return "Please write answer atleast 100 characters long";
    } else {
      return null;
    }
  }

  static Widget myLinearProgressIndicator(double progress) {
    return LinearProgressIndicator(
      backgroundColor: Colors.green[50],
      valueColor: AlwaysStoppedAnimation(Colors.green[700]),
      value: progress ?? null,
    );
  }

  static void showToastInstruction(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 18.0,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  static void showToastError(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 18.0,
        backgroundColor: Colors.grey[900],
        textColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  static void showToastSuccess(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 18.0,
        backgroundColor: Colors.green[50],
        textColor: Colors.green[900],
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  static void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String> getCurrentUsername() async {
    try {
      FirebaseUser curUser = await FirebaseAuth.instance.currentUser();
      QuerySnapshot curUserQuery = await Firestore.instance
          .collection('Users')
          .where('email', isEqualTo: curUser.email)
          .getDocuments();
      String username = curUserQuery.documents[0].data['username'];
      return username;
    } catch (e) {
      print("Constant.getCurrentUsername:");
      print(e);
      return null;
    }
  }

  static Future<DocumentReference> getCurrentUserDoc() async {
    FirebaseUser curUser = await FirebaseAuth.instance.currentUser();
    String email = curUser.email;
    QuerySnapshot curUserQuery = await Firestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .getDocuments();
    DocumentReference userDoc = curUserQuery.documents[0].reference;
    return userDoc;
  }

  static Future<bool> isUserProfById({@required String userId}) async {
    try {
      DocumentSnapshot curUser =
          await Firestore.instance.collection('Users').document(userId).get();
      bool isProf = curUser.data['isProf'] as bool;
      return isProf;
    } catch (e) {
      print("isUserProfId");
      print(e);
      return false;
    }
  }

  static void userProfileView(context, {@required String userId}) async {
    showModalBottomSheet(
      context: context,
      elevation: 5.0,
      backgroundColor: Colors.grey[200],
      isDismissible: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints.loose(
            Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height - 40,
            ),
          ),
          child: UserProfile(
            userId: userId,
          ),
        );
      },
    );
  }

  static String formatDateTime(DateTime timestamp) {
    return DateFormat.MMMEd().format(timestamp);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class DarkTheme {
  static get shimmerBaseColor => Colors.grey[800];

  static get shimmerHighLightColor => Colors.grey[700];

  static get chipBackgroundColor => Colors.grey[700];

  static get menuButtonTextStyle => TextStyle(
        fontSize: 24.0,
        color: Colors.grey[300],
        fontWeight: FontWeight.w600,
        fontFamily: 'ValeraRound',
      );

  static get menuButtonIconColor => Colors.grey[200];

  static get menuButtonBackgroundColor => Colors.black87;

  static get fabBackgroundColor => Colors.cyanAccent;

  static get questionTileHeaderBackgroundColor => Colors.grey[800];

  static get ratingBoxBackgroundColor => Colors.grey[700];

  static get upvoteCountTextStyle => TextStyle(
        fontWeight: FontWeight.w500,
        color: upvoteCountColor,
        fontSize: 14.0,
      );

  static get upvoteCountColor => Colors.cyanAccent;

  static get downvoteCountTextStyle => TextStyle(
        fontWeight: FontWeight.w500,
        color: downvoteCountColor,
        fontSize: 14.0,
      );

  static get downvoteCountColor => Colors.red[100];

  static get upvoteButtonBackgroundColor => Colors.blueGrey[700];

  static get upvoteButtonCountColor => Colors.cyanAccent;

  static get upvoteButtonTextStyle => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: upvoteButtonCountColor,
      );

  static get downvoteButtonBackgroundColor => Colors.blueGrey[700];

  static get downvoteButtonCountColor => Colors.red[50];

  static get downvoteButtonTextStyle => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: downvoteButtonCountColor,
      );

  static get headingStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w500,
        fontSize: 28.0,
        color: Color(0xffbbe1fa),
      );

  static get headingDescriptionStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        color: Color(0xffbbe1fa),
      );

  static get textFieldFillColor => Colors.grey[800];

  static get formFieldTextStyle => TextStyle(
      fontSize: 18.0,
      color: Color(0xffd7fffd),
      fontWeight: FontWeight.w500,
  );

  static get formFieldHintStyle => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 14.0,
      color: Colors.grey[400]
  );

  static get counterStyle => TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.grey[200],
      fontSize: 8.0,
  );

  static get formFieldBorder => OutlineInputBorder(
      borderSide: BorderSide(
          color: Color(0xff363062),
      ),
  );

  static get formFieldFocusedBorder => OutlineInputBorder(
      borderSide: BorderSide(
          color: Color(0xff827397),
          width: 2.0,
      ),
  );

  static get formFieldLabelStyle => TextStyle(
      color: Color(0xffbbe1fa),
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
  );

  static get appDrawerMenuStyle => TextStyle();

}

class LightTheme {
  static get shimmerBaseColor => Colors.grey[100];

  static get shimmerHighLightColor => Colors.grey[400];

  static get chipBackgroundColor => Colors.grey[100];

  static get menuButtonTextStyle => TextStyle(
        fontSize: 24.0,
        color: Colors.blue[800],
        fontWeight: FontWeight.w600,
        fontFamily: 'ValeraRound',
      );

  static get menuButtonIconColor => Colors.blue[700];

  static get menuButtonBackgroundColor => Colors.grey[100];

  static get fabBackgroundColor => Colors.blue[700];

  static get questionTileHeaderBackgroundColor => Colors.blue[50];

  static get ratingBoxBackgroundColor => Colors.grey[50];

  static get upvoteCountTextStyle => TextStyle(
        fontWeight: FontWeight.w500,
        color: upvoteCountColor,
        fontSize: 14.0,
      );

  static get upvoteCountColor => Colors.green[500];

  static get downvoteCountTextStyle => TextStyle(
        fontWeight: FontWeight.w500,
        color: downvoteCountColor,
        fontSize: 14.0,
      );

  static get downvoteCountColor => Colors.red[600];

  static get upvoteButtonBackgroundColor => Colors.green[50];

  static get upvoteButtonCountColor => Colors.green[800];

  static get upvoteButtonTextStyle => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: upvoteButtonCountColor,
      );

  static get downvoteButtonBackgroundColor => Colors.red[50];

  static get downvoteButtonCountColor => Colors.redAccent;

  static get downvoteButtonTextStyle => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: downvoteButtonCountColor,
      );

  static get headingStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w500,
        fontSize: 28.0,
        color: Color(0xff053f5e),
      );

  static get headingDescriptionStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        color: Color(0xff053f5e),
      );

  static get textFieldFillColor => Colors.grey[200];

  static get formFieldTextStyle => TextStyle(
      fontSize: 18.0,
      color: Colors.teal[900],
      fontWeight: FontWeight.w500,
  );

  static get formFieldHintStyle => TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 14.0,
      color: Colors.black87
  );

  static get counterStyle => TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.black54,
      fontSize: 8.0,
  );

  static get formFieldBorder => OutlineInputBorder(
      borderSide: BorderSide(
          color: Color(0xffb2ebf2),
      ),
  );

  static get formFieldFocusedBorder => OutlineInputBorder(
      borderSide: BorderSide(
          color: Color(0xff00bcd4),
          width: 2.0,
      ),
  );

  static get formFieldLabelStyle => TextStyle(
      color: Color(0xff053f5e),
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
  );

  static get appDrawerMenuStyle => TextStyle();
}
