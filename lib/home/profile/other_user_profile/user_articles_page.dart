import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/article/article_thumb_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

class UserArticles extends StatelessWidget {
  final User user;

  const UserArticles({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Articles')
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
                Article a = Article.fromSnapshot(snapshot.data.documents[i]);
                return ArticleThumbCard(
                  article: a,
                );
              },
            );
          } else {
            return Padding(
              padding: Constant.edgePadding,
              child: Center(
                child: Text(
                  "${user.userName} has not written any articles yet.",
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
