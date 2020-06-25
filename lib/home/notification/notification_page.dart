import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/notification/answer_posted_notification_list.dart';
import 'package:ednet/home/notification/answer_removed_notification_list.dart';
import 'package:ednet/home/notification/answer_reported_notification_list.dart';
import 'package:ednet/home/notification/article_posted_notification_list.dart';
import 'package:ednet/home/notification/article_removed_notificaton_list.dart';
import 'package:ednet/home/notification/article_reported_notification_list.dart';
import 'package:ednet/home/notification/question_posted_notifications_list.dart';
import 'package:ednet/home/notification/question_removed_notification_list.dart';
import 'package:ednet/home/notification/question_reported_notification_list.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final User currentUser;

  const NotificationPage({Key key, this.currentUser}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  InterstitialAd _interstitialAd;
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
    if (Random().nextBool()) {
      _interstitialAd..show();
    }
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: AdConstant.appID);
    _interstitialAd = buildInterstitialAd()..load();
    _bannerAd = buildBannerAd()..load();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          _showInterstitialAd();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                "Notifications",
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.appBarTextStyle
                    : LightTheme.appBarTextStyle,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.help),
                  onPressed: () {
                    Constant.showToastInstruction(
                        "Dismiss notifications by swiping it horizontally.");
                  },
                ),
              ]),
          body: Scrollbar(
            child: ListView(
              children: <Widget>[
                QuestionPostedNotificationList(
                  currentUser: widget.currentUser,
                ),
                AnswerPostedNotificationList(
                  currentUser: widget.currentUser,
                ),
                ArticlePostedNotificationList(
                  currentUser: widget.currentUser,
                ),
                QuestionReportedNotificationList(
                  currentUser: widget.currentUser,
                ),
                AnswerReportedNotificationList(
                  currentUser: widget.currentUser,
                ),
                ArticleReportedNotificationList(
                  currentUser: widget.currentUser,
                ),
                QuestionRemovedNotificationList(
                  currentUser: widget.currentUser,
                ),
                AnswerRemovedNotificationList(
                  currentUser: widget.currentUser,
                ),
                ArticleRemovedNotificationList(
                  currentUser: widget.currentUser,
                ),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Users")
                      .document(widget.currentUser.id)
                      .collection('notifications')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.documents.isEmpty) {
                        return Container(
                          height: 350,
                          child: Center(
                            child: Text(
                              "You are all caught up! 👍🏻",
                              style: Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.secondaryHeadingTextStyle
                                  : LightTheme.secondaryHeadingTextStyle,
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
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
