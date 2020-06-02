import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/create/answer/create_answer.dart';
import 'package:ednet/home/feed/answer/answer_thumb_card.dart';
import 'package:ednet/home/feed/question/question_tile_header.dart';
import 'package:ednet/home/feed/report_content_sheet.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  final Question question;

  const QuestionPage({Key key, this.question}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
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

  Widget _popUpMenu() {
    return PopupMenuButton(
      offset: Offset.fromDirection(math.pi / 2, AppBar().preferredSize.height),
      itemBuilder: (_) {
        return [
          PopupMenuItem<int>(
            child: Text("Report Question"),
            value: 1,
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
        }
      },
    );
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
            children: <Widget>[
              StreamBuilder(
                stream: Firestore.instance
                    .collection('Questions')
                    .document(widget.question.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Question q = Question.fromSnapshot(snapshot.data);
                    return QuestionTile(
                      question: q,
                    );
                  } else {
                    return ShimmerQuestionTile();
                  }
                },
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('Answers')
                    .where('questionId', isEqualTo: widget.question.id)
                    .where('isDraft', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data.documents.length > 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, i) {
                          Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
                          return AnswerThumbCard(
                            answer: a,
                          );
                        },
                      );
                    } else {
                      return SizedBox(
                        height: 200,
                        width: double.maxFinite,
                        child: Center(
                          child: Text(
                            "Be the first person to answer.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.secondaryHeadingTextStyle
                                : LightTheme.secondaryHeadingTextStyle,
                          ),
                        ),
                      );
                    }
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(
                        3,
                        (i) => ShimmerAnswerThumbCard(),
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: Constant.edgePadding,
                child: SizedBox(
                  height: 64.0,
                  width: double.maxFinite,
                  child: PrimaryBlueCTA(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.mode_edit,
                          size: 20.0,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.primaryCTATextColor
                              : LightTheme.primaryCTATextColor,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Write Answer",
                          style: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.primaryCTATextStyle
                              : LightTheme.primaryCTATextStyle,
                        ),
                      ],
                    ),
                    callback: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return CreateAnswer(
                              question: widget.question,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
