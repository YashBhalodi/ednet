import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:flutter/material.dart';

class ArticlePostedNotificationList extends StatelessWidget {
  final User currentUser;

  const ArticlePostedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: "ArticlePosted")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.isEmpty) {
            return Container();
          } else {
              return ExpansionTile(
                  title: Text(
                      "New Articles",
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
                              ArticlePostedNotification articlePostedNotification =
                              ArticlePostedNotification.fromJson(snapshot.data.documents[i]);
                              return ArticlePostedNotificationTile(
                                  currentUser: currentUser,
                                  notification: articlePostedNotification,
                              );
                          },
                      ),
                  ],
              );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class ArticlePostedNotificationTile extends StatelessWidget {
  final User currentUser;
  final ArticlePostedNotification notification;

  const ArticlePostedNotificationTile({Key key, this.currentUser, this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
