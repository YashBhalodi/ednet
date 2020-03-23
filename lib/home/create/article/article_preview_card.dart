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
              height: 24.0,
            ),
            Text(
              article.content,
              style: Constant.articleContentStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 16.0,
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
            SizedBox(height: 16.0,)
          ],
        ),
      ),
    );
  }
}