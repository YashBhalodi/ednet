import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/article/article_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/notification_classes.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class ArticlePostedNotificationList extends StatefulWidget {
  final User currentUser;

  const ArticlePostedNotificationList({Key key, this.currentUser}) : super(key: key);

  @override
  _ArticlePostedNotificationListState createState() => _ArticlePostedNotificationListState();
}

class _ArticlePostedNotificationListState extends State<ArticlePostedNotificationList> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(widget.currentUser.id)
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
                      currentUser: widget.currentUser,
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

  @override
  bool get wantKeepAlive => true;
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
                  .document(notification.authorId)
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
                            author.userName + " wrote an article.",
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
                              a.title,
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
                              "Read Article",
                              style: Theme.of(context).brightness == Brightness.dark
                                     ? DarkTheme.notificationCTATextStyle
                                     : LightTheme.notificationCTATextStyle,
                            ),
                            callback: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ArticlePage(
                                      article: a,
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
