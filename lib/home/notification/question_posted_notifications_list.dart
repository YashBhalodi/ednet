import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:flutter/material.dart';

class QuestionPostedNotificationList extends StatelessWidget {
  final User currentUser;

  const QuestionPostedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: "QuestionPosted")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.isEmpty) {
            return Container();
          } else {
            return ExpansionTile(
              title: ListTile(
                title: Text(
                  "New Questions",
                  style: Theme.of(context).brightness == Brightness.dark
                         ? DarkTheme.dropDownMenuTitleStyle
                         : LightTheme.dropDownMenuTitleStyle,
                ),
              ),
              initiallyExpanded: true,
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) {
                      QuestionPostedNotification questionPostedNotification =
                      QuestionPostedNotification.fromJson(snapshot.data.documents[i]);
                      return QuestionPostedNotificationTile(
                        currentUser: currentUser,
                        notification: questionPostedNotification,
                      );
                    }),
              ],
            );
          }
        } else {
          //TODO shimmer
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

class QuestionPostedNotificationTile extends StatelessWidget {
  final QuestionPostedNotification notification;
  final User currentUser;

  const QuestionPostedNotificationTile({Key key, this.notification, this.currentUser})
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
