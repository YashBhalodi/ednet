import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/profile/my_profile/my_drafts_page.dart';
import 'package:ednet/home/profile/my_profile/my_profile_info_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_answers_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_articles_page.dart';
import 'package:ednet/home/profile/other_user_profile/user_questions_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:flutter/foundation.dart';
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
        length: 5,
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
                    text: "Profile",
                  ),
                  Tab(
                    text: "Drafts",
                  ),
                  Tab(
                    text: "Questions",
                  ),
                  Tab(
                    text: "Articles",
                  ),
                  Tab(
                    text: "Answers",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    MyProfile(
                      user: currentUser,
                    ),
                    MyDrafts(
                      user: currentUser,
                    ),
                    UserQuestions(
                      user: currentUser,
                    ),
                    UserArticles(
                      user: currentUser,
                    ),
                    UserAnswers(
                      user: currentUser,
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

/*
class MyQuestions extends StatelessWidget {
  final User user;

  const MyQuestions({Key key, @required this.user}) : super(key: key);

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
              padding: Constant.sidePadding,
              child: Center(
                child: Text(
                  "You haven't asked any questions yet.\n\nStart feeding your curiosity.",
                  textAlign: TextAlign.center,
                  style: Constant.secondaryBlueTextStyle,
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

class MyArticles extends StatelessWidget {
  final User user;

  const MyArticles({Key key, @required this.user}) : super(key: key);

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
            return Padding(
              padding: Constant.sidePadding,
              child: Center(
                child: Text(
                  "Strengthen your knowledge by sharing.",
                  textAlign: TextAlign.center,
                  style: Constant.secondaryBlueTextStyle,
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

class MyAnswers extends StatelessWidget {
  final User user;

  const MyAnswers({Key key, @required this.user}) : super(key: key);

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
            return Padding(
              padding: Constant.sidePadding,
              child: Center(
                child: Text(
                  "You haven't answered any questions yet.\n\nSomeone might be looking forward to your contribution.",
                  textAlign: TextAlign.center,
                  style: Constant.secondaryBlueTextStyle,
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
*/
