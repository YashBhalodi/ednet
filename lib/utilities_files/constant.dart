import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/profile/other_user_profile/user_profile_sheet.dart';
import 'package:ednet/setup/signup_instruction_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class Constant {
  static get reportThreshold => 3;

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

  static get notificationCardMargin => EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 8.0,
  );

  static get formFieldContentPadding => EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 20.0,
      );

  static get zefyrFieldContentPadding => EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 20.0,
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
    final userDoc = await Firestore.instance.collection('Users').document(currentUser.uid).get();
    if (value.contains(' ')) {
      return "Username can't contain space";
    } else if (userDoc.data['username'] == value) {
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
    if (value.trim().length == 0) {
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
    if (value.trim().length == 0) {
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
    if (value.trim().length == 0) {
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
    if (value.trim().length == 0) {
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
    if (value.trim().length == 0) {
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
    if (value.trim().length < 100) {
      Constant.showToastInstruction("Answer should be atleast 100 characters long.");
      return "Please write answer atleast 100 characters long";
    } else {
      return null;
    }
  }

  static String reportCommentValidator(value) {
    if (value.trim().length < 10) {
      return "Description should be atleast 10 characters long";
    } else {
      return null;
    }
  }

  static Widget myLinearProgressIndicator(double progress) {
    return LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.green[700]),
      value: progress ?? null,
    );
  }

  static void showToastInstruction(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 18.0,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
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

  static Future<DocumentReference> getCurrentUserDoc() async {
    FirebaseUser curUser = await FirebaseAuth.instance.currentUser();
    DocumentReference userDoc = Firestore.instance.collection('Users').document(curUser.uid);
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

  static Future<String> getCurrentUserDocId() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser.uid;
  }

  static Future<User> getCurrentUserObject() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userDoc = await Firestore.instance.collection('Users').document(currentUser.uid).get();
    User user = User.fromSnapshot(userDoc);
    return user;
  }

  static void userProfileView(context, {@required String userId}) async {
    showModalBottomSheet(
      context: context,
      elevation: 10.0,
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
          padding: const EdgeInsets.only(bottom:60),
          child: UserProfile(
            userId: userId,
          ),
        );
      },
    );
  }

  static void showNoSignUpDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Your university hasn't applied for ednet yet."),
                SizedBox(
                  height: 32.0,
                ),
                SecondaryCTA(
                  child: Text(
                    "How to join EDNET",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.secondaryCTATextStyle
                        : LightTheme.secondaryCTATextStyle,
                  ),
                  callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpInstruction();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  static void showAccountDisabledDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            title: Text("Account Disabled"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    "We received request from your university admin to temporarily suspend your EDNET account.\n\nYou may have violated the community standard by performing malicious activities.\n\nPlease try again after a while."),
                SizedBox(
                  height: 32.0,
                ),
                SecondaryCTA(
                  child: Text(
                    "OK",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.secondaryCTATextStyle
                        : LightTheme.secondaryCTATextStyle,
                  ),
                  callback: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  static String formatDateTime(DateTime timestamp) {
    return DateFormat.MMMEd().format(timestamp);
  }

  static void defaultVibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 40);
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class DarkTheme {
  static get shimmerBaseColor => Colors.grey[800];
  static get brandingShimmerBaseColor => Colors.blue[400];

  static get shimmerHighLightColor => Colors.grey[700];
  static get brandingShimmerHighlightColor => Colors.blue[600];

  static get chipBackgroundColor => Colors.grey[700];

  static get menuButtonTextStyle => TextStyle(
        fontSize: 24.0,
        color: Colors.grey[300],
        fontWeight: FontWeight.w600,
        fontFamily: 'ValeraRound',
      );

  static get menuButtonIconColor => Colors.grey[50];

  static get menuButtonBackgroundColor => Colors.blueGrey[800];

  static get fabBackgroundColor => Colors.cyanAccent;

  static get questionTileHeaderBackgroundColor => Colors.grey[800];

  static get ratingBoxBackgroundColor => Colors.blueGrey[700];

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

  static get downvoteButtonCountColor => Colors.red[100];

  static get downvoteButtonTextStyle => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: downvoteButtonCountColor,
      );

  static get headingStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w500,
        fontSize: 28.0,
        color: Color(0xfff1f9f9),
      );

  static get headingDescriptionStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        color: Color(0xfff1f9f9),
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
        color: Colors.grey[400],
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

  static get professorUpvoteTextStyle => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Colors.cyanAccent,
      );

  static get questionTileShadow => [
        BoxShadow(
          color: Colors.grey[900],
          offset: Offset(0.0, 3.0),
          blurRadius: 16.0,
        ),
      ];

  static get circularProgressIndicator => SizedBox(
        height: 28.0,
        width: 28.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.cyanAccent),
          backgroundColor: Color(0xff35495e),
        ),
      );

  static get primaryCTABackgroundColor => Color(0xff35495e);

  static get primaryCTATextColor => Colors.cyanAccent;

  static get primaryCTATextStyle => TextStyle(
        fontSize: 18.0,
        color: primaryCTATextColor,
        fontWeight: FontWeight.w600,
      );

  static get secondaryCTATextStyle => TextStyle(
        fontSize: 18.0,
        color: Colors.grey[50],
        fontWeight: FontWeight.w500,
      );

  static get secondaryNegativeTextStyle => TextStyle(
        color: Colors.red[50],
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      );

  static get secondaryHeadingTextStyle => TextStyle(
        color: Color(0xffd7fffd),
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      );

  static get dropDownMenuTitleStyle => TextStyle(
        color: Color(0xffd7fffd),
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      );

  static get outlineButtonTextColor => Color(0xffd7fffd);

  static get outlineButtonTextStyle => TextStyle(
        color: outlineButtonTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      );

  static get outlineButtonBackgroundColor => Colors.blueGrey[800];

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

  static get secondaryCTADisabledColor => Colors.grey[800];

  static get secondaryCTABackgroundColor => Colors.grey[700];

  static get secondaryCTABorderColor => Colors.grey[600];

  static get stepButtonIconColor => Colors.grey[100];

  static get stepButtonBackgroundColor => Colors.grey[700];

  static get stepButtonBorderColor => Colors.grey[600];

  static get stepButtonDisabledColor => Colors.grey[800];

  static get secondaryNegativeCardButtonBackgroundColor => Colors.blueGrey[600];

  static get secondaryPositiveCardButtonBackgroundColor => Colors.blueGrey[600];

  static get secondaryPositiveTextStyle => TextStyle(
        color: Colors.cyanAccent,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      );

  static get tabSelectedLabelColor => Colors.cyanAccent;

  static get tabUnselectedLabelColor => Colors.grey[400];

  static get negativePrimaryButtonColor => Colors.blueGrey[700];

  static get negativePrimaryButtonTextStyle => TextStyle(
        color: Colors.red[100],
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      );

  static get graphBackgroundColor => Colors.blueGrey;

  static get graphValueColor => Color(0xffd7fffd);

  static get graphLabelStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w500,
        fontSize: 28.0,
        color: graphValueColor,
      );

  static get graphDescriptionStyle => TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        color: graphValueColor,
      );

  static get profileSetupBannerColor => Colors.blueGrey[700];

  static get profileSetupBannerTextStyle => TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: Color(0xffd7fffd),
      );

  static get voterTextStyle => TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w300,
      );
  static get notificationCTAColor => Colors.blueGrey[800];

  static get notificationCTATextStyle => TextStyle(
      color: Colors.blue[50],
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
  );

  static get notificationMessageTextStyle => TextStyle(
      fontSize: 14.0,
      color: Colors.blueGrey[100],
      fontWeight: FontWeight.w400,
  );

  static get notificationContentTextStyle => TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.w500
  );

  static get notificationContentBackgroundColor => Colors.black12;

  static get signUpInstructionDescriptionTextStyle => TextStyle(
      fontSize: 18.0,
  );

  static get badgeColor => Colors.blueGrey[900];
  static get badgeTextStyle => TextStyle(color: Colors.cyan);
}

class LightTheme {
  static get shimmerBaseColor => Colors.grey[100];
  static get brandingShimmerBaseColor => Colors.blue[800];

  static get shimmerHighLightColor => Colors.grey[200];
  static get brandingShimmerHighlightColor => Colors.blue[400];

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

  static get questionTileHeaderBackgroundColor => Colors.grey[200];

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
        color: Colors.black87,
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

  static get professorUpvoteTextStyle => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Colors.orange[700],
      );

  static get questionTileShadow => [
        BoxShadow(
          color: Colors.grey[500],
          offset: Offset(0.0, 3.0),
          blurRadius: 16.0,
        ),
      ];

  static get circularProgressIndicator => SizedBox(
        height: 28.0,
        width: 28.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
          backgroundColor: Colors.blue[600],
        ),
      );

  static get primaryCTABackgroundColor => Colors.blue[600];

  static get primaryCTATextColor => Colors.white;

  static get primaryCTATextStyle => TextStyle(
        fontSize: 18.0,
        color: primaryCTATextColor,
        fontWeight: FontWeight.w600,
      );

  static get secondaryCTATextStyle => TextStyle(
        fontSize: 18.0,
        color: Colors.grey[800],
        fontWeight: FontWeight.w500,
      );

  static get secondaryNegativeTextStyle => TextStyle(
        color: Colors.red[500],
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      );

  static get secondaryHeadingTextStyle => TextStyle(
        color: Colors.blue[600],
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      );

  static get dropDownMenuTitleStyle => TextStyle(
        color: Colors.grey[700],
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      );

  static get outlineButtonTextColor => Colors.blue[600];

  static get outlineButtonTextStyle => TextStyle(
        color: outlineButtonTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      );

  static get outlineButtonBackgroundColor => Colors.grey[100];

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

  static get secondaryCTADisabledColor => Colors.grey[300];

  static get secondaryCTABackgroundColor => Colors.white;

  static get secondaryCTABorderColor => Colors.grey[300];

  static get stepButtonIconColor => Colors.grey[800];

  static get stepButtonBackgroundColor => Colors.white;

  static get stepButtonBorderColor => Colors.grey[300];

  static get stepButtonDisabledColor => Colors.grey[300];

  static get secondaryNegativeCardButtonBackgroundColor => Colors.red[50];

  static get secondaryPositiveCardButtonBackgroundColor => Colors.blue[50];

  static get secondaryPositiveTextStyle => TextStyle(
        color: Colors.blue[700],
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      );

  static get tabSelectedLabelColor => Colors.blue[700];

  static get tabUnselectedLabelColor => Colors.blueGrey[600];

  static get negativePrimaryButtonColor => Colors.red[300];

  static get negativePrimaryButtonTextStyle => TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      );

  static get graphBackgroundColor => Colors.grey[500];

  static get graphValueColor => Colors.blue[600];

  static get graphLabelStyle => TextStyle(
        fontFamily: 'VarelaRound',
        fontWeight: FontWeight.w500,
        fontSize: 28.0,
        color: graphValueColor,
      );

  static get graphDescriptionStyle => TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        color: graphValueColor,
      );

  static get profileSetupBannerColor => Colors.green[50];

  static get profileSetupBannerTextStyle => TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: Colors.green[700],
      );

  static get voterTextStyle => TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w300,
      );

  static get notificationCTAColor => Colors.blue[50];

  static get notificationCTATextStyle => TextStyle(
      color: Colors.blue[800],
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
  );

  static get notificationMessageTextStyle => TextStyle(
      fontSize: 14.0,
      color: Colors.blueGrey[900],
      fontWeight: FontWeight.w400,
  );

  static get notificationContentTextStyle => TextStyle(
      fontSize: 16.0,
      color: Colors.black87,
      fontWeight: FontWeight.w500
  );

  static get notificationContentBackgroundColor => Colors.grey[100];

  static get signUpInstructionDescriptionTextStyle => TextStyle(
      fontSize: 18.0,
  );

  static get badgeColor => Colors.grey[200];
  static get badgeTextStyle => TextStyle(color: Colors.blue[800]);
}

class AdConstant {
    static get appID => "ca-app-pub-7887184329758881~3348790982";
    static get bannerAdID => "ca-app-pub-7887184329758881/7901213852";
    static get interstitialAdID => "ca-app-pub-7887184329758881/7709642165";
}