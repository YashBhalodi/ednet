import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zefyr/zefyr.dart';

class QuestionTile extends StatelessWidget {
  final Question question;

  const QuestionTile({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(0.0, 3.0),
            blurRadius: 16.0,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        color: Theme
                   .of(context)
                   .brightness == Brightness.dark
               ? DarkTheme.questionTileHeaderBackgroundColor
               : LightTheme.questionTileHeaderBackgroundColor,
      ),
      margin: EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: Constant.edgePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(question.topics.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(
                            question.topics[i],
                            style: Constant.topicStyle,
                          ),
                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                                           ? DarkTheme.chipBackgroundColor
                                           : LightTheme.chipBackgroundColor,
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  question.heading,
                  style: Constant.questionHeadingStyle,
                ),
                SizedBox(
                  height: 8.0,
                ),
                ZefyrView(
                  document: NotusDocument.fromJson(
                    jsonDecode(question.descriptionJson),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                question.profUpvoteCount > 0
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "${question.profUpvoteCount} professor upvoted",
                            style: Constant.professorUpvoteTextStyle,
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
                            .document(question.userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return ShimmerUsername();
                          } else {
                            if (snapshot.data.data != null) {
                              DocumentSnapshot userDoc = snapshot.data;
                              return GestureDetector(
                                onTap: () {
                                  Constant.userProfileView(context, userId: question.userId);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Asked by",
                                      style: Constant.dateTimeStyle,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.person,
                                          size: 16.0,
                                        ),
                                        question.byProf
                                            ? Icon(
                                                Icons.star,
                                                color: Colors.orangeAccent,
                                                size: 16.0,
                                              )
                                            : Container(),
                                        Text(
                                          userDoc.data['username'],
                                          style: Constant.usernameStyle,
                                        ),
                                      ],
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "On",
                            style: Constant.dateTimeStyle,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            Constant.formatDateTime(question.createdOn),
                            style: Constant.dateTimeStyle,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: UpvoteButton(
                          count: question.upvoteCount,
                          callback: () async {
                            await question.upvote();
                          },
                        ),
                      ),
                      Expanded(
                        child: DownvoteButton(
                          count: question.downvoteCount,
                          callback: () async {
                            await question.downvote();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
