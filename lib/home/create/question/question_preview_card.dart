import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              question.description,
              style: Constant.questionDescriptionStyle,
              textAlign: TextAlign.justify,
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
                      StreamBuilder(
                        stream: Firestore.instance
                            .collection('Users')
                            .document(question.userId)
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
                      )
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
          ],
        ),
      ),
    );
  }
}
