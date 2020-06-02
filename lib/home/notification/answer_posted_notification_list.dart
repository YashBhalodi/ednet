import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/answer/answer_page.dart';
import 'package:ednet/home/feed/question/question_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class AnswerPostedNotificationList extends StatefulWidget {
  final User currentUser;

  const AnswerPostedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  _AnswerPostedNotificationListState createState() => _AnswerPostedNotificationListState();
}

class _AnswerPostedNotificationListState extends State<AnswerPostedNotificationList> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
      super.build(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(widget.currentUser.id)
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
                      currentUser: widget.currentUser,
                    );
                  },
                )
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
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
                  .document(notification.ansAuthorId)
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
                            author.userName + " answered the question.",
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
                              "Read Answer",
                              style: Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.notificationCTATextStyle
                                  : LightTheme.notificationCTATextStyle,
                            ),
                            callback: () async {
                              DocumentSnapshot ansDoc = await Firestore.instance
                                  .collection('Answers')
                                  .document(notification.answerId)
                                  .get();
                              if (ansDoc == null) {
                                Constant.showToastInstruction(
                                    "This answer was removed by an admin.\nOpening the question page");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return QuestionPage(
                                        question: q,
                                      );
                                    },
                                  ),
                                );
                                notification.remove();
                              } else {
                                Answer a = Answer.fromSnapshot(ansDoc);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AnswerPage(
                                        answer: a,
                                        question: q,
                                      );
                                    },
                                  ),
                                );
                              }
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
