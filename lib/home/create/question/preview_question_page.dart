import 'package:ednet/utilities_files/classes.dart';
import 'package:flutter/material.dart';

class PreviewQuestion extends StatefulWidget {
  final Question question;
  final PageController parentPageController;

  const PreviewQuestion({Key key,@required this.question,@required this.parentPageController}) : super(key: key);

    @override
  _PreviewQuestionState createState() => _PreviewQuestionState();
}

class _PreviewQuestionState extends State<PreviewQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
