import 'dart:convert';

import 'package:ednet/home/create/article/create_article.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class ArticleDraftCard extends StatelessWidget {
  final Article article;

  const ArticleDraftCard({Key key, this.article}) : super(key: key);

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
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
                            backgroundColor: Theme
                                                 .of(context)
                                                 .brightness == Brightness.dark
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
                  article.title ?? " ",
                  style: Theme.of(context).brightness == Brightness.dark
                         ? DarkTheme.articleTitleStyle
                         : LightTheme.articleTitleStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  article.subtitle ?? " ",
                  style: Theme.of(context).brightness == Brightness.dark
                         ? DarkTheme.articleSubtitleStyle
                         : LightTheme.articleSubtitleStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 24.0,
                ),
                Container(
                  constraints: BoxConstraints.loose(Size(double.maxFinite, 100.0)),
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
                  height: 16.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SecondaryNegativeCardButton(
                    child: Text(
                      "Delete",
                      style: Theme.of(context).brightness == Brightness.dark
                             ? DarkTheme.secondaryNegativeTextStyle
                             : LightTheme.secondaryNegativeTextStyle,
                    ),
                    callback: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirmationAlert(
                            title: "Delete article draft?",
                            msg: "You will lose this content permenantly.",
                            deleteCallback: () async {
                              Navigator.of(context).pop();
                              await article.delete();
                            },
                            cancelCallback: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: SecondaryPositiveCardButton(
                    callback: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return CreateArticle(
                              article: article,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Finish",
                      style: Theme.of(context).brightness == Brightness.dark
                             ? DarkTheme.secondaryPositiveTextStyle
                             : LightTheme.secondaryPositiveTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
