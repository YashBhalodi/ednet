import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:flutter/material.dart';

class AnswerRemovedNotificationList extends StatelessWidget {
  final User currentUser;

  const AnswerRemovedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: "AnswerRemoved")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.isEmpty) {
            return Container();
          } else {
            return ExpansionTile(
              title: Text(
                "Removed Answer",
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
                      AnswerRemovedNotification answerRemovedNotification =
                          AnswerRemovedNotification.fromJson(snapshot.data.documents[i]);
                      return AnswerRemovedNotificationTile(
                        currentUser: currentUser,
                        notification: answerRemovedNotification,
                      );
                    }),
              ],
            );
          }
        } else {
          //TODO shimmer
          return Container();
        }
      },
    );
  }
}

class AnswerRemovedNotificationTile extends StatelessWidget {
  final User currentUser;
  final AnswerRemovedNotification notification;

  const AnswerRemovedNotificationTile({Key key, this.currentUser, this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO fix UI
    //TODO Target launch
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
