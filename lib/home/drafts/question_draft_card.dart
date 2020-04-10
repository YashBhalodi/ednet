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
                    children: List.generate(
                      question.topics.length,
                      (i) {
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
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  question.heading ?? "",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.questionHeadingStyle
                      : LightTheme.questionHeadingStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  constraints: BoxConstraints.loose(Size(double.maxFinite, 100.0)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
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
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.secondaryNegativeTextStyle
                          : LightTheme.secondaryNegativeTextStyle,
                    ),
                    callback: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirmationAlert(
                            title: "Delete question draft?",
                            msg: "You will lose this content permenantly.",
                            deleteCallback: () async {
                              Navigator.of(context).pop();
                              await question.delete();
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
                  child: SecondaryPositiveCardButton(
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
                      style: Theme.of(context).brightness == Brightness.dark
                          ? DarkTheme.secondaryPositiveTextStyle
                          : LightTheme.secondaryPositiveTextStyle,
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
