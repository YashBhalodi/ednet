import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/create/article/create_article.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
                  article.title ?? " ",
                  style: Constant.articleTitleStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  article.subtitle ?? " ",
                  style: Constant.articleSubtitleStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  article.content ?? " ",
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
                          StreamBuilder(
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
                                DocumentSnapshot userDoc = snapshot.data;
                                return Text(
                                  userDoc.data['username'],
                                  style: Constant.usernameStyle,
                                );
                              }
                            },
                          )
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
                  height: 16.0,
                )
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
                      style: Constant.secondaryNegativeTextStyle,
                    ),
                    callback: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirmationAlert(
                            title: "Delete article draft?",
                            msg: "You will lose this content permenantly.",
                            deleteCallback: () async {
                              await article.delete();
                              Navigator.of(context).pop();
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
                  child: SecondaryBlueCardButton(
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
                      style: Constant.secondaryBlueTextStyle,
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
