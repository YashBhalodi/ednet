import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/answer/answer_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class UserAnswers extends StatelessWidget {
  final User user;

  const UserAnswers({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Answers')
          .where('isDraft', isEqualTo: false)
          .where('userid', isEqualTo: user.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
                return AnswerThumbCard(
                  answer: a,
                );
              },
            );
          } else {
            return Padding(
              padding: Constant.edgePadding,
              child: Center(
                child: Text(
                  "${user.userName} has not answered any questions yet.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        } else {
          return Center(
            child: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Constant.greenCircularProgressIndicator,
            ),
          );
        }
      },
    );
  }
}
