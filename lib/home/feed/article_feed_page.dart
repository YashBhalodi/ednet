import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/article/article_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:flutter/material.dart';

class ArticleFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance
              .collection('Articles')
              .where('isDraft', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.documents.length > 0) {
                return Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        Article a = Article.fromSnapshot(snapshot.data.documents[i]);
                        return ArticleThumbCard(
                          article: a,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: Padding(
                    padding: Constant.sidePadding,
                    child: Center(
                      child: Text(
                        "Be the first to write for the sake of knowledge.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.secondaryHeadingTextStyle
                            : LightTheme.secondaryHeadingTextStyle,
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(
                    3,
                    (i) => ShimmerArticleThumbCard(),
                  ),
                ),
              );
            }
          },
        )
      ],
    );
  }
}
