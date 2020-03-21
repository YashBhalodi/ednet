import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/create/question/question_preview_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('Questions').where('isDraft', isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, i) {
              Question q = Question.fromSnapshot(snapshot.data.documents[i]);
              return QuestionPreviewCard(
                question: q,
              );
            },
          );
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }
}
