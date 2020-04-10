import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/question/question_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:flutter/material.dart';

class QuestionFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance
              .collection('Questions')
              .where('isDraft', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.documents.length > 0) {
                return Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, i) {
                        Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                        return QuestionThumbCard(
                          question: q,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: Padding(
                    padding: Constant.sidePadding,
                    child: Center(
                      child: Text(
                        "Be the first to satisfy your curiousity.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.secondaryHeadingTextStyle
                            : LightTheme.secondaryHeadingTextStyle,
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(
                    3,
                    (i) => ShimmerQuestionThumbCard(),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
