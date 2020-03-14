import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ednet/home_page.dart';

class SetUpProfile extends StatefulWidget {
    final DocumentSnapshot userSnap;

  const SetUpProfile({Key key,@required this.userSnap}) : super(key: key);
    @override
    _SetUpProfileState createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {
    @override
    Widget build(BuildContext context) {
        //TODO different profile set up page for students and university admin
        return Scaffold(
            body: Text("Configure Profile\n\n" + widget.userSnap.data.toString()),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                    //updating profile
                    try {
                        QuerySnapshot docRef = await Firestore.instance
                            .collection('Users')
                            .where('email', isEqualTo: widget.userSnap.data['email'])
                            .getDocuments();
                        await Firestore.instance
                            .collection('Users')
                            .document(docRef.documents[0].documentID)
                            .updateData({'isProfileSet': true});
                    } catch (e) {
                        print(e);
                    }
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                        return Home(userSnap: widget.userSnap,);
                    }));
                },
            ),
        );
    }
}
