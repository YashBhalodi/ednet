import 'package:ednet/home/create/article/article_preview_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class ArticlePreview extends StatefulWidget {
  final Article article;

  const ArticlePreview({Key key,@required this.article}) : super(key: key);

    @override
  _ArticlePreviewState createState() => _ArticlePreviewState();
}

class _ArticlePreviewState extends State<ArticlePreview> {
  @override
  Widget build(BuildContext context) {
      if (widget.article.title == null || widget.article.subtitle == null || widget.article.content == null) {
          return Center(
              child: SizedBox(
                  height: 28.0,
                  width: 28.0,
                  child: Constant.greenCircularProgressIndicator,
              ),
          );
      } else {
          return ListView(
              shrinkWrap: true,
              children: <Widget>[
                  ArticlePreviewCard(
                      article: widget.article,
                  ),
              ],
          );
      }
  }
}
