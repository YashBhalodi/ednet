import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/question/question_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:flutter/material.dart';

class UserQuestions extends StatelessWidget {
  final User user;

  const UserQuestions({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Questions')
          .where('isDraft', isEqualTo: false)
          .where('userid', isEqualTo: user.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i) {
                Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                return QuestionThumbCard(
                  question: q,
                );
              },
            );
          } else {
            return Padding(
              padding: Constant.edgePadding,
              child: Center(
                child: Text(
                  "${user.userName} has not asked any questions yet.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        } else {
          return ListView(
            shrinkWrap: true,
            children: List.generate(
              3,
              (i) => ShimmerQuestionThumbCard(),
            ),
          );
        }
      },
    );
  }
}
