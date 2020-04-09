import 'package:ednet/home/create/article/article_preview_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:flutter/material.dart';

class ArticlePreview extends StatefulWidget {
  final Article article;

  const ArticlePreview({Key key, @required this.article}) : super(key: key);

  @override
  _ArticlePreviewState createState() => _ArticlePreviewState();
}

class _ArticlePreviewState extends State<ArticlePreview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: Constant.edgePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Preview Article",
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.headingStyle
                       : LightTheme.headingStyle,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "Please review your article before finally publishing.",
                style: Theme
                           .of(context)
                           .brightness == Brightness.dark
                       ? DarkTheme.headingDescriptionStyle
                       : LightTheme.headingDescriptionStyle,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "Once article is published it can't be edited or removed.\nSave your article as draft and publish it once you are confident.",
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.formFieldHintStyle
                       : LightTheme.formFieldHintStyle,
              ),
            ],
          ),
        ),
        (widget.article.title == null ||
                widget.article.subtitle == null ||
                widget.article.content == null)
            ? ShimmerArticlePreviewCard()
            : Expanded(
                child: Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ArticlePreviewCard(
                        article: widget.article,
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
