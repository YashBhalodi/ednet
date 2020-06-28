import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/app_drawer.dart';
import 'package:ednet/home/create_content.dart';
import 'package:ednet/home/feed/article_feed_page.dart';
import 'package:ednet/home/feed/question_feed_page.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  final DocumentSnapshot userSnap;

  const Home({Key key, @required this.userSnap}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  createContentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateContent();
      },
    );
  }

  int triedExit = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (triedExit >= 1) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        } else {
          triedExit++;
          Constant.showToastInstruction("Press again to exit");
          return false;
        }
      },
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              key: Key('createContentFAB'),
              onPressed: () {
                createContentDialog();
                Constant.defaultVibrate();
              },
              elevation: 12,
              child: Icon(Icons.edit),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.fabBackgroundColor
                  : LightTheme.fabBackgroundColor,
            ),
            drawer: StreamBuilder(
              stream: Firestore.instance.collection("Users").document(widget.userSnap.documentID).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return AppDrawer(
                    userSnap: snapshot.data,
                  );
                } else {
                  return AppDrawer(
                    userSnap: widget.userSnap,
                  );
                }
              },
            ),
            appBar: AppBar(
              title: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    text: "Questions",
                  ),
                  Tab(
                    text: "Articles",
                  ),
                ],
              ),
              titleSpacing: 0.0,
              centerTitle: true,
            ),
            body: TabBarView(
              children: [
                QuestionFeed(),
                ArticleFeed(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
