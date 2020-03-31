import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/create/answer/create_answer.dart';
import 'package:ednet/home/feed/answer/answer_thumb_card.dart';
import 'package:ednet/home/feed/question/question_tile_header.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  final Question question;

  const QuestionPage({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            QuestionTile(
              question: question,
              scrollDescriptionEnabled: true,
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('Answers')
                  .where('questionId', isEqualTo: question.id)
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
                          Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
                          return AnswerThumbCard(
                            answer: a,
                          );
                        },
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "Be the first person to answer.",
                          textAlign: TextAlign.center,
                          style: Constant.secondaryBlueTextStyle,
                        ),
                      ),
                    );
                  }
                } else {
                  return Expanded(
                    child: Center(
                      child: SizedBox(
                        height: 32.0,
                        width: 32.0,
                        child: Constant.greenCircularProgressIndicator,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 64.0,
              width: double.maxFinite,
              child: PrimaryBlueCTA(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.mode_edit,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Write Answer",
                      style: Constant.primaryCTATextStyle,
                    ),
                  ],
                ),
                callback: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CreateAnswer(
                          question: question,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
