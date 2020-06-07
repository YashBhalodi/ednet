import 'package:ednet/home/feed/article/article_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class UserArticles extends StatelessWidget {
  final User user;
  final List<Article> articles;

  const UserArticles({Key key, @required this.user, this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (articles.length > 0)
        ? Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: articles.length,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                return ArticleThumbCard(
                  article: articles[i],
                );
              },
            ),
          )
        : Padding(
            padding: Constant.edgePadding,
            child: Center(
              child: Text(
                "${user.userName} has not written any articles yet.",
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
