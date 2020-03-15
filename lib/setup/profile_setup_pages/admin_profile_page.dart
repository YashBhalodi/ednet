import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/home_page.dart';
import 'package:flutter/material.dart';

class AdminProfileSetup extends StatefulWidget {
    final DocumentSnapshot userSnap;

    const AdminProfileSetup({Key key, this.userSnap}) : super(key: key);

    @override
    _AdminProfileSetupState createState() => _AdminProfileSetupState();
}

class _AdminProfileSetupState extends State<AdminProfileSetup> {

    Future<void> updateUserProfileStatus() async {
        try {
            widget.userSnap.reference.updateData({'isProfileSet': true});
        } catch (e) {
            print("updateUserProfileStatus");
            print(e);
        }
    }

    //TODO implement Admin profile setup UI
    @override
    Widget build(BuildContext context) {
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
    }
}
