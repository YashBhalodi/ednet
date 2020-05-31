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
            )
          ],
        ),
      ),
    );
  }
}
