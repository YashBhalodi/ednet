import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/home_page.dart';
import 'package:ednet/setup/onboarding_page.dart';
import 'package:ednet/setup/profile_setup_pages/admin_profile_page.dart';
import 'package:ednet/setup/profile_setup_pages/student_profile_page.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
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
          buttonTheme: ButtonThemeData(minWidth: 40.0,),
        ),
        home: EntryPoint(),
        debugShowCheckedModeBanner: false,
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
                      body: ShimmerMainHome(),
                    );
                  default:
                    if (!futureSnapshot.hasError) {
                      return futureSnapshot.data.getBool("welcome") != null
                          ? Onboarding(
                              isLogin: true,
                            )
                          : Onboarding(
                              isLogin: false,
                            );
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
            DocumentSnapshot universitySnap;
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

            return FutureBuilder(
              future: retrieveData(),
              builder: (context, profileSnapshot) {
                switch (profileSnapshot.connectionState) {
                  case ConnectionState.none:
                    return Scaffold(
                      body: ShimmerMainHome(),
                    );
                    break;
                  case ConnectionState.waiting:
                    return Scaffold(
                      body: ShimmerMainHome(),
                    );
                    break;
                  case ConnectionState.active:
                    return Scaffold(
                      body: ShimmerMainHome(),
                    );
                    break;
                  case ConnectionState.done:
                    if (!profileSnapshot.hasError) {
                      DocumentSnapshot userDocSnapshot = profileSnapshot.data.documents[0];
                      bool isProfileSet = userDocSnapshot['isProfileSet'];
                      if (isProfileSet) {
                        return Home(
                          userSnap: userDocSnapshot,
                        );
                      } else {
                        bool isAdmin = userDocSnapshot['isAdmin'] as bool;
                        if (isAdmin) {
                          return AdminProfileSetup(
                              userSnap: userDocSnapshot, universitySnap: universitySnap);
                        } else {
                          return StudentProfileSetup(
                            userSnap: userDocSnapshot,
                          );
                        }
                      }
                    } else {
                      return Scaffold(
                        body: Container(
                          child: Center(
                            child: Text(
                              "Error" + snapshot.error.toString(),
                            ),
                          ),
                        ),
                      );
                    }
                    break;
                  default:
                    {
                      return Scaffold(
                        body: ShimmerMainHome(),
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
