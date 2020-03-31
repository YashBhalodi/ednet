import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/profile/my_profile/answer_draft_card.dart';
import 'package:ednet/home/profile/my_profile/article_draft_card.dart';
import 'package:ednet/home/profile/my_profile/question_draft_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class MyDrafts extends StatelessWidget {
  final User user;

  const MyDrafts({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ExpansionTile(
          title: Text(
            "Questions",
            style: Constant.dropDownMenuTitleStyle,
          ),
          initiallyExpanded: true,
          backgroundColor: Colors.grey[50],
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('Questions')
                      .where('isDraft', isEqualTo: true)
                      .where('userid', isEqualTo: user.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data.documents.length > 0) {
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
                        return Padding(
                          padding: Constant.edgePadding,
                          child: Center(
                            child: Text(
                              "You don't have any draft questions so far.\n\nCongratulations.",
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
                ),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "Articles",
            style: Constant.dropDownMenuTitleStyle,
          ),
          initiallyExpanded: false,
          backgroundColor: Colors.grey[50],
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('Articles')
                      .where('isDraft', isEqualTo: true)
                      .where('userid', isEqualTo: user.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data.documents.length > 0) {
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
                        return Padding(
                          padding: Constant.edgePadding,
                          child: Center(
                            child: Text(
                              "Wow!\nNo draft article pending to publish!\n\nWhen are you planning for next?",
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
                ),
              ],
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            "Answers",
            style: Constant.dropDownMenuTitleStyle,
          ),
          initiallyExpanded: false,
          backgroundColor: Colors.grey[50],
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('Answers')
                      .where('isDraft', isEqualTo: true)
                      .where('userid', isEqualTo: user.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data.documents.length > 0) {
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
                        return Padding(
                          padding: Constant.edgePadding,
                          child: Center(
                            child: Text(
                              "WhooHoo!\n\nNo draft answer to write up.",
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
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
