import 'dart:convert';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/report_content_sheet.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class ArticlePage extends StatefulWidget {
  final Article article;

  const ArticlePage({Key key, this.article}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  Widget _popUpMenu() {
    return PopupMenuButton(
        offset: Offset.fromDirection(math.pi / 2, AppBar().preferredSize.height),
        itemBuilder: (_) {
            return [
                PopupMenuItem<int>(
                    child: Text("Report Article"),
                    value: 1,
                ),
            ];
        },
        onSelected: (i) {
            if (i == 1) {
                ReportFlow.showSubmitReportBottomSheet(
                    context,
                    contentCollection: 'Articles',
                    contentDocId: widget.article.id,
                );
            }
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            _popUpMenu(),
          ],
        ),
        body: Scrollbar(
          child: ListView(
            padding: Constant.edgePadding,
            children: <Widget>[
              Text(
                widget.article.title,
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.articleTitleStyle
                       : LightTheme.articleTitleStyle,
              ),
              SizedBox(height: 18.0),
              Text(
                widget.article.subtitle,
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.articleSubtitleStyle
                       : LightTheme.articleSubtitleStyle,
              ),
              SizedBox(
                height: 24.0,
              ),
              ZefyrView(
                document: NotusDocument.fromJson(
                  jsonDecode(widget.article.contentJson),
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
                          .document(widget.article.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          if (snapshot.data.data != null) {
                            DocumentSnapshot userDoc = snapshot.data;
                            return GestureDetector(
                              onTap: () {
                                Constant.userProfileView(context, userId: widget.article.userId);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Written by",
                                    style: Theme.of(context).brightness == Brightness.dark
                                           ? DarkTheme.dateTimeStyle
                                           : LightTheme.dateTimeStyle,
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
                                      widget.article.byProf
                                      ? Icon(
                                        Icons.star,
                                        color: Colors.orangeAccent,
                                        size: 16.0,
                                      )
                                      : Container(),
                                      Text(
                                        userDoc.data['username'],
                                        style: Theme.of(context).brightness == Brightness.dark
                                               ? DarkTheme.usernameStyle
                                               : LightTheme.usernameStyle,
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
                          style: Theme.of(context).brightness == Brightness.dark
                                 ? DarkTheme.dateTimeStyle
                                 : LightTheme.dateTimeStyle,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          Constant.formatDateTime(widget.article.createdOn),
                          style: Theme.of(context).brightness == Brightness.dark
                                 ? DarkTheme.dateTimeMediumStyle
                                 : LightTheme.dateTimeMediumStyle,
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
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.headingDescriptionStyle
                       : LightTheme.headingDescriptionStyle,
                textAlign: TextAlign.center,
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('Articles')
                    .document(widget.article.id)
                    .snapshots(),
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
                            style: Theme.of(context).brightness == Brightness.dark
                                   ? DarkTheme.professorUpvoteTextStyle
                                   : LightTheme.professorUpvoteTextStyle,
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
                stream: Firestore.instance
                    .collection('Articles')
                    .document(widget.article.id)
                    .snapshots(),
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
                    return ShimmerRatingBox();
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
