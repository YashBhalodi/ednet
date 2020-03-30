import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/answer/answer_thumb_card.dart';
import 'package:ednet/home/feed/article/article_thumb_card.dart';
import 'package:ednet/home/feed/question/question_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class ExploreContent extends StatelessWidget {
  final User user;

  const ExploreContent({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            indicator: BoxDecoration(
              color: Colors.blue,
            ),
            unselectedLabelColor: Colors.blue,
            tabs: <Widget>[
              Tab(
                text: "Questions",
              ),
              Tab(
                text: "Answers",
              ),
              Tab(
                text: "Articles",
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                UserQuestions(
                  user: user,
                ),
                UserAnswers(
                  user: user,
                ),
                UserArticles(
                  user: user,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserQuestions extends StatelessWidget {
  final User user;

  const UserQuestions({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Questions')
          .where('isDraft', isEqualTo: false)
          .where('userid', isEqualTo: user.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.length > 0) {
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
            return Padding(
              padding: Constant.edgePadding,
              child: Center(
                child: Text(
                  "${user.userName} has not asked any questions yet.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
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
    );
  }
}

class UserArticles extends StatelessWidget {
  final User user;

  const UserArticles({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Articles')
          .where('isDraft', isEqualTo: false)
          .where('userid', isEqualTo: user.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                Article a = Article.fromSnapshot(snapshot.data.documents[i]);
                return ArticleThumbCard(
                  article: a,
                );
              },
            );
          } else {
            return Padding(
              padding: Constant.edgePadding,
              child: Center(
                child: Text(
                  "${user.userName} has not written any articles yet.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
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
    );
  }
}

class UserAnswers extends StatelessWidget {
  final User user;

  const UserAnswers({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Answers')
          .where('isDraft', isEqualTo: false)
          .where('userid', isEqualTo: user.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
                return AnswerThumbCard(
                  answer: a,
                );
              },
            );
          } else {
            return Padding(
              padding: Constant.edgePadding,
              child: Center(
                child: Text(
                  "${user.userName} has not answered any questions yet.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
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
    );
  }
}
