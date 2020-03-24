import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/create/question/question_preview_card.dart';
import 'package:ednet/home/create/answer/create_answer.dart';
import 'package:ednet/home/feed/answer/answer_thumb_card.dart';
import 'package:ednet/home/feed/article/article_thumb_card.dart';
import 'package:ednet/home/feed/question/question_thumb_card.dart';
import 'package:ednet/home/profile/answer_draft_card.dart';
import 'package:ednet/home/profile/article_draft_card.dart';
import 'package:ednet/home/profile/question_draft_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const ProfilePage({Key key, this.userSnap}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = User.fromSnapshot(widget.userSnap);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Colors.blue,
                ),
                unselectedLabelColor: Colors.blue,
                tabs: <Widget>[
                  Tab(
                    text: "Questions",
                  ),
                  Tab(
                    text: "Articles",
                  ),
                  Tab(
                    text: "Answers",
                  ),
                  Tab(
                    text: "Draft",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    MyQuestions(
                      currentUser: currentUser,
                    ),
                    MyArticles(
                      currentUser: currentUser,
                    ),
                    MyAnswers(
                      currentUser: currentUser,
                    ),
                    MyDrafts(
                      currentUser: currentUser,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyQuestions extends StatelessWidget {
  final User currentUser;

  const MyQuestions({Key key, @required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Questions')
          .where('isDraft', isEqualTo: false)
          .where('username', isEqualTo: currentUser.userName)
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
    );
  }
}

class MyArticles extends StatelessWidget {
  final User currentUser;

  const MyArticles({Key key, @required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Articles')
          .where('isDraft', isEqualTo: false)
          .where('username', isEqualTo: currentUser.userName)
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
    );
  }
}

class MyAnswers extends StatelessWidget {
  final User currentUser;

  const MyAnswers({Key key, @required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Answers')
          .where('isDraft', isEqualTo: false)
          .where('username', isEqualTo: currentUser.userName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
              return AnswerThumbCard(
                answer: a,
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
    );
  }
}

class MyDrafts extends StatelessWidget {
  final User currentUser;

  const MyDrafts({Key key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: Constant.sidePadding,
          child: Text("Questions",style: Constant.sectionSubHeadingStyle,),
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection('Questions')
              .where('isDraft', isEqualTo: true)
              .where('username', isEqualTo: currentUser.userName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, i) {
                  Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                  return QuestionDraftCard(
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
        Divider(
          endIndent: 24.0,
          indent: 24.0,
        ),
        SizedBox(height: 16.0,),
        Padding(
          padding: Constant.sidePadding,
          child: Text("Articles",style: Constant.sectionSubHeadingStyle,),
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection('Articles')
              .where('isDraft', isEqualTo: true)
              .where('username', isEqualTo: currentUser.userName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  Article a = Article.fromSnapshot(snapshot.data.documents[i]);
                  return ArticleDraftCard(
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
        Divider(
          endIndent: 24.0,
          indent: 24.0,
        ),
        SizedBox(height: 16.0,),
        Padding(
          padding: Constant.sidePadding,
          child: Text("Answers",style: Constant.sectionSubHeadingStyle,),
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection('Answers')
              .where('isDraft', isEqualTo: true)
              .where('username', isEqualTo: currentUser.userName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
                  return AnswerDraftCard(
                    answer: a,
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
      ],
    );
  }
}
