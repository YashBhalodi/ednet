import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuestionTile extends StatelessWidget {
  final Question question;

  const QuestionTile({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.questionTileShadow
            : LightTheme.questionTileShadow,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        color: Theme.of(context).brightness == Brightness.dark
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
                QuestionContentView(
                  question: question,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                    SizedBox(height: 4.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: UpVoterList(upvoters: question.upvoters),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:10.0),
                          child: DownVoterList(downvoters: question.downvoters,),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
