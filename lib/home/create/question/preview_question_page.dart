import 'package:ednet/home/create/question/question_preview_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewQuestion extends StatefulWidget {
  final Question question;

  const PreviewQuestion({Key key, @required this.question}) : super(key: key);

  @override
  _PreviewQuestionState createState() => _PreviewQuestionState();
}

class _PreviewQuestionState extends State<PreviewQuestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: Constant.edgePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Preview Question",
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.headingStyle
                       : LightTheme.headingStyle,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "Please review your question before finally publishing.",
                style: Theme
                           .of(context)
                           .brightness == Brightness.dark
                       ? DarkTheme.headingDescriptionStyle
                       : LightTheme.headingDescriptionStyle,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "Once question is published it can't be edited or removed.\nSave your question as draft and publish it once you are confident.",
                style: Theme.of(context).brightness == Brightness.dark
                       ? DarkTheme.formFieldHintStyle
                       : LightTheme.formFieldHintStyle,
              ),
            ],
          ),
        ),
        (widget.question.heading == null || widget.question.description == null)
            ? ShimmerQuestionPreviewCard()
            : Expanded(
                child: Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      QuestionPreviewCard(
                        question: widget.question,
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
