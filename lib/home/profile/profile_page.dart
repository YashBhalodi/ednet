import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/create/question/question_preview_card.dart';
import 'package:ednet/home/profile/question_draft_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const ProfilePage({Key key, this.userSnap}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    User currentUser = User.fromSnapshot(widget.userSnap);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          currentUser.toString(),
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection('Questions')
              .where('isDraft', isEqualTo: true)
              .where('username', isEqualTo: currentUser.userName)
              .getDocuments()
              .asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return LinearProgressIndicator();
            } else {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) {
                      Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                      return QuestionDraftCard(
                        question: q,
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  child: Center(
                    child: Text("Error"),
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
