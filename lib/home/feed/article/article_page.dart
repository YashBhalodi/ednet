import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
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
                  Text(
                    article.content,
                    style: Constant.articleContentStyle,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("Written by",style: Constant.dateTimeStyle,),
                            SizedBox(height: 8.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  size: 20.0,
                                ),
                                article.byProf
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.orangeAccent,
                                        size: 20.0,
                                      )
                                    : Container(),
                                Text(
                                  article.username,
                                  style: Constant.usernameMediumStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("On",style: Constant.dateTimeStyle,),
                            SizedBox(height: 8.0,),
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
                  )
                ],
              ),
            ),
            SizedBox(
              height: 56.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: UpvoteButton(
                      callback: () {
                        //TODO implement this
                      },
                      count: article.upvoteCount,
                    ),
                  ),
                  Expanded(
                    child: DownvoteButton(
                      callback: () {
                        //TODO implement this
                      },
                      count: article.downvoteCount,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
