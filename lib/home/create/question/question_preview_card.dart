import 'package:ednet/home/create/question/create_question.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';

class QuestionPreviewCard extends StatelessWidget {
  final Question question;

  const QuestionPreviewCard({Key key, @required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Text(
              question.heading,
              style: Constant.questionHeadingStyle,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              question.description,
              style: Constant.questionDescriptionStyle,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 8.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(question.topics.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      label: Text(
                        question.topics[i],
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
                Spacer(),
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
              height: 8.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          side: BorderSide(color: Colors.green[100], width: 1.0)),
                      color: Colors.green[50]),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        "Upvotes: " + question.upvoteCount.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          side: BorderSide(color: Colors.red[100], width: 1.0)),
                      color: Colors.red[50]),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        "Downvotes: " + question.downvoteCount.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            question.isDraft?SizedBox(height: 8.0,):Container(),
            question.isDraft?SecondaryCTA(
              callback: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return CreateQuestion(question: question,);
                }));
              },
              child: Text("Finish the draft",style: Constant.secondaryCTATextStyle,),
            ):Container(),
          ],
        ),
      ),
    );
  }
}
