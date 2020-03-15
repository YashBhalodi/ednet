import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ednet/home_page.dart';

class SetUpProfile extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const SetUpProfile({Key key, @required this.userSnap}) : super(key: key);

  @override
  _SetUpProfileState createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {
  bool isAdmin;

  @override
  void initState() {
    isAdmin = widget.userSnap.data['isAdmin'];
    super.initState();
  }

  Future<void> updateUserProfileStatus() async {
    try {
      widget.userSnap.reference.updateData({'isProfileSet': true});
    } catch (e) {
      print("updateUserProfileStatus");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO different profile set up page for students and university admin
    if (isAdmin) {
      //TODO implement Admin profile setup UI
      return Scaffold(
        body: Text("Admin Configure Profile \n\n" + widget.userSnap.data.toString()),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await updateUserProfileStatus();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return Home(
                    userSnap: widget.userSnap,
                  );
                },
              ),
            );
          },
        ),
      );
    } else {
      //TODO implement student setup profile UI
      return Scaffold(
        body: Text("Student Configure Profile\n\n" + widget.userSnap.data.toString()),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //updating profile
            await updateUserProfileStatus();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return Home(
                    userSnap: widget.userSnap,
                  );
                },
              ),
            );
          },
        ),
      );
    }
  }
}
