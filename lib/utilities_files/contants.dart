import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Constant {
  static get edgePadding => EdgeInsets.symmetric(
        horizontal: 24.0,
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

  static get greenCircularProgressIndicator => SizedBox(
        height: 32.0,
        width: 32.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.green[800]),
          backgroundColor: Colors.green[50],
        ),
      );

  static get raisedButtonPaddingHigh => EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);

  static get raisedButtonPaddingMedium => EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0);

  static get raisedButtonPaddingLow => EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

  static get scrollAnimationDuration => Duration(milliseconds: 400);

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
    //pass through regex filter
    //check fireStore for username
    //return appropriate boolean
    if (value.contains(' ')) {
      return "Username can't contain space";
    } else {
      final result = await Firestore.instance
          .collection('Users')
          .where('username', isEqualTo: value)
          .getDocuments();
      return result.documents.isEmpty ? null : "Username already in use. Try something else.";
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
}
