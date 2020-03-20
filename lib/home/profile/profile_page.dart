import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const ProfilePage({Key key, this.userSnap}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    User currentUser = User.fromSnapshot(widget.userSnap);
    return Container(
      child: Center(
        child: Text(
          currentUser.toString(),
        ),
      ),
    );
  }
}
