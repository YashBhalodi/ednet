import 'dart:convert';

import 'package:ednet/home/create/answer/create_answer.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class AnswerDraftCard extends StatelessWidget {
  final Answer answer;

  const AnswerDraftCard({Key key, this.answer}) : super(key: key);

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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: Constant.cardPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  constraints: BoxConstraints.loose(Size(double.maxFinite, 100.0)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    child: ZefyrView(
                      document: NotusDocument.fromJson(
                        jsonDecode(answer.contentJson),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            title: "Delete answer draft?",
                            msg: "You will lose this content permenantly.",
                            deleteCallback: () async {
                              Navigator.of(context).pop();
                              await answer.delete();
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
                            return CreateAnswer(
                              answer: answer,
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
