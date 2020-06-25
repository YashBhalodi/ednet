import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/admin/reports/content_report_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ArticleReportedNotificationList extends StatefulWidget {
  final User currentUser;

  const ArticleReportedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  _ArticleReportedNotificationListState createState() => _ArticleReportedNotificationListState();
}

class _ArticleReportedNotificationListState extends State<ArticleReportedNotificationList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(widget.currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: "ArticleReported")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.isEmpty) {
            return Container();
          } else {
            return ExpansionTile(
              title: Text(
                "Reported Articles",
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
                      ArticleReportedNotification articleReportedNotification =
                          ArticleReportedNotification.fromJson(snapshot.data.documents[i]);
                      return ArticleReportedNotificationTile(
                        currentUser: widget.currentUser,
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

  @override
  bool get wantKeepAlive => true;
}

class ArticleReportedNotificationTile extends StatelessWidget {
  final User currentUser;
  final ArticleReportedNotification notification;

  const ArticleReportedNotificationTile({Key key, this.currentUser, this.notification})
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
                  "This article has been reported",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.notificationMessageTextStyle
                      : LightTheme.notificationMessageTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('Articles')
                    .document(notification.articleId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      notification.remove();
                      return Container();
                    } else {
                      Article a = Article.fromSnapshot(snapshot.data);
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
                          a.title,
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
                    .collection('Articles')
                    .document(notification.articleId)
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
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
