import 'package:ednet/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ednet/login_page.dart';
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
        home: EntryPoint(),
      ),
    );
  }
}

//Stream builder widget to handle entry point decisions
class EntryPoint extends StatefulWidget {
  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  //TODO FIX streamBuilder sometimes update two times in the beginning.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
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
                    return Scaffold(
                      body: Container(
                        child: Center(
                          child: Text("Loading"),
                        ),
                      ),
                    );
                  default:
                    if (!futureSnapshot.hasError) {
                      return futureSnapshot.data.getBool("welcome") != null
                             ? LoginPage()
                             : Onboarding();
                    } else {
                      return Scaffold(
                        body: Container(
                          child: Center(
                            child: Text("Error" + futureSnapshot.error.toString()),
                          ),
                        ),
                      );
                    }
                }
              },
            );
          } else {
            return FutureBuilder(
              future: Firestore.instance
                  .collection('Users')
                  .where('email', isEqualTo: user.email)
                  .getDocuments(),
              builder: (context, profileSnapshot) {
                switch (profileSnapshot.connectionState) {
                  case ConnectionState.none:
                    return Scaffold(
                      body: Container(
                        child: Center(
                          child: Text(
                            "state : none",
                          ),
                        ),
                      ),
                    );
                    break;
                  case ConnectionState.waiting:
                    return Scaffold(
                      body: Container(
                        child: Center(
                          child: Text(
                            "state : waiting",
                          ),
                        ),
                      ),
                    );
                    break;
                  case ConnectionState.active:
                    return Scaffold(
                      body: Container(
                        child: Center(
                          child: Text(
                            "state : waiting",
                          ),
                        ),
                      ),
                    );
                    break;
                  case ConnectionState.done:
                    if (!profileSnapshot.hasError) {
                      DocumentSnapshot userDocSnapshot = profileSnapshot.data.documents[0];
                      print(userDocSnapshot.data);
                      bool isProfileSet = userDocSnapshot['isProfileSet'];
                      print("132 isProfileSet"+isProfileSet.toString());
                      if (isProfileSet) {
                        return Home(userSnap: userDocSnapshot,);
                      } else {
                        return SetUpProfile(userSnap: userDocSnapshot,);
                      }
                    } else {
                      return Scaffold(
                        body: Container(
                          child: Center(
                            child: Text(
                              "Error!",
                            ),
                          ),
                        ),
                      );
                    }
                    break;
                  default:
                    {
                      return Scaffold(
                        body: Container(
                          child: Center(
                            child: Text(
                              "state : default",
                            ),
                          ),
                        ),
                      );
                    }
                }
              },
            );
          }
        } else {
          //Internet is not connected.
          print("App main stream builder Snapshot connection state:- " +
              snapshot.connectionState.toString());
          return Scaffold(
            body: Container(
              child: Center(
                child: Text("No Internet!"),
              ),
            ),
          );
        }
      },
    );
  }
}

