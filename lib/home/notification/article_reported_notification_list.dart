import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:flutter/material.dart';

class ArticleReportedNotificationList extends StatelessWidget {
  final User currentUser;

  const ArticleReportedNotificationList({Key key, this.currentUser}) : super(key: key);
    @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(currentUser.id)
            .collection('notifications')
            .where('type', isEqualTo: "ArticleReported")
            .snapshots(),
        builder: (context, snapshot) {
            if (snapshot.hasData) {
                if (snapshot.data.documents.isEmpty) {
                    return Container();
                } else {
                    return ExpansionTile(
                        title: ListTile(
                            title: Text(
                                "Reported Articles",
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
                                    ArticleReportedNotification articleReportedNotification =
                                    ArticleReportedNotification.fromJson(snapshot.data.documents[i]);
                                    return ArticleReportedNotificationTile(
                                        currentUser: currentUser,
                                        notification: articleReportedNotification,
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

class ArticleReportedNotificationTile extends StatelessWidget {
    final User currentUser;
    final ArticleReportedNotification notification;

  const ArticleReportedNotificationTile({Key key, this.currentUser, this.notification}) : super(key: key);
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
