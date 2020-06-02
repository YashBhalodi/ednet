import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/feed/question/question_tile_header.dart';
import 'package:ednet/home/feed/report_content_sheet.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswerPage extends StatefulWidget {
  final Answer answer;
  final Question question;

  const AnswerPage({Key key, this.answer, this.question}) : super(key: key);

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  Widget _popUpMenu() {
    return PopupMenuButton(
      offset: Offset.fromDirection(math.pi / 2, AppBar().preferredSize.height),
      itemBuilder: (_) {
        return [
          PopupMenuItem<int>(
            child: Text("Report Question"),
            value: 1,
          ),
          PopupMenuItem<int>(
            child: Text("Report Answer"),
            value: 2,
          ),
        ];
      },
      onSelected: (i) {
        if (i == 1) {
          ReportFlow.showSubmitReportBottomSheet(
            context,
            contentCollection: 'Questions',
            contentDocId: widget.question.id,
          );
        } else if (i == 2) {
          ReportFlow.showSubmitReportBottomSheet(
            context,
            contentCollection: 'Answers',
            contentDocId: widget.answer.id,
          );
        }
      },
    );
  }
  BannerAd _bannerAd;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: AdConstant.bannerAdID,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            _bannerAd..show();
          }
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: AdConstant.appID);
    _bannerAd = buildBannerAd()..load();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            _popUpMenu(),
          ],
        ),
        body: Scrollbar(
          child: ListView(
            padding: EdgeInsets.only(bottom: 32.0),
            children: <Widget>[
              widget.question == null
              ? StreamBuilder(
                stream: Firestore.instance
                    .collection('Questions')
                    .document(widget.answer.queID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    Question q = Question.fromSnapshot(snapshot.data);
                    return QuestionTile(
                      question: q,
                    );
                  } else {
                    return ShimmerQuestionTile();
                  }
                },
              )
              : QuestionTile(
                question: widget.question,
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: Constant.edgePadding,
                children: <Widget>[
                  AnswerContentView(
                    answer: widget.answer,
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          indent: 5.0,
                          endIndent: 5.0,
                        ),
                      ),
                      Text("End of answer"),
                      Expanded(
                        child: Divider(
                          indent: 5.0,
                          endIndent: 5.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    "So...What do you think?\n\nDoes it deserve an upvote?",
                    style: Theme.of(context).brightness == Brightness.dark
                           ? DarkTheme.headingDescriptionStyle
                           : LightTheme.headingDescriptionStyle,
                    textAlign: TextAlign.center,
                  ),
                  StreamBuilder(
                    stream:
                    Firestore.instance.collection('Answers').document(widget.answer.id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Answer a = Answer.fromSnapshot(snapshot.data);
                        if (a.profUpvoteCount > 0) {
                          return Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text(
                                "${a.profUpvoteCount} professor upvoted",
                                style: Theme.of(context).brightness == Brightness.dark
                                       ? DarkTheme.professorUpvoteTextStyle
                                       : LightTheme.professorUpvoteTextStyle,
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  StreamBuilder(
                    stream:
                    Firestore.instance.collection('Answers').document(widget.answer.id).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Answer a = Answer.fromSnapshot(snapshot.data);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 56.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: UpvoteButton(
                                      callback: () async {
                                        await a.upvote();
                                      },
                                      count: a.upvoteCount,
                                    ),
                                  ),
                                  Expanded(
                                    child: DownvoteButton(
                                      callback: () async {
                                        await a.downvote();
                                      },
                                      count: a.downvoteCount,
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
                                  child: UpVoterList(upvoters: a.upvoters),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right:10.0),
                                  child: DownVoterList(downvoters: a.downvoters,),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return ShimmerRatingBox();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 60.0,),
            ],
          ),
        ),
      ),
    );
  }
}