import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zefyr/zefyr.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          padding: Constant.edgePadding,
          children: <Widget>[
            Text(
              article.title,
              style: Constant.articleTitleStyle,
            ),
            SizedBox(height: 18.0),
            Text(
              article.subtitle,
              style: Constant.articleSubtitleStyle,
            ),
            SizedBox(
              height: 24.0,
            ),
            ZefyrView(
              document: NotusDocument.fromJson(
                jsonDecode(article.contentJson),
              ),
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('Users')
                        .document(article.userId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Shimmer.fromColors(
                          child: Container(
                            width: 100.0,
                            height: 18.0,
                            color: Colors.white,
                          ),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          period: Duration(milliseconds: 300),
                        );
                      } else {
                        if (snapshot.data.data != null) {
                          DocumentSnapshot userDoc = snapshot.data;
                          return GestureDetector(
                            onTap: () {
                              Constant.userProfileView(context, userId: article.userId);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "Written by",
                                  style: Constant.dateTimeStyle,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      size: 16.0,
                                    ),
                                    article.byProf
                                    ? Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 16.0,
                                    )
                                    : Container(),
                                    Text(
                                      userDoc.data['username'],
                                      style: Constant.usernameStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(); //TODO user account is removed. msg if we want
                        }
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "On",
                        style: Constant.dateTimeStyle,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        Constant.formatDateTime(article.createdOn),
                        style: Constant.dateTimeMediumStyle,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 32.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Divider(
                    indent: 5.0,
                    endIndent: 5.0,
                  ),
                ),
                Text("End of article"),
                Expanded(
                  child: Divider(
                    indent: 5.0,
                    endIndent: 5.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32.0,
            ),
            Text(
              "So...What do you think?\n\nDoes it deserve an upvote?",
              style: Constant.sectionSubHeadingDescriptionStyle,
              textAlign: TextAlign.center,
            ),
            StreamBuilder(
              stream: Firestore.instance.collection('Articles').document(article.id).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Article a = Article.fromSnapshot(snapshot.data);
                  if (a.profUpvoteCount > 0) {
                    return Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          "${a.profUpvoteCount} professor upvoted",
                          style: Constant.professorUpvoteTextStyle,
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
            SizedBox(
              height: 32.0,
            ),
            StreamBuilder(
              stream: Firestore.instance.collection('Articles').document(article.id).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Article a = Article.fromSnapshot(snapshot.data);
                  return SizedBox(
                    height: 56.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: UpvoteButton(
                            callback: () async {
                              await a.upvote();
                            },
                            count: a.upvoteCount,
                          ),
                        ),
                        Expanded(
                          child: DownvoteButton(
                            callback: () async {
                              await a.downvote();
                            },
                            count: a.downvoteCount,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Shimmer.fromColors(
                    child: Container(
                      height: 56.0,
                      color: Colors.white,
                      width: double.maxFinite,
                    ),
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[300],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
