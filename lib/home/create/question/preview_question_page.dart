import 'package:ednet/home/create/question/question_preview_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
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
        Text(
          "Preview Question",
          style: Constant.sectionSubHeadingStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Please review your question before finally publishing.",
          style: Constant.sectionSubHeadingDescriptionStyle,
        ),
        SizedBox(
          height: 12.0,
        ),
        (widget.question.heading == null || widget.question.description == null)
            ? Center(
                child: SizedBox(
                  height: 28.0,
                  width: 28.0,
                  child: Constant.greenCircularProgressIndicator,
                ),
              )
            : Expanded(
              child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    QuestionPreviewCard(
                      question: widget.question,
                    ),
                  ],
                ),
            ),
      ],
    );
  }
}
