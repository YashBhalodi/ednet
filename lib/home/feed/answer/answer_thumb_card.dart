import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/answer/answer_page.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zefyr/zefyr.dart';

class AnswerThumbCard extends StatelessWidget {
  final Answer answer;

  const AnswerThumbCard({Key key, this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AnswerPage(answer: answer);
            },
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        elevation: 5.0,
        margin: Constant.cardMargin,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: Constant.cardPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                constraints: BoxConstraints.loose(Size(double.maxFinite, 80.0)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  child: ZefyrView(
                    document: NotusDocument.fromJson(
                      jsonDecode(answer.contentJson),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 22.0,
              ),
              answer.profUpvoteCount > 0
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "${answer.profUpvoteCount} professor upvoted",
                          style: Theme.of(context).brightness == Brightness.dark
                                 ? DarkTheme.professorUpvoteTextStyle
                                 : LightTheme.professorUpvoteTextStyle,
                        ),
                      ),
                    )
                  : Container(),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('Users')
                          .document(answer.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          if (snapshot.data.data != null) {
                            DocumentSnapshot userDoc = snapshot.data;
                            return GestureDetector(
                              onTap: () {
                                Constant.userProfileView(context, userId: answer.userId);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    size: 16.0,
                                  ),
                                  answer.byProf
                                      ? Icon(
                                          Icons.star,
                                          color: Colors.orangeAccent,
                                          size: 16.0,
                                        )
                                      : Container(),
                                  Text(
                                    userDoc.data['username'],
                                    style: Theme.of(context).brightness == Brightness.dark
                                           ? DarkTheme.usernameStyle
                                           : LightTheme.usernameStyle,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(); //TODO user account is removed. msg if we want
                          }
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      Constant.formatDateTime(answer.createdOn),
                      style: Theme.of(context).brightness == Brightness.dark
                             ? DarkTheme.dateTimeStyle
                             : LightTheme.dateTimeStyle,
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 32.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: UpvoteBox(
                        upvoteCount: answer.upvoteCount,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: DownvoteBox(
                        downvoteCount: answer.downvoteCount,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
