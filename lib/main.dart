import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:ednet/home/home_page.dart';
import 'package:ednet/setup/onboarding_page.dart';
import 'package:ednet/setup/profile_setup_pages/admin_profile_page.dart';
import 'package:ednet/setup/profile_setup_pages/student_profile_page.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Crashlytics.instance.enableInDevMode = true;
    FlutterError.onError = (error) {
      // dumps errors to console
      FlutterError.dumpErrorToConsole(error);
      // re-throws error so that `runZoned` handles it
      throw error;
    };
    runZoned<Future<void>>(
          () async {
        runApp(MyApp(pref: pref));
      },
      onError: (e, s) {
        Crashlytics.instance.recordError(e, s);
      },
    );
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences pref;

  const MyApp({Key key, this.pref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasPrimaryFocus == false) {
          FocusScope.of(context).unfocus();
        }
      },
      child: DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => ThemeData(
          fontFamily: 'Inter',
          buttonTheme: ButtonThemeData(
            minWidth: 40.0,
          ),
          brightness: brightness,
          errorColor: brightness == Brightness.dark
                      ? Colors.red[100]
                      : Colors.red[700],
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            theme: theme,
            home: EntryPoint(
              pref: pref,
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class EntryPoint extends StatefulWidget {
  final SharedPreferences pref;

  const EntryPoint({Key key, this.pref}) : super(key: key);

  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  QuerySnapshot queryDocRef;

  Future<void> _updateSignUpStatus(String email) async {
    try {
      await queryDocRef.documents[0].reference.updateData({'signup_status': true});
    } catch (e) {
      print("_updateSignUpStatus");
      print(e);
    }
  }

  Future<void> _createRelevantDocument(String uid, String email) async {
    bool isAdmin = queryDocRef.documents[0]['type'] == "admin"
                   ? true
                   : false;
    bool isProf = queryDocRef.documents[0]['type'] == "prof"
                  ? true
                  : false;
    String userUniversity = queryDocRef.documents[0]['university'];
    //create user document
    try {
      var userDocRef = Firestore.instance.collection('Users').document(uid);
      await userDocRef.setData({
        'email': email,
        'isProfileSet': false,
        'isAdmin': isAdmin,
        'university': userUniversity,
        'isProf': isProf,
      });
    } catch (e) {
      print("_createRelevantDocument_user");
      print(e);
    }
    //create university document if user is admin
    if (isAdmin) {
      try {
        DocumentReference uniDocRef = Firestore.instance.collection('University').document(uid);
        await uniDocRef.setData({
          'name': userUniversity,
        });
      } catch (e) {
        print("_createRelevantDocument_university");
        print(e);
      }
    }
  }

  Future<bool> _isFirstSignUp(String email) async {
    queryDocRef = await Firestore.instance
        .collection('SignUpApplications')
        .where('email', isEqualTo: email)
        .getDocuments();
    bool signUpStat = queryDocRef.documents[0].data['signup_status'] as bool;
    return !signUpStat;
  }

  @override
  void didChangeDependencies() {
    FirebaseAuth.instance.onAuthStateChanged.listen(
          (user) async {
        //No user logged in
        if (user == null) {
          //Not first time app use
          if (widget.pref.getBool("welcome") != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Onboarding(
                    isLogin: true,
                  );
                },
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Onboarding(
                    isLogin: false,
                  );
                },
              ),
            );
          }
        } else {
          //User logged in
          bool validSession = true;
          if (validSession) {
            DocumentSnapshot universitySnap;
            DocumentSnapshot userDocSnapshot;
            bool isAdmin;
            bool firstSignUp;
            Future<void> retrieveData() async {
              firstSignUp = await _isFirstSignUp(user.email);
              print("firstSignUp $firstSignUp");
              if (firstSignUp) {
                await _createRelevantDocument(user.uid, user.email);
                await _updateSignUpStatus(user.email);
              }
              try {
                userDocSnapshot =
                await Firestore.instance.collection('Users').document(user.uid).get();
                print("userDocSnapshot == ${userDocSnapshot.data}");
                isAdmin = userDocSnapshot.data['isAdmin'];
                if (isAdmin) {
                  universitySnap =
                  await Firestore.instance.collection('University').document(user.uid).get();
                }
              } catch (e, s) {
                print("retrieveData:-");
                print(e);
                print(s);
              }
              return userDocSnapshot;
            }

            await retrieveData();
            bool isProfileSet = userDocSnapshot.data['isProfileSet'];
            if (isProfileSet) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Home(
                      userSnap: userDocSnapshot,
                    );
                  },
                ),
              );
            } else {
              if (isAdmin) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AdminProfileSetup(
                        userSnap: userDocSnapshot,
                        universitySnap: universitySnap,
                      );
                    },
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return StudentProfileSetup(
                        userSnap: userDocSnapshot,
                      );
                    },
                  ),
                );
              }
            }
          }
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    print('171___EntryPointState___EntryPointState.dispose__main.dart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShimmerMainHome(),
    );
  }
}
