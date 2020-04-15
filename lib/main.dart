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
        /*Crashlytics.instance.recordError(e, s);
        Crashlytics.instance.recordFlutterError(e);
        FlutterError.dumpErrorToConsole(e);*/
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

          //TODO see if the user account is disabled or not.
          /*
          user.reload().catchError((e) {
            PlatformException err = e;
            if (err.code == "ERROR_USER_DISABLED") {
              validSession = false;
              Constant.showAccountDisabledDialog(context);
            }
          });
          */

          if (validSession) {
            DocumentSnapshot universitySnap;
            DocumentSnapshot userDocSnapshot;
            Future<QuerySnapshot> retrieveData() async {
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
