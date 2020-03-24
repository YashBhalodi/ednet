import 'package:ednet/home/feed/question/question_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';

class QuestionThumbCard extends StatelessWidget {
  final Question question;

  const QuestionThumbCard({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO navigate to Question screen
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
        elevation: 5.0,
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
                          style: Constant.topicStyle,
                        ),
                        backgroundColor: Colors.grey[100],
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
                style: Constant.questionHeadingStyle,
                textAlign: TextAlign.justify,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                question.description,
                style: Constant.questionDescriptionStyle,
                textAlign: TextAlign.justify,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 16.0,
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
