import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/article/article_thumb_card.dart';
import 'package:ednet/home/feed/question/question_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: Constant.edgePadding,
              child: Text(
                "Questions",
                style: Constant.sectionSubHeadingStyle,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('Questions')
                    .where('isDraft', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, i) {
                        Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                        return QuestionThumbCard(
                          question: q,
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: SizedBox(
                        height: 32.0,
                        width: 32.0,
                        child: Constant.greenCircularProgressIndicator,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: Constant.edgePadding,
              child: Text(
                "Articles",
                style: Constant.sectionSubHeadingStyle,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('Articles')
                    .where('isDraft', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        Article a = Article.fromSnapshot(snapshot.data.documents[i]);
                        return ArticleThumbCard(
                          article: a,
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: SizedBox(
                        height: 32.0,
                        width: 32.0,
                        child: Constant.greenCircularProgressIndicator,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
