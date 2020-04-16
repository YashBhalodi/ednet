import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/article/article_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class ArticleThumbCard extends StatelessWidget {
  final Article article;

  const ArticleThumbCard({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ArticlePage(
                article: article,
              );
            },
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        elevation: 5.0,
        margin: Constant.cardMargin,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: Constant.cardPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(article.topics.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(
                          article.topics[i],
                          style: Theme
                                     .of(context)
                                     .brightness == Brightness.dark
                                 ? DarkTheme.topicStyle
                                 : LightTheme.topicStyle,
                        ),
                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                                         ? DarkTheme.chipBackgroundColor
                                         : LightTheme.chipBackgroundColor,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                article.title,
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.articleTitleStyle
                       : LightTheme.articleTitleStyle,
                textAlign: TextAlign.justify,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                article.subtitle,
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.articleSubtitleStyle
                       : LightTheme.articleSubtitleStyle,
                textAlign: TextAlign.justify,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                constraints: BoxConstraints.loose(Size(double.maxFinite, 130.0)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  child: ZefyrView(
                    document: NotusDocument.fromJson(
                      jsonDecode(article.contentJson),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              article.profUpvoteCount > 0
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "${article.profUpvoteCount} professor upvoted",
                          style: Theme.of(context).brightness == Brightness.dark
                                 ? DarkTheme.professorUpvoteTextStyle
                                 : LightTheme.professorUpvoteTextStyle,
                        ),
                      ),
                    )
                  : Container(),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('Users')
                          .document(article.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          if (snapshot.data.data != null) {
                            DocumentSnapshot userDoc = snapshot.data;
                            return GestureDetector(
                              onTap: () {
                                Constant.userProfileView(context, userId: article.userId);
                              },
                              child: Row(
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
                                    style: Theme.of(context).brightness == Brightness.dark
                                           ? DarkTheme.usernameStyle
                                           : LightTheme.usernameStyle,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();   //TODO user account is removed. msg if we want
                          }
                        }
                      },
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 2,
                    child: Text(
                      Constant.formatDateTime(article.createdOn),
                      style: Theme.of(context).brightness == Brightness.dark
                             ? DarkTheme.dateTimeStyle
                             : LightTheme.dateTimeStyle,
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              SizedBox(
                height: 32.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: UpvoteBox(
                        upvoteCount: article.upvoteCount,
                      ),
                    ),
                    Expanded(
                      child: DownvoteBox(
                        downvoteCount: article.downvoteCount,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
