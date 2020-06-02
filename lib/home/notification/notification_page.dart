import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/notification/answer_posted_notification_list.dart';
import 'package:ednet/home/notification/answer_removed_notification_list.dart';
import 'package:ednet/home/notification/answer_reported_notification_list.dart';
import 'package:ednet/home/notification/article_posted_notification_list.dart';
import 'package:ednet/home/notification/article_removed_notificaton_list.dart';
import 'package:ednet/home/notification/article_reported_notification_list.dart';
import 'package:ednet/home/notification/question_posted_notifications_list.dart';
import 'package:ednet/home/notification/question_removed_notification_list.dart';
import 'package:ednet/home/notification/question_reported_notification_list.dart';
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: (){
              Constant.showToastInstruction("Dismiss notifications by swiping it horizontally.");
            },
          ),
        ]
      ),
      body: Scrollbar(
        child: ListView(
          children: <Widget>[
            QuestionPostedNotificationList(
              currentUser: currentUser,
            ),
            AnswerPostedNotificationList(
              currentUser: currentUser,
            ),
            ArticlePostedNotificationList(
              currentUser: currentUser,
            ),
            QuestionReportedNotificationList(
              currentUser: currentUser,
            ),
            AnswerReportedNotificationList(
              currentUser: currentUser,
            ),
            ArticleReportedNotificationList(
              currentUser: currentUser,
            ),
            QuestionRemovedNotificationList(
              currentUser: currentUser,
            ),
            AnswerRemovedNotificationList(
              currentUser: currentUser,
            ),
            ArticleRemovedNotificationList(
              currentUser: currentUser,
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection("Users")
                  .document(currentUser.id)
                  .collection('notifications')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.documents.isEmpty) {
                    //TODO better no notification message
                    return Container(
                      height: 350,
                      child: Center(
                        child: Text(
                          "Zero Notification",
                          style: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.headingStyle
                              : LightTheme.headingStyle,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
