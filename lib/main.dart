import 'package:ednet/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ednet/log_in_page.dart';
import 'package:ednet/home_page.dart';
import 'package:ednet/setup_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  //TODO wrap inherited widget
  //TODO add routing animation package
  //TODO build a file for constants class throughout the app.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasPrimaryFocus == false) {
          FocusScope.of(context).unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Inter',
        ),
        home: StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              FirebaseUser user = snapshot.data;
              if (user == null) {
                return FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, futureSnapshot) {
                    switch (futureSnapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Container(
                          child: Center(
                            child: Text("Loading"),
                          ),
                        );
                      default:
                        if (!futureSnapshot.hasError) {
                          return futureSnapshot.data.getBool("welcome") != null
                              ? LoginPage()
                              : Onboarding();
                        } else {
                          return Container(
                            child: Center(
                              child: Text("Error" + futureSnapshot.error.toString()),
                            ),
                          );
                        }
                    }
                  },
                );
                return LoginPage();
              } else {
                //TODO if the profile is not set, set up the profile
                //TODO if profile is set, open home page
                return Home();
              }
            } else {
              //Internet is not connected.
              print("App main stream builder Snapshot connection state:- " + snapshot.connectionState.toString());
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
