import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/article/article_thumb_card.dart';
import 'package:ednet/home/feed/question/question_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TabBar(
                  tabs: [
                    Tab(
                      text: "Questions",
                    ),
                    Tab(
                      text: "Articles",
                    ),
                  ],
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              QuestionFeed(),
              ArticleFeed(),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance
              .collection('Questions')
              .where('isDraft', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.documents.length > 0) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) {
                      Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                      return QuestionThumbCard(
                        question: q,
                      );
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: Padding(
                    padding: Constant.sidePadding,
                    child: Center(
                      child: Text(
                        "Be the first to satisfy your curiousity.",
                        textAlign: TextAlign.center,
                        style: Constant.secondaryBlueTextStyle,
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
                    (i) => ShimmerQuestionThumbCard(),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

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
                );
              } else {
                return Expanded(
                  child: Padding(
                    padding: Constant.sidePadding,
                    child: Center(
                      child: Text(
                        "Be the first to write for the sake of knowledge.",
                        textAlign: TextAlign.center,
                        style: Constant.secondaryBlueTextStyle,
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
