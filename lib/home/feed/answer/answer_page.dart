import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/question/question_tile_header.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnswerPage extends StatelessWidget {
  final Answer answer;
  final Question question;

  const AnswerPage({Key key, this.answer, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          question == null
              ? StreamBuilder(
                  stream:
                      Firestore.instance.collection('Questions').document(answer.queID).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      Question q = Question.fromSnapshot(snapshot.data);
                      return QuestionTile(
                        question: q,
                        scrollDescriptionEnabled: false,
                      );
                    } else {
                      return ShimmerQuestionTile();
                    }
                  },
                )
              : QuestionTile(
                  question: question,
                  scrollDescriptionEnabled: false,
                ),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: Constant.edgePadding,
            children: <Widget>[
              Text(
                answer.content,
                style: Constant.answerContentStyle,
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Constant.userProfileView(context, userId: answer.userId);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Answered by",
                            style: Constant.dateTimeStyle,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                size: 20.0,
                              ),
                              answer.byProf
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 20.0,
                                    )
                                  : Container(),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection('Users')
                                    .document(answer.userId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Shimmer.fromColors(
                                      child: Container(
                                        width: 100.0,
                                        height: 18.0,
                                        color: Colors.white,
                                      ),
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      period: Duration(milliseconds: 300),
                                    );
                                  } else {
                                    DocumentSnapshot userDoc = snapshot.data;
                                    return Text(
                                      userDoc.data['username'],
                                      style: Constant.usernameStyle,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "On",
                          style: Constant.dateTimeStyle,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          Constant.formatDateTime(answer.createdOn),
                          style: Constant.dateTimeMediumStyle,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  )
                ],
              ),
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
                  Text("End of answer"),
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
                style: Constant.sectionSubHeadingDescriptionStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 32.0,
              ),
              SizedBox(
                height: 54.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: UpvoteButton(
                        callback: () {
                          //TODO implement upvote function
                        },
                        count: answer.upvoteCount,
                      ),
                    ),
                    Expanded(
                      child: DownvoteButton(
                        callback: () {
                          //TODO implement downvote function
                        },
                        count: answer.downvoteCount,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
