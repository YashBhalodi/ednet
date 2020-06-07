import 'package:ednet/home/feed/question/question_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class UserQuestions extends StatelessWidget {
  final User user;
  final List<Question> questions;

  const UserQuestions({Key key, @required this.user, this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return questions.length > 0
        ? Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: questions.length,
              itemBuilder: (context, i) {
                return QuestionThumbCard(
                  question: questions[i],
                );
              },
            ),
          )
        : Padding(
            padding: Constant.edgePadding,
            child: Center(
              child: Text(
                "${user.userName} has not asked any questions yet.",
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
