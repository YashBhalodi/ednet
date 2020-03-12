import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ednet/log_in_page.dart';
import 'package:ednet/home_page.dart';
import 'package:ednet/setup_profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  //TODO wrap inherited widget
  //TODO wrap defocuser gesture detector
  //TODO import font families
  //TODO add routing animation package
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasPrimaryFocus == false) {
          FocusScope.of(context).unfocus();
        }
      },
      child: MaterialApp(
        home: StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              FirebaseUser user = snapshot.data;
              if (user == null) {
                //TODO if the app is being opened first time, show Onboarding. else Login page.
                return LoginPage();
              } else {
                //TODO if the profile is not set, set up the profile
                //TODO if profile is set, open home page
                return Home();
              }
            } else {
              //Internet is not connected.
              print("Snapshot connection state:-" + snapshot.connectionState.toString());
              return Container(
                child: Center(
                  child: Text("No Internet!"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
