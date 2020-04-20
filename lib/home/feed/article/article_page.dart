import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/report_content_sheet.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  final Article article;

  const ArticlePage({Key key, this.article}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  Widget _popUpMenu() {
    return PopupMenuButton(
        offset: Offset.fromDirection(math.pi / 2, AppBar().preferredSize.height),
        itemBuilder: (_) {
            return [
                PopupMenuItem<int>(
                    child: Text("Report Article"),
                    value: 1,
                ),
            ];
        },
        onSelected: (i) {
            if (i == 1) {
                ReportFlow.showSubmitReportBottomSheet(
                    context,
                    contentCollection: 'Articles',
                    contentDocId: widget.article.id,
                );
            }
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            _popUpMenu(),
          ],
        ),
        body: Scrollbar(
          child: ListView(
            padding: Constant.edgePadding,
            children: <Widget>[
              ArticleContentView(article: widget.article,),
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
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.headingDescriptionStyle
                       : LightTheme.headingDescriptionStyle,
                textAlign: TextAlign.center,
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('Articles')
                    .document(widget.article.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Article a = Article.fromSnapshot(snapshot.data);
                    if (a.profUpvoteCount > 0) {
                      return Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            "${a.profUpvoteCount} professor upvoted",
                            style: Theme.of(context).brightness == Brightness.dark
                                   ? DarkTheme.professorUpvoteTextStyle
                                   : LightTheme.professorUpvoteTextStyle,
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                height: 32.0,
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('Articles')
                    .document(widget.article.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Article a = Article.fromSnapshot(snapshot.data);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 56.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: UpvoteButton(
                                  callback: () async {
                                    await a.upvote();
                                  },
                                  count: a.upvoteCount,
                                ),
                              ),
                              Expanded(
                                child: DownvoteButton(
                                  callback: () async {
                                    await a.downvote();
                                  },
                                  count: a.downvoteCount,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left:10.0),
                              child: UpVoterList(upvoters: a.upvoters),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:10.0),
                              child: DownVoterList(downvoters: a.downvoters,),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return ShimmerRatingBox();
                  }
                },
              ),
              SizedBox(height: 32,),
            ],
          ),
        ),
      ),
    );
  }
}

