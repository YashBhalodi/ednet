import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const Home({Key key,@required this.userSnap}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Home Page"),
            Text(widget.userSnap.data.toString()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
          } catch (e) {
            print(e.toString());
          }
        },
      ),
    );
  }
}
