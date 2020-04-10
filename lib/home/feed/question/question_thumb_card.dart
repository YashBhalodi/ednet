import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/question/question_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zefyr/zefyr.dart';

class QuestionThumbCard extends StatelessWidget {
  final Question question;

  const QuestionThumbCard({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return QuestionPage(
                question: question,
              );
            },
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        elevation: 15.0,
        margin: Constant.cardMargin,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: Constant.cardPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleChildScrollView(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(question.topics.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Chip(
                        label: Text(
                          question.topics[i],
                          style: Theme.of(context).brightness == Brightness.dark
                                 ? DarkTheme.topicStyle
                                 : LightTheme.topicStyle,
                        ),
                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.chipBackgroundColor
                            : LightTheme.chipBackgroundColor,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                question.heading,
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.questionHeadingStyle
                       : LightTheme.questionHeadingStyle,
                textAlign: TextAlign.justify,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                constraints: BoxConstraints.loose(Size(double.maxFinite, 100.0)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  child: ZefyrView(
                    document: NotusDocument.fromJson(
                      jsonDecode(question.descriptionJson),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              question.profUpvoteCount > 0
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "${question.profUpvoteCount} professor upvoted",
                          style: Theme.of(context).brightness == Brightness.dark
                                 ? DarkTheme.professorUpvoteTextStyle
                                 : LightTheme.professorUpvoteTextStyle,
                        ),
                      ),
                    )
                  : Container(),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('Users')
                          .document(question.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          if (snapshot.data.data != null) {
                            DocumentSnapshot userDoc = snapshot.data;
                            return GestureDetector(
                              onTap: () {
                                Constant.userProfileView(context, userId: question.userId);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    size: 16.0,
                                  ),
                                  question.byProf
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
                            );
                          } else {
                            return Container(); //TODO user account is removed. msg if we want
                          }
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      Constant.formatDateTime(question.createdOn),
                      style: Theme.of(context).brightness == Brightness.dark
                             ? DarkTheme.dateTimeStyle
                             : LightTheme.dateTimeStyle,
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 32.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: UpvoteBox(
                        upvoteCount: question.upvoteCount,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: AnswerCountBox(
                        answerCount: question.answerCount,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: DownvoteBox(
                        downvoteCount: question.downvoteCount,
                      ),
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
