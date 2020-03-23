import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/create/question/question_preview_card.dart';
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
  @override
  Widget build(BuildContext context) {
    User currentUser = User.fromSnapshot(widget.userSnap);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          currentUser.toString(),
        ),
        Expanded(
          child: PageView(
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
                          .where('isDraft', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.active) {
                          return ListView.builder(
                            shrinkWrap: true,
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
                          .where('isDraft', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.active) {
                          return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            shrinkWrap: true,
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
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
