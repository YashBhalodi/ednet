import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
    final User currentUser;

  const NotificationPage({Key key, this.currentUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: Theme.of(context).brightness == Brightness.dark
              ? DarkTheme.appBarTextStyle
              : LightTheme.appBarTextStyle,
        ),
      ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('Users').document(currentUser.id).collection('notifications').snapshots(),
            builder: (context,snapshot){
                if(snapshot.hasData){
                    //TODO UI
                    print(snapshot.data.documents);
                    return Text("Notification loaded");
                } else {
                    //TODO shimmer
                    return Center(child: CircularProgressIndicator());
                }
            },
        ),
    );
  }
}
