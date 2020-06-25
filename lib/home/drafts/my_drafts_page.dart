import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/drafts/answer_draft_card.dart';
import 'package:ednet/home/drafts/article_draft_card.dart';
import 'package:ednet/home/drafts/question_draft_card.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/shimmer_widgets.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class MyDrafts extends StatefulWidget {
  final User user;

  const MyDrafts({Key key, this.user}) : super(key: key);

  @override
  _MyDraftsState createState() => _MyDraftsState();
}

class _MyDraftsState extends State<MyDrafts> {
  InterstitialAd _interstitialAd;

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: AdConstant.interstitialAdID,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          try {
            _interstitialAd..load();
          } catch (e) {
            print(e);
          }
        } else if (event == MobileAdEvent.closed) {
          _interstitialAd = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  void _showInterstitialAd() {
    _interstitialAd..show();
  }
  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: AdConstant.appID);
    _interstitialAd = buildInterstitialAd()..load();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async{
          _showInterstitialAd();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("My Drafts"),
          ),
          body: ListView(
            children: <Widget>[
              ExpansionTile(
                title: Text(
                  "Questions",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.dropDownMenuTitleStyle
                      : LightTheme.dropDownMenuTitleStyle,
                ),
                initiallyExpanded: true,
                children: <Widget>[
                  Scrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection('Questions')
                              .where('isDraft', isEqualTo: true)
                              .where('userid', isEqualTo: widget.user.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.active) {
                              if (snapshot.data.documents.length > 0) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, i) {
                                    Question q = Question.fromSnapshot(snapshot.data.documents[i]);
                                    return QuestionDraftCard(
                                      question: q,
                                    );
                                  },
                                );
                              } else {
                                return SizedBox(
                                  width: double.maxFinite,
                                  height: 150.0,
                                  child: Center(
                                    child: Text(
                                      "You don't have any draft questions.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return ShimmerQuestionDraftCard();
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  "Articles",
                  style: Theme.of(context).brightness == Brightness.dark
                         ? DarkTheme.dropDownMenuTitleStyle
                         : LightTheme.dropDownMenuTitleStyle,
                ),
                initiallyExpanded: false,
                children: <Widget>[
                  Scrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection('Articles')
                              .where('isDraft', isEqualTo: true)
                              .where('userid', isEqualTo: widget.user.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.active) {
                              if (snapshot.data.documents.length > 0) {
                                return ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    Article a = Article.fromSnapshot(snapshot.data.documents[i]);
                                    return ArticleDraftCard(
                                      article: a,
                                    );
                                  },
                                );
                              } else {
                                return SizedBox(
                                  width: double.maxFinite,
                                  height: 150.0,
                                  child: Center(
                                    child: Text(
                                      "No draft article pending to publish!\n\nWhen are you planning for next?",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return ShimmerArticleDraftCard();
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  "Answers",
                  style: Theme.of(context).brightness == Brightness.dark
                         ? DarkTheme.dropDownMenuTitleStyle
                         : LightTheme.dropDownMenuTitleStyle,
                ),
                initiallyExpanded: false,
                children: <Widget>[
                  Scrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection('Answers')
                              .where('isDraft', isEqualTo: true)
                              .where('userid', isEqualTo: widget.user.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.active) {
                              if (snapshot.data.documents.length > 0) {
                                return ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    Answer a = Answer.fromSnapshot(snapshot.data.documents[i]);
                                    return AnswerDraftCard(
                                      answer: a,
                                    );
                                  },
                                );
                              } else {
                                return SizedBox(
                                  width: double.maxFinite,
                                  height: 150.0,
                                  child: Center(
                                    child: Text(
                                      "No draft answer to write up.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return ShimmerAnswerDraftCard();
                            }
                          },
                        ),
                      ],
                    ),
                  )
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
