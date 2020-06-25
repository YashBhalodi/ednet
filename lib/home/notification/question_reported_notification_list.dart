import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/admin/reports/content_report_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class QuestionReportedNotificationList extends StatefulWidget {
  final User currentUser;

  const QuestionReportedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  _QuestionReportedNotificationListState createState() => _QuestionReportedNotificationListState();
}

class _QuestionReportedNotificationListState extends State<QuestionReportedNotificationList> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(widget.currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: "QuestionReported")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.isEmpty) {
            return Container();
          } else {
            return ExpansionTile(
              title: Text(
                "Reported Questions",
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
                      QuestionReportedNotification questionReportedNotification =
                          QuestionReportedNotification.fromJson(snapshot.data.documents[i]);
                      return QuestionReportedNotificationTile(
                        currentUser: widget.currentUser,
                        notification: questionReportedNotification,
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

  @override
  bool get wantKeepAlive => true;
}

class QuestionReportedNotificationTile extends StatelessWidget {
  final User currentUser;
  final QuestionReportedNotification notification;

  const QuestionReportedNotificationTile({Key key, this.currentUser, this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      onDismissed: (x) {
        notification.remove();
      },
      background: NotificationDismissBackground(),
      child: Card(
        margin: Constant.notificationCardMargin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
                child: Text(
                  "This question has been reported",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.notificationMessageTextStyle
                      : LightTheme.notificationMessageTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('Questions')
                    .document(notification.questionId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      notification.remove();
                      return Container();
                    } else {
                      Question q = Question.fromSnapshot(snapshot.data);
                      return Container(
                        width: double.maxFinite,
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            color: Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.notificationContentBackgroundColor
                                : LightTheme.notificationContentBackgroundColor),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        child: Text(
                          q.heading,
                          style: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.notificationContentTextStyle
                              : LightTheme.notificationContentTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }
                  } else {
                    //TODO shimmer
                    return Container();
                  }
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                "Reportd violations:",
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.notificationMessageTextStyle
                    : LightTheme.notificationMessageTextStyle,
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('Questions')
                    .document(notification.questionId)
                    .collection('reports')
                    .document(notification.reportId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null || snapshot.data.data == null) {
                      notification.remove();
                      return Container();
                    } else {
                      Report report = Report.fromSnapshot(snapshot.data);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical:12.0),
                        child: Container(
                          decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.notificationContentBackgroundColor
                                  : LightTheme.notificationContentBackgroundColor),
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              MarkdownBody(
                                shrinkWrap: true,
                                data: ReportReviewFlow.violationsMarkdown(report.violations),
                              ),
                              //comment
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? DarkTheme.chipBackgroundColor
                                          : LightTheme.chipBackgroundColor,
                                      width: 4.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  report.comment,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
