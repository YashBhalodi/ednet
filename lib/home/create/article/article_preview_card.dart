import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class ArticlePreviewCard extends StatelessWidget {
  final Article article;

  const ArticlePreviewCard({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Text(
              article.title,
              style: Constant.articleTitleStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              article.subtitle,
              style: Constant.articleSubtitleStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              article.content,
              style: Constant.articleContentStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 12.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(article.topics.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      label: Text(
                        article.topics[i],
                      ),
                      backgroundColor: Colors.grey[100],
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
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
                        article.username,
                        style: Constant.usernameStyle,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 2,
                  child: Text(
                    Constant.formatDateTime(article.createdOn),
                    style: Constant.dateTimeStyle,
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          side: BorderSide(color: Colors.green[100], width: 1.0)),
                      color: Colors.green[50]),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        "Upvotes: " + article.upvoteCount.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          side: BorderSide(color: Colors.red[100], width: 1.0)),
                      color: Colors.red[50]),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        "Downvotes: " + article.downvoteCount.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
