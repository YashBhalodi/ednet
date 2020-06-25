import 'package:ednet/home/profile/my_profile/edit_details_profile.dart';
import 'package:ednet/home/profile/my_profile/university_topic_list.dart';
import 'package:ednet/home/profile/my_profile/user_topic_list.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:ednet/utilities_files/utility_widgets.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  final User user;

  MyProfile({Key key, @required this.user}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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
      _interstitialAd..show();
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
              "My Profile",
              style: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.appBarTextStyle
                  : LightTheme.appBarTextStyle,
            ),
          ),
          body: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ExpansionTile(
                  title: Text(
                    "Preview Profile",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.dropDownMenuTitleStyle
                        : LightTheme.dropDownMenuTitleStyle,
                  ),
                  initiallyExpanded: true,
                  children: <Widget>[
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: Constant.edgePadding,
                      children: <Widget>[
                        Text(
                          "How other users will see your profile...",
                          style: Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.headingDescriptionStyle
                              : LightTheme.headingDescriptionStyle,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        BlueOutlineButton(
                          child: Text(
                            "My Profile",
                            style: Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.outlineButtonTextStyle
                                : LightTheme.outlineButtonTextStyle,
                          ),
                          callback: () {
                            Constant.userProfileView(context, userId: widget.user.id);
                          },
                        ),
                      ],
                    )
                  ],
                ),
                EditDetailsTile(
                  user: widget.user,
                ),
                widget.user.isAdmin
                    ? UniversityTopicListTile(
                        user: widget.user,
                      )
                    : UserTopicListTile(
                        user: widget.user,
                      ),
                SizedBox(
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
