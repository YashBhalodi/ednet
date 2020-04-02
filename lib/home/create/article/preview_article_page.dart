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
                style: Constant.sectionSubHeadingStyle,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "Please review your article before finally publishing.",
                style: Constant.sectionSubHeadingDescriptionStyle,
              ),
            ],
          ),
        ),
        (widget.article.title == null ||
                widget.article.subtitle == null ||
                widget.article.content == null)
            ? ShimmerArticlePreviewCard()
            : Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ArticlePreviewCard(
                      article: widget.article,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
