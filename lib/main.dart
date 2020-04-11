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
    Crashlytics.instance.setUserEmail('yashbhalodi007@gmail.com');
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
      onError: (error) {
        Crashlytics.instance.recordFlutterError(error);
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
  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    FirebaseAuth.instance.onAuthStateChanged.listen(
          (user) async {
        print("line 205:- stream listening");
        //No user logged in
        if (user == null) {
          print("line 208:- no user");
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
          print("line 233:- user logged in");
          DocumentSnapshot universitySnap;
          DocumentSnapshot userDocSnapshot;
          Future<QuerySnapshot> retrieveData() async {
            print("retrieveData() called");
            QuerySnapshot userProfileResponse;
            try {
              userProfileResponse = await Firestore.instance
                  .collection('Users')
                  .where('email', isEqualTo: user.email)
                  .getDocuments();
              String uniName = userProfileResponse.documents[0].data['university'];
              final universityResponse = await Firestore.instance
                  .collection('University')
                  .where('name', isEqualTo: uniName)
                  .getDocuments();
              universitySnap = universityResponse.documents[0];
            } catch (e) {
              print("retrieveData:-");
              print(e);
            }
            return userProfileResponse;
          }

          await retrieveData().then((v) {
            print(v.documents[0]);
            userDocSnapshot = v.documents[0];
          });
          bool isProfileSet = userDocSnapshot['isProfileSet'];
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
            bool isAdmin = userDocSnapshot['isAdmin'] as bool;
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
