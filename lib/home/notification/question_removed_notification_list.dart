import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class QuestionRemovedNotificationList extends StatefulWidget {
  final User currentUser;

  const QuestionRemovedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  _QuestionRemovedNotificationListState createState() => _QuestionRemovedNotificationListState();
}

class _QuestionRemovedNotificationListState extends State<QuestionRemovedNotificationList> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(widget.currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: "QuestionRemoved")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.isEmpty) {
            return Container();
          } else {
            return ExpansionTile(
              title: Text(
                "Removed Question",
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
                    QuestionRemovedNotification questionRemovedNotification =
                        QuestionRemovedNotification.fromJson(snapshot.data.documents[i]);
                    return QuestionRemovedNotificationTile(
                      currentUser: widget.currentUser,
                      notification: questionRemovedNotification,
                    );
                  },
                ),
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

class QuestionRemovedNotificationTile extends StatelessWidget {
  final User currentUser;
  final QuestionRemovedNotification notification;

  const QuestionRemovedNotificationTile({Key key, this.currentUser, this.notification})
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
              stream:
                  Firestore.instance.collection('Users').document(notification.adminId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User admin = User.fromSnapshot(snapshot.data);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      admin.userName + " removed your question.",
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.notificationMessageTextStyle
                          : LightTheme.notificationMessageTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                } else {
                  //TODO shimmer
                  return Container();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 12.0),
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
                  notification.content,
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.notificationContentTextStyle
                      : LightTheme.notificationContentTextStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
