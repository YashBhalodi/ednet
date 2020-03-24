import 'dart:core';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  static get formFieldTextStyle => TextStyle(
        fontSize: 18.0,
        color: Colors.teal[900],
        fontWeight: FontWeight.w500,
      );

  static get formFieldHintStyle => TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: 14.0,
        color: Colors.black87,
      );

  static get counterStyle => TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black54,
        fontSize: 8.0,
      );

  static get formFieldContentPadding => EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 20.0,
      );

  static get formFieldBorder => OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.teal[300],
        ),
      );

  static get formFieldFocusedBorder => OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.cyan[500],
          width: 2.0,
        ),
      );

  static get formFieldLabelStyle => TextStyle(
        color: Colors.blue[900],
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      );

  static get sectionHeadingStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w500,
        fontSize: 36.0,
        color: Colors.blueGrey[800],
      );

  static get sectionSubHeadingStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w500,
        fontSize: 28.0,
        color: Colors.deepPurple[800],
      );

  static get sectionSubHeadingDescriptionStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        color: Colors.deepPurple[800],
      );

  static get greenCircularProgressIndicator => SizedBox(
        height: 28.0,
        width: 28.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.green[800]),
          backgroundColor: Colors.green[50],
        ),
      );

  static get raisedButtonPaddingHigh => EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0,);

  static get raisedButtonPaddingMedium => EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0,);

  static get raisedButtonPaddingLow => EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,);

  static get scrollAnimationDuration => Duration(milliseconds: 400,);

  static get pageAnimationDuration => Duration(milliseconds: 600,);

  //TODO style this
  static get bottomNavigationTitleStyle => TextStyle();

  //TODO style this
  static get appDrawerMenuStyle => TextStyle();

  static get menuButtonTextStyle => TextStyle(
      fontSize: 24.0,
      color: Colors.blue[800],
      fontWeight: FontWeight.w600,
      fontFamily: 'ValeraRound');

  static get primaryCTATextStyle => TextStyle(
        fontSize: 20.0,
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

  static get secondaryNegativeTextStyle => TextStyle(color: Colors.red[500],fontSize: 16.0,fontWeight: FontWeight.w600,);

  static get secondaryBlueTextStyle => TextStyle(color: Colors.blue[500],fontSize: 16.0,fontWeight: FontWeight.w600,);

  static get appBarTextStyle => TextStyle(
        fontFamily: 'ValeraRound',
        fontWeight: FontWeight.w700,
      );

  static get questionHeadingStyle => TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
  );

  static get questionDescriptionStyle => TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
  );

  static get dateTimeStyle => TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w300,
      color: Colors.black54,
  );

  static get dateTimeMediumStyle => TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w300,
      color: Colors.black54,
  );

  static get usernameStyle => TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,

  );

  static get usernameMediumStyle => TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,);

  static get topicStyle => TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
  );

  static get articleTitleStyle => TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
  );

  static get articleSubtitleStyle => TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w400,
      color: Colors.grey[800],
  );

  static get articleContentStyle => TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
  );

  static get answerThumbContentStyle => TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w300,
      color: Colors.black,
  );

  static get answerContentStyle => TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
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

  //TODO toast instruction for validator violations

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
    if (value.length == 0) {
      return "Please provide mobile number";
    } else if (value.length != 10) {
      return "This mobile number is not valid";
    } else {
      return null;
    }
  }

  static String questionHeadingValidator(value) {
    if (value.length < 10) {
      return "Heading needs atleast 10 characters";
    } else {
      return null;
    }
  }

  static String questionDescriptionValidator(value) {
    if (value.length < 20) {
      return "Please, describe question in atleast 20 characters";
    } else {
      return null;
    }
  }

  static String articleTitleValidator(value){
      if(value.length<10) {
          return "Article title should be atleast 10 charactes long";
      } else {
          return null;
      }
  }

  static String articleSubtitleValidator(value){
      if(value.length<20) {
          return "Article Subtitle should be atleast 20 charactes long";
      } else {
          return null;
      }
  }

  static String articleContentValidator(value){
      if(value.length<100) {
          return "Article content should be atleast 100 charactes long";
      } else {
          return null;
      }
  }

  static String answerValidator(value){
      if(value.length<100) {
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
      value: progress??null,
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

  static Future<DocumentReference> getUserDocRef(String username) async {
      QuerySnapshot curUserQuery = await Firestore.instance.collection('Users').where('username',isEqualTo: username).getDocuments();
      DocumentReference userDoc = curUserQuery.documents[0].reference;
      return userDoc;
  }

  static Future<DocumentReference> getCurrentUserDoc() async {
      FirebaseUser curUser = await FirebaseAuth.instance.currentUser();
      String email = curUser.email;
      QuerySnapshot curUserQuery = await Firestore.instance.collection('Users').where('email',isEqualTo: email).getDocuments();
      DocumentReference userDoc = curUserQuery.documents[0].reference;
      return userDoc;
  }
  static Future<bool> isUserProf(String username) async {
      try {
          QuerySnapshot curUserQuery = await Firestore.instance.collection('Users').where('username',isEqualTo: username).getDocuments();
          bool isProf = curUserQuery.documents[0].data['isProf'] as bool;
          return isProf;
      } catch (e) {
          print("isUserProf");
          print(e);
      }
  }

  static String formatDateTime(DateTime timestamp){
      return DateFormat.MMMEd().format(timestamp);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
