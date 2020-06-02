import 'package:ednet/home/feed/answer/answer_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class UserAnswers extends StatelessWidget {
  final User user;
  final List<Answer> answers;

  const UserAnswers({Key key, @required this.user, this.answers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (answers.length > 0)
        ? Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: answers.length,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                return AnswerThumbCard(
                  answer: answers[i],
                );
              },
            ),
          )
        : Padding(
            padding: Constant.edgePadding,
            child: Center(
              child: Text(
                "${user.userName} has not answered any questions yet.",
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
