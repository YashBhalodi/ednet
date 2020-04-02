import 'dart:convert';

import 'package:ednet/home/create/question/create_question.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class QuestionDraftCard extends StatelessWidget {
  final Question question;

  const QuestionDraftCard({Key key, this.question}) : super(key: key);

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
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
                  question.heading ?? "",
                  style: Constant.questionHeadingStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 100.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ZefyrView(
                      document: NotusDocument.fromJson(
                        jsonDecode(question.descriptionJson),
                      ),
                    ),
                  ),
                ),
                /*Text(
                  question.description??"",
                  style: Constant.questionDescriptionStyle,
                  textAlign: TextAlign.justify,
                ),*/
                SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SecondaryNegativeCardButton(
                    child: Text(
                      "Delete",
                      style: Constant.secondaryNegativeTextStyle,
                    ),
                    callback: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirmationAlert(
                            title: "Delete question draft?",
                            msg: "You will lose this content permenantly.",
                            deleteCallback: () async {
                              await question.delete();
                              Navigator.of(context).pop();
                            },
                            cancelCallback: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: SecondaryBlueCardButton(
                    callback: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return CreateQuestion(
                              question: question,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Finish",
                      style: Constant.secondaryBlueTextStyle,
                    ),
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
