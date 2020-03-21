import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/contants.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
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
    if (widget.question.heading == null || widget.question.description == null) {
      return Center(
        child: SizedBox(
          height: 28.0,
          width: 28.0,
          child: Constant.greenCircularProgressIndicator,
        ),
      );
    } else {
      return ListView(
        shrinkWrap: true,
        padding: Constant.edgePadding,
        children: <Widget>[
          QuestionCard(
            question: widget.question,
          ),
        ],
      );
    }
  }
}
