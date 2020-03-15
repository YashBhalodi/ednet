import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/home_page.dart';
import 'package:flutter/material.dart';

class StudentProfileSetup extends StatefulWidget {
    final DocumentSnapshot userSnap;

    const StudentProfileSetup({Key key, this.userSnap}) : super(key: key);

    @override
    _StudentProfileSetupState createState() => _StudentProfileSetupState();
}

class _StudentProfileSetupState extends State<StudentProfileSetup> {
    Future<void> updateUserProfileStatus() async {
        try {
            widget.userSnap.reference.updateData({'isProfileSet': true});
        } catch (e) {
            print("updateUserProfileStatus");
            print(e);
        }
    }

    //TODO implement student setup profile UI
    @override
    Widget build(BuildContext context) {
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