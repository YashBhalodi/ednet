import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:flutter/material.dart';

class AnswerPostedNotificationList extends StatelessWidget {
  final User currentUser;

  const AnswerPostedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: "AnswerPosted")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.isEmpty) {
            return Container();
          } else {
              return ExpansionTile(
                  title: Text(
                      "New Answers",
                      style: Theme.of(context).brightness == Brightness.dark
                             ? DarkTheme.dropDownMenuTitleStyle
                             : LightTheme.dropDownMenuTitleStyle,
                  ),
                  initiallyExpanded: true,
                  children: <Widget>[
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, i) {
                              AnswerPostedNotification answerPostedNotification =
                              AnswerPostedNotification.fromJson(snapshot.data.documents[i]);
                              return AnswerPostedNotificationTile(
                                  notification: answerPostedNotification,
                                  currentUser: currentUser,
                              );
                          },
                      )
                  ],
              );
          }
        } else {
          return SizedBox(
              height: 50,
              child: Center(
                  child: CircularProgressIndicator(),
              ),
          );
        }
      },
    );
  }
}

class AnswerPostedNotificationTile extends StatelessWidget {
  final User currentUser;
  final AnswerPostedNotification notification;

  const AnswerPostedNotificationTile({Key key, this.currentUser, this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
      //TODO FIX UI
    return Dismissible(
      key: Key(notification.id),
      onDismissed: (x) {
        notification.remove();
      },
      child: Text(
        notification.toString(),
      ),
    );
  }
}
