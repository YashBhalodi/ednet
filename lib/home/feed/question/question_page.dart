import 'package:ednet/home/feed/question/create_answer.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  final Question question;

  const QuestionPage({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          QuestionTile(
            question: question,
          ),
          Expanded(
            //TODO Answer List build
            child: Container(),
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
    );
  }
}

class QuestionTile extends StatelessWidget {
  final Question question;

  const QuestionTile({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(0.0, 3.0),
            blurRadius: 16.0,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        color: Colors.blue[50],
      ),
      margin: EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: Constant.edgePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(question.topics.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(
                            question.topics[i],
                            style: Constant.topicStyle,
                          ),
                          backgroundColor: Colors.grey[100],
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  question.heading,
                  style: Constant.questionHeadingStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  question.description,
                  style: Constant.questionDescriptionStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
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
                            question.username,
                            style: Constant.usernameStyle,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        Constant.formatDateTime(question.createdOn),
                        style: Constant.dateTimeStyle,
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: UpvoteButton(
                          count: question.upvoteCount,
                          callback: () {
                            //TODO implement the function
                          },
                        ),
                      ),
                      Expanded(
                          child: DownvoteButton(
                        count: question.downvoteCount,
                        callback: () {
                          //TODO implement the function
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
