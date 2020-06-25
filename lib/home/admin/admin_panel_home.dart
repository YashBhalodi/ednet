import 'package:ednet/home/admin/reports/reported_content_overview.dart';
import 'package:ednet/home/admin/users/users_overview.dart';
import 'package:ednet/utilities_files/classes.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class AdminPanelHome extends StatefulWidget {
  final User admin;

  const AdminPanelHome({Key key, this.admin}) : super(key: key);

  @override
  _AdminPanelHomeState createState() => _AdminPanelHomeState();
}

class _AdminPanelHomeState extends State<AdminPanelHome> {
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
        onWillPop: ()async{
          _showInterstitialAd();
          return true;
        },
        child: DefaultTabController(
          length: 2, //TODO content summary tab
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Admin Panel",
                style: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.appBarTextStyle
                    : LightTheme.appBarTextStyle,
              ),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "Users",
                  ),
                  Tab(
                    text: "Reports",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                AdminUsersList(
                  admin: widget.admin,
                ),
                ReportedContents(
                  admin: widget.admin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
