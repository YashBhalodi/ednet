import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ednet/home/app_drawer.dart';
import 'package:ednet/home/create/article/create_article.dart';
import 'package:ednet/home/create/question/create_question.dart';
import 'package:ednet/home/feed/article_feed_page.dart';
import 'package:ednet/home/feed/question_feed_page.dart';
import 'package:ednet/utilities_files/constant.dart';
import 'package:flutter/material.dart';

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
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.all(0.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                  padding: Constant.edgePadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Icon(
                        Icons.help,
                        size: 52.0,
                        color: Colors.blue[700],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Ask a Question",
                        style: Constant.menuButtonTextStyle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  elevation: 15.0,
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[300], width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return CreateQuestion();
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 36,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                  padding: Constant.edgePadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        size: 52.0,
                        color: Colors.blue[700],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "Write an Article",
                        style: Constant.menuButtonTextStyle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  elevation: 15.0,
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[300], width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return CreateArticle();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              createContentDialog();
            },
            child: Icon(Icons.edit),
            backgroundColor: Colors.blue[800],
          ),
          drawer: AppDrawer(
            userSnap: widget.userSnap,
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
    );
  }
}
