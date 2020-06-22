import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpInstruction extends StatelessWidget {
  final String aboutText =
      "EDNET is a network made up of students and professors from various educational institutes from all around the world.\n\nTo make this network of authenticated peers, EDNET relies on instituition provided emails as a verified member of institution.\n\nAny educational institution can join EDNET.";
  final String studentInstruction =
      "You can send an email to administration of your institute.\n\nWe have already written the email to save you the trouble of explaining what is EDNET.\n\nOnce administration applies to join EDNET, they should inform you of activation of your EDNET account.\n\nAfter that, you can login using institute approved email address.\n\nTo proceed, simply tap the below button and edit the destination email with appropriate email of your institute admin.";
  final String adminInstruction1 =
      """Institute admin need to provide us all the institute-verified email ids and their user type.\n\nThis list of email ids should be in a csv or excel file.\n\n\u2022 First column should contain email ids.\n\u2022 Second column should contain user type.\n\nUser type can be one of the following.\n\t\t\u2022 student\n\t\t\u2022 professor\n\t\t\u2022 admin\n\nEmail this file to us on """;
  final String adminInstruction2 = " along with basic information about your institution.";


  final String _adminEmailString = Uri.encodeFull('mailto:contact.ednet@gmail.com?subject=Wish to join EDNET!&body=...Please tell us little bit about your institute...\n...Make sure to attach the csv file containing all valid email ids and user types...');

  final String _userEmailString = Uri.encodeFull('mailto:contact.ednet@gmail.com?subject=Wish to join EDNET!&body=EDNET is cool.'); //TODO draft email content

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Join EDNET",
            style: Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.appBarTextStyle
                : LightTheme.appBarTextStyle,
          ),
        ),
        body: Scrollbar(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 24.0),
                child: Text(
                  aboutText,
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.signUpInstructionDescriptionTextStyle
                      : LightTheme.signUpInstructionDescriptionTextStyle,
                ),
              ),
              ExpansionTile(
                initiallyExpanded: false,
                title: Text(
                  "For students or professors",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.dropDownMenuTitleStyle
                      : LightTheme.dropDownMenuTitleStyle,
                ),
                children: <Widget>[
                  const SizedBox(height: 16.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      studentInstruction,
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.signUpInstructionDescriptionTextStyle
                          : LightTheme.signUpInstructionDescriptionTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: BlueOutlineButton(
                      child: Text(
                        "Send Email",
                        style: Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.secondaryCTATextStyle
                            : LightTheme.secondaryCTATextStyle,
                      ),
                      callback: () async {
                        if (await canLaunch(_userEmailString.toString())) {
                          await launch(_userEmailString.toString());
                        } else {
                          Constant.showToastError("Could not launch Email Client.");
                          throw 'Could not launch $_userEmailString';
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0,),
                ],
              ),
              ExpansionTile(
                initiallyExpanded: false,
                title: Text("For university admins",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.dropDownMenuTitleStyle
                        : LightTheme.dropDownMenuTitleStyle),
                children: <Widget>[
                  const SizedBox(height: 16.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16.0),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.signUpInstructionDescriptionTextStyle
                            : LightTheme.signUpInstructionDescriptionTextStyle,
                        children: [
                          TextSpan(
                            text: adminInstruction1,
                          ),
                          TextSpan(
                              text: "contact.ednet@gmail.com",
                              style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue[500]),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  if (await canLaunch(_adminEmailString)) {
                                  await launch(_adminEmailString);
                                  } else {
                                    Constant.showToastError("Could not launch Email Client.");
                                    throw 'Could not launch $_adminEmailString';
                                  }
                                }),
                          TextSpan(
                            text: adminInstruction2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0,),
                ],
              ),
              const SizedBox(height: 60,),
            ],
          ),
        ),
      ),
    );
  }
}
