import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/question/question_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class QuestionPostedNotificationList extends StatefulWidget {
  final User currentUser;

  const QuestionPostedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  _QuestionPostedNotificationListState createState() => _QuestionPostedNotificationListState();
}

class _QuestionPostedNotificationListState extends State<QuestionPostedNotificationList> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(widget.currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: "QuestionPosted")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.isEmpty) {
            return Container();
          } else {
            return ExpansionTile(
              title: Text(
                "New Questions",
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
                      QuestionPostedNotification questionPostedNotification =
                          QuestionPostedNotification.fromJson(snapshot.data.documents[i]);
                      return QuestionPostedNotificationTile(
                        currentUser: widget.currentUser,
                        notification: questionPostedNotification,
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

class QuestionPostedNotificationTile extends StatelessWidget {
  final QuestionPostedNotification notification;
  final User currentUser;

  const QuestionPostedNotificationTile({Key key, this.notification, this.currentUser})
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder(
              stream: Firestore.instance
                  .collection('Users')
                  .document(notification.quesAuthorId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User author = User.fromSnapshot(snapshot.data);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            author.userName + " asked a question.",
                            style: Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.notificationMessageTextStyle
                                : LightTheme.notificationMessageTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Visibility(
                          visible: author.isProf,
                          child: Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  //TODO shimmer
                  return Container();
                }
              },
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
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
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            child: Text(
                              q.heading,
                              style: Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.notificationContentTextStyle
                                  : LightTheme.notificationContentTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        SizedBox(
                          height: 36.0,
                          width: double.maxFinite,
                          child: NotificationCTA(
                            child: Text(
                              "Read Question",
                              style: Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.notificationCTATextStyle
                                  : LightTheme.notificationCTATextStyle,
                            ),
                            callback: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return QuestionPage(
                                      question: q,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  //TODO shimmer
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
