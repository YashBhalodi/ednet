import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/question/question_tile_header.dart';
import 'package:ednet/home/feed/report_content_sheet.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class AnswerPage extends StatefulWidget {
  final Answer answer;
  final Question question;

  const AnswerPage({Key key, this.answer, this.question}) : super(key: key);

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  Widget _popUpMenu() {
    return PopupMenuButton(
      itemBuilder: (_) {
        return [
          PopupMenuItem<int>(
            child: Text("Report Question"),
            value: 1,
          ),
          PopupMenuItem<int>(
            child: Text("Report Answer"),
            value: 2,
          ),
        ];
      },
      onSelected: (i) {
        if (i == 1) {
            ReportFlow.showSubmitReportBottomSheet(
            context,
            contentCollection: 'Questions',
            contentDocId: widget.question.id,
          );
        } else if (i == 2) {
            ReportFlow.showSubmitReportBottomSheet(
            context,
            contentCollection: 'Answers',
            contentDocId: widget.answer.id,
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
            children: <Widget>[
              widget.question == null
              ? StreamBuilder(
                stream: Firestore.instance
                    .collection('Questions')
                    .document(widget.answer.queID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    Question q = Question.fromSnapshot(snapshot.data);
                    return QuestionTile(
                      question: q,
                    );
                  } else {
                    return ShimmerQuestionTile();
                  }
                },
              )
              : QuestionTile(
                question: widget.question,
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: Constant.edgePadding,
                children: <Widget>[
                  ZefyrView(
                    document: NotusDocument.fromJson(
                      jsonDecode(widget.answer.contentJson),
                    ),
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
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('Users')
                              .document(widget.answer.userId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              if (snapshot.data.data != null) {
                                DocumentSnapshot userDoc = snapshot.data;
                                return GestureDetector(
                                  onTap: () {
                                    Constant.userProfileView(context, userId: widget.answer.userId);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Answered by",
                                        style: Theme.of(context).brightness == Brightness.dark
                                               ? DarkTheme.dateTimeStyle
                                               : LightTheme.dateTimeStyle,
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
                                            size: 16.0,
                                          ),
                                          widget.answer.byProf
                                          ? Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                            size: 16.0,
                                          )
                                          : Container(),
                                          Text(
                                            userDoc.data['username'],
                                            style: Theme.of(context).brightness == Brightness.dark
                                                   ? DarkTheme.usernameStyle
                                                   : LightTheme.usernameStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container(); //TODO user account is removed. msg if we want
                              }
                            }
                          },
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
                              style: Theme.of(context).brightness == Brightness.dark
                                     ? DarkTheme.dateTimeStyle
                                     : LightTheme.dateTimeStyle,
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              Constant.formatDateTime(widget.answer.createdOn),
                              style: Theme.of(context).brightness == Brightness.dark
                                     ? DarkTheme.dateTimeMediumStyle
                                     : LightTheme.dateTimeMediumStyle,
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
                    style: Theme.of(context).brightness == Brightness.dark
                           ? DarkTheme.headingDescriptionStyle
                           : LightTheme.headingDescriptionStyle,
                    textAlign: TextAlign.center,
                  ),
                  StreamBuilder(
                    stream:
                    Firestore.instance.collection('Answers').document(widget.answer.id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Answer a = Answer.fromSnapshot(snapshot.data);
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
                    stream:
                    Firestore.instance.collection('Answers').document(widget.answer.id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Answer a = Answer.fromSnapshot(snapshot.data);
                        return SizedBox(
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
                        );
                      } else {
                        return ShimmerRatingBox();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
